# RvNOVA — RISC-V CPU Design Plan

> A comprehensive implementation roadmap for the RvNOVA RV32I(M) soft-core processor.
> Phases are ordered by dependency: later phases build on earlier ones.

---

## Phase 0 — Housekeeping & Repository Structure

Before writing any RTL, establish a clean project skeleton so every subsequent phase has a consistent home.

### 0.1 Directory Layout

```
rvnova/
├── rtl/                  # All synthesisable Verilog
│   ├── core/             # Datapath, control, hazard units
│   ├── mem/              # Memory controller, BRAM wrapper
│   └── bus/              # AXI4-Lite / Wishbone adapter
├── firmware/             # Software toolchain (see Phase 2)
│   ├── crt0.S
│   ├── link.ld
│   └── Makefile
├── tb/                   # Testbenches
│   ├── tb_riscv_top.v
│   └── tests/            # Per-instruction directed tests
├── compliance/           # riscv-compliance integration
├── constraints/          # FPGA .xdc / .sdc files
├── scripts/              # Simulation, synthesis helper scripts
├── docs/                 # Microarchitecture docs, waveforms
└── PLAN.md
```

### 0.2 Toolchain Prerequisites

| Tool | Purpose |
|---|---|
| `riscv32-unknown-elf-gcc` | Cross-compiler for firmware |
| `riscv32-unknown-elf-objcopy` | ELF → binary/hex conversion |
| Icarus Verilog / Verilator | RTL simulation |
| GTKWave | Waveform viewer |
| Yosys + nextpnr (or Vivado) | Synthesis & place-and-route |

### 0.3 Missing Items Not in Original TODO

- `README.md` — project overview, build instructions, feature matrix
- `CHANGELOG.md` — track breaking RTL changes between phases
- Git tags at each phase boundary (`v0-single-cycle`, `v1-pipeline`, etc.)
- A top-level `Makefile` with targets: `sim`, `synth`, `compliance`, `clean`
- `.gitignore` for simulation artefacts and ELF files

---

## Phase 1 — Instruction Completeness (RV32I Baseline)

Goal: achieve a complete, correct, single-cycle RV32I implementation before adding any pipeline complexity.

### 1.1 Sub-word Memory Access

Missing instructions: `LB`, `LH`, `LBU`, `LHU`, `SB`, `SH`.

**Design tasks:**

- Extend the load data-path with a byte/half-word extract-and-sign-extend mux keyed on `funct3`.
- Extend the store data-path with a byte-enable generator (`mem_be[3:0]`) so the memory interface supports partial writes without corrupting neighbouring bytes.
- Add a `mem_align_check` block that raises a misaligned-address exception when `addr[0]` is set for half-word accesses or `addr[1:0] != 2'b00` for word accesses.

**Suggested RTL module:** `rtl/core/load_store_unit.v`

```
Inputs : alu_result, rs2_data, funct3, mem_wen, mem_ren
Outputs: mem_addr, mem_wdata, mem_wstrb[3:0], mem_rdata_aligned
```

**Verification:**
- Directed tests for each of the six instructions with aligned and unaligned addresses.
- Boundary tests: byte write at word boundary, half-word read crossing a word boundary.

### 1.2 CSR Support

Minimum required CSRs for RV32I compliance:

| CSR | Address | Purpose |
|---|---|---|
| `mstatus` | `0x300` | Global interrupt-enable bits |
| `misa` | `0x301` | ISA capabilities (read-only) |
| `mie` | `0x304` | Interrupt-enable register |
| `mtvec` | `0x305` | Trap-vector base address |
| `mscratch` | `0x340` | Scratch for trap handlers |
| `mepc` | `0x341` | Exception program counter |
| `mcause` | `0x342` | Cause of last trap |
| `mtval` | `0x343` | Bad address / instruction value |
| `mip` | `0x344` | Interrupt-pending register |
| `mcycle` | `0xC00` | Cycle counter (low 32 bits) |
| `minstret` | `0xC02` | Retired instruction counter |

**Design tasks:**

