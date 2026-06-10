// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Valu.h for the primary calling header

#include "Valu__pch.h"
#include "Valu___024root.h"

VlCoroutine Valu___024root___eval_initial__TOP__Vtiming__0(Valu___024root* vlSelf);
VlCoroutine Valu___024root___eval_initial__TOP__Vtiming__1(Valu___024root* vlSelf);

void Valu___024root___eval_initial(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval_initial\n"); );
    // Body
    Valu___024root___eval_initial__TOP__Vtiming__0(vlSelf);
    Valu___024root___eval_initial__TOP__Vtiming__1(vlSelf);
    vlSelf->__Vtrigprevexpr___TOP__tb_csr__DOT__clk__0 
        = vlSelf->tb_csr__DOT__clk;
    vlSelf->__Vtrigprevexpr___TOP__tb_csr__DOT__rst_n__0 
        = vlSelf->tb_csr__DOT__rst_n;
}

VL_INLINE_OPT VlCoroutine Valu___024root___eval_initial__TOP__Vtiming__1(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval_initial__TOP__Vtiming__1\n"); );
    // Body
    while (1U) {
        co_await vlSelf->__VdlySched.delay(0x1388ULL, 
                                           nullptr, 
                                           "tb/tb_csr.v", 
                                           36);
        vlSelf->tb_csr__DOT__clk = (1U & (~ (IData)(vlSelf->tb_csr__DOT__clk)));
    }
}

void Valu___024root___eval_act(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval_act\n"); );
}

extern const VlUnpacked<CData/*3:0*/, 128> Valu__ConstPool__TABLE_h6d61c68a_0;

