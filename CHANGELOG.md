# Changelog

All notable changes to the RvNOVA RISC-V CPU project will be documented in this file.

## [0.1.0] - 2026-06-05

### Added
- Phase 0: Housekeeping (Renamed `rdl/` to `rtl/`, updated `Makefile` and `README.md`).
- Phase 1.1: Sub-word Memory Access.
  - Added `rtl/core/load_store_unit.v` with support for LB, LH, LW, LBU, LHU, SB, SH, SW.
  - Integrated `load_store_unit.v` into `riscv_top.v`.
  - Updated memory interface to support 4-bit byte enables.
  - Added SystemVerilog immediate assertions to verify memory operations and alignment.
  - Verified with a comprehensive test suite in `tb/tb_riscv_top.v`.

## [0.2.0] - 2026-06-09

### Added
- Phase 1.2: CSR Support.
  - Added `rtl/core/csr_regfile` with support for MSTATUS, MTVEC, MEPC, MCAUSE.
  - Integrated `csr_regfile.v` into `riscv_top.v`.
  - Updated register mux to include CSR writeback.
  - Completed a check using testbench in `tb/tb_csr_regfile.v`.

## [0.2.1] - 2026-06-10

### Added
- Phase 1.2: CSR Support.
  - Modified `rtl/core/main_decode.v` to build architecture for CSSR and CSSRI commands.
  - Modified `rtl/core/csr_regfile.v` to include support for MTVAL.
  - Updated `riscv_top.v` to reflect changes done.
  - CSR write-enable logic is now complete.
  - Verified using a comprehensive test in `tb/tb_csr.v`.
  
### Left
- Phase 1.2: CSR Support.
  - MCYCLE, MINSTRET, MIP, MIE, MISA, MSCRATCH [Unneeded till after trap architecture is done].

## [0.3.0] - 2026-06-12

### Added
- Phase 1.3: Exceptions and Interrupts
  - Added `rtl/core/trap_ctrl.v` with support for 6 exceptions and external interrupt. COMBINATIONAL ONLY.
  - Modified `rtl/core/csr_regfile.v` to add trap handling architecture.
  - Updated `rtl/core/riscv_top.v`, `rtl/core/pc_mux.v` and `rtl/core/main_decode.v` to include wiring for trap execution.
  - Support for masking/unmasking interrupts; MSTATUS updates to reflect saved and current value of interrupt enable.
  - Note: Currently only Direct Mode of MTVEC is supported.

### Left
- Phase 1.2: CSR Support.
  - MCYCLE, MINSTRET, MIP, MIE, MISA, MSCRATCH [Unneeded till after trap architecture is done].

- Phase 1.3 Exceptions and Interrupts.
  - Instruction Access Fault left unchecked for now.
  - Testbench verification.
  - MTVAL assignment based on type of exception handled.

## [0.3.1] - 2026-06-13

### Added
- Phase 1.3: Exceptions and Interrupts
  - Updated `rtl/core/trap_ctrl.v` and `rtl/core/riscv_top.v` to update MTVAL registers.
  - Faulty instruction and faulty address is now handed over to trap control.
  - Added `tb/tb_trapexec.v` completely testing every trap execution and handling. PASSED SUCCESSFULLY.

  - Note: Currently only Direct Mode of MTVEC is supported.
  - Note: Currently RvNOVA only supports M-mode 

### Left
- Phase 1.2: CSR Support.
  - MCYCLE, MINSTRET, MIP, MIE, MISA, MSCRATCH [Unneeded till after trap architecture is done].

- Phase 1.3 Exceptions and Interrupts.
  - Instruction Access Fault left unchecked for now [Memory Subsystem cannot report errors yet].
  - System level testbench verification for trap handler.

## [0.3.2] - 2026-06-14

### Added
- Phase 1.2: CSR Support.
  - MCYCLE, MINSTRET, MIP, MIE, MISA, MSCRATCH registers added in `rtl/core/csr_regfile.v`.
  - Modified `rtl/core/csr_regfile.v` to include exception-generation for illegal read/write CSR operations.
  - `rtl/core/riscv_top.v` and `rtl/core/trap_ctrl.v` updated to reflect the same.
  
- Phase 1.3: Exceptions and Interrupts.  
  - Updated `rtl/core/trap_ctrl.v` to integrate MTVEC vectored mode.

- Notes:
  - RvNOVA only supports M-Mode currently.
  - Updates to `rtl/core/*.v` have outdated a few testbenches.

### Left
- Phase 1.2: CSR Support.
  - Testbench verification for illegal CSR access operations.

- Phase 1.3 Exceptions and Interrupts.
  - Instruction Access Fault left unchecked for now [Memory Subsystem cannot report errors yet].
  - System level testbench verification for trap handler.
  - Testbench verification for MTVEC vectored mode. 