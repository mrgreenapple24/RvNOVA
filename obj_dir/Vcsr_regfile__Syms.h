// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VCSR_REGFILE__SYMS_H_
#define VERILATED_VCSR_REGFILE__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vcsr_regfile.h"

// INCLUDE MODULE CLASSES
#include "Vcsr_regfile___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES)Vcsr_regfile__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vcsr_regfile* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vcsr_regfile___024root         TOP;

    // SCOPE NAMES
    VerilatedScope __Vscope_tb_csr_regfile;

    // CONSTRUCTORS
    Vcsr_regfile__Syms(VerilatedContext* contextp, const char* namep, Vcsr_regfile* modelp);
    ~Vcsr_regfile__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
};

#endif  // guard
