`timescale 1ns/1ps

module tb_riscv_top;

    integer i;
    // Clock + Reset
    reg clk;
    reg rst_n;
    reg ext_irq;

    // Instruction Memory Interface
    wire [31:0] pc_out;
    reg  [31:0] instr_in;

    // Data Memory Interface
    wire [31:0] data_addr;
    wire [31:0] data_wdata;
    wire [3:0]  data_be;
    wire        data_re;
    reg  [31:0] data_rdata;

    // Instantiate DUT
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
        if (|data_be) begin
            if (data_be[0]) data_mem[data_addr[9:2]][7:0]   <= data_wdata[7:0];
            if (data_be[1]) data_mem[data_addr[9:2]][15:8]  <= data_wdata[15:8];
            if (data_be[2]) data_mem[data_addr[9:2]][23:16] <= data_wdata[23:16];
            if (data_be[3]) data_mem[data_addr[9:2]][31:24] <= data_wdata[31:24];
            $display("[MEM WRITE] time=%0t addr=0x%08x data=0x%08x be=%b",
                     $time, data_addr, data_wdata, data_be);
        end
    end

    // ============================================================
    // Debug Monitor
    // ============================================================
    always @(posedge clk) begin
        $display("time=%0t PC=0x%08x INSTR=0x%08x BE=%b RE=%b ADDR=0x%08x WDATA=0x%08x RDATA=0x%08x",
                 $time, pc_out, instr_in, data_be, data_re, data_addr, data_wdata, data_rdata);
    end

    // ============================================================
    // Test Program Loader
    // ============================================================
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_riscv_top);

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
        // Sub-word Memory Access Test Program
        // ========================================================
        // lui x5, 0x12345
        instr_mem[0] = 32'h123452B7;
        // addi x5, x5, 0x678 -> x5 = 0x12345678
        instr_mem[1] = 32'h67828293;
        // sb x5, 4(x0) -> Store 0x78 at addr 4
        instr_mem[2] = 32'h00500223;
        // sh x5, 6(x0) -> Store 0x5678 at addr 6
        instr_mem[3] = 32'h00501323;
        // sw x5, 8(x0) -> Store 0x12345678 at addr 8
        instr_mem[4] = 32'h00502423;
        // lbu x6, 4(x0) -> Load 0x00000078 from addr 4
        instr_mem[5] = 32'h00404303;
        // lb x7, 4(x0) -> Load 0x00000078 from addr 4
        instr_mem[6] = 32'h00400383;
        // lhu x8, 6(x0) -> Load 0x00005678 from addr 6
        instr_mem[7] = 32'h00605403;
        // lh x9, 6(x0) -> Load 0x00005678 from addr 6
        instr_mem[8] = 32'h00601483;
        // addi x10, x0, -1 -> x10 = 0xFFFFFFFF
        instr_mem[9] = 32'hFFF00513;
        // sb x10, 12(x0) -> Store 0xFF at addr 12
        instr_mem[10] = 32'h00A00623;
        // lb x11, 12(x0) -> Load 0xFFFFFFFF from addr 12 (sign extend)
        instr_mem[11] = 32'h00C00583;
        // lbu x12, 12(x0) -> Load 0x000000FF from addr 12 (zero extend)
        instr_mem[12] = 32'h00C04603;

        // infinite loop: jal x0, 0
        instr_mem[13] = 32'h0000006F;

        // ========================================================
        // Reset pulse
        // ========================================================
        #20;
        rst_n = 1;

        // Run for some cycles
        #300;

        // Dump memory result
        $display("--------------------------------------------------");
        $display("FINAL DATA MEM [1] = 0x%08x (expected 0x56780078)", data_mem[1]);
        $display("FINAL DATA MEM [2] = 0x%08x (expected 0x12345678)", data_mem[2]);
        $display("FINAL DATA MEM [3] = 0x%08x (expected 0x000000ff)", data_mem[3]);
        $display("--------------------------------------------------");

        if (data_mem[1] == 32'h56780078 && data_mem[2] == 32'h12345678 && data_mem[3] == 32'h000000ff) begin
            $display("RISCV_TOP TEST PASSED");
        end else begin
            $display("RISCV_TOP TEST FAILED");
        end

        $finish;
    end

endmodule
