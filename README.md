# RvNOVA

## RISC-V RV32I Core

A lightweight bare-metal RISC-V SoC featuring a modular single-cycle RV32I processor written in Verilog HDL. RvNOVA is designed with clean module separation, privileged architecture support, firmware execution, and comprehensive verification while remaining easy to understand and extend.

---

# 🚀 Features

* **ISA:** RISC-V RV32I (Base Integer Instruction Set)
* **Architecture:** Single-cycle Harvard Architecture
* **Privilege Support:** Machine Mode (M-Mode)
* **Firmware Support:** Bare-metal C and Assembly
* **Verification:** Dedicated unit and integration testbenches

### Implemented Features

* Complete RV32I Base Integer ISA
* ALU with arithmetic, logical and shift operations
* Register File (32 × 32-bit)
* Immediate Generator
* Branch and Jump Logic
* Load / Store Unit with byte enables
* CSR Subsystem
* Trap Controller
* ECALL / EBREAK
* MRET
* WFI
* Illegal Instruction Detection
* Illegal CSR Access Detection
* Machine External Interrupt Support
* Bare-metal Firmware Toolchain

---

# 🏗 Architecture

RvNOVA is organized into three major components:

Firmware
    │
    ▼
Instruction Memory
    │
    ▼
+----------------------+
|      RV32I Core      |
|                      |
|  Fetch               |
|  Decode              |
|  Execute             |
|  Memory              |
|  Writeback           |
|  Trap Controller     |
|  CSR Subsystem       |
+----------------------+
    │
    ▼
Data Memory

The processor follows a Harvard architecture with separate instruction and data memories wrapped inside a lightweight SoC.

---

# 📁 Project Structure

RvNOVA/
├── rtl/
│   ├── core/
│   │   ├── alu.v
│   │   ├── alu_decode.v
│   │   ├── csr_regfile.v
│   │   ├── imm_gen.v
│   │   ├── load_store_unit.v
│   │   ├── main_decode.v
│   │   ├── pc.v
│   │   ├── pc_mux.v
│   │   ├── regfile.v
│   │   ├── riscv_top.v
│   │   └── trap_ctrl.v
│   │
│   └── soc/
│       ├── data_mem.v
│       ├── instr_mem.v
│       └── rvnova_soc.v
│
├── firmware/
│   ├── startup.S
│   ├── main.c
│   ├── linker.ld
│   └── test.S
│
├── tb/
│   ├── tb_alu.v
│   ├── tb_csr_regfile.v
│   ├── tb_imm_gen.v
│   ├── tb_load_store.v
│   ├── tb_regfile.v
│   ├── tb_riscv_top.v
│   ├── tb_trapexec.v
│   └── ...
│
├── scripts/
│   ├── build.sh
│   └── converttohex.py
│
├── build/
│   ├── firmware.elf
│   ├── firmware.hex
│   ├── firmware.mem
│   └── ...
│
├── README.md
├── PLAN.md
├── CHANGELOG.md
└── Makefile

---

# 💻 Getting Started

## Prerequisites

Install:

* Icarus Verilog
* GTKWave
* RISC-V GNU Toolchain (`riscv32-unknown-elf-gcc`)

---

## Build Firmware

```bash
make firmware
```

Compiles the firmware and generates the Verilog-compatible memory image.

---

## Simulate the SoC

```bash
make
```

Builds the processor, loads the firmware and runs the simulation.

---

## Run Testbenches

```bash
./scripts/build.sh test
```

Runs the complete verification suite.

---

## Clean Build Files

```bash
make clean
```

---

# 🧪 Verification

RvNOVA includes dedicated verification for major subsystems including:

* ALU
* Register File
* Immediate Generator
* Load / Store Unit
* CSR Register File
* Trap Controller
* Top-Level Integration
* Firmware Execution

---

RvNOVA is an educational processor project focused on clean RTL design, modular architecture and progressive implementation of the RISC-V ISA.

## Branch predictor analysis

A new analysis tool (branch_predictor.py) was added to evaluate branch predictors using either synthetic traces or by parsing the hardware testbench report produced by the project's `branch_predictor_tb` Verilog module. Usage examples:

- Synthetic traces: `python3 branch_predictor.py --trials 20 --branches 1000 --seed 123`
- Hardware integration (requires Icarus Verilog): `python3 branch_predictor.py --verilog --tb "sim/top DUTs/tb_branch.v" --mispred-penalty 3`

The tool parses the Verilog report to extract cycle counts and misprediction stats, then computes estimated effective cycles by adding a configurable penalty per misprediction. This lets you compare predictors by estimated timing impact on the existing pipelined CPU testbench.

### Latest hardware analysis

Branches: 4, Cycles: 50, Mispred penalty: 3 cycles
