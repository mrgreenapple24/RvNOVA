// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vcsr_regfile__pch.h"

//============================================================
// Constructors

Vcsr_regfile::Vcsr_regfile(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vcsr_regfile__Syms(contextp(), _vcname__, this)}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vcsr_regfile::Vcsr_regfile(const char* _vcname__)
    : Vcsr_regfile(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vcsr_regfile::~Vcsr_regfile() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vcsr_regfile___024root___eval_debug_assertions(Vcsr_regfile___024root* vlSelf);
#endif  // VL_DEBUG
void Vcsr_regfile___024root___eval_static(Vcsr_regfile___024root* vlSelf);
void Vcsr_regfile___024root___eval_initial(Vcsr_regfile___024root* vlSelf);
void Vcsr_regfile___024root___eval_settle(Vcsr_regfile___024root* vlSelf);
void Vcsr_regfile___024root___eval(Vcsr_regfile___024root* vlSelf);

void Vcsr_regfile::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vcsr_regfile::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vcsr_regfile___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vcsr_regfile___024root___eval_static(&(vlSymsp->TOP));
        Vcsr_regfile___024root___eval_initial(&(vlSymsp->TOP));
        Vcsr_regfile___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vcsr_regfile___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vcsr_regfile::eventsPending() { return !vlSymsp->TOP.__VdlySched.empty(); }

uint64_t Vcsr_regfile::nextTimeSlot() { return vlSymsp->TOP.__VdlySched.nextTimeSlot(); }

//============================================================
// Utilities

const char* Vcsr_regfile::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vcsr_regfile___024root___eval_final(Vcsr_regfile___024root* vlSelf);

VL_ATTR_COLD void Vcsr_regfile::final() {
    Vcsr_regfile___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vcsr_regfile::hierName() const { return vlSymsp->name(); }
const char* Vcsr_regfile::modelName() const { return "Vcsr_regfile"; }
unsigned Vcsr_regfile::threads() const { return 1; }
void Vcsr_regfile::prepareClone() const { contextp()->prepareClone(); }
void Vcsr_regfile::atClone() const {
    contextp()->threadPoolpOnClone();
}

//============================================================
// Trace configuration

VL_ATTR_COLD void Vcsr_regfile::trace(VerilatedVcdC* tfp, int levels, int options) {
    vl_fatal(__FILE__, __LINE__, __FILE__,"'Vcsr_regfile::trace()' called on model that was Verilated without --trace option");
}
