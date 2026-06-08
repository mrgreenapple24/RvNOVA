// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtb_csr_regfile.h for the primary calling header

#ifndef VERILATED_VTB_CSR_REGFILE___024ROOT_H_
#define VERILATED_VTB_CSR_REGFILE___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vtb_csr_regfile__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtb_csr_regfile___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ tb_csr_regfile__DOT__clk;
    CData/*0:0*/ tb_csr_regfile__DOT__rst_n;
    CData/*0:0*/ tb_csr_regfile__DOT__csr_we;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb_csr_regfile__DOT__clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb_csr_regfile__DOT__rst_n__0;
    CData/*0:0*/ __VactContinue;
    SData/*11:0*/ tb_csr_regfile__DOT__csr_waddr;
    SData/*11:0*/ tb_csr_regfile__DOT__csr_raddr;
    IData/*31:0*/ tb_csr_regfile__DOT__csr_wdata;
    IData/*31:0*/ tb_csr_regfile__DOT__csr_rdata;
    IData/*31:0*/ tb_csr_regfile__DOT__dut__DOT__mstatus;
    IData/*31:0*/ tb_csr_regfile__DOT__dut__DOT__mtvec;
    IData/*31:0*/ tb_csr_regfile__DOT__dut__DOT__mepc;
    IData/*31:0*/ tb_csr_regfile__DOT__dut__DOT__mcause;
    IData/*31:0*/ __VactIterCount;
    VlDelayScheduler __VdlySched;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<2> __VactTriggered;
    VlTriggerVec<2> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtb_csr_regfile__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtb_csr_regfile___024root(Vtb_csr_regfile__Syms* symsp, const char* v__name);
    ~Vtb_csr_regfile___024root();
    VL_UNCOPYABLE(Vtb_csr_regfile___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
