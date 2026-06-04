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
