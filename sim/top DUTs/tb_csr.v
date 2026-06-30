`timescale 1ns/1ps

module tb_csr;

    integer i;

    reg clk;
    reg rst_n;
    reg ext_irq;

    wire [31:0] pc_out;
    reg  [31:0] instr_in;

    wire [31:0] data_addr;
    wire [31:0] data_wdata;
    wire [3:0]  data_be;
    wire        data_re;
    reg  [31:0] data_rdata;

    riscv_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .ext_irq(ext_irq),

        .pc_out(pc_out),
        .instr_in(instr_in),

        .data_addr(data_addr),
        .data_wdata(data_wdata),
        .data_be(data_be),
        .data_re(data_re),
        .data_rdata(data_rdata)
    );

    // ============================================================
    // Clock
    // ============================================================
    always #5 clk = ~clk;

    // ============================================================
    // Instruction Memory (rom)
    // ============================================================
    reg [31:0] instr_mem [0:255];

    always @(*) begin
        instr_in = instr_mem[pc_out[9:2]]; // word aligned (divide by 4)
    end

    // ============================================================
    // Data Memory (dummy)
    // ============================================================
    reg [31:0] data_mem [0:255];

    always @(*) begin
        if (data_re)
            data_rdata = data_mem[data_addr[9:2]];
        else
            data_rdata = 32'b0;
    end

    always @(posedge clk) begin
        if (|data_be) begin
            data_mem[data_addr[9:2]] <= data_wdata;
        end
    end

    // ============================================================
    // debug
    // ============================================================
    always @(posedge clk) begin
        $display(
            "PC=%h mtvec=%h x2=%h x4=%h x6=%h x7=%h x8=%h x9=%h x10=%h",
            pc_out,
            dut.csr_reg.mtvec,
            dut.rf.reg_array[2],
            dut.rf.reg_array[4],
            dut.rf.reg_array[6],
            dut.rf.reg_array[7],
            dut.rf.reg_array[8],
            dut.rf.reg_array[9],
            dut.rf.reg_array[10]
            );
    end

    // ============================================================
    // Test
    // ============================================================
    initial begin
        
        // init signals
        clk = 0;
        rst_n = 0;
        ext_irq = 0;

        // clear memories
        for (i = 0; i < 256; i = i + 1) begin
            instr_mem[i] = 32'h00000013; // NOP (addi x0,x0,0)
            data_mem[i]  = 32'h00000000;
        end

        // ========================================================
        // CSR Test Program
        // ========================================================

        // addi x1, x0, 5
        instr_mem[0] = 32'h00500093;

        // csrrw x2, mtvec, x1
        instr_mem[1] = 32'h30509173;

        // addi x3, x0, 2
        instr_mem[2] = 32'h00200193;

        // csrrs x4, mtvec, x3
        instr_mem[3] = 32'h3051A273;

        // addi x5, x0, 1
        instr_mem[4] = 32'h00100293;

        // csrrc x6, mtvec, x5
        instr_mem[5] = 32'h3052B373;

        // csrrwi x7, mtvec, 3
        instr_mem[6] = 32'h3051D3F3;

        // csrrsi x8, mtvec, 8
        instr_mem[7] = 32'h30546473;

        // csrrci x9, mtvec, 2
        instr_mem[8] = 32'h305174F3;

        // csrrs x10, mtvec, x0
        // should NOT modify mtvec
        instr_mem[9] = 32'h30502573;

        // infinite loop
        instr_mem[10] = 32'h0000006F;

        // ========================================================
        // Reset pulse
        // ========================================================
        
        #20;
        rst_n = 1;

        // Run for some cycles
        #300;


        $display("-----------------------------------");
        $display("FINAL RESULTS");
        $display("-----------------------------------");

        $display("mtvec = %h", dut.csr_reg.mtvec);
        $display("x2    = %h", dut.rf.reg_array[2]);
        $display("x4    = %h", dut.rf.reg_array[4]);
        $display("x6    = %h", dut.rf.reg_array[6]);
        $display("x7    = %h", dut.rf.reg_array[7]);
        $display("x8    = %h", dut.rf.reg_array[8]);
        $display("x9    = %h", dut.rf.reg_array[9]);
        $display("x10   = %h", dut.rf.reg_array[10]);

        if (dut.rf.reg_array[2]  !== 32'h00000000)
            $fatal(1, "CSRRW FAILED");

        if (dut.rf.reg_array[4]  !== 32'h00000005)
            $fatal(1, "CSRRS FAILED");

        if (dut.rf.reg_array[6]  !== 32'h00000007)
            $fatal(1, "CSRRC FAILED");

        if (dut.rf.reg_array[7]  !== 32'h00000006)
            $fatal(1, "CSRRWI FAILED");

        if (dut.rf.reg_array[8]  !== 32'h00000003)
            $fatal(1, "CSRRSI FAILED");

        if (dut.rf.reg_array[9]  !== 32'h0000000B)
            $fatal(1, "CSRRCI FAILED");

        if (dut.rf.reg_array[10] !== 32'h00000009)
            $fatal(1, "CSRRS READ-ONLY FAILED");

        if (dut.csr_reg.mtvec    !== 32'h00000009)
            $fatal(1, "FINAL MTVEC WRONG");

        $display("ALL CSR TESTS PASSED");

        $finish;
    end

endmodule