VL_INLINE_OPT void Valu___024root___nba_sequent__TOP__1(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___nba_sequent__TOP__1\n"); );
    // Init
    CData/*2:0*/ tb_csr__DOT__dut__DOT__alu_op;
    tb_csr__DOT__dut__DOT__alu_op = 0;
    CData/*6:0*/ __Vtableidx1;
    __Vtableidx1 = 0;
    // Body
    if (vlSelf->tb_csr__DOT__rst_n) {
        if (vlSelf->tb_csr__DOT__dut__DOT__csr_write) {
            if ((0x300U != (vlSelf->tb_csr__DOT__instr_in 
                            >> 0x14U))) {
                if ((0x305U != (vlSelf->tb_csr__DOT__instr_in 
                                >> 0x14U))) {
                    if ((0x341U != (vlSelf->tb_csr__DOT__instr_in 
                                    >> 0x14U))) {
                        if ((0x342U == (vlSelf->tb_csr__DOT__instr_in 
                                        >> 0x14U))) {
                            vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mcause 
                                = vlSelf->tb_csr__DOT__dut__DOT__csr_wdata_int;
                        }
                    }
                    if ((0x341U == (vlSelf->tb_csr__DOT__instr_in 
                                    >> 0x14U))) {
                        vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mepc 
                            = vlSelf->tb_csr__DOT__dut__DOT__csr_wdata_int;
                    }
                }
                if ((0x305U == (vlSelf->tb_csr__DOT__instr_in 
                                >> 0x14U))) {
                    vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mtvec 
                        = vlSelf->tb_csr__DOT__dut__DOT__csr_wdata_int;
                }
            }
            if ((0x300U == (vlSelf->tb_csr__DOT__instr_in 
                            >> 0x14U))) {
                vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mstatus 
                    = vlSelf->tb_csr__DOT__dut__DOT__csr_wdata_int;
            }
        }
        vlSelf->tb_csr__DOT__dut__DOT__pc_current = vlSelf->tb_csr__DOT__dut__DOT__pc_next;
    } else {
        vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mcause = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mstatus = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mepc = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mtvec = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__pc_current = 0U;
    }
    vlSelf->tb_csr__DOT__instr_in = vlSelf->tb_csr__DOT__instr_mem
        [(0xffU & (vlSelf->tb_csr__DOT__dut__DOT__pc_current 
                   >> 2U))];
    vlSelf->tb_csr__DOT__dut__DOT__reg_write = 0U;
    vlSelf->tb_csr__DOT__dut__DOT__reg_mux = 0U;
    vlSelf->tb_csr__DOT__dut__DOT__csr_write = 0U;
    vlSelf->tb_csr__DOT__dut__DOT__mem_write_internal = 0U;
    vlSelf->tb_csr__DOT__dut__DOT__csr_rdata = ((0x300U 
                                                 == 
                                                 (vlSelf->tb_csr__DOT__instr_in 
                                                  >> 0x14U))
                                                 ? vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mstatus
                                                 : 
                                                ((0x305U 
                                                  == 
                                                  (vlSelf->tb_csr__DOT__instr_in 
                                                   >> 0x14U))
                                                  ? vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mtvec
                                                  : 
                                                 ((0x341U 
                                                   == 
                                                   (vlSelf->tb_csr__DOT__instr_in 
                                                    >> 0x14U))
                                                   ? vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mepc
                                                   : 
                                                  ((0x342U 
                                                    == 
                                                    (vlSelf->tb_csr__DOT__instr_in 
                                                     >> 0x14U))
                                                    ? vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mcause
                                                    : 0U))));
    vlSelf->tb_csr__DOT__data_re = 0U;
    if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in >> 6U)))) {
        if ((0x20U & vlSelf->tb_csr__DOT__instr_in)) {
            if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                          >> 4U)))) {
                if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                              >> 3U)))) {
                    if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                                  >> 2U)))) {
                        vlSelf->tb_csr__DOT__dut__DOT__mem_write_internal = 1U;
                    }
                }
            }
        }
        if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                      >> 5U)))) {
            if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                          >> 4U)))) {
                if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                              >> 3U)))) {
                    if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                                  >> 2U)))) {
                        vlSelf->tb_csr__DOT__data_re = 1U;
                    }
                }
            }
        }
    }
    vlSelf->tb_csr__DOT__dut__DOT__branch = 0U;
    vlSelf->tb_csr__DOT__dut__DOT__jump = 0U;
    vlSelf->tb_csr__DOT__dut__DOT__jalr = 0U;
    vlSelf->tb_csr__DOT__dut__DOT__alu_src = 0U;
    vlSelf->tb_csr__DOT__dut__DOT__op1_src = 0U;
    tb_csr__DOT__dut__DOT__alu_op = 0U;
    if ((0x40U & vlSelf->tb_csr__DOT__instr_in)) {
        if ((0x20U & vlSelf->tb_csr__DOT__instr_in)) {
            if ((0x10U & vlSelf->tb_csr__DOT__instr_in)) {
                if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                              >> 3U)))) {
                    if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                                  >> 2U)))) {
                        if ((0U != (7U & (vlSelf->tb_csr__DOT__instr_in 
                                          >> 0xcU)))) {
                            vlSelf->tb_csr__DOT__dut__DOT__reg_write = 1U;
                            vlSelf->tb_csr__DOT__dut__DOT__reg_mux = 3U;
                            vlSelf->tb_csr__DOT__dut__DOT__csr_write 
                                = (1U & ((0x4000U & vlSelf->tb_csr__DOT__instr_in)
                                          ? ((0x2000U 
                                              & vlSelf->tb_csr__DOT__instr_in)
                                              ? ((0x1000U 
                                                  & vlSelf->tb_csr__DOT__instr_in)
                                                  ? 
                                                 (0U 
                                                  != 
                                                  (0x1fU 
                                                   & (vlSelf->tb_csr__DOT__instr_in 
                                                      >> 0xfU)))
                                                  : 
                                                 (0U 
                                                  != 
                                                  (0x1fU 
                                                   & (vlSelf->tb_csr__DOT__instr_in 
                                                      >> 0xfU))))
                                              : (vlSelf->tb_csr__DOT__instr_in 
                                                 >> 0xcU))
                                          : ((0x2000U 
                                              & vlSelf->tb_csr__DOT__instr_in)
                                              ? ((0x1000U 
                                                  & vlSelf->tb_csr__DOT__instr_in)
                                                  ? 
                                                 (0U 
                                                  != 
                                                  (0x1fU 
                                                   & (vlSelf->tb_csr__DOT__instr_in 
                                                      >> 0xfU)))
                                                  : 
                                                 (0U 
                                                  != 
                                                  (0x1fU 
                                                   & (vlSelf->tb_csr__DOT__instr_in 
                                                      >> 0xfU))))
                                              : (vlSelf->tb_csr__DOT__instr_in 
                                                 >> 0xcU))));
                        }
                    }
                }
                vlSelf->tb_csr__DOT__dut__DOT__imm_ext = 0U;
            } else if ((8U & vlSelf->tb_csr__DOT__instr_in)) {
                if ((4U & vlSelf->tb_csr__DOT__instr_in)) {
                    vlSelf->tb_csr__DOT__dut__DOT__reg_write = 1U;
                    vlSelf->tb_csr__DOT__dut__DOT__reg_mux = 2U;
                    vlSelf->tb_csr__DOT__dut__DOT__imm_ext 
                        = ((2U & vlSelf->tb_csr__DOT__instr_in)
                            ? ((1U & vlSelf->tb_csr__DOT__instr_in)
                                ? (((- (IData)((vlSelf->tb_csr__DOT__instr_in 
                                                >> 0x1fU))) 
                                    << 0x15U) | ((0x100000U 
                                                  & (vlSelf->tb_csr__DOT__instr_in 
                                                     >> 0xbU)) 
                                                 | ((0xff000U 
                                                     & vlSelf->tb_csr__DOT__instr_in) 
                                                    | ((0x800U 
                                                        & (vlSelf->tb_csr__DOT__instr_in 
                                                           >> 9U)) 
                                                       | (0x7feU 
                                                          & (vlSelf->tb_csr__DOT__instr_in 
                                                             >> 0x14U))))))
                                : 0U) : 0U);
                } else {
                    vlSelf->tb_csr__DOT__dut__DOT__imm_ext = 0U;
                }
            } else if ((4U & vlSelf->tb_csr__DOT__instr_in)) {
                vlSelf->tb_csr__DOT__dut__DOT__reg_write = 1U;
                vlSelf->tb_csr__DOT__dut__DOT__reg_mux = 2U;
                vlSelf->tb_csr__DOT__dut__DOT__imm_ext 
                    = ((2U & vlSelf->tb_csr__DOT__instr_in)
                        ? ((1U & vlSelf->tb_csr__DOT__instr_in)
                            ? (((- (IData)((vlSelf->tb_csr__DOT__instr_in 
                                            >> 0x1fU))) 
                                << 0xcU) | (vlSelf->tb_csr__DOT__instr_in 
                                            >> 0x14U))
                            : 0U) : 0U);
            } else {
                vlSelf->tb_csr__DOT__dut__DOT__imm_ext 
                    = ((2U & vlSelf->tb_csr__DOT__instr_in)
                        ? ((1U & vlSelf->tb_csr__DOT__instr_in)
                            ? (((- (IData)((vlSelf->tb_csr__DOT__instr_in 
                                            >> 0x1fU))) 
                                << 0xdU) | ((0x1000U 
                                             & (vlSelf->tb_csr__DOT__instr_in 
                                                >> 0x13U)) 
                                            | ((0x800U 
                                                & (vlSelf->tb_csr__DOT__instr_in 
                                                   << 4U)) 
                                               | ((0x7e0U 
                                                   & (vlSelf->tb_csr__DOT__instr_in 
                                                      >> 0x14U)) 
                                                  | (0x1eU 
                                                     & (vlSelf->tb_csr__DOT__instr_in 
                                                        >> 7U))))))
                            : 0U) : 0U);
            }
            if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                          >> 4U)))) {
                if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                              >> 3U)))) {
                    if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                                  >> 2U)))) {
                        vlSelf->tb_csr__DOT__dut__DOT__branch = 1U;
                    }
                    if ((4U & vlSelf->tb_csr__DOT__instr_in)) {
                        vlSelf->tb_csr__DOT__dut__DOT__jalr = 1U;
                    }
                }
                if ((8U & vlSelf->tb_csr__DOT__instr_in)) {
                    if ((4U & vlSelf->tb_csr__DOT__instr_in)) {
                        vlSelf->tb_csr__DOT__dut__DOT__jump = 1U;
                        vlSelf->tb_csr__DOT__dut__DOT__alu_src = 1U;
                        vlSelf->tb_csr__DOT__dut__DOT__op1_src = 1U;
                        tb_csr__DOT__dut__DOT__alu_op = 0U;
                    }
                } else {
                    if ((4U & vlSelf->tb_csr__DOT__instr_in)) {
                        vlSelf->tb_csr__DOT__dut__DOT__jump = 1U;
                        tb_csr__DOT__dut__DOT__alu_op = 0U;
                    } else {
                        tb_csr__DOT__dut__DOT__alu_op = 1U;
                    }
                    vlSelf->tb_csr__DOT__dut__DOT__alu_src 
                        = (1U & (vlSelf->tb_csr__DOT__instr_in 
                                 >> 2U));
                }
            }
        } else {
            vlSelf->tb_csr__DOT__dut__DOT__imm_ext = 0U;
        }
    } else {
        if ((0x20U & vlSelf->tb_csr__DOT__instr_in)) {
            if ((0x10U & vlSelf->tb_csr__DOT__instr_in)) {
                if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                              >> 3U)))) {
                    vlSelf->tb_csr__DOT__dut__DOT__reg_write = 1U;
                    if ((4U & vlSelf->tb_csr__DOT__instr_in)) {
                        vlSelf->tb_csr__DOT__dut__DOT__alu_src = 1U;
                        tb_csr__DOT__dut__DOT__alu_op = 5U;
                    } else {
                        tb_csr__DOT__dut__DOT__alu_op = 2U;
                    }
                }
                vlSelf->tb_csr__DOT__dut__DOT__imm_ext 
                    = ((8U & vlSelf->tb_csr__DOT__instr_in)
                        ? 0U : ((4U & vlSelf->tb_csr__DOT__instr_in)
                                 ? ((2U & vlSelf->tb_csr__DOT__instr_in)
                                     ? ((1U & vlSelf->tb_csr__DOT__instr_in)
                                         ? (0xfffff000U 
                                            & vlSelf->tb_csr__DOT__instr_in)
                                         : 0U) : 0U)
                                 : 0U));
            } else {
                if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                              >> 3U)))) {
                    if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                                  >> 2U)))) {
                        vlSelf->tb_csr__DOT__dut__DOT__alu_src = 1U;
                        tb_csr__DOT__dut__DOT__alu_op = 0U;
                    }
                }
                vlSelf->tb_csr__DOT__dut__DOT__imm_ext 
                    = ((8U & vlSelf->tb_csr__DOT__instr_in)
                        ? 0U : ((4U & vlSelf->tb_csr__DOT__instr_in)
                                 ? 0U : ((2U & vlSelf->tb_csr__DOT__instr_in)
                                          ? ((1U & vlSelf->tb_csr__DOT__instr_in)
                                              ? (((- (IData)(
                                                             (vlSelf->tb_csr__DOT__instr_in 
                                                              >> 0x1fU))) 
                                                  << 0xcU) 
                                                 | ((0xfe0U 
                                                     & (vlSelf->tb_csr__DOT__instr_in 
                                                        >> 0x14U)) 
                                                    | (0x1fU 
                                                       & (vlSelf->tb_csr__DOT__instr_in 
                                                          >> 7U))))
                                              : 0U)
                                          : 0U)));
            }
        } else if ((0x10U & vlSelf->tb_csr__DOT__instr_in)) {
            if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                          >> 3U)))) {
                vlSelf->tb_csr__DOT__dut__DOT__reg_write = 1U;
                vlSelf->tb_csr__DOT__dut__DOT__alu_src = 1U;
                tb_csr__DOT__dut__DOT__alu_op = ((4U 
                                                  & vlSelf->tb_csr__DOT__instr_in)
                                                  ? 0U
                                                  : 3U);
            }
            vlSelf->tb_csr__DOT__dut__DOT__imm_ext 
                = ((8U & vlSelf->tb_csr__DOT__instr_in)
                    ? 0U : ((4U & vlSelf->tb_csr__DOT__instr_in)
                             ? ((2U & vlSelf->tb_csr__DOT__instr_in)
                                 ? ((1U & vlSelf->tb_csr__DOT__instr_in)
                                     ? (0xfffff000U 
                                        & vlSelf->tb_csr__DOT__instr_in)
                                     : 0U) : 0U) : 
                            ((2U & vlSelf->tb_csr__DOT__instr_in)
                              ? ((1U & vlSelf->tb_csr__DOT__instr_in)
                                  ? (((- (IData)((vlSelf->tb_csr__DOT__instr_in 
                                                  >> 0x1fU))) 
                                      << 0xcU) | (vlSelf->tb_csr__DOT__instr_in 
                                                  >> 0x14U))
                                  : 0U) : 0U)));
        } else {
            if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                          >> 3U)))) {
                if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                              >> 2U)))) {
                    vlSelf->tb_csr__DOT__dut__DOT__reg_write = 1U;
                    vlSelf->tb_csr__DOT__dut__DOT__alu_src = 1U;
                    tb_csr__DOT__dut__DOT__alu_op = 0U;
                }
            }
            vlSelf->tb_csr__DOT__dut__DOT__imm_ext 
                = ((8U & vlSelf->tb_csr__DOT__instr_in)
                    ? 0U : ((4U & vlSelf->tb_csr__DOT__instr_in)
                             ? 0U : ((2U & vlSelf->tb_csr__DOT__instr_in)
                                      ? ((1U & vlSelf->tb_csr__DOT__instr_in)
                                          ? (((- (IData)(
                                                         (vlSelf->tb_csr__DOT__instr_in 
                                                          >> 0x1fU))) 
                                              << 0xcU) 
                                             | (vlSelf->tb_csr__DOT__instr_in 
                                                >> 0x14U))
                                          : 0U) : 0U)));
        }
        if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                      >> 5U)))) {
            if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                          >> 4U)))) {
                if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                              >> 3U)))) {
                    if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                                  >> 2U)))) {
                        vlSelf->tb_csr__DOT__dut__DOT__reg_mux = 1U;
                    }
                }
            }
            if ((0x10U & vlSelf->tb_csr__DOT__instr_in)) {
                if ((1U & (~ (vlSelf->tb_csr__DOT__instr_in 
                              >> 3U)))) {
                    if ((4U & vlSelf->tb_csr__DOT__instr_in)) {
                        vlSelf->tb_csr__DOT__dut__DOT__op1_src = 1U;
                    }
                }
            }
        }
    }
    __Vtableidx1 = ((0x40U & (vlSelf->tb_csr__DOT__instr_in 
                              >> 0x18U)) | ((0x38U 
                                             & (vlSelf->tb_csr__DOT__instr_in 
                                                >> 9U)) 
                                            | (IData)(tb_csr__DOT__dut__DOT__alu_op)));
    vlSelf->tb_csr__DOT__dut__DOT__alu_ctrl = Valu__ConstPool__TABLE_h6d61c68a_0
        [__Vtableidx1];
    vlSelf->tb_csr__DOT__dut__DOT__pc_logic__DOT__branch_targ 
        = (vlSelf->tb_csr__DOT__dut__DOT__imm_ext + vlSelf->tb_csr__DOT__dut__DOT__pc_current);
}

