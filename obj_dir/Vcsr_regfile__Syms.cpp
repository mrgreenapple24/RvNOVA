// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vcsr_regfile__pch.h"
#include "Vcsr_regfile.h"
#include "Vcsr_regfile___024root.h"

// FUNCTIONS
Vcsr_regfile__Syms::~Vcsr_regfile__Syms()
{
}

Vcsr_regfile__Syms::Vcsr_regfile__Syms(VerilatedContext* contextp, const char* namep, Vcsr_regfile* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
{
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-9);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
    // Setup scopes
    __Vscope_tb_csr_regfile.configure(this, name(), "tb_csr_regfile", "tb_csr_regfile", -9, VerilatedScope::SCOPE_OTHER);
}