- Implement `rtl/core/csr_regfile.v`: a register file with read/write port controlled by `funct3` (CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI).
- CSR instructions must be atomic — read the old value to the destination register, then write the new value in the same cycle.
- `mcycle` and `minstret` should free-run from the clock domain and increment automatically.
- Illegal CSR address or write to a read-only CSR must generate an illegal-instruction exception.

### 1.3 Exceptions & Interrupts

**Exception sources to handle:**

| Cause Code | Description |
|---|---|
| 0 | Instruction address misaligned |
| 1 | Instruction access fault |
| 2 | Illegal instruction |
| 3 | Breakpoint (`ebreak`) |
| 4 | Load address misaligned |
| 6 | Store address misaligned |
| 8 | Environment call from M-mode (`ecall`) |
| 11 | External interrupt (M-mode) |

**Design tasks:**

- Implement `rtl/core/trap_ctrl.v`: priority-encodes all exception sources, writes `mcause`, `mepc`, `mtval`, updates `mstatus.MIE → MPIE`, redirects PC to `mtvec`.
- `MRET` instruction: restore `mstatus.MPIE → MIE`, redirect PC to `mepc`.
- Connect an external `irq` input line that can be masked via `mie`/`mstatus`.
- In the single-cycle core, exception handling stalls the pipeline for one cycle to write CSRs before fetching from the trap vector.

### 1.4 Missing Instructions Audit

Run `grep` / a script against the opcode table to confirm 100% RV32I coverage:

- `FENCE` — treat as NOP in a single-cycle core (no caches yet).
- `FENCE.I` — same; document this decision.
- `WFI` — halt the core and wait for an interrupt; implement as a simple stall loop.

---

## Phase 2 — Firmware Toolchain

Goal: be able to write C or assembly, compile it, and load it into the simulator without manual hex editing.

### 2.1 `firmware/crt0.S` — C Runtime Start-up

```asm
.section .text.init
_start:
    la   sp, _stack_top        # Initialise stack pointer
    la   gp, __global_pointer$ # Set global pointer
    la   t0, _bss_start
    la   t1, _bss_end
_bss_loop:
    bge  t0, t1, _bss_done
    sw   zero, 0(t0)
    addi t0, t0, 4
    j    _bss_loop
_bss_done:
    call main
_hang:
    j    _hang                 # Trap if main() returns
```

### 2.2 `firmware/link.ld` — Linker Script

```ld
MEMORY {
    ROM (rx)  : ORIGIN = 0x00000000, LENGTH = 16K
    RAM (rwx) : ORIGIN = 0x00010000, LENGTH = 16K
}

SECTIONS {
    .text   : { *(.text.init) *(.text*) }  > ROM
    .rodata : { *(.rodata*) }              > ROM
    .data   : { *(.data*) }               > RAM AT > ROM
    .bss    : { *(.bss*) *(COMMON) }      > RAM
    _stack_top = ORIGIN(RAM) + LENGTH(RAM);
}
```

### 2.3 `firmware/Makefile`

Targets:

| Target | Action |
|---|---|
| `all` | Compile → link → objcopy to `.bin` → convert to `.hex` (for `$readmemh`) |
| `clean` | Remove build artefacts |
| `disasm` | Run `objdump -d` for inspection |
| `size` | Print section sizes |

The hex conversion step should produce both `@address data` format (for Verilog `$readmemh`) and a plain binary image.

### 2.4 Testbench Integration

Update `tb/tb_riscv_top.v`:

```verilog
// Replace hardcoded ROM with:
reg [31:0] mem [0:MEM_DEPTH-1];
initial $readmemh("firmware/build/test.hex", mem);
```

Add a `+firmware=<path>` plusarg so the simulation binary can point at different firmware files without recompilation:

```verilog
initial begin
    if (!$value$plusargs("firmware=%s", fw_path))
        fw_path = "firmware/build/default.hex";
    $readmemh(fw_path, mem);
end
```

---

## Phase 3 — Verification & Compliance

### 3.1 Directed Unit Tests

Write one test per instruction group in `tb/tests/`:

