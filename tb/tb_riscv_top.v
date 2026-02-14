`timescale 1ns/1ps

module tb_riscv_top;

    integer i;
    // Clock + Reset
    reg clk;
    reg rst_n;

    // Instruction Memory Interface
    wire [31:0] pc_out;
    reg  [31:0] instr_in;

    // Data Memory Interface
    wire [31:0] data_addr;
    wire [31:0] data_wdata;
    wire        data_we;
    wire        data_re;
    reg  [31:0] data_rdata;

    // Instantiate DUT
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

    // ============================================================
    // Clock Generation (100 MHz -> 10ns period)
    // ============================================================
    always #5 clk = ~clk;

    // ============================================================
    // Instruction Memory (Simple ROM)
    // ============================================================
    reg [31:0] instr_mem [0:255];

    always @(*) begin
        instr_in = instr_mem[pc_out[9:2]]; // word aligned (divide by 4)
    end

    // ============================================================
    // Data Memory (Simple RAM)
    // ============================================================
    reg [31:0] data_mem [0:255];

    always @(*) begin
        if (data_re)
            data_rdata = data_mem[data_addr[9:2]];
        else
            data_rdata = 32'b0;
    end

    always @(posedge clk) begin
        if (data_we) begin
            data_mem[data_addr[9:2]] <= data_wdata;
            $display("[MEM WRITE] time=%0t addr=0x%08x data=0x%08x",
                     $time, data_addr, data_wdata);
        end
    end

    // ============================================================
    // Debug Monitor
    // ============================================================
    always @(posedge clk) begin
        $display("time=%0t PC=0x%08x INSTR=0x%08x WE=%b RE=%b ADDR=0x%08x WDATA=0x%08x RDATA=0x%08x",
                 $time, pc_out, instr_in, data_we, data_re, data_addr, data_wdata, data_rdata);
    end

    // ============================================================
    // Test Program Loader
    // ============================================================
    initial begin
        // init signals
        clk = 0;
        rst_n = 0;

        // clear memories
        for (i = 0; i < 256; i = i + 1) begin
            instr_mem[i] = 32'h00000013; // NOP (addi x0,x0,0)
            data_mem[i]  = 32'h00000000;
        end

        // ========================================================
        // Example Program
        // ========================================================
        // addi x1, x0, 10
        instr_mem[0] = 32'h00A00093;

        // addi x2, x0, 20
        instr_mem[1] = 32'h01400113;

        // add x3, x1, x2
        instr_mem[2] = 32'h002081B3;

        // sw x3, 0(x0)
        instr_mem[3] = 32'h00302023;

        // lw x4, 0(x0)
        instr_mem[4] = 32'h00002203;

        // infinite loop: jal x0, 0
        instr_mem[5] = 32'h0000006F;

        // ========================================================
        // Reset pulse
        // ========================================================
        #20;
        rst_n = 1;

        // Run for some cycles
        #300;

        // Dump memory result
        $display("--------------------------------------------------");
        $display("FINAL DATA MEM [0] = 0x%08x", data_mem[0]);
        $display("--------------------------------------------------");

        $finish;
    end

endmodule
