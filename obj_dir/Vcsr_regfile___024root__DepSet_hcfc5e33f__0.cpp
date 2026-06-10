// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcsr_regfile.h for the primary calling header

#include "Vcsr_regfile__pch.h"
#include "Vcsr_regfile__Syms.h"
#include "Vcsr_regfile___024root.h"

VL_INLINE_OPT VlCoroutine Vcsr_regfile___024root___eval_initial__TOP__Vtiming__0(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___eval_initial__TOP__Vtiming__0\n"); );
    // Body
    vlSelf->tb_csr_regfile__DOT__clk = 0U;
    vlSelf->tb_csr_regfile__DOT__rst_n = 0U;
    vlSelf->tb_csr_regfile__DOT__csr_we = 0U;
    vlSelf->tb_csr_regfile__DOT__csr_waddr = 0U;
    vlSelf->tb_csr_regfile__DOT__csr_raddr = 0U;
    vlSelf->tb_csr_regfile__DOT__csr_wdata = 0U;
    co_await vlSelf->__VdlySched.delay(0x4e20ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       45);
    vlSelf->tb_csr_regfile__DOT__rst_n = 1U;
    vlSelf->tb_csr_regfile__DOT__csr_we = 1U;
    vlSelf->tb_csr_regfile__DOT__csr_waddr = 0x300U;
    vlSelf->tb_csr_regfile__DOT__csr_wdata = 0xdeadbeefU;
    co_await vlSelf->__VdlySched.delay(0x2710ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       56);
    vlSelf->tb_csr_regfile__DOT__csr_we = 0U;
    vlSelf->tb_csr_regfile__DOT__csr_raddr = 0x300U;
    co_await vlSelf->__VdlySched.delay(0x3e8ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       62);
    VL_WRITEF("mstatus = %x\n",32,vlSelf->tb_csr_regfile__DOT__csr_rdata);
    co_await vlSelf->__VdlySched.delay(0x4e20ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       66);
    if (VL_UNLIKELY((0xdeadbeefU != vlSelf->tb_csr_regfile__DOT__csr_rdata))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr_regfile.v:69: Assertion failed in %Ntb_csr_regfile\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr_regfile.v", 69, "");
    }
    vlSelf->tb_csr_regfile__DOT__csr_we = 1U;
    vlSelf->tb_csr_regfile__DOT__csr_waddr = 0x305U;
    vlSelf->tb_csr_regfile__DOT__csr_wdata = 0x11111111U;
    co_await vlSelf->__VdlySched.delay(0x2710ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       79);
    vlSelf->tb_csr_regfile__DOT__csr_we = 0U;
    vlSelf->tb_csr_regfile__DOT__csr_raddr = 0x305U;
    co_await vlSelf->__VdlySched.delay(0x3e8ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       85);
    VL_WRITEF("mtvec = %x\n",32,vlSelf->tb_csr_regfile__DOT__csr_rdata);
    co_await vlSelf->__VdlySched.delay(0x4e20ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       89);
    if (VL_UNLIKELY((0x11111111U != vlSelf->tb_csr_regfile__DOT__csr_rdata))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr_regfile.v:92: Assertion failed in %Ntb_csr_regfile\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr_regfile.v", 92, "");
    }
    vlSelf->tb_csr_regfile__DOT__csr_we = 1U;
    vlSelf->tb_csr_regfile__DOT__csr_waddr = 0x341U;
    vlSelf->tb_csr_regfile__DOT__csr_wdata = 0xffffffffU;
    co_await vlSelf->__VdlySched.delay(0x2710ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       102);
    vlSelf->tb_csr_regfile__DOT__csr_we = 0U;
    vlSelf->tb_csr_regfile__DOT__csr_raddr = 0x341U;
    co_await vlSelf->__VdlySched.delay(0x3e8ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       108);
    VL_WRITEF("mepc = %x\n",32,vlSelf->tb_csr_regfile__DOT__csr_rdata);
    co_await vlSelf->__VdlySched.delay(0x4e20ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       112);
    if (VL_UNLIKELY((0xffffffffU != vlSelf->tb_csr_regfile__DOT__csr_rdata))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr_regfile.v:115: Assertion failed in %Ntb_csr_regfile\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr_regfile.v", 115, "");
    }
    vlSelf->tb_csr_regfile__DOT__csr_we = 1U;
    vlSelf->tb_csr_regfile__DOT__csr_waddr = 0x342U;
    vlSelf->tb_csr_regfile__DOT__csr_wdata = 0xb00bb00bU;
    co_await vlSelf->__VdlySched.delay(0x2710ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       125);
    vlSelf->tb_csr_regfile__DOT__csr_we = 0U;
    vlSelf->tb_csr_regfile__DOT__csr_raddr = 0x342U;
    co_await vlSelf->__VdlySched.delay(0x3e8ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       131);
    VL_WRITEF("mcause = %x\n",32,vlSelf->tb_csr_regfile__DOT__csr_rdata);
    co_await vlSelf->__VdlySched.delay(0x4e20ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       135);
    if (VL_UNLIKELY((0xb00bb00bU != vlSelf->tb_csr_regfile__DOT__csr_rdata))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr_regfile.v:138: Assertion failed in %Ntb_csr_regfile\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr_regfile.v", 138, "");
    }
    vlSelf->tb_csr_regfile__DOT__csr_we = 1U;
    vlSelf->tb_csr_regfile__DOT__csr_waddr = 0x343U;
    vlSelf->tb_csr_regfile__DOT__csr_wdata = 0xdeaddeadU;
    co_await vlSelf->__VdlySched.delay(0x2710ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       148);
    vlSelf->tb_csr_regfile__DOT__csr_we = 0U;
    vlSelf->tb_csr_regfile__DOT__csr_raddr = 0x343U;
    co_await vlSelf->__VdlySched.delay(0x3e8ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       154);
    VL_WRITEF("mtvac = %x\n",32,vlSelf->tb_csr_regfile__DOT__csr_rdata);
    co_await vlSelf->__VdlySched.delay(0x4e20ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       158);
    if (VL_UNLIKELY((0xdeaddeadU != vlSelf->tb_csr_regfile__DOT__csr_rdata))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr_regfile.v:161: Assertion failed in %Ntb_csr_regfile\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr_regfile.v", 161, "");
    }
    vlSelf->tb_csr_regfile__DOT__rst_n = 0U;
    co_await vlSelf->__VdlySched.delay(0x2710ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       168);
    vlSelf->tb_csr_regfile__DOT__rst_n = 1U;
    vlSelf->tb_csr_regfile__DOT__csr_raddr = 0x300U;
    co_await vlSelf->__VdlySched.delay(0x3e8ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       172);
    if (VL_UNLIKELY((0U != vlSelf->tb_csr_regfile__DOT__csr_rdata))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr_regfile.v:174: Assertion failed in %Ntb_csr_regfile: RESET FAILED: MSTATUS\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr_regfile.v", 174, "");
    }
    vlSelf->tb_csr_regfile__DOT__csr_raddr = 0x305U;
    co_await vlSelf->__VdlySched.delay(0x3e8ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       177);
    if (VL_UNLIKELY((0U != vlSelf->tb_csr_regfile__DOT__csr_rdata))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr_regfile.v:179: Assertion failed in %Ntb_csr_regfile: RESET FAILED: MTVEC\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr_regfile.v", 179, "");
    }
    vlSelf->tb_csr_regfile__DOT__csr_raddr = 0x341U;
    co_await vlSelf->__VdlySched.delay(0x3e8ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       182);
    if (VL_UNLIKELY((0U != vlSelf->tb_csr_regfile__DOT__csr_rdata))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr_regfile.v:184: Assertion failed in %Ntb_csr_regfile: RESET FAILED: MEPC\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr_regfile.v", 184, "");
    }
    vlSelf->tb_csr_regfile__DOT__csr_raddr = 0x342U;
    co_await vlSelf->__VdlySched.delay(0x3e8ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       187);
    if (VL_UNLIKELY((0U != vlSelf->tb_csr_regfile__DOT__csr_rdata))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr_regfile.v:189: Assertion failed in %Ntb_csr_regfile: RESET FAILED: MCAUSE\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr_regfile.v", 189, "");
    }
    vlSelf->tb_csr_regfile__DOT__csr_raddr = 0x343U;
    co_await vlSelf->__VdlySched.delay(0x3e8ULL, nullptr, 
                                       "tb/tb_csr_regfile.v", 
                                       192);
    if (VL_UNLIKELY((0U != vlSelf->tb_csr_regfile__DOT__csr_rdata))) {
        VL_WRITEF("[%0t] %%Fatal: tb_csr_regfile.v:194: Assertion failed in %Ntb_csr_regfile: RESET FAILED: MTVAL\n",
                  64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("tb/tb_csr_regfile.v", 194, "");
    }
    VL_WRITEF("ALL TESTS PASSED\n");
    VL_FINISH_MT("tb/tb_csr_regfile.v", 198, "");
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcsr_regfile___024root___dump_triggers__act(Vcsr_regfile___024root* vlSelf);
#endif  // VL_DEBUG

void Vcsr_regfile___024root___eval_triggers__act(Vcsr_regfile___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcsr_regfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcsr_regfile___024root___eval_triggers__act\n"); );
    // Body
    vlSelf->__VactTriggered.set(0U, (((IData)(vlSelf->tb_csr_regfile__DOT__clk) 
                                      & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__tb_csr_regfile__DOT__clk__0))) 
                                     | ((~ (IData)(vlSelf->tb_csr_regfile__DOT__rst_n)) 
                                        & (IData)(vlSelf->__Vtrigprevexpr___TOP__tb_csr_regfile__DOT__rst_n__0))));
    vlSelf->__VactTriggered.set(1U, vlSelf->__VdlySched.awaitingCurrentTime());
    vlSelf->__Vtrigprevexpr___TOP__tb_csr_regfile__DOT__clk__0 
        = vlSelf->tb_csr_regfile__DOT__clk;
    vlSelf->__Vtrigprevexpr___TOP__tb_csr_regfile__DOT__rst_n__0 
        = vlSelf->tb_csr_regfile__DOT__rst_n;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vcsr_regfile___024root___dump_triggers__act(vlSelf);
    }
#endif
}
