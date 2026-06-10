// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcsr_regfile.h for the primary calling header

#include "Vcsr_regfile__pch.h"
#include "Vcsr_regfile___024root.h"

VlCoroutine Vcsr_regfile___024root___eval_initial__TOP__Vtiming__0(Vcsr_regfile___024root* vlSelf);
VlCoroutine Vcsr_regfile___024root___eval_initial__TOP__Vtiming__1(Vcsr_regfile___024root* vlSelf);

void Vcsr_regfile___024root___eval_initial(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___eval_initial\n"); );
    // Body
    Vcsr_regfile___024root___eval_initial__TOP__Vtiming__0(vlSelf);
    Vcsr_regfile___024root___eval_initial__TOP__Vtiming__1(vlSelf);
    vlSelf->__Vtrigprevexpr___TOP__tb_csr_regfile__DOT__clk__0 
        = vlSelf->tb_csr_regfile__DOT__clk;
    vlSelf->__Vtrigprevexpr___TOP__tb_csr_regfile__DOT__rst_n__0 
        = vlSelf->tb_csr_regfile__DOT__rst_n;
}

VL_INLINE_OPT VlCoroutine Vcsr_regfile___024root___eval_initial__TOP__Vtiming__1(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___eval_initial__TOP__Vtiming__1\n"); );
    // Body
    while (1U) {
        co_await vlSelf->__VdlySched.delay(0x1388ULL, 
                                           nullptr, 
                                           "tb/tb_csr_regfile.v", 
                                           25);
        vlSelf->tb_csr_regfile__DOT__clk = (1U & (~ (IData)(vlSelf->tb_csr_regfile__DOT__clk)));
    }
}

VL_INLINE_OPT void Vcsr_regfile___024root___act_sequent__TOP__0(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___act_sequent__TOP__0\n"); );
    // Body
    vlSelf->tb_csr_regfile__DOT__csr_rdata = ((0x300U 
                                               == (IData)(vlSelf->tb_csr_regfile__DOT__csr_raddr))
                                               ? vlSelf->tb_csr_regfile__DOT__dut__DOT__mstatus
                                               : ((0x305U 
                                                   == (IData)(vlSelf->tb_csr_regfile__DOT__csr_raddr))
                                                   ? vlSelf->tb_csr_regfile__DOT__dut__DOT__mtvec
                                                   : 
                                                  ((0x341U 
                                                    == (IData)(vlSelf->tb_csr_regfile__DOT__csr_raddr))
                                                    ? vlSelf->tb_csr_regfile__DOT__dut__DOT__mepc
                                                    : 
                                                   ((0x342U 
                                                     == (IData)(vlSelf->tb_csr_regfile__DOT__csr_raddr))
                                                     ? vlSelf->tb_csr_regfile__DOT__dut__DOT__mcause
                                                     : 
                                                    ((0x343U 
                                                      == (IData)(vlSelf->tb_csr_regfile__DOT__csr_raddr))
                                                      ? vlSelf->tb_csr_regfile__DOT__dut__DOT__mtval
                                                      : 0U)))));
}

void Vcsr_regfile___024root___eval_act(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___eval_act\n"); );
    // Body
    if ((2ULL & vlSelf->__VactTriggered.word(0U))) {
        Vcsr_regfile___024root___act_sequent__TOP__0(vlSelf);
    }
}

