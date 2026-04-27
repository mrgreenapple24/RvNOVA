`timescale 1ns/1ps

module tb_branch;

    integer i;
    reg clk;
    reg rst_n;

    wire [31:0] pc_out;
    reg  [31:0] instr_in;

    wire [31:0] data_addr;
    wire [31:0] data_wdata;
    wire        data_we;
    wire        data_re;
    reg  [31:0] data_rdata;

    riscv_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .pc_out(pc_out),
        .instr_in(instr_in),
        .data_addr(data_addr),
        .data_wdata(data_wdata),
        .data_we(data_we),
        .data_re(data_re),
        .data_rdata(data_rdata)
    );

    always #5 clk = ~clk;

    reg [31:0] instr_mem [0:255];
    always @(*) instr_in = instr_mem[pc_out[9:2]];

    reg [31:0] data_mem [0:255];
    always @(*) data_rdata = data_mem[data_addr[9:2]];
    always @(posedge clk) if (data_we) data_mem[data_addr[9:2]] <= data_wdata;

    // Debug Monitor
    always @(posedge clk) begin
        if (rst_n)
            $display("time=%0t PC=0x%08x INSTR=0x%08x WE=%b ADDR=0x%08x WDATA=0x%08x",
                     $time, pc_out, instr_in, data_we, data_addr, data_wdata);
    end

    initial begin
        clk = 0;
        rst_n = 0;

        for (i = 0; i < 256; i = i + 1) begin
            instr_mem[i] = 32'h00000013; // NOP
            data_mem[i]  = 32'h00000000;
        end

        // Test Program
        // 0: addi x1, x0, 5
        instr_mem[0] = 32'h00500093;
        // 4: addi x2, x0, 10
        instr_mem[1] = 32'h00A00113;
        
        // 8: beq x1, x2, label_fail_beq (offset +12) -> should NOT take
        instr_mem[2] = 32'h00208663; 
        
        // 12: bne x1, x2, label_pass_bne (offset +8) -> SHOULD take
        instr_mem[3] = 32'h00209463; 

        // 16: label_fail_beq: addi x3, x0, 1 (should be skipped)
        instr_mem[4] = 32'h00100193;

        // 20: label_pass_bne: addi x4, x0, 1 (expected)
        instr_mem[5] = 32'h00100213;

        // 24: blt x1, x2, label_pass_blt (offset +8) -> SHOULD take (5 < 10)
        instr_mem[6] = 32'h0020C463;

        // 28: label_fail_blt: addi x5, x0, 1 (should be skipped)
        instr_mem[7] = 32'h00100293;

        // 32: label_pass_blt: addi x6, x0, 1 (expected)
        instr_mem[8] = 32'h00100313;

        // 36: bge x1, x2, label_fail_bge (offset +8) -> should NOT take (5 < 10)
        instr_mem[9] = 32'h0020D463;

        // 40: label_pass_bge: addi x7, x0, 1 (expected)
        instr_mem[10] = 32'h00100393;

        // 44: sw x4, 0(x0)  // Store results to verify
        instr_mem[11] = 32'h00402023;
        // 48: sw x6, 4(x0)
        instr_mem[12] = 32'h00602223;
        // 52: sw x7, 8(x0)
        instr_mem[13] = 32'h00702423;
        // 56: sw x3, 12(x0) // Should be 0
        instr_mem[14] = 32'h00302623;
        // 60: sw x5, 16(x0) // Should be 0
        instr_mem[15] = 32'h00502823;

        // 64: loop: jal x0, 0
        instr_mem[16] = 32'h0000006F;

        #20 rst_n = 1;
        #500;

        $display("--- Branch Test Results ---");
        $display("x4 (BNE pass): %d (expected 1)", data_mem[0]);
        $display("x6 (BLT pass): %d (expected 1)", data_mem[1]);
        $display("x7 (BGE fail-skip pass): %d (expected 1)", data_mem[2]);
        $display("x3 (BEQ fail-taken): %d (expected 0)", data_mem[3]);
        $display("x5 (BLT fail-taken): %d (expected 0)", data_mem[4]);
        
        if (data_mem[0] == 1 && data_mem[1] == 1 && data_mem[2] == 1 && data_mem[3] == 0 && data_mem[4] == 0)
            $display("BRANCH TEST PASSED!");
        else
            $display("BRANCH TEST FAILED!");
        
        $finish;
    end

endmodule
