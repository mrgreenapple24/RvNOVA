// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcsr_regfile.h for the primary calling header

#include "Vcsr_regfile__pch.h"
#include "Vcsr_regfile__Syms.h"
#include "Vcsr_regfile___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcsr_regfile___024root___dump_triggers__stl(Vcsr_regfile___024root* vlSelf);
#endif  // VL_DEBUG

VL_ATTR_COLD void Vcsr_regfile___024root___eval_triggers__stl(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___eval_triggers__stl\n"); );
    // Body
    vlSelf->__VstlTriggered.set(0U, (IData)(vlSelf->__VstlFirstIteration));
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vcsr_regfile___024root___dump_triggers__stl(vlSelf);
    }
#endif
}