VL_INLINE_OPT void Valu___024root___nba_comb__TOP__0(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___nba_comb__TOP__0\n"); );
    // Init
    IData/*31:0*/ tb_csr__DOT__data_rdata;
    tb_csr__DOT__data_rdata = 0;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__rd1_data;
    tb_csr__DOT__dut__DOT__rd1_data = 0;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__rd2_data;
    tb_csr__DOT__dut__DOT__rd2_data = 0;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__operand_a;
    tb_csr__DOT__dut__DOT__operand_a = 0;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__operand_b;
    tb_csr__DOT__dut__DOT__operand_b = 0;
    // Body
    tb_csr__DOT__dut__DOT__rd2_data = vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
        [(0x1fU & (vlSelf->tb_csr__DOT__instr_in >> 0x14U))];
    tb_csr__DOT__dut__DOT__rd1_data = vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
        [(0x1fU & (vlSelf->tb_csr__DOT__instr_in >> 0xfU))];
    tb_csr__DOT__dut__DOT__operand_b = ((IData)(vlSelf->tb_csr__DOT__dut__DOT__alu_src)
                                         ? vlSelf->tb_csr__DOT__dut__DOT__imm_ext
                                         : tb_csr__DOT__dut__DOT__rd2_data);
    tb_csr__DOT__dut__DOT__operand_a = ((IData)(vlSelf->tb_csr__DOT__dut__DOT__op1_src)
                                         ? vlSelf->tb_csr__DOT__dut__DOT__pc_current
                                         : tb_csr__DOT__dut__DOT__rd1_data);
    vlSelf->tb_csr__DOT__dut__DOT__alu_result = ((8U 
                                                  & (IData)(vlSelf->tb_csr__DOT__dut__DOT__alu_ctrl))
                                                  ? 
                                                 ((4U 
                                                   & (IData)(vlSelf->tb_csr__DOT__dut__DOT__alu_ctrl))
                                                   ? 0U
                                                   : 
                                                  ((2U 
                                                    & (IData)(vlSelf->tb_csr__DOT__dut__DOT__alu_ctrl))
                                                    ? 
                                                   ((1U 
                                                     & (IData)(vlSelf->tb_csr__DOT__dut__DOT__alu_ctrl))
                                                     ? 0U
                                                     : tb_csr__DOT__dut__DOT__operand_b)
                                                    : 
                                                   ((1U 
                                                     & (IData)(vlSelf->tb_csr__DOT__dut__DOT__alu_ctrl))
                                                     ? 
                                                    (tb_csr__DOT__dut__DOT__operand_a 
                                                     & tb_csr__DOT__dut__DOT__operand_b)
                                                     : 
                                                    (tb_csr__DOT__dut__DOT__operand_a 
                                                     | tb_csr__DOT__dut__DOT__operand_b))))
                                                  : 
                                                 ((4U 
                                                   & (IData)(vlSelf->tb_csr__DOT__dut__DOT__alu_ctrl))
                                                   ? 
                                                  ((2U 
                                                    & (IData)(vlSelf->tb_csr__DOT__dut__DOT__alu_ctrl))
                                                    ? 
                                                   ((1U 
                                                     & (IData)(vlSelf->tb_csr__DOT__dut__DOT__alu_ctrl))
                                                     ? 
                                                    VL_SHIFTRS_III(32,32,5, tb_csr__DOT__dut__DOT__operand_a, 
                                                                   (0x1fU 
                                                                    & tb_csr__DOT__dut__DOT__operand_b))
                                                     : 
                                                    (tb_csr__DOT__dut__DOT__operand_a 
                                                     >> 
                                                     (0x1fU 
                                                      & tb_csr__DOT__dut__DOT__operand_b)))
                                                    : 
                                                   ((1U 
                                                     & (IData)(vlSelf->tb_csr__DOT__dut__DOT__alu_ctrl))
                                                     ? 
                                                    (tb_csr__DOT__dut__DOT__operand_a 
                                                     ^ tb_csr__DOT__dut__DOT__operand_b)
                                                     : 
                                                    ((tb_csr__DOT__dut__DOT__operand_a 
                                                      < tb_csr__DOT__dut__DOT__operand_b)
                                                      ? 1U
                                                      : 0U)))
                                                   : 
                                                  ((2U 
                                                    & (IData)(vlSelf->tb_csr__DOT__dut__DOT__alu_ctrl))
                                                    ? 
                                                   ((1U 
                                                     & (IData)(vlSelf->tb_csr__DOT__dut__DOT__alu_ctrl))
                                                     ? 
                                                    (VL_LTS_III(32, tb_csr__DOT__dut__DOT__operand_a, tb_csr__DOT__dut__DOT__operand_b)
                                                      ? 1U
                                                      : 0U)
                                                     : 
                                                    (tb_csr__DOT__dut__DOT__operand_a 
                                                     << 
                                                     (0x1fU 
                                                      & tb_csr__DOT__dut__DOT__operand_b)))
                                                    : 
                                                   ((1U 
                                                     & (IData)(vlSelf->tb_csr__DOT__dut__DOT__alu_ctrl))
                                                     ? 
                                                    (tb_csr__DOT__dut__DOT__operand_a 
                                                     - tb_csr__DOT__dut__DOT__operand_b)
                                                     : 
                                                    (tb_csr__DOT__dut__DOT__operand_a 
                                                     + tb_csr__DOT__dut__DOT__operand_b)))));
    if (vlSelf->tb_csr__DOT__dut__DOT__mem_write_internal) {
        if ((0U == (3U & (vlSelf->tb_csr__DOT__instr_in 
                          >> 0xcU)))) {
            vlSelf->tb_csr__DOT__dut__DOT__lsu__DOT__be 
                = ((2U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)
                    ? ((1U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)
                        ? 8U : 4U) : ((1U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)
                                       ? 2U : 1U));
        } else if ((1U == (3U & (vlSelf->tb_csr__DOT__instr_in 
                                 >> 0xcU)))) {
            if ((2U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)) {
                if ((2U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)) {
                    vlSelf->tb_csr__DOT__dut__DOT__lsu__DOT__be = 0xcU;
                }
            } else {
                vlSelf->tb_csr__DOT__dut__DOT__lsu__DOT__be = 3U;
            }
        } else {
            vlSelf->tb_csr__DOT__dut__DOT__lsu__DOT__be 
                = ((2U == (3U & (vlSelf->tb_csr__DOT__instr_in 
                                 >> 0xcU))) ? 0xfU : 0U);
        }
    } else {
        vlSelf->tb_csr__DOT__dut__DOT__lsu__DOT__be = 0U;
    }
    if ((0U == (3U & (vlSelf->tb_csr__DOT__instr_in 
                      >> 0xcU)))) {
        vlSelf->tb_csr__DOT__dut__DOT__lsu__DOT__wdata 
            = ((2U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)
                ? ((1U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)
                    ? (tb_csr__DOT__dut__DOT__rd2_data 
                       << 0x18U) : (0xff0000U & (tb_csr__DOT__dut__DOT__rd2_data 
                                                 << 0x10U)))
                : ((1U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)
                    ? (0xff00U & (tb_csr__DOT__dut__DOT__rd2_data 
                                  << 8U)) : (0xffU 
                                             & tb_csr__DOT__dut__DOT__rd2_data)));
    } else if ((1U == (3U & (vlSelf->tb_csr__DOT__instr_in 
                             >> 0xcU)))) {
        if ((2U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)) {
            if ((2U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)) {
                vlSelf->tb_csr__DOT__dut__DOT__lsu__DOT__wdata 
                    = (tb_csr__DOT__dut__DOT__rd2_data 
                       << 0x10U);
            }
        } else {
            vlSelf->tb_csr__DOT__dut__DOT__lsu__DOT__wdata 
                = (0xffffU & tb_csr__DOT__dut__DOT__rd2_data);
        }
    } else {
        vlSelf->tb_csr__DOT__dut__DOT__lsu__DOT__wdata 
            = tb_csr__DOT__dut__DOT__rd2_data;
    }
    tb_csr__DOT__data_rdata = ((IData)(vlSelf->tb_csr__DOT__data_re)
                                ? vlSelf->tb_csr__DOT__data_mem
                               [(0xffU & (vlSelf->tb_csr__DOT__dut__DOT__alu_result 
                                          >> 2U))] : 0U);
    if ((0x4000U & vlSelf->tb_csr__DOT__instr_in)) {
        if ((0x2000U & vlSelf->tb_csr__DOT__instr_in)) {
            vlSelf->tb_csr__DOT__dut__DOT__csr_wdata_int 
                = ((0x1000U & vlSelf->tb_csr__DOT__instr_in)
                    ? (vlSelf->tb_csr__DOT__dut__DOT__csr_rdata 
                       & (~ (0x1fU & (vlSelf->tb_csr__DOT__instr_in 
                                      >> 0xfU)))) : 
                   (vlSelf->tb_csr__DOT__dut__DOT__csr_rdata 
                    | (0x1fU & (vlSelf->tb_csr__DOT__instr_in 
                                >> 0xfU))));
            vlSelf->tb_csr__DOT__dut__DOT__load_data_internal 
                = tb_csr__DOT__data_rdata;
        } else if ((0x1000U & vlSelf->tb_csr__DOT__instr_in)) {
            vlSelf->tb_csr__DOT__dut__DOT__csr_wdata_int 
                = (0x1fU & (vlSelf->tb_csr__DOT__instr_in 
                            >> 0xfU));
            if ((2U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)) {
                if ((2U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)) {
                    vlSelf->tb_csr__DOT__dut__DOT__load_data_internal 
                        = (tb_csr__DOT__data_rdata 
                           >> 0x10U);
                }
            } else {
                vlSelf->tb_csr__DOT__dut__DOT__load_data_internal 
                    = (0xffffU & tb_csr__DOT__data_rdata);
            }
        } else {
            vlSelf->tb_csr__DOT__dut__DOT__csr_wdata_int = 0U;
            vlSelf->tb_csr__DOT__dut__DOT__load_data_internal 
                = ((2U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)
                    ? ((1U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)
                        ? (tb_csr__DOT__data_rdata 
                           >> 0x18U) : (0xffU & (tb_csr__DOT__data_rdata 
                                                 >> 0x10U)))
                    : ((1U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)
                        ? (0xffU & (tb_csr__DOT__data_rdata 
                                    >> 8U)) : (0xffU 
                                               & tb_csr__DOT__data_rdata)));
        }
    } else if ((0x2000U & vlSelf->tb_csr__DOT__instr_in)) {
        vlSelf->tb_csr__DOT__dut__DOT__csr_wdata_int 
            = ((0x1000U & vlSelf->tb_csr__DOT__instr_in)
                ? (vlSelf->tb_csr__DOT__dut__DOT__csr_rdata 
                   & (~ tb_csr__DOT__dut__DOT__rd1_data))
                : (vlSelf->tb_csr__DOT__dut__DOT__csr_rdata 
                   | tb_csr__DOT__dut__DOT__rd1_data));
        vlSelf->tb_csr__DOT__dut__DOT__load_data_internal 
            = tb_csr__DOT__data_rdata;
    } else if ((0x1000U & vlSelf->tb_csr__DOT__instr_in)) {
        vlSelf->tb_csr__DOT__dut__DOT__csr_wdata_int 
            = tb_csr__DOT__dut__DOT__rd1_data;
        if ((2U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)) {
            if ((2U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)) {
                vlSelf->tb_csr__DOT__dut__DOT__load_data_internal 
                    = (((- (IData)((tb_csr__DOT__data_rdata 
                                    >> 0x1fU))) << 0x10U) 
                       | (tb_csr__DOT__data_rdata >> 0x10U));
            }
        } else {
            vlSelf->tb_csr__DOT__dut__DOT__load_data_internal 
                = (((- (IData)((1U & (tb_csr__DOT__data_rdata 
                                      >> 0xfU)))) << 0x10U) 
                   | (0xffffU & tb_csr__DOT__data_rdata));
        }
    } else {
        vlSelf->tb_csr__DOT__dut__DOT__csr_wdata_int = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__load_data_internal 
            = ((2U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)
                ? ((1U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)
                    ? (((- (IData)((tb_csr__DOT__data_rdata 
                                    >> 0x1fU))) << 8U) 
                       | (tb_csr__DOT__data_rdata >> 0x18U))
                    : (((- (IData)((1U & (tb_csr__DOT__data_rdata 
                                          >> 0x17U)))) 
                        << 8U) | (0xffU & (tb_csr__DOT__data_rdata 
                                           >> 0x10U))))
                : ((1U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)
                    ? (((- (IData)((1U & (tb_csr__DOT__data_rdata 
                                          >> 0xfU)))) 
                        << 8U) | (0xffU & (tb_csr__DOT__data_rdata 
                                           >> 8U)))
                    : (((- (IData)((1U & (tb_csr__DOT__data_rdata 
                                          >> 7U)))) 
                        << 8U) | (0xffU & tb_csr__DOT__data_rdata))));
    }
    vlSelf->tb_csr__DOT__dut__DOT__pc_next = ((IData)(vlSelf->tb_csr__DOT__dut__DOT__jump)
                                               ? ((IData)(vlSelf->tb_csr__DOT__dut__DOT__jalr)
                                                   ? 
                                                  (0xfffffffeU 
                                                   & (vlSelf->tb_csr__DOT__dut__DOT__imm_ext 
                                                      + tb_csr__DOT__dut__DOT__rd1_data))
                                                   : vlSelf->tb_csr__DOT__dut__DOT__pc_logic__DOT__branch_targ)
                                               : (((IData)(vlSelf->tb_csr__DOT__dut__DOT__branch) 
                                                   & ((0x4000U 
                                                       & vlSelf->tb_csr__DOT__instr_in)
                                                       ? 
                                                      ((0x2000U 
                                                        & vlSelf->tb_csr__DOT__instr_in)
                                                        ? 
                                                       ((0x1000U 
                                                         & vlSelf->tb_csr__DOT__instr_in)
                                                         ? 
                                                        (~ vlSelf->tb_csr__DOT__dut__DOT__alu_result)
                                                         : vlSelf->tb_csr__DOT__dut__DOT__alu_result)
                                                        : 
                                                       ((0x1000U 
                                                         & vlSelf->tb_csr__DOT__instr_in)
                                                         ? 
                                                        (~ vlSelf->tb_csr__DOT__dut__DOT__alu_result)
                                                         : vlSelf->tb_csr__DOT__dut__DOT__alu_result))
                                                       : 
                                                      ((1U 
                                                        & (~ 
                                                           (vlSelf->tb_csr__DOT__instr_in 
                                                            >> 0xdU))) 
                                                       && ((0x1000U 
                                                            & vlSelf->tb_csr__DOT__instr_in)
                                                            ? 
                                                           (0U 
                                                            != vlSelf->tb_csr__DOT__dut__DOT__alu_result)
                                                            : 
                                                           (0U 
                                                            == vlSelf->tb_csr__DOT__dut__DOT__alu_result)))))
                                                   ? vlSelf->tb_csr__DOT__dut__DOT__pc_logic__DOT__branch_targ
                                                   : 
                                                  ((IData)(4U) 
                                                   + vlSelf->tb_csr__DOT__dut__DOT__pc_current)));
}

