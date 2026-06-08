// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_csr_regfile.h for the primary calling header

#include "Vtb_csr_regfile__pch.h"
#include "Vtb_csr_regfile__Syms.h"
#include "Vtb_csr_regfile___024root.h"

void Vtb_csr_regfile___024root___ctor_var_reset(Vtb_csr_regfile___024root* vlSelf);

Vtb_csr_regfile___024root::Vtb_csr_regfile___024root(Vtb_csr_regfile__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , __VdlySched{*symsp->_vm_contextp__}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vtb_csr_regfile___024root___ctor_var_reset(this);
}

void Vtb_csr_regfile___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vtb_csr_regfile___024root::~Vtb_csr_regfile___024root() {
}
