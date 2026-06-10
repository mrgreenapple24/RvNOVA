// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Valu.h for the primary calling header

#include "Valu__pch.h"
#include "Valu___024root.h"

VL_ATTR_COLD void Valu___024root___eval_static(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval_static\n"); );
}

VL_ATTR_COLD void Valu___024root___eval_final(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval_final\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Valu___024root___dump_triggers__stl(Valu___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Valu___024root___eval_phase__stl(Valu___024root* vlSelf);

VL_ATTR_COLD void Valu___024root___eval_settle(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval_settle\n"); );
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
            Valu___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("tb/tb_csr.v", 3, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Valu___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelf->__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Valu___024root___dump_triggers__stl(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

extern const VlUnpacked<CData/*3:0*/, 128> Valu__ConstPool__TABLE_h6d61c68a_0;

VL_ATTR_COLD void Valu___024root___stl_sequent__TOP__0(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___stl_sequent__TOP__0\n"); );
    // Init
    IData/*31:0*/ tb_csr__DOT__data_rdata;
    tb_csr__DOT__data_rdata = 0;
    CData/*2:0*/ tb_csr__DOT__dut__DOT__alu_op;
    tb_csr__DOT__dut__DOT__alu_op = 0;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__rd1_data;
    tb_csr__DOT__dut__DOT__rd1_data = 0;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__rd2_data;
    tb_csr__DOT__dut__DOT__rd2_data = 0;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__operand_a;
    tb_csr__DOT__dut__DOT__operand_a = 0;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__operand_b;
    tb_csr__DOT__dut__DOT__operand_b = 0;
    CData/*6:0*/ __Vtableidx1;
    __Vtableidx1 = 0;
    // Body
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
    tb_csr__DOT__dut__DOT__rd2_data = vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
        [(0x1fU & (vlSelf->tb_csr__DOT__instr_in >> 0x14U))];
    tb_csr__DOT__dut__DOT__rd1_data = vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
        [(0x1fU & (vlSelf->tb_csr__DOT__instr_in >> 0xfU))];
    __Vtableidx1 = ((0x40U & (vlSelf->tb_csr__DOT__instr_in 
                              >> 0x18U)) | ((0x38U 
                                             & (vlSelf->tb_csr__DOT__instr_in 
                                                >> 9U)) 
                                            | (IData)(tb_csr__DOT__dut__DOT__alu_op)));
    vlSelf->tb_csr__DOT__dut__DOT__alu_ctrl = Valu__ConstPool__TABLE_h6d61c68a_0
        [__Vtableidx1];
    tb_csr__DOT__dut__DOT__operand_a = ((IData)(vlSelf->tb_csr__DOT__dut__DOT__op1_src)
                                         ? vlSelf->tb_csr__DOT__dut__DOT__pc_current
                                         : tb_csr__DOT__dut__DOT__rd1_data);
    vlSelf->tb_csr__DOT__dut__DOT__pc_logic__DOT__branch_targ 
        = (vlSelf->tb_csr__DOT__dut__DOT__imm_ext + vlSelf->tb_csr__DOT__dut__DOT__pc_current);
    tb_csr__DOT__dut__DOT__operand_b = ((IData)(vlSelf->tb_csr__DOT__dut__DOT__alu_src)
                                         ? vlSelf->tb_csr__DOT__dut__DOT__imm_ext
                                         : tb_csr__DOT__dut__DOT__rd2_data);
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

VL_ATTR_COLD void Valu___024root___eval_stl(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval_stl\n"); );
    // Body
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        Valu___024root___stl_sequent__TOP__0(vlSelf);
    }
}

VL_ATTR_COLD void Valu___024root___eval_triggers__stl(Valu___024root* vlSelf);

VL_ATTR_COLD bool Valu___024root___eval_phase__stl(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval_phase__stl\n"); );
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Valu___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelf->__VstlTriggered.any();
    if (__VstlExecute) {
        Valu___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Valu___024root___dump_triggers__act(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge tb_csr.clk)\n");
    }
    if ((2ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @(posedge tb_csr.clk or negedge tb_csr.rst_n)\n");
    }
    if ((4ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 2 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Valu___024root___dump_triggers__nba(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge tb_csr.clk)\n");
    }
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @(posedge tb_csr.clk or negedge tb_csr.rst_n)\n");
    }
    if ((4ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 2 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Valu___024root___ctor_var_reset(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->tb_csr__DOT__clk = VL_RAND_RESET_I(1);
    vlSelf->tb_csr__DOT__rst_n = VL_RAND_RESET_I(1);
    vlSelf->tb_csr__DOT__instr_in = VL_RAND_RESET_I(32);
    vlSelf->tb_csr__DOT__data_re = VL_RAND_RESET_I(1);
    for (int __Vi0 = 0; __Vi0 < 256; ++__Vi0) {
        vlSelf->tb_csr__DOT__instr_mem[__Vi0] = VL_RAND_RESET_I(32);
    }
    for (int __Vi0 = 0; __Vi0 < 256; ++__Vi0) {
        vlSelf->tb_csr__DOT__data_mem[__Vi0] = VL_RAND_RESET_I(32);
    }
    vlSelf->tb_csr__DOT__dut__DOT__pc_current = VL_RAND_RESET_I(32);
    vlSelf->tb_csr__DOT__dut__DOT__pc_next = VL_RAND_RESET_I(32);
    vlSelf->tb_csr__DOT__dut__DOT__reg_write = VL_RAND_RESET_I(1);
    vlSelf->tb_csr__DOT__dut__DOT__alu_src = VL_RAND_RESET_I(1);
    vlSelf->tb_csr__DOT__dut__DOT__op1_src = VL_RAND_RESET_I(1);
    vlSelf->tb_csr__DOT__dut__DOT__reg_mux = VL_RAND_RESET_I(2);
    vlSelf->tb_csr__DOT__dut__DOT__alu_ctrl = VL_RAND_RESET_I(4);
    vlSelf->tb_csr__DOT__dut__DOT__branch = VL_RAND_RESET_I(1);
    vlSelf->tb_csr__DOT__dut__DOT__jump = VL_RAND_RESET_I(1);
    vlSelf->tb_csr__DOT__dut__DOT__csr_write = VL_RAND_RESET_I(1);
    vlSelf->tb_csr__DOT__dut__DOT__alu_result = VL_RAND_RESET_I(32);
    vlSelf->tb_csr__DOT__dut__DOT__imm_ext = VL_RAND_RESET_I(32);
    vlSelf->tb_csr__DOT__dut__DOT__jalr = VL_RAND_RESET_I(1);
    vlSelf->tb_csr__DOT__dut__DOT__csr_rdata = VL_RAND_RESET_I(32);
    vlSelf->tb_csr__DOT__dut__DOT__mem_write_internal = VL_RAND_RESET_I(1);
    vlSelf->tb_csr__DOT__dut__DOT__csr_wdata_int = VL_RAND_RESET_I(32);
    vlSelf->tb_csr__DOT__dut__DOT__load_data_internal = VL_RAND_RESET_I(32);
    vlSelf->tb_csr__DOT__dut__DOT__lsu__DOT__be = VL_RAND_RESET_I(4);
    vlSelf->tb_csr__DOT__dut__DOT__lsu__DOT__wdata = VL_RAND_RESET_I(32);
    for (int __Vi0 = 0; __Vi0 < 32; ++__Vi0) {
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[__Vi0] = VL_RAND_RESET_I(32);
    }
    vlSelf->tb_csr__DOT__dut__DOT__pc_logic__DOT__branch_targ = VL_RAND_RESET_I(32);
    vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mstatus = VL_RAND_RESET_I(32);
    vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mtvec = VL_RAND_RESET_I(32);
    vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mepc = VL_RAND_RESET_I(32);
    vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mcause = VL_RAND_RESET_I(32);
    vlSelf->__Vtrigprevexpr___TOP__tb_csr__DOT__clk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__tb_csr__DOT__rst_n__0 = VL_RAND_RESET_I(1);
}
