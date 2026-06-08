// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vtb_csr_regfile__pch.h"

//============================================================
// Constructors

Vtb_csr_regfile::Vtb_csr_regfile(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vtb_csr_regfile__Syms(contextp(), _vcname__, this)}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vtb_csr_regfile::Vtb_csr_regfile(const char* _vcname__)
    : Vtb_csr_regfile(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vtb_csr_regfile::~Vtb_csr_regfile() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vtb_csr_regfile___024root___eval_debug_assertions(Vtb_csr_regfile___024root* vlSelf);
#endif  // VL_DEBUG
void Vtb_csr_regfile___024root___eval_static(Vtb_csr_regfile___024root* vlSelf);
void Vtb_csr_regfile___024root___eval_initial(Vtb_csr_regfile___024root* vlSelf);
void Vtb_csr_regfile___024root___eval_settle(Vtb_csr_regfile___024root* vlSelf);
void Vtb_csr_regfile___024root___eval(Vtb_csr_regfile___024root* vlSelf);

void Vtb_csr_regfile::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vtb_csr_regfile::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vtb_csr_regfile___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vtb_csr_regfile___024root___eval_static(&(vlSymsp->TOP));
        Vtb_csr_regfile___024root___eval_initial(&(vlSymsp->TOP));
        Vtb_csr_regfile___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vtb_csr_regfile___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vtb_csr_regfile::eventsPending() { return !vlSymsp->TOP.__VdlySched.empty(); }

uint64_t Vtb_csr_regfile::nextTimeSlot() { return vlSymsp->TOP.__VdlySched.nextTimeSlot(); }

//============================================================
// Utilities

const char* Vtb_csr_regfile::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vtb_csr_regfile___024root___eval_final(Vtb_csr_regfile___024root* vlSelf);

VL_ATTR_COLD void Vtb_csr_regfile::final() {
    Vtb_csr_regfile___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vtb_csr_regfile::hierName() const { return vlSymsp->name(); }
const char* Vtb_csr_regfile::modelName() const { return "Vtb_csr_regfile"; }
unsigned Vtb_csr_regfile::threads() const { return 1; }
void Vtb_csr_regfile::prepareClone() const { contextp()->prepareClone(); }
void Vtb_csr_regfile::atClone() const {
    contextp()->threadPoolpOnClone();
}

//============================================================
// Trace configuration

VL_ATTR_COLD void Vtb_csr_regfile::trace(VerilatedVcdC* tfp, int levels, int options) {
    vl_fatal(__FILE__, __LINE__, __FILE__,"'Vtb_csr_regfile::trace()' called on model that was Verilated without --trace option");
}
