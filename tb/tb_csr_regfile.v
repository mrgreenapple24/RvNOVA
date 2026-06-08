`timescale 1ns/1ps

module tb_csr_regfile;

    reg clk;
    reg rst_n;

    reg         csr_we;
    reg  [11:0] csr_waddr;
    reg  [11:0] csr_raddr;
    reg  [31:0] csr_wdata;

    wire [31:0] csr_rdata;

    csr_regfile dut (
        .clk(clk),
        .rst_n(rst_n),
        .csr_we(csr_we),
        .csr_waddr(csr_waddr),
        .csr_raddr(csr_raddr),
        .csr_wdata(csr_wdata),
        .csr_rdata(csr_rdata)
    );

    always #5 clk = ~clk;

    initial begin

        // ========================================================================
        // initialize values
        // ========================================================================
        
        clk   = 0;
        rst_n = 0;

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
                $fatal("MSTATUS FAILED");
        
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
                $fatal("MTVEC FAILED");

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
                $fatal("MEPC FAILED");

// ========================================================================
        // mstatus
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
                $fatal("MCAUSE FAILED");

        // ========================================================================
        // reset test
        // ========================================================================

        rst_n = 0;
        #10;
        rst_n = 1;

        csr_raddr = 12'h300;
        #1;
        if (csr_rdata != 32'h0)
            $fatal(1, "RESET FAILED: MSTATUS");

        csr_raddr = 12'h305;
        #1;
        if (csr_rdata != 32'h0)
            $fatal(1, "RESET FAILED: MTVEC");

        csr_raddr = 12'h341;
        #1;
        if (csr_rdata != 32'h0)
            $fatal(1, "RESET FAILED: MEPC");

        csr_raddr = 12'h342;
        #1;
        if (csr_rdata != 32'h0)
            $fatal(1, "RESET FAILED: MCAUSE");

        $display("ALL TESTS PASSED");
        
        $finish;

    end

endmodule