```
tb/tests/
├── test_alu.S          # ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU
├── test_branch.S       # BEQ, BNE, BLT, BLTU, BGE, BGEU
├── test_load_store.S   # LW, LH, LB, LHU, LBU, SW, SH, SB
├── test_csr.S          # CSRRW, CSRRS, CSRRC, CSRRWI, ...
├── test_exception.S    # ecall, ebreak, illegal instruction, misaligned
└── test_multiply.S     # MUL, MULH, DIV, DIVU, REM, REMU (Phase 5)
```

Each test writes a result to a known register/address; the testbench reads it and compares against a golden value.

### 3.2 RISC-V Compliance Suite

Clone `riscv-software-src/riscv-compliance` (or its successor `riscv-arch-test`):

```bash
git submodule add https://github.com/riscv-non-isa/riscv-arch-test compliance/riscv-arch-test
```

**Integration steps:**

1. Write a compliance target `.S` file for RV32I.
2. Provide a reference signature dump mechanism — after running the test, dump a region of memory to a file and `diff` against the golden signatures in the repo.
3. Add `make compliance` to the top-level Makefile; it should run all tests and print a PASS/FAIL summary.

### 3.3 Coverage Goals

| Metric | Target |
|---|---|
| Instruction coverage | 100% of RV32I opcodes executed |
| Branch coverage | All branch outcomes (taken / not-taken) for each branch type |
| Exception coverage | Every `mcause` code reachable |
| Memory access patterns | All alignment cases, all byte-enable combinations |

Consider using Verilator with a coverage plugin, or a commercial simulator's coverage tools.

---

## Phase 4 — Pipelined Architecture

This is the largest structural change. Freeze all RTL from Phase 1–3 at a git tag (`v1-single-cycle-compliant`) before starting.

### 4.1 Pipeline Stage Definitions (5-stage)

```
IF  → ID  → EX  → MEM → WB
```

| Stage | Responsibility |
|---|---|
| IF (Instruction Fetch) | Drive PC, fetch from instruction memory, increment PC |
| ID (Instruction Decode) | Decode opcode, read register file, generate immediate, detect hazards |
| EX (Execute) | ALU operation, branch condition evaluation, address calculation |
| MEM (Memory) | Data memory read/write |
| WB (Write-Back) | Write result back to register file |

### 4.2 Pipeline Registers

Instantiate four inter-stage registers:

```
IF/ID  — pc, instr
ID/EX  — pc, rs1_data, rs2_data, imm, rd, funct3, funct7, opcode, ctrl signals
EX/MEM — alu_result, rs2_data (for stores), rd, ctrl signals
MEM/WB — alu_result or mem_rdata, rd, ctrl signals
```

All pipeline registers should support synchronous reset and a stall/flush enable.

### 4.3 Hazard Detection Unit (`rtl/core/hazard_unit.v`)

**Data hazards — forwarding (EX-EX and MEM-EX):**

```verilog
// Forward from EX/MEM to EX stage
if (ex_mem_regwrite && ex_mem_rd != 0 && ex_mem_rd == id_ex_rs1)
    forwardA = 2'b10;

// Forward from MEM/WB to EX stage
if (mem_wb_regwrite && mem_wb_rd != 0 &&
    !(ex_mem_regwrite && ex_mem_rd != 0 && ex_mem_rd == id_ex_rs1) &&
    mem_wb_rd == id_ex_rs1)
    forwardA = 2'b01;
```

**Load-use hazard — one-cycle stall:**

```verilog
if (id_ex_memread &&
    (id_ex_rd == if_id_rs1 || id_ex_rd == if_id_rs2)) begin
    stall_pc   = 1;
    stall_if_id = 1;
    flush_id_ex = 1;
end
```

**Control hazards — branch resolution:**

Option A (simple): always flush two instructions after a branch (2-cycle penalty).
Option B (better): resolve branches at the end of ID using a dedicated comparator; 1-cycle penalty.
Option C (advanced): add a static branch predictor (always-not-taken or BTB); handle mispredictions with flushes.

Recommend Option B for RvNOVA v1 pipeline.

### 4.4 Exception Handling in the Pipeline

