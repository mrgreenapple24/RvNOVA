`timescale 1ns/1ps

module tb_integrated;

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

        // --- Integrated Test Program ---
        
        // 0x00: lui x1, 0x12345        (x1 = 0x12345000)
        instr_mem[0] = 32'h123450B7;
        
        // 0x04: addi x2, x0, 100       (x2 = 100)
        instr_mem[1] = 32'h06400113;

        // 0x08: addi x3, x0, 100       (x3 = 100)
        instr_mem[2] = 32'h06400193;

        // 0x0C: beq x2, x3, 0x14 (skip 2 instrs) -> SHOULD TAKE (pc -> 0x0C + 0x14 = 0x20)
        // B-type encoding for offset 0x14: imm[12]=0, imm[11]=0, imm[10:5]=000000, imm[4:1]=1010
        // imm[12]=0, imm[10:5]=000000, rs2=3, rs1=2, funct3=000, imm[4:1]=1010, imm[11]=0, opcode=1100011
        instr_mem[3] = 32'h00310A63; 

        // 0x10: addi x4, x0, 1 (FAILED BRANCH BEQ)
        instr_mem[4] = 32'h00100213;

        // 0x14: jal x0, end (should not reach)
        instr_mem[5] = 32'h0000006F;

        // 0x20: addi x5, x0, 1 (SUCCESS BRANCH BEQ)
        instr_mem[8] = 32'h00100293;

        // 0x24: blt x2, x1, 0x08 (skip 1 instr) -> SHOULD TAKE (100 < 0x12345000) (pc -> 0x24 + 0x08 = 0x2C)
        instr_mem[9] = 32'h00114463;

        // 0x28: addi x6, x0, 1 (FAILED BRANCH BLT)
        instr_mem[10] = 32'h00100313;

        // 0x2C: jal x7, 0x08 (x7 = 0x30, pc -> 0x2C + 0x08 = 0x34)
        instr_mem[11] = 32'h008003EF;

        // 0x30: addi x8, x0, 1 (FAILED JAL)
        instr_mem[12] = 32'h00100413;

        // 0x34: sw x1, 0(x0)  // 0x12345000
        instr_mem[13] = 32'h00102023;
        // 0x38: sw x5, 4(x0)  // 1
        instr_mem[14] = 32'h00502223;
        // 0x3C: sw x7, 8(x0)  // 0x30 (48)
        instr_mem[15] = 32'h00702423;

        // 0x40: loop: jal x0, 0
        instr_mem[16] = 32'h0000006F;

        #20 rst_n = 1;
        #500;

        $display("--- Integrated Test Results ---");
        $display("MEM[0] (LUI): 0x%08x (expected 0x12345000)", data_mem[0]);
        $display("MEM[4] (BEQ): %d (expected 1)", data_mem[1]);
        $display("MEM[8] (JAL): %d (expected 48)", data_mem[2]);
        
        if (data_mem[0] == 32'h12345000 && data_mem[1] == 1 && data_mem[2] == 48)
            $display("INTEGRATED TEST PASSED!");
        else
            $display("INTEGRATED TEST FAILED!");
        
        $finish;
    end

endmodule
