// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcsr_regfile.h for the primary calling header

#include "Vcsr_regfile__pch.h"
#include "Vcsr_regfile__Syms.h"
#include "Vcsr_regfile___024root.h"

void Vcsr_regfile___024root___ctor_var_reset(Vcsr_regfile___024root* vlSelf);

Vcsr_regfile___024root::Vcsr_regfile___024root(Vcsr_regfile__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , __VdlySched{*symsp->_vm_contextp__}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vcsr_regfile___024root___ctor_var_reset(this);
}

void Vcsr_regfile___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vcsr_regfile___024root::~Vcsr_regfile___024root() {
}