- Exceptions must be precise — only commit the faulting instruction's side-effects.
- Add an `exception_valid` + `exception_cause` signal that travels with each pipeline stage.
- When the MEM stage detects a fault, flush all younger stages before writing CSRs and redirecting PC.

### 4.5 CSR Hazards

CSR instructions must be treated as full pipeline barriers to prevent read-modify-write races. On a CSR instruction, stall until the pipeline is drained (or implement forwarding from WB).

---

## Phase 5 — RV32M Extension (Multiply & Divide)

### 5.1 Multiply (`MUL`, `MULH`, `MULHSU`, `MULHU`)

- A purely combinational 32×32 multiplier produces a 64-bit result in one cycle but is slow.
- Prefer a 2–4 cycle iterative multiplier or instantiate the FPGA DSP block via an inference hint.
- In a pipelined core, stall the pipeline for the latency of the multiplier (insert bubbles).

### 5.2 Divide (`DIV`, `DIVU`, `REM`, `REMU`)

- Hardware division is expensive. A 32-cycle restoring or non-restoring divider is the simplest approach.
- Implement a start/done handshake; the hazard unit stalls the pipeline until `done` is asserted.
- Handle division by zero per spec: result = all-ones for `DIV`/`DIVU`, dividend for `REM`/`REMU`.
- Handle overflow case: `INT_MIN / -1`.

**Suggested module:** `rtl/core/muldiv_unit.v` with a `valid_in`/`valid_out` interface.

---

## Phase 6 — Bus Interface

### 6.1 AXI4-Lite Adapter (`rtl/bus/axi4lite_adapter.v`)

AXI4-Lite is the natural choice for FPGA SoC integration (Xilinx, Intel).

**Channel mapping:**

| AXI4-Lite Channel | Direction | Purpose |
|---|---|---|
| AW (Write Address) | Master→Slave | Memory write address |
| W (Write Data) | Master→Slave | Write data + strobe |
| B (Write Response) | Slave→Master | Write acknowledgement |
| AR (Read Address) | Master→Slave | Memory read address |
| R (Read Data) | Slave→Master | Read data + response |

The adapter should translate the core's simple `addr/wen/wdata/rdata/ack` interface into AXI4-Lite handshakes, adding wait states as needed.

### 6.2 Wishbone Adapter (alternative)

If targeting open-source SoCs (LiteX, OpenCores), provide a Wishbone B4 adapter instead. Both can be included; select via a define.

### 6.3 Memory Map

Define a top-level address decoder:

| Region | Base | Size | Device |
|---|---|---|---|
| ROM / Flash | `0x0000_0000` | 16 KB | Boot code |
| SRAM | `0x0001_0000` | 64 KB | Data + stack |
| GPIO | `0x1000_0000` | 4 KB | Digital I/O |
| UART | `0x1000_1000` | 4 KB | Serial console |
| Timer | `0x1000_2000` | 4 KB | Machine timer (`mtime`, `mtimecmp`) |

The timer peripheral is **required** for RISC-V compliance (drives `mip.MTIP`).

---

## Phase 7 — Memory Controller & FPGA Deployment

### 7.1 BRAM Wrapper (`rtl/mem/bram_sp.v`)

Instantiate a synchronous single-port or dual-port BRAM with registered outputs. Provide both:

- A behavioural model for simulation (`$readmemh`-compatible).
- An FPGA inference template that maps cleanly to block RAM primitives on Xilinx 7-series / UltraScale and Intel Cyclone/Arria families.

### 7.2 FPGA Top-Level (`rtl/rvnova_top_fpga.v`)

Wire up:

```
PLL → clk_core (e.g., 50 MHz)
rvnova_core
bram_sp (instruction + data, unified or Harvard split)
uart_tx / uart_rx
gpio[7:0]
LED[3:0] — show lower nibble of a GP register for debug
```

### 7.3 UART for Debug Output

Implement a minimal 8N1 UART transmitter (`rtl/periph/uart_tx.v`) mapped to the memory-mapped address above. `printf` from firmware should route through it.

### 7.4 Constraint Files

- `constraints/rvnova_arty_a7.xdc` — Digilent Arty A7-35T (Xilinx, common dev board)
- `constraints/rvnova_icestick.pcf` — iCEstick (iCE40, fully open-source flow)

