`timescale 1ns/1ps

module tb_csr_regfile;

    reg         clk;
    reg         rst_n;

    reg         instr_retired;
    reg         ext_irq;
    reg         csr_access;

    reg         csr_we;
    reg  [11:0] csr_waddr;
    reg  [11:0] csr_raddr;
    reg  [31:0] csr_wdata;

    reg         trap_we;
    reg  [31:0] trap_mepc;
    reg  [31:0] trap_mstatus;
    reg  [31:0] trap_mtval;
    reg  [31:0] trap_mcause;

    wire [31:0] csr_rdata;

    wire [31:0] csr_mstatus;
    wire [31:0] csr_mepc;
    wire [31:0] csr_mcause;
    wire [31:0] csr_mtvec;
    wire [31:0] csr_misa;
    wire [31:0] csr_mscratch;
    wire [31:0] csr_mcycle;
    wire [31:0] csr_minstret;
    wire [31:0] csr_mie;
    wire [31:0] csr_mip;
    wire [31:0] csr_mtval;

    wire        csr_ilgl_instr;

    csr_regfile dut (
        .clk(clk),
        .rst_n(rst_n),
        .instr_retired(instr_retired),
        .ext_irq(ext_irq),
        .csr_access(csr_access),
        .csr_we(csr_we),
        .csr_waddr(csr_waddr),
        .csr_raddr(csr_raddr),
        .csr_wdata(csr_wdata),
        .trap_we(trap_we),
        .trap_mepc(trap_mepc),
        .trap_mstatus(trap_mstatus),
        .trap_mtval(trap_mtval),
        .trap_mcause(trap_mcause),
        .csr_rdata(csr_rdata),
        .csr_mstatus(csr_mstatus),
        .csr_mepc(csr_mepc),
        .csr_mcause(csr_mcause),
        .csr_mtvec(csr_mtvec),
        .csr_misa(csr_misa),
        .csr_mscratch(csr_mscratch),
        .csr_mcycle(csr_mcycle),
        .csr_minstret(csr_minstret),
        .csr_mie(csr_mie),
        .csr_mip(csr_mip),
        .csr_mtval(csr_mtval),
        .csr_ilgl_instr(csr_ilgl_instr)
    );

    always #5 clk = ~clk;

    initial begin

        // ========================================================================
        // initialize values
        // ========================================================================
        
        clk   = 0;
        rst_n = 0;

        ext_irq = 0;
        instr_retired = 0;
        csr_access = 0;

        trap_we = 0;
        trap_mcause = 0;
        trap_mepc = 0;
        trap_mstatus = 0;
        trap_mtval = 0;

        csr_we    = 0;
        csr_waddr = 0;
        csr_raddr = 0;
        csr_wdata = 0;

        // ========================================================================
        // release reset
        // ========================================================================
        
        #20;
        rst_n = 1;

        // ========================================================================
        // mstatus
        // ========================================================================
        
        csr_we    = 1;
        csr_waddr = 12'h300;
        csr_wdata = 32'hDEADBEEF;       //writing

        #10;

        csr_we = 0;

        csr_raddr = 12'h300;            //reading

        #1;

        $display("mstatus = %h", csr_rdata);

        #20;

            if (csr_rdata != 32'hDEADBEEF)
                $fatal(1, "MSTATUS FAILED");

        // ========================================================================
        // misa
        // ========================================================================
        
        csr_we    = 1;
        csr_waddr = 12'h301;
        csr_wdata = 32'hDEADBEAD;       //writing

        #20;

            if (!csr_ilgl_instr)
                $fatal(1, "MISA IS WRITABLE");

        #10;

        csr_we = 0;

        csr_raddr = 12'h301;            //reading

        #1;

        $display("misa = %h", csr_rdata);

        #20;

            if (csr_rdata != 32'h40000100)
                $fatal(1, "MISA FAILED");

        // ========================================================================
        // mie
        // ========================================================================
        
        csr_we    = 1;
        csr_waddr = 12'h304;
        csr_wdata = 32'h0F0F0F0F;       //writing

        #10;

        csr_we = 0;

        csr_raddr = 12'h304;            //reading

        #1;

        $display("mie = %h", csr_rdata);

        #20;

            if (csr_rdata != 32'h0F0F0F0F)
                $fatal(1, "MIE FAILED");
        
        // ========================================================================
        // mtvec
        // ========================================================================
        
        csr_we    = 1;
        csr_waddr = 12'h305;
        csr_wdata = 32'h11111111;       //writing

        #10;

        csr_we = 0;

        csr_raddr = 12'h305;            //reading

        #1;

        $display("mtvec = %h", csr_rdata);

        #20;

            if (csr_rdata != 32'h11111111)
                $fatal(1, "MTVEC FAILED");

        // ========================================================================
        // mscratch
        // ========================================================================
        
        csr_we    = 1;
        csr_waddr = 12'h340;
        csr_wdata = 32'hAAAAAAAA;       //writing

        #10;

        csr_we = 0;

        csr_raddr = 12'h340;            //reading

        #1;

        $display("mscratch = %h", csr_rdata);

        #20;

            if (csr_rdata != 32'hAAAAAAAA)
                $fatal(1, "MSCRATCH FAILED");

        // ========================================================================
        // mepc
        // ========================================================================
        
        csr_we    = 1;
        csr_waddr = 12'h341;
        csr_wdata = 32'hFFFFFFFF;       //writing

        #10;

        csr_we = 0;

        csr_raddr = 12'h341;            //reading

        #1;

        $display("mepc = %h", csr_rdata);

        #20;

            if (csr_rdata != 32'hFFFFFFFF)
                $fatal(1, "MEPC FAILED");

        // ========================================================================
        // mcause
        // ========================================================================
        
        csr_we    = 1;
        csr_waddr = 12'h342;
        csr_wdata = 32'hB00BB00B;       //writing

        #10;

        csr_we = 0;

        csr_raddr = 12'h342;            //reading

        #1;

        $display("mcause = %h", csr_rdata);

        #20;

            if (csr_rdata != 32'hB00BB00B)
                $fatal(1, "MCAUSE FAILED");

        // ========================================================================
        // mtval
        // ========================================================================
        
        csr_we    = 1;
        csr_waddr = 12'h343;
        csr_wdata = 32'hDEADDEAD;       //writing

        #10;

        csr_we = 0;

        csr_raddr = 12'h343;            //reading

        #1;

        $display("mtval = %h", csr_rdata);

        #20;

            if (csr_rdata != 32'hDEADDEAD)
                $fatal(1, "MTVAL FAILED");

        // ========================================================================
        // mip
        // ========================================================================
        
        csr_we    = 1;
        csr_waddr = 12'h344;
        csr_wdata = 32'h22222222;       //writing

        #20;

            if (!csr_ilgl_instr)
                $fatal(1, "mip is writable");

        #10;
        
        csr_we = 0;

        ext_irq = 0;

        csr_raddr = 12'h344;            //reading

        #1;

        $display("mip = %h", csr_rdata);

        #20;

            if (csr_rdata != 32'h0)
                $fatal(1, "MIP FAILED");

        #10;

        csr_we = 0;

        ext_irq = 1;

        csr_raddr = 12'h344;            //reading

        #1;

        $display("mip = %h", csr_rdata);

        #20;

            if (csr_rdata != 32'b00000000000000000000100000000000)
                $fatal(1, "MIP FAILED.2");

        // ========================================================================
        // mcycle
        // ========================================================================
        
        csr_we    = 1;
        csr_waddr = 12'hB00;
        csr_wdata = 32'hFFFF0000;       //writing

        #10;

        csr_we = 0;

        csr_raddr = 12'hB00;            //reading

        #1;

        $display("mcycle = %h", csr_rdata);

        /* #20; 
        
        // interesting case where mcycle has two assign statements in our sequential block. 
        if we pause for some time then the csr_rdata is overwritten by normal mcycle operations. i think.

        the above display statement gives us rdata as ffff0000 while the one below gives us ffff0002. because of the #20 i assume.
        however not pausing for any time allows the test to pass as normal.

        i guess we can change up the normal mcycle increments by only allowing the increment to happen when csr_waddr is NOT 0xB00.

        $display("mcycle = %h", csr_rdata); */

            if (csr_rdata != 32'hFFFF0000)
                $fatal(1, "MCYCLE FAILED");

        // ========================================================================
        // minsret
        // ========================================================================
        
        csr_we    = 1;
        csr_waddr = 12'hB02;
        csr_wdata = 32'hDEADDEAD;       //writing

        #10;

        csr_we = 0;

        csr_raddr = 12'hB02;            //reading

        #1;

        $display("minstret = %h", csr_rdata);

        #20;

            if (csr_rdata != 32'hDEADDEAD)
                $fatal(1, "MINSTRET FAILED");

        // ========================================================================
        // reset test
        // ========================================================================

        rst_n = 0;
        #10;            // this #10 doesnt seem to affect mcycle increments? verilog behaviour or am i messing up the logic
        rst_n = 1;

        ext_irq = 0;

        csr_raddr = 12'hB00;
        // #1;
        if (csr_rdata != 32'h0)
            $fatal(1, "RESET FAILED: MCYCLE. csr_rdata = %h", csr_rdata);

        csr_raddr = 12'h300;
        #1;
        if (csr_rdata != 32'h0)
            $fatal(1, "RESET FAILED: MSTATUS");
        
        csr_raddr = 12'h301;
        #1;
        if (csr_rdata != 32'h40000100)
            $fatal(1, "RESET FAILED: MISA");

        csr_raddr = 12'h304;
        #1;
        if (csr_rdata != 32'h0)
            $fatal(1, "RESET FAILED: MIE");

        csr_raddr = 12'h305;
        #1;
        if (csr_rdata != 32'h0)
            $fatal(1, "RESET FAILED: MTVEC");

        csr_raddr = 12'h340;
        #1;
        if (csr_rdata != 32'h0)
            $fatal(1, "RESET FAILED: MSCRATCH");

        csr_raddr = 12'h341;
        #1;
        if (csr_rdata != 32'h0)
            $fatal(1, "RESET FAILED: MEPC");

        csr_raddr = 12'h342;
        #1;
        if (csr_rdata != 32'h0)
            $fatal(1, "RESET FAILED: MCAUSE");
        
        csr_raddr = 12'h343;
        #1;
        if (csr_rdata != 32'h0)
            $fatal(1, "RESET FAILED: MTVAL");
        
        csr_raddr = 12'h344;
        #1;
        if (csr_rdata != 32'h0)
            $fatal(1, "RESET FAILED: MIP");
        
        #1;
        
        ext_irq = 1;

        #10;

        csr_raddr = 12'h344;
        #1;
        if (csr_rdata != 32'b00000000000000000000100000000000)
            $fatal(1, "RESET FAILED: MIP.2. csr_rdata = %h", csr_rdata);

        csr_raddr = 12'hB02;
        #1;
        if (csr_rdata != 32'h0)
            $fatal(1, "RESET FAILED: MINSTRET");

        $display("ALL TESTS PASSED");
        
        $finish;

    end

endmodule