module riscv_top (
    input  wire        clk,
    input  wire        rst_n,

    // Instruction Memory
    output wire [31:0] pc_out,
    input  wire [31:0] instr_in,

    // Data Memory
    output wire [31:0] data_addr,
    output wire [31:0] data_wdata,
    output wire        data_we,
    output wire        data_re,
    input  wire [31:0] data_rdata
);

    // ========================================================================
    // Internal Wires
    // ========================================================================
    wire  [31:0] pc_current;
    wire  [31:0] pc_next;
    wire [31:0] pc_plus_4;
    wire [31:0] pc_target;

    // Control Signals
    wire        reg_write;
    wire        alu_src;
    wire        op1_src;
    wire [1:0]  mem_to_reg;
    wire [2:0]  alu_op;
    wire [3:0]  alu_ctrl;
    wire        branch;
    wire        jump;
    wire        is_ecall;

    // Datapath Signals
    wire [31:0] rd1_data;
    wire [31:0] rd2_data;
    reg  [31:0] write_data; // reg for always block assignment
    wire [31:0] operand_a;
    wire [31:0] operand_b;
    wire [31:0] alu_result;
    wire        alu_zero;
    wire [31:0] imm_ext;
    wire jalr;

    // ========================================================================
    // Fetch Stage
    // ========================================================================

    // PC Flip-Flop
    pc pc_unit (
        .clk(clk),
        .rst(rst_n),
        .pc_next(pc_next),
        .pc(pc_current)
    );

    assign pc_plus_4 = pc_current + 4;
    assign pc_out    = pc_current;

    // ========================================================================
    // Control Unit
    // ========================================================================
    main_decode control (
        .opcode     (instr_in[6:0]),
        .funct3     (instr_in[14:12]),
        .funct12_b0 (instr_in[20]),
        .reg_write  (reg_write),
        .alu_src    (alu_src),
        .mem_write  (data_we),
        .mem_read   (data_re),
        .mem_to_reg (mem_to_reg),
        .alu_op     (alu_op),
        .branch     (branch),
        .jump       (jump),
        .op1_src    (op1_src),
        .is_ecall   (is_ecall),
        .is_ebreak  (), // Leave unconnected
        .csr_write  (),  // Leave unconnected
        .jalr(jalr)
    );

    alu_decode control_alu(
        .alu_op(alu_op),
        .funct3(instr_in[14:12]),
        .funct7_b5(instr_in[30]),
        .alu_ctrl(alu_ctrl)
    );



    // ========================================================================
    // Datapath Instantiations
    // ========================================================================

    // Register File
    regfile rf (
        .clk        (clk),
        .reset      (rst_n),
        .we         (reg_write),
        .rs1_addr        (instr_in[19:15]),
        .rs2_addr        (instr_in[24:20]),
        .rd_addr         (instr_in[11:7]),
        .w_data      (write_data),
        .rs1_data (rd1_data),
        .rs2_data     (rd2_data)
    );

    // Immediate Generator
    imm_gen ig (
        .instr      (instr_in),
        .imm    (imm_ext)
    );

    // ALU Input Muxes
    assign operand_a = (op1_src) ? pc_current : rd1_data;
    assign operand_b = (alu_src) ? imm_ext : rd2_data;

    // ALU
    alu main_alu (
        .a          (operand_a),
        .b          (operand_b),
        .alu_ctrl   (alu_ctrl),
        .op         (alu_result),
        .zero       (alu_zero)
    );

    // ========================================================================
    // Writeback Selection (Mux)
    // ========================================================================
    always @(*) begin
        case (mem_to_reg)
            2'b00: write_data = alu_result;
            2'b01: write_data = data_rdata;
            2'b10: write_data = pc_plus_4;
            default: write_data = 32'b0;
        endcase
    end


    pc_mux pc_logic (
        .pc(pc_current),
        .imm(imm_ext),
        .rs1_data(rd1_data),
        .cmpr(alu_zero),
        .branch(branch),
        .jump(jump),
        .jalr(jalr),
        .pc_next(pc_next)
    );

    assign data_addr  = alu_result;
    assign data_wdata = rd2_data;


endmodule
