# RV32I ISA Coverage Audit

**Project:** RvNOVA
**Architecture:** RV32I + Zicsr + Machine Mode Privileged Support
**Audit Date:** June 2026
**Status:** PASS

---

## Overview

This document records the implementation audit of the RvNOVA processor against the RISC-V RV32I Base Integer Instruction Set Architecture.

The audit verifies that each RV32I instruction has a complete execution path through:

* Instruction Decode (`main_decode.v`)
* Control Generation (`alu_decode.v`)
* Datapath Execution (`alu.v`, `pc_mux.v`, `load_store_unit.v`)
* Writeback Logic
* Immediate Generation (`imm_gen.v`)

This audit is intended to establish functional coverage of the RV32I ISA before progression to SoC integration and advanced verification phases.

---

# RV32I Base Instruction Set

## Load Instructions

| Instruction | Status        |
| ----------- | ------------- |
| LB          | ✓ Implemented |
| LH          | ✓ Implemented |
| LW          | ✓ Implemented |
| LBU         | ✓ Implemented |
| LHU         | ✓ Implemented |

**Verification Path**

* `main_decode.v`
* `load_store_unit.v`
* Load sign/zero extension logic
* Register writeback path

---

## Store Instructions

| Instruction | Status        |
| ----------- | ------------- |
| SB          | ✓ Implemented |
| SH          | ✓ Implemented |
| SW          | ✓ Implemented |

**Verification Path**

* `main_decode.v`
* `load_store_unit.v`
* Byte-enable generation
* Data memory interface

---

## Immediate Arithmetic Instructions

| Instruction | Status        |
| ----------- | ------------- |
| ADDI        | ✓ Implemented |
| SLTI        | ✓ Implemented |
| SLTIU       | ✓ Implemented |
| XORI        | ✓ Implemented |
| ORI         | ✓ Implemented |
| ANDI        | ✓ Implemented |
| SLLI        | ✓ Implemented |
| SRLI        | ✓ Implemented |
| SRAI        | ✓ Implemented |

**Verification Path**

* `main_decode.v`
* `alu_decode.v`
* `alu.v`

---

## Register Arithmetic Instructions

| Instruction | Status        |
| ----------- | ------------- |
| ADD         | ✓ Implemented |
| SUB         | ✓ Implemented |
| SLL         | ✓ Implemented |
| SLT         | ✓ Implemented |
| SLTU        | ✓ Implemented |
| XOR         | ✓ Implemented |
| SRL         | ✓ Implemented |
| SRA         | ✓ Implemented |
| OR          | ✓ Implemented |
| AND         | ✓ Implemented |

**Verification Path**

* `alu_decode.v`
* `alu.v`

---

## Branch Instructions

| Instruction | Status        |
| ----------- | ------------- |
| BEQ         | ✓ Implemented |
| BNE         | ✓ Implemented |
| BLT         | ✓ Implemented |
| BGE         | ✓ Implemented |
| BLTU        | ✓ Implemented |
| BGEU        | ✓ Implemented |

**Verification Path**

* `main_decode.v`
* `pc_mux.v`

---

## Jump Instructions

| Instruction | Status        |
| ----------- | ------------- |
| JAL         | ✓ Implemented |
| JALR        | ✓ Implemented |

**Verification Path**

* `main_decode.v`
* `pc_mux.v`
* PC+4 writeback path

---

## Upper Immediate Instructions

| Instruction | Status        |
| ----------- | ------------- |
| LUI         | ✓ Implemented |
| AUIPC       | ✓ Implemented |

**Verification Path**

* `main_decode.v`
* `imm_gen.v`
* ALU datapath

---

## System Instructions (RV32I)

| Instruction | Status        |
| ----------- | ------------- |
| ECALL       | ✓ Implemented |
| EBREAK      | ✓ Implemented |
| FENCE       | ✓ Implemented |
| FENCE.I     | ✓ Implemented |

**Verification Path**

* `main_decode.v`
* `trap_ctrl.v`

---

# Coverage Summary

| Category             | Implemented |
| -------------------- | ----------- |
| Loads                | 5 / 5       |
| Stores               | 3 / 3       |
| Immediate Arithmetic | 9 / 9       |
| Register Arithmetic  | 10 / 10     |
| Branches             | 6 / 6       |
| Jumps                | 2 / 2       |
| Upper Immediate      | 2 / 2       |
| System               | 4 / 4       |

**RV32I Coverage:** **41 / 41 Instructions Implemented**

---

# Additional Features Beyond RV32I

The following features are implemented but are not part of the RV32I base ISA:

### Zicsr

* CSRRW
* CSRRS
* CSRRC
* CSRRWI
* CSRRSI
* CSRRCI

### Machine Mode CSRs

* MSTATUS
* MTVEC
* MEPC
* MCAUSE
* MTVAL
* MISA
* MSCRATCH
* MCYCLE
* MINSTRET
* MIE
* MIP

### Trap and Interrupt Support

* Illegal Instruction Exceptions
* Illegal CSR Access Exceptions
* External Interrupt Architecture
* MRET
* WFI
* MTVEC Direct Mode
* MTVEC Vectored Mode

---

# Conclusion

The RvNOVA processor successfully implements the complete RV32I Base Integer Instruction Set Architecture together with machine-mode privileged functionality required for exception and interrupt handling.

Phase 1 development objectives are considered complete.