## RvNOVA Project TODO List

### 1. Instruction Completeness
- [ ] **Sub-word Memory Access:** Implement byte and half-word loads/stores (LB, LH, LBU, LHU, SB, SH). Currently, only full-word accesses (LW, SW) are supported.
- [ ] **CSR Support:** Implement Control and Status Registers (mstatus, mepc, mcause, etc.).
- [ ] **Exceptions & Interrupts:** Handle `ecall`, `ebreak`, and illegal instruction exceptions.

### 2. Ecosystem & Testing
- [ ] **Firmware Toolchain:** Create the missing `firmware/` directory with a Makefile, `crt0.S`, and linker script to compile C/Assembly into hex/vmem files.
- [ ] **RISC-V Compliance Suite:** Integrate standard riscv-compliance tests into the verification flow.
- [ ] **Enhanced Testbench:** Update `tb_riscv_top.v` to use `$readmemh` for loading dynamically compiled test firmware instead of a hardcoded ROM array.

### 3. Advanced Architecture
- [ ] **Pipelining:** Upgrade the current single-cycle architecture to a 3-stage or 5-stage pipeline to improve maximum clock frequency.
- [ ] **Hazard Unit:** Implement a hazard detection and forwarding unit for the pipeline.
- [ ] **RV32M Extension:** Add hardware support for Multiply and Divide instructions.

### 4. Integration & Bus Interfaces
- [ ] **Standard Bus Interface:** Replace the custom memory interface with a standard bus interface like AXI4-Lite or Wishbone.
- [ ] **Memory Controller:** Implement an SRAM/BRAM memory controller module for easier FPGA deployment.
