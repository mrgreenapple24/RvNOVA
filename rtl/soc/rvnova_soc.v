module rvnova_soc (
    input clk,
    input rst_n
);

    // ========================================================
    // Instruction Memory
    // ========================================================

    wire [31:0] pc;
    wire [31:0] instr_in;

    // ========================================================
    // Data Memory
    // ========================================================

    wire [31:0] data_addr;
    wire [31:0] data_wdata;
    wire [3:0]  data_be;
    wire        data_re;
    wire [31:0] data_rdata;

    // ========================================================
    // External Inputs
    // ========================================================

    wire        ext_irq;

    riscv_top cpu(
        .clk(clk),
        .rst_n(rst_n),
        .ext_irq(ext_irq),
        .pc_out(pc),
        .instr_in(instr_in),
        .data_addr(data_addr),
        .data_wdata(data_wdata),
        .data_be(data_be),
        .data_re(data_re),
        .data_rdata(data_rdata)
    );

    instr_mem imem(
        .addr(pc),
        .instr(instr_in)
    );

    data_mem dmem(
        .clk(clk),
        .addr(data_addr),
        .wdata(data_wdata),
        .byte_en(data_be),
        .read_en(data_re),
        .rdata(data_rdata)
    );

endmodule
