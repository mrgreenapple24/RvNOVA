# RvNOVA

RISC-V RV32I Core
A single-cycle RISC-V processor implementation designed in Verilog HDL. This core is designed to be lightweight, modular, and compliant with the RV32I Base Integer Instruction Set.

# **🚀 Features**
ISA: RISC-V RV32I (Base Integer Instruction Set).

Architecture: [Single-cycle].

Modules: * Arithmetic Logic Unit (ALU)

Control Unit

Register File (32 registers)

Immediate Generator

Program Counter (PC)

Memory: Harvard Architecture (Separate Instruction and Data memory)

# **🛠 Project Structure**
```
├── build.sh            # Automated build, waveform, and test suite script
├── rtl/core/           # Verilog source files
│   ├── alu.v           # Arithmetic Logic Unit
│   ├── alu_decode.v    # Decodes instr for alu
│   ├── imm_gen.v       # Generates Immediates
│   ├── main_decode.v   # Decodes instr for alu_decoder
│   ├── pc.v            # program counter logic
│   ├── pc_mux.v        # mux for program counter
│   ├── regfile.v       # Register File
│   └── riscv_top.v     # Top-level module
├── tb/                 # Testbenches
│   ├── alu_tb.v        # ALU Testbench
│   ├── immgen_tb.v     # Immediate Generator Testbench
│   ├── tb_branch.v     # Branch Logic Testbench
│   ├── tb_csr.v        # CSR Operations Testbench
│   ├── tb_csr_regfile.v # CSR Register File Testbench
│   ├── tb_integrated.v # Integrated System Testbench
│   ├── tb_regfile.v    # Register File Testbench
│   ├── tb_riscv_top.v  # Main System Testbench
│   └── tb_trapexec.v   # Trap and Exception Execution Testbench
├── firmware/           # Assembly/C test programs
└── docs/               # Architecture diagrams and specs
```

# **💻 Getting Started**

### Prerequisites
To simulate this design, you will need:
- **Icarus Verilog** (Simulation)
- **GTKWave** (Waveform visualization)

### Running Simulation & Waveforms
To compile, simulate, and automatically open the CPU simulation waveform in GTKWave:
```bash
./build.sh
```

### Running the Test Suite
To compile and run all 9 testbenches to verify CPU functionality:
```bash
./build.sh test
```

### Cleaning Up
To remove all compiled binaries (`.out`) and waveform outputs (`.vcd`):
```bash
./build.sh clean
```

### Command Help
For details on available options:
```bash
./build.sh help
```