VL_INLINE_OPT void Vcsr_regfile___024root___nba_sequent__TOP__0(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___nba_sequent__TOP__0\n"); );
    // Body
    if (vlSelf->tb_csr_regfile__DOT__rst_n) {
        if (vlSelf->tb_csr_regfile__DOT__csr_we) {
            if ((0x300U != (IData)(vlSelf->tb_csr_regfile__DOT__csr_waddr))) {
                if ((0x305U == (IData)(vlSelf->tb_csr_regfile__DOT__csr_waddr))) {
                    vlSelf->tb_csr_regfile__DOT__dut__DOT__mtvec 
                        = vlSelf->tb_csr_regfile__DOT__csr_wdata;
                }
                if ((0x305U != (IData)(vlSelf->tb_csr_regfile__DOT__csr_waddr))) {
                    if ((0x341U != (IData)(vlSelf->tb_csr_regfile__DOT__csr_waddr))) {
                        if ((0x342U != (IData)(vlSelf->tb_csr_regfile__DOT__csr_waddr))) {
                            if ((0x343U == (IData)(vlSelf->tb_csr_regfile__DOT__csr_waddr))) {
                                vlSelf->tb_csr_regfile__DOT__dut__DOT__mtval 
                                    = vlSelf->tb_csr_regfile__DOT__csr_wdata;
                            }
                        }
                        if ((0x342U == (IData)(vlSelf->tb_csr_regfile__DOT__csr_waddr))) {
                            vlSelf->tb_csr_regfile__DOT__dut__DOT__mcause 
                                = vlSelf->tb_csr_regfile__DOT__csr_wdata;
                        }
                    }
                    if ((0x341U == (IData)(vlSelf->tb_csr_regfile__DOT__csr_waddr))) {
                        vlSelf->tb_csr_regfile__DOT__dut__DOT__mepc 
                            = vlSelf->tb_csr_regfile__DOT__csr_wdata;
                    }
                }
            }
            if ((0x300U == (IData)(vlSelf->tb_csr_regfile__DOT__csr_waddr))) {
                vlSelf->tb_csr_regfile__DOT__dut__DOT__mstatus 
                    = vlSelf->tb_csr_regfile__DOT__csr_wdata;
            }
        }
    } else {
        vlSelf->tb_csr_regfile__DOT__dut__DOT__mtvec = 0U;
        vlSelf->tb_csr_regfile__DOT__dut__DOT__mtval = 0U;
        vlSelf->tb_csr_regfile__DOT__dut__DOT__mcause = 0U;
        vlSelf->tb_csr_regfile__DOT__dut__DOT__mstatus = 0U;
        vlSelf->tb_csr_regfile__DOT__dut__DOT__mepc = 0U;
    }
}

void Vcsr_regfile___024root___eval_nba(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vcsr_regfile___024root___nba_sequent__TOP__0(vlSelf);
    }
    if ((3ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vcsr_regfile___024root___act_sequent__TOP__0(vlSelf);
    }
}

void Vcsr_regfile___024root___timing_resume(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___timing_resume\n"); );
    // Body
    if ((2ULL & vlSelf->__VactTriggered.word(0U))) {
        vlSelf->__VdlySched.resume();
    }
}

void Vcsr_regfile___024root___eval_triggers__act(Vcsr_regfile___024root* vlSelf);

bool Vcsr_regfile___024root___eval_phase__act(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___eval_phase__act\n"); );
    // Init
    VlTriggerVec<2> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vcsr_regfile___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelf->__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
        vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
        Vcsr_regfile___024root___timing_resume(vlSelf);
        Vcsr_regfile___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vcsr_regfile___024root___eval_phase__nba(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___eval_phase__nba\n"); );
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelf->__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vcsr_regfile___024root___eval_nba(vlSelf);
        vlSelf->__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcsr_regfile___024root___dump_triggers__nba(Vcsr_regfile___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vcsr_regfile___024root___dump_triggers__act(Vcsr_regfile___024root* vlSelf);
#endif  // VL_DEBUG

void Vcsr_regfile___024root___eval(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___eval\n"); );
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vcsr_regfile___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("tb/tb_csr_regfile.v", 3, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                Vcsr_regfile___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("tb/tb_csr_regfile.v", 3, "", "Active region did not converge.");
            }
            vlSelf->__VactIterCount = ((IData)(1U) 
                                       + vlSelf->__VactIterCount);
            vlSelf->__VactContinue = 0U;
            if (Vcsr_regfile___024root___eval_phase__act(vlSelf)) {
                vlSelf->__VactContinue = 1U;
            }
        }
        if (Vcsr_regfile___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vcsr_regfile___024root___eval_debug_assertions(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___eval_debug_assertions\n"); );
}
#endif  // VL_DEBUG
