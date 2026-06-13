//OUTDATED AS OF THIS UPDATE

`timescale 1ns/1ps

module tb_trapexec;

    integer i;

    reg  [31:0] pc;                       //our current pc
    reg  [31:0] fault_addr;
    reg  [31:0] fault_instr;

    reg         illegal_instr;
    reg         ecall;
    reg         ebreak;
    reg         instr_misalign;
    reg         load_misalign;
    reg         store_misalign;           //all of these are exceptions that can occur

    reg         ext_irq;                  //interrupt that can occur (maskable thru MIE)

    reg  [31:0] csr_mstatus;
    reg  [31:0] csr_mtvec;
    reg  [31:0] csr_mcause;
    reg  [31:0] csr_mtval;
    reg  [31:0] csr_mepc;                 //csr values

    reg         csr_mret;                 //decoder SEES mret => control signal becomes 1

    wire        trap_taken;               //is a trap being executed (handled)
    wire        mret_taken;               //effectively the same as csr_mret for single-cycle. difference is that this becomes 1 when trap_ctrl accepts and starts executing mret op

    wire [31:0] trap_target_pc;           //the pc that corresponds to trap_taken

    wire        csr_trap_we;              //write-enable

    wire [31:0] trap_mepc;
    wire [31:0] trap_mcause;
    wire [31:0] trap_mtval;
    wire [31:0] trap_mstatus;

    // ========================================================================
    // test 0: default task
    // ========================================================================

    task check;
        input         condition;
        input [8*64-1:0] msg;

        begin
            if (!condition) begin
                $display("FAIL: %s", msg);
                $fatal;
            end
            else begin
                $display("PASS: %s", msg);
            end
        end
    endtask

    trap_ctrl dut (
        .pc(pc),
        .fault_addr(fault_addr),
        .fault_instr(fault_instr),
        .illegal_instr(illegal_instr),
        .instr_misalign(instr_misalign),
        .load_misalign(load_misalign),
        .store_misalign(store_misalign),
        .ecall(ecall),
        .ebreak(ebreak),
        .ext_irq(ext_irq),
        .csr_mstatus(csr_mstatus),
        .csr_mepc(csr_mepc),
        .csr_mtvec(csr_mtvec),
        .csr_mtval(csr_mtval),
        .csr_mcause(csr_mcause),
        .csr_mret(csr_mret),
        .trap_taken(trap_taken),
        .mret_taken(mret_taken),
        .trap_target_pc(trap_target_pc),
        .csr_trap_we(csr_trap_we),
        .trap_mcause(trap_mcause),
        .trap_mepc(trap_mepc),
        .trap_mstatus(trap_mstatus),
        .trap_mtval(trap_mtval)
    );

    initial begin

        // ========================================================================
        // initialize values
        // ========================================================================

        illegal_instr  = 0;
        ebreak         = 0;
        instr_misalign = 0;
        load_misalign  = 0;
        store_misalign = 0;
        ecall          = 0;
        ext_irq        = 0;
        csr_mcause     = 32'h0;
        csr_mstatus    = 32'h00000008;
        csr_mtvec      = 32'h00000100;
        csr_mepc       = 32'h0;
        csr_mtval      = 32'h0;
        csr_mret       = 0;

        // ========================================================================
        // test 0.5: instr misalign (i forgor)
        // ========================================================================

        pc = 32'h2004;

        instr_misalign = 1;
        #1;

        check(trap_mepc == 32'h2004, "instr misalign: instr pc saved");
        check(trap_mcause == 32'h0, "instr misalign: mcause updated");
        check(trap_mtval == 32'h2004, "instr misalign: mtval updated");

        instr_misalign = 0;
        #1;
        
        // ========================================================================
        // test 1: illegal instr
        // ========================================================================

        pc          = 32'h1000;
        fault_instr = 32'hFFFFFFFF;
        csr_mstatus = 32'h8;

        illegal_instr = 1;
        #1;

        check(trap_taken, "illegal instr: trap taken");
        check(csr_trap_we, "illegal instr: trap write enabled");
        check(trap_target_pc == csr_mtvec, "illegal instr: pc updated");
        check(trap_mepc == 32'h1000, "illegal instr: instr pc saved");
        check(trap_mcause == 32'h2, "illegal instr: mcause updated");
        check(trap_mstatus[3] == 1'b0, "illegal instr: interrupts masked");
        check(trap_mstatus[7] == csr_mstatus[3], "illegal instr: mpie saves mie value");
        check(trap_mtval ==  32'hFFFFFFFF, "illegal instr: mtval updated");

        illegal_instr = 0;
        #1;

        // ========================================================================
        // test 2: ecall
        // ========================================================================

        pc = 32'h1004;

        ecall = 1;
        #1;

        check(trap_mepc == 32'h1004, "ecall: instr pc saved");
        check(trap_mcause == 32'hB, "ecall: mcause updated");
        check(trap_mtval == 32'h0, "ecall: mtval updated");

        ecall = 0;
        #1;

        // ========================================================================
        // test 3: ebreak
        // ========================================================================

        pc = 32'h1008;

        ebreak = 1;
        #1;

        check(trap_mepc == 32'h1008, "ebreak: instr pc saved");
        check(trap_mcause == 32'h3, "ebreak: mcause updated");
        check(trap_mtval == 32'h0, "ebreak: mtval updated");

        ebreak = 0;
        #1;

        // ========================================================================
        // test 4: load misalign
        // ========================================================================

        pc = 32'h100C;
        fault_addr = 32'h1002;

        load_misalign = 1;
        #1;

        check(trap_mepc == 32'h100C, "load misalign: instr pc saved");
        check(trap_mcause == 32'h4, "load misalign: mcause updated");
        check(trap_mtval == 32'h1002, "load misalign: mtval updated");

        load_misalign = 0;
        #1;

        // ========================================================================
        // test 5: store misalign
        // ========================================================================

        pc = 32'h1010;
        fault_addr = 32'h2002;

        store_misalign = 1;
        #1;

        check(trap_mepc == 32'h1010, "store misalign: instr pc saved");
        check(trap_mcause == 32'h6, "store misalign: mcause updated");
        check(trap_mtval == 32'h2002, "store misalign: mtval update");

        store_misalign = 0;
        #1;

        // ========================================================================
        // test 6: ext irq/unmasked
        // ========================================================================

        csr_mstatus = 32'h8;    //mie bit is set
        ext_irq = 1;
        #1;

        check(trap_taken, "ext irq: interrupt unmasked, trap taken");
        check(trap_mcause == 32'h8000000B, "ext irq: mcause updated");
        check(trap_mtval == 32'h0, "ext irq: mtval update");

        ext_irq = 0;
        #1;

        // ========================================================================
        // test 7: ext irq/masked
        // ========================================================================

        csr_mstatus = 32'h0;    //mie cleared
        ext_irq = 1;
        #1;

        check(!trap_taken, "ext_irq: interrupt masked");

        ext_irq = 0;
        #1;

        // ========================================================================
        // test 8: mret
        // ========================================================================

        csr_mstatus = 32'h80;   //mpie set
        csr_mepc    = 32'h2000; //return address
        csr_mret    = 1;
        #1;

        check(mret_taken, "mret taken");
        check(csr_trap_we, "mret is writing");
        check(trap_target_pc == 32'h2000, "mret return address satisfied");
        check(trap_mstatus[3] == 1'b1, "mret restores mie");
        check(trap_mstatus[7] == 1'b1, "mret sets mpie");

        csr_mret = 0;
        #1;

        // ========================================================================
        // test 9: priority encoder
        // ========================================================================

        instr_misalign = 1;
        illegal_instr  = 1;
        ebreak         = 1;
        load_misalign  = 1;
        store_misalign = 1;
        ecall          = 1;
        ext_irq        = 1;

        csr_mstatus    = 32'h8;

        #1;

        check(trap_mcause == 32'h0, "instr misalign wins");

        instr_misalign = 0;

        #1;

        check(trap_mcause == 32'h2, "illegal intr wins");

        illegal_instr = 0;

        #1;

        check(trap_mcause == 32'h3, "ebreak wins");

        ebreak = 0;

        #1;

        check(trap_mcause == 32'h4, "load misalign wins");

        load_misalign = 0;

        #1;

        check(trap_mcause == 32'h6, "store misalign wins");

        store_misalign = 0;

        #1;

        check(trap_mcause == 32'hB, "ecall wins");

        ecall = 0;

        #1;

        check(trap_mcause == 32'h8000000B, "interrupt wins");

        ext_irq = 0;

        #1;

        // ========================================================================
        // test 10: mie and mpie
        // ========================================================================

        csr_mstatus = 32'h8;

        ext_irq = 1;
        #1;

        check(trap_mstatus[7] == 1'b1, "mie saved to mpie");
        check(trap_mstatus[3] == 1'b0, "mie cleared");

        #1;

        $display("ALL TESTS PASSED");

        $finish;

    end

endmodule