// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Valu.h for the primary calling header

#include "Valu__pch.h"
#include "Valu__Syms.h"
#include "Valu___024root.h"

VL_INLINE_OPT VlCoroutine Valu___024root___eval_initial__TOP__Vtiming__0(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval_initial__TOP__Vtiming__0\n"); );
    // Init
    IData/*31:0*/ tb_csr__DOT__i;
    tb_csr__DOT__i = 0;
    // Body
    vlSelf->tb_csr__DOT__clk = 0U;
    vlSelf->tb_csr__DOT__rst_n = 0U;
    tb_csr__DOT__i = 0U;
    while (VL_GTS_III(32, 0x100U, tb_csr__DOT__i)) {
        vlSelf->tb_csr__DOT__instr_mem[(0xffU & tb_csr__DOT__i)] = 0x13U;
        vlSelf->tb_csr__DOT__data_mem[(0xffU & tb_csr__DOT__i)] = 0U;
        tb_csr__DOT__i = ((IData)(1U) + tb_csr__DOT__i);
    }
    vlSelf->tb_csr__DOT__instr_mem[0U] = 0x500093U;
    vlSelf->tb_csr__DOT__instr_mem[1U] = 0x30509173U;
    vlSelf->tb_csr__DOT__instr_mem[2U] = 0x200193U;
    vlSelf->tb_csr__DOT__instr_mem[3U] = 0x3051a273U;
    vlSelf->tb_csr__DOT__instr_mem[4U] = 0x100293U;
    vlSelf->tb_csr__DOT__instr_mem[5U] = 0x3052b373U;
    vlSelf->tb_csr__DOT__instr_mem[6U] = 0x3051d3f3U;
    vlSelf->tb_csr__DOT__instr_mem[7U] = 0x30546473U;
    vlSelf->tb_csr__DOT__instr_mem[8U] = 0x305174f3U;
    vlSelf->tb_csr__DOT__instr_mem[9U] = 0x30502573U;
    vlSelf->tb_csr__DOT__instr_mem[0xaU] = 0x6fU;
    co_await vlSelf->__VdlySched.delay(0x4e20ULL, nullptr, 
                                       "tb/tb_csr.v", 
                                       140);
    vlSelf->tb_csr__DOT__rst_n = 1U;
    co_await vlSelf->__VdlySched.delay(0x493e0ULL, 
                                       nullptr, "tb/tb_csr.v", 
                                       144);
    VL_WRITEF("-----------------------------------\nFINAL RESULTS\n-----------------------------------\nmtvec = %x\nx2    = %x\nx4    = %x\nx6    = %x\nx7    = %x\nx8    = %x\nx9    = %x\nx10   = %x\n",
              32,vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mtvec,
              32,vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
              [2U],32,vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
              [4U],32,vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
              [6U],32,vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
              [7U],32,vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
              [8U],32,vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
              [9U],32,vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
              [0xaU]);
    if (VL_UNLIKELY((0U != vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
                     [2U]))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr.v:161: Assertion failed in %Ntb_csr\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr.v", 161, "");
    }
    if (VL_UNLIKELY((5U != vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
                     [4U]))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr.v:164: Assertion failed in %Ntb_csr\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr.v", 164, "");
    }
    if (VL_UNLIKELY((7U != vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
                     [6U]))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr.v:167: Assertion failed in %Ntb_csr\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr.v", 167, "");
    }
    if (VL_UNLIKELY((6U != vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
                     [7U]))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr.v:170: Assertion failed in %Ntb_csr\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr.v", 170, "");
    }
    if (VL_UNLIKELY((3U != vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
                     [8U]))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr.v:173: Assertion failed in %Ntb_csr\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr.v", 173, "");
    }
    if (VL_UNLIKELY((0xbU != vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
                     [9U]))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr.v:176: Assertion failed in %Ntb_csr\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr.v", 176, "");
    }
    if (VL_UNLIKELY((9U != vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
                     [0xaU]))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr.v:179: Assertion failed in %Ntb_csr\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr.v", 179, "");
    }
    if (VL_UNLIKELY((9U != vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mtvec))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr.v:182: Assertion failed in %Ntb_csr\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr.v", 182, "");
    }
    VL_WRITEF("ALL CSR TESTS PASSED\n");
    VL_FINISH_MT("tb/tb_csr.v", 186, "");
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Valu___024root___dump_triggers__act(Valu___024root* vlSelf);
#endif  // VL_DEBUG

void Valu___024root___eval_triggers__act(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval_triggers__act\n"); );
    // Body
    vlSelf->__VactTriggered.set(0U, ((IData)(vlSelf->tb_csr__DOT__clk) 
                                     & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__tb_csr__DOT__clk__0))));
    vlSelf->__VactTriggered.set(1U, (((IData)(vlSelf->tb_csr__DOT__clk) 
                                      & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__tb_csr__DOT__clk__0))) 
                                     | ((~ (IData)(vlSelf->tb_csr__DOT__rst_n)) 
                                        & (IData)(vlSelf->__Vtrigprevexpr___TOP__tb_csr__DOT__rst_n__0))));
    vlSelf->__VactTriggered.set(2U, vlSelf->__VdlySched.awaitingCurrentTime());
    vlSelf->__Vtrigprevexpr___TOP__tb_csr__DOT__clk__0 
        = vlSelf->tb_csr__DOT__clk;
    vlSelf->__Vtrigprevexpr___TOP__tb_csr__DOT__rst_n__0 
        = vlSelf->tb_csr__DOT__rst_n;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Valu___024root___dump_triggers__act(vlSelf);
    }
