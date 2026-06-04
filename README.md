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
│   ├── alu_tb.v        # Alu Testbench
│   ├── immgen_tb.v     # Immediate Generator Test Bench
│   ├── tb_regfile.v    # Test bench for regfile
│   └── riscv_top.v     # Main system testbench
├── firmware/           # Assembly/C test programs
└── docs/               # Architecture diagrams and specs
```

# **💻 Getting Started**

*Prerequisites*
To simulate this design, you will need:

Icarus Verilog (Simulation)

GTKWave (Waveform visualization)

RISC-V GNU Toolchain (To compile assembly to machine code)

Simulation Steps
Clone the repo:

```Bash
git clone https://github.com/your-username/riscv-verilog.git
cd riscv-verilog
```

Compile the Verilog files:


```Bash
iverilog -o processor_sim rtl/core/*.v tb/tb_riscv_top.v
```

Run the simulation:


```Bash
vvp processor_sim
```

View Waves:

```Bash
gtkwave dump.vcd
```