---

## Phase 8 — Performance & Quality of Results

### 8.1 Timing Closure

After each structural change, run synthesis and check:

- **Target Fmax:** ≥ 50 MHz on iCE40HX; ≥ 100 MHz on Artix-7.
- Identify the critical path (usually the ALU + forwarding mux chain in EX stage).
- Consider registering the branch comparator output if it becomes the bottleneck.

### 8.2 Resource Utilisation Tracking

Keep a table in `docs/utilisation.md`:

| Version | LUTs | FFs | BRAM | DSPs | Fmax |
|---|---|---|---|---|---|
| v0 single-cycle | — | — | — | — | — |
| v1 5-stage | — | — | — | — | — |
| v2 +RV32M | — | — | — | — | — |

### 8.3 Static Analysis

- Run `iverilog -Wall` and eliminate all warnings.
- Add a linting pass with `verilator --lint-only`.
- Check for latches (unintended state in combinational blocks).
- Verify no `X`-propagation issues in simulation — use `$fatal` in the testbench on unexpected `X` on the register file outputs.

---

## Phase 9 — Additional Items Not in the Original TODO

These are commonly overlooked but important for a production-quality core.

### 9.1 Debug Interface (JTAG / RISC-V Debug Spec)

Implement a minimal Debug Module compliant with the RISC-V Debug Specification 0.13:
- Halt / resume the core externally.
- Read / write GPRs and CSRs over JTAG.
- Single-step execution.

This enables OpenOCD + GDB debugging of firmware running on the FPGA.

### 9.2 Physical Memory Protection (PMP)

Even a minimal 4-region PMP implementation makes the core usable in multi-privilege environments and is required for some compliance test suites.

### 9.3 Machine Timer Peripheral

The RISC-V privilege spec mandates memory-mapped `mtime` and `mtimecmp` registers. The timer interrupt (`MTIP`) must be reflected in `mip` and must trigger a trap if `mtime >= mtimecmp` and `mstatus.MIE` is set. This is needed to run FreeRTOS and other RTOS kernels.

### 9.4 Instruction Cache (Future)

Once the bus interface is in place, adding a direct-mapped instruction cache (e.g., 512-entry, 32-bit lines) removes the 1-cycle memory stall on every fetch when using slow off-chip memory.

### 9.5 Formal Verification

Use SymbiYosys (`sby`) to formally verify critical submodules:

- `csr_regfile.v` — prove no unintended CSR aliasing.
- `hazard_unit.v` — prove forwarding covers all RAW hazards.
- `trap_ctrl.v` — prove `mepc` always holds the correct faulting PC.

Add `scripts/formal/` with `.sby` configuration files.

### 9.6 Continuous Integration

Set up a GitHub Actions (or GitLab CI) workflow:

```yaml
# .github/workflows/ci.yml
jobs:
  simulate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install tools
        run: sudo apt-get install -y iverilog gcc-riscv64-unknown-elf
      - name: Build firmware
        run: make -C firmware all
      - name: Run directed tests
        run: make sim
      - name: Run compliance suite
        run: make compliance
```

---

## Implementation Order Summary

```
Phase 0  — Repo structure, toolchain setup           (Day 1)
Phase 1  — Sub-word memory, CSRs, exceptions         (Weeks 1-2)
Phase 2  — Firmware toolchain, $readmemh testbench   (Week 2)
Phase 3  — Directed tests + compliance suite         (Weeks 2-3)
Phase 4  — 5-stage pipeline + hazard unit            (Weeks 4-6)
Phase 5  — RV32M multiply/divide                     (Week 7)
Phase 6  — AXI4-Lite bus adapter + memory map        (Week 8)
Phase 7  — BRAM wrapper + FPGA top-level             (Week 9)
Phase 8  — Timing closure + QoR tracking             (Ongoing)
Phase 9  — Debug interface, timer, formal, CI        (Ongoing)
```

**Gate rule:** do not start Phase N+1 until the compliance suite passes on Phase N.

---

*RvNOVA — built right, one phase at a time.*
