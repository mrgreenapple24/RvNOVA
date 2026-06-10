// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcsr_regfile.h for the primary calling header

#include "Vcsr_regfile__pch.h"
#include "Vcsr_regfile___024root.h"

VL_ATTR_COLD void Vcsr_regfile___024root___eval_static(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vcsr_regfile___024root___eval_final(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___eval_final\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcsr_regfile___024root___dump_triggers__stl(Vcsr_regfile___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vcsr_regfile___024root___eval_phase__stl(Vcsr_regfile___024root* vlSelf);

VL_ATTR_COLD void Vcsr_regfile___024root___eval_settle(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___eval_settle\n"); );
    // Init
    IData/*31:0*/ __VstlIterCount;
    CData/*0:0*/ __VstlContinue;
    // Body
    __VstlIterCount = 0U;
    vlSelf->__VstlFirstIteration = 1U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        if (VL_UNLIKELY((0x64U < __VstlIterCount))) {
#ifdef VL_DEBUG
            Vcsr_regfile___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("tb/tb_csr_regfile.v", 3, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vcsr_regfile___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelf->__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcsr_regfile___024root___dump_triggers__stl(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

void Vcsr_regfile___024root___act_sequent__TOP__0(Vcsr_regfile___024root* vlSelf);

VL_ATTR_COLD void Vcsr_regfile___024root___eval_stl(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___eval_stl\n"); );
    // Body
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        Vcsr_regfile___024root___act_sequent__TOP__0(vlSelf);
    }
}

VL_ATTR_COLD void Vcsr_regfile___024root___eval_triggers__stl(Vcsr_regfile___024root* vlSelf);

VL_ATTR_COLD bool Vcsr_regfile___024root___eval_phase__stl(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___eval_phase__stl\n"); );
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vcsr_regfile___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelf->__VstlTriggered.any();
    if (__VstlExecute) {
        Vcsr_regfile___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcsr_regfile___024root___dump_triggers__act(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge tb_csr_regfile.clk or negedge tb_csr_regfile.rst_n)\n");
    }
    if ((2ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcsr_regfile___024root___dump_triggers__nba(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge tb_csr_regfile.clk or negedge tb_csr_regfile.rst_n)\n");
    }
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vcsr_regfile___024root___ctor_var_reset(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->tb_csr_regfile__DOT__clk = VL_RAND_RESET_I(1);
    vlSelf->tb_csr_regfile__DOT__rst_n = VL_RAND_RESET_I(1);
    vlSelf->tb_csr_regfile__DOT__csr_we = VL_RAND_RESET_I(1);
    vlSelf->tb_csr_regfile__DOT__csr_waddr = VL_RAND_RESET_I(12);
    vlSelf->tb_csr_regfile__DOT__csr_raddr = VL_RAND_RESET_I(12);
    vlSelf->tb_csr_regfile__DOT__csr_wdata = VL_RAND_RESET_I(32);
    vlSelf->tb_csr_regfile__DOT__csr_rdata = VL_RAND_RESET_I(32);
    vlSelf->tb_csr_regfile__DOT__dut__DOT__mstatus = VL_RAND_RESET_I(32);
    vlSelf->tb_csr_regfile__DOT__dut__DOT__mtvec = VL_RAND_RESET_I(32);
    vlSelf->tb_csr_regfile__DOT__dut__DOT__mepc = VL_RAND_RESET_I(32);
    vlSelf->tb_csr_regfile__DOT__dut__DOT__mcause = VL_RAND_RESET_I(32);
    vlSelf->tb_csr_regfile__DOT__dut__DOT__mtval = VL_RAND_RESET_I(32);
    vlSelf->__Vtrigprevexpr___TOP__tb_csr_regfile__DOT__clk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__tb_csr_regfile__DOT__rst_n__0 = VL_RAND_RESET_I(1);
}