#endif
}

VL_INLINE_OPT void Valu___024root___nba_sequent__TOP__0(Valu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___nba_sequent__TOP__0\n"); );
    // Init
    CData/*7:0*/ __Vdlyvdim0__tb_csr__DOT__data_mem__v0;
    __Vdlyvdim0__tb_csr__DOT__data_mem__v0 = 0;
    IData/*31:0*/ __Vdlyvval__tb_csr__DOT__data_mem__v0;
    __Vdlyvval__tb_csr__DOT__data_mem__v0 = 0;
    CData/*0:0*/ __Vdlyvset__tb_csr__DOT__data_mem__v0;
    __Vdlyvset__tb_csr__DOT__data_mem__v0 = 0;
    CData/*4:0*/ __Vdlyvdim0__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v0;
    __Vdlyvdim0__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v0 = 0;
    IData/*31:0*/ __Vdlyvval__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v0;
    __Vdlyvval__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v0 = 0;
    CData/*0:0*/ __Vdlyvset__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v0;
    __Vdlyvset__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v0 = 0;
    CData/*0:0*/ __Vdlyvset__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v1;
    __Vdlyvset__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v1 = 0;
    // Body
    __Vdlyvset__tb_csr__DOT__data_mem__v0 = 0U;
    if (VL_UNLIKELY(((IData)(vlSelf->tb_csr__DOT__data_re) 
                     & (IData)(vlSelf->tb_csr__DOT__dut__DOT__mem_write_internal)))) {
        VL_WRITEF("ASSERTION FAILED: [%Ntb_csr.dut.lsu] Simultaneous mem_read and mem_write\n",
                  vlSymsp->name());
        VL_WRITEF("[%0t] %%Fatal: load_store_unit.v:118: Assertion failed in %Ntb_csr.dut.lsu\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("rtl/core/load_store_unit.v", 118, "");
    }
    if (VL_UNLIKELY((((IData)(vlSelf->tb_csr__DOT__data_re) 
                      | (IData)(vlSelf->tb_csr__DOT__dut__DOT__mem_write_internal)) 
                     & ((IData)(((0x2000U == (0x3000U 
                                              & vlSelf->tb_csr__DOT__instr_in)) 
                                 & (0U != (3U & vlSelf->tb_csr__DOT__dut__DOT__alu_result)))) 
                        | (IData)(((0x1000U == (0x3000U 
                                                & vlSelf->tb_csr__DOT__instr_in)) 
                                   & vlSelf->tb_csr__DOT__dut__DOT__alu_result)))))) {
        VL_WRITEF("ASSERTION FAILED: [%Ntb_csr.dut.lsu] Misaligned access at addr 0x%x (funct3=0x%x)\n",
                  vlSymsp->name(),32,vlSelf->tb_csr__DOT__dut__DOT__alu_result,
                  3,(7U & (vlSelf->tb_csr__DOT__instr_in 
                           >> 0xcU)));
    }
    VL_WRITEF("PC=%x mtvec=%x x2=%x x4=%x x6=%x x7=%x x8=%x x9=%x x10=%x\n",
              32,vlSelf->tb_csr__DOT__dut__DOT__pc_current,
              32,vlSelf->tb_csr__DOT__dut__DOT__csr_reg__DOT__mtvec,
              32,vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
              [2U],32,vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
              [4U],32,vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
              [6U],32,vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
              [7U],32,vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
              [8U],32,vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
              [9U],32,vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array
              [0xaU]);
    __Vdlyvset__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v0 = 0U;
    __Vdlyvset__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v1 = 0U;
    if ((0U != (IData)(vlSelf->tb_csr__DOT__dut__DOT__lsu__DOT__be))) {
        __Vdlyvval__tb_csr__DOT__data_mem__v0 = vlSelf->tb_csr__DOT__dut__DOT__lsu__DOT__wdata;
        __Vdlyvset__tb_csr__DOT__data_mem__v0 = 1U;
        __Vdlyvdim0__tb_csr__DOT__data_mem__v0 = (0xffU 
                                                  & (vlSelf->tb_csr__DOT__dut__DOT__alu_result 
                                                     >> 2U));
    }
    if (vlSelf->tb_csr__DOT__rst_n) {
        if (((IData)(vlSelf->tb_csr__DOT__dut__DOT__reg_write) 
             & (0U != (0x1fU & (vlSelf->tb_csr__DOT__instr_in 
                                >> 7U))))) {
            __Vdlyvval__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v0 
                = ((2U & (IData)(vlSelf->tb_csr__DOT__dut__DOT__reg_mux))
                    ? ((1U & (IData)(vlSelf->tb_csr__DOT__dut__DOT__reg_mux))
                        ? vlSelf->tb_csr__DOT__dut__DOT__csr_rdata
                        : ((IData)(4U) + vlSelf->tb_csr__DOT__dut__DOT__pc_current))
                    : ((1U & (IData)(vlSelf->tb_csr__DOT__dut__DOT__reg_mux))
                        ? vlSelf->tb_csr__DOT__dut__DOT__load_data_internal
                        : vlSelf->tb_csr__DOT__dut__DOT__alu_result));
            __Vdlyvset__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v0 = 1U;
            __Vdlyvdim0__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v0 
                = (0x1fU & (vlSelf->tb_csr__DOT__instr_in 
                            >> 7U));
        }
    } else {
        __Vdlyvset__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v1 = 1U;
    }
    if (__Vdlyvset__tb_csr__DOT__data_mem__v0) {
        vlSelf->tb_csr__DOT__data_mem[__Vdlyvdim0__tb_csr__DOT__data_mem__v0] 
            = __Vdlyvval__tb_csr__DOT__data_mem__v0;
    }
    if (__Vdlyvset__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v0) {
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[__Vdlyvdim0__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v0] 
            = __Vdlyvval__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v0;
    }
    if (__Vdlyvset__tb_csr__DOT__dut__DOT__rf__DOT__reg_array__v1) {
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[1U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[2U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[3U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[4U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[5U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[6U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[7U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[8U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[9U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0xaU] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0xbU] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0xcU] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0xdU] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0xeU] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0xfU] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0x10U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0x11U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0x12U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0x13U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0x14U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0x15U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0x16U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0x17U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0x18U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0x19U] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0x1aU] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0x1bU] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0x1cU] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0x1dU] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0x1eU] = 0U;
        vlSelf->tb_csr__DOT__dut__DOT__rf__DOT__reg_array[0x1fU] = 0U;
    }
}