void Valu___024root___nba_sequent__TOP__0(Valu___024root* vlSelf);

void Valu___024root___eval_nba(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Valu___024root___nba_sequent__TOP__0(vlSelf);
    }
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Valu___024root___nba_sequent__TOP__1(vlSelf);
    }
    if ((3ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Valu___024root___nba_comb__TOP__0(vlSelf);
    }
}

void Valu___024root___timing_resume(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___timing_resume\n"); );
    // Body
    if ((4ULL & vlSelf->__VactTriggered.word(0U))) {
        vlSelf->__VdlySched.resume();
    }
}

void Valu___024root___eval_triggers__act(Valu___024root* vlSelf);

bool Valu___024root___eval_phase__act(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval_phase__act\n"); );
    // Init
    VlTriggerVec<3> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Valu___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelf->__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
        vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
        Valu___024root___timing_resume(vlSelf);
        Valu___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Valu___024root___eval_phase__nba(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval_phase__nba\n"); );
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelf->__VnbaTriggered.any();
    if (__VnbaExecute) {
        Valu___024root___eval_nba(vlSelf);
        vlSelf->__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Valu___024root___dump_triggers__nba(Valu___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Valu___024root___dump_triggers__act(Valu___024root* vlSelf);
#endif  // VL_DEBUG

void Valu___024root___eval(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval\n"); );
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Valu___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("tb/tb_csr.v", 3, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                Valu___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("tb/tb_csr.v", 3, "", "Active region did not converge.");
            }
            vlSelf->__VactIterCount = ((IData)(1U) 
                                       + vlSelf->__VactIterCount);
            vlSelf->__VactContinue = 0U;
            if (Valu___024root___eval_phase__act(vlSelf)) {
                vlSelf->__VactContinue = 1U;
            }
        }
        if (Valu___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Valu___024root___eval_debug_assertions(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval_debug_assertions\n"); );
}
#endif  // VL_DEBUG
