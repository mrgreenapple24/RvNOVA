// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Valu.h for the primary calling header

#ifndef VERILATED_VALU___024ROOT_H_
#define VERILATED_VALU___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Valu__Syms;

class alignas(VL_CACHE_LINE_BYTES) Valu___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ tb_csr__DOT__clk;
    CData/*0:0*/ tb_csr__DOT__rst_n;
    CData/*0:0*/ tb_csr__DOT__data_re;
    CData/*0:0*/ tb_csr__DOT__dut__DOT__reg_write;
    CData/*0:0*/ tb_csr__DOT__dut__DOT__alu_src;
    CData/*0:0*/ tb_csr__DOT__dut__DOT__op1_src;
    CData/*1:0*/ tb_csr__DOT__dut__DOT__reg_mux;
    CData/*3:0*/ tb_csr__DOT__dut__DOT__alu_ctrl;
    CData/*0:0*/ tb_csr__DOT__dut__DOT__branch;
    CData/*0:0*/ tb_csr__DOT__dut__DOT__jump;
    CData/*0:0*/ tb_csr__DOT__dut__DOT__csr_write;
    CData/*0:0*/ tb_csr__DOT__dut__DOT__jalr;
    CData/*0:0*/ tb_csr__DOT__dut__DOT__mem_write_internal;
    CData/*3:0*/ tb_csr__DOT__dut__DOT__lsu__DOT__be;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb_csr__DOT__clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb_csr__DOT__rst_n__0;
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ tb_csr__DOT__instr_in;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__pc_current;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__pc_next;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__alu_result;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__imm_ext;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__csr_rdata;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__csr_wdata_int;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__load_data_internal;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__lsu__DOT__wdata;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__pc_logic__DOT__branch_targ;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__csr_reg__DOT__mstatus;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__csr_reg__DOT__mtvec;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__csr_reg__DOT__mepc;
    IData/*31:0*/ tb_csr__DOT__dut__DOT__csr_reg__DOT__mcause;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<IData/*31:0*/, 256> tb_csr__DOT__instr_mem;
    VlUnpacked<IData/*31:0*/, 256> tb_csr__DOT__data_mem;
    VlUnpacked<IData/*31:0*/, 32> tb_csr__DOT__dut__DOT__rf__DOT__reg_array;
    VlDelayScheduler __VdlySched;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<3> __VactTriggered;
    VlTriggerVec<3> __VnbaTriggered;

    // INTERNAL VARIABLES
    Valu__Syms* const vlSymsp;

    // CONSTRUCTORS
    Valu___024root(Valu__Syms* symsp, const char* v__name);
    ~Valu___024root();
    VL_UNCOPYABLE(Valu___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
