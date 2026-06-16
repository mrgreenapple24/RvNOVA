module riscv_top (
    input  wire        clk,
    input  wire        rst_n,

    //External Interrupts
    input  wire        ext_irq,

    // Instruction Memory
    output wire [31:0] pc_out,
    input  wire [31:0] instr_in,

    // Data Memory
    output wire [31:0] data_addr,
    output wire [31:0] data_wdata,
    output wire [3:0]  data_be,
    output wire        data_re,
    input  wire [31:0] data_rdata
);

    // ========================================================================
    // Internal Wires
    // ========================================================================
    wire [31:0] pc_current;
    wire [31:0] pc_next;
    wire [31:0] pc_plus_4;
    wire [31:0] pc_target;

    // Control Signals
    wire        reg_write;
    wire        alu_src;
    wire        op1_src;
    wire [1:0]  reg_mux;
    wire [2:0]  alu_op;
    wire [3:0]  alu_ctrl;
    wire        branch;
    wire        jump;
    wire        is_ecall;
    wire        is_ebreak;
    wire        csr_write;
    wire [2:0]  csr_op;
    wire        csr_trap_we;
    wire        illegal_instr;
    wire        instr_misalign;
    wire        load_misalign;
    wire        store_misalign;
    wire        trap_taken;
    wire        mret_taken;
    wire        csr_mret;
    wire        instr_retired;
    wire        csr_access;
    wire        csr_ilgl_instr;
    wire        decode_ilgl_instr;
    wire        is_wfi;
    wire        interrupt_pending;

    // Datapath Signals
    wire [31:0] rd1_data;
    wire [31:0] rd2_data;
    reg  [31:0] write_data; // reg for always block assignment
    wire [31:0] operand_a;
    wire [31:0] operand_b;
    wire [31:0] alu_result;
    wire        alu_zero;
    wire [31:0] imm_ext;
    wire        jalr;
    wire [11:0] csr_addr;
    wire [31:0] csr_rdata;
    wire [31:0] csr_wdata;
    wire [31:0] csr_mstatus;
    wire [31:0] csr_mcause;
    wire [31:0] csr_mtval;
    wire [31:0] csr_mtvec;
    wire [31:0] csr_misa;
    wire [31:0] csr_mscratch;
    wire [31:0] csr_mcycle;
    wire [31:0] csr_minstret;
    wire [31:0] csr_mie;
    wire [31:0] csr_mip;
    wire [31:0] csr_mepc;
    wire [31:0] trap_mcause;
    wire [31:0] trap_mepc;
    wire [31:0] trap_mtval;
    wire [31:0] trap_mstatus;
    wire [31:0] trap_target_pc;

    //PROCESSOR STATUS
    reg         sleeping;       //assigned in sequential block

    // ========================================================================
    // Fetch Stage
    // ========================================================================

    // PC Flip-Flop
    pc pc_unit (
        .clk(clk),
        .rst(rst_n),
        .sleeping(sleeping),
        .pc_next(pc_next),
        .pc(pc_current)
    );

    assign pc_plus_4 = pc_current + 4;
    assign pc_out    = pc_current;

    // ========================================================================
    // Control Unit
    // ========================================================================
    wire mem_write_internal;

    main_decode control (
        .opcode     (instr_in[6:0]),
        .funct3     (instr_in[14:12]),
        .funct12    (instr_in[31:20]),
        .reg_write  (reg_write),
        .alu_src    (alu_src),
        .mem_write  (mem_write_internal),
        .mem_read   (data_re),
        .reg_mux    (reg_mux),
        .alu_op     (alu_op),
        .branch     (branch),
        .jump       (jump),
        .op1_src    (op1_src),
        .is_ecall   (is_ecall),
        .is_ebreak  (is_ebreak),                     // Leave unconnected. edit 1: connected...
        .is_wfi     (is_wfi),
        .csr_write  (csr_write),                     // Leave unconnected. edit 1: connected...
        .jalr(jalr),
        .csr_op(csr_op),
        .csr_mret(csr_mret),
        .decode_ilgl_instr(decode_ilgl_instr),
        .csr_src(instr_in[19:15])
    );
    
    reg    [31:0] csr_wdata_int;
    assign        csr_wdata = csr_wdata_int;
    assign        illegal_instr = decode_ilgl_instr || csr_ilgl_instr;

    always @(*) begin
        case (csr_op)
            3'b001:  csr_wdata_int = rd1_data;                                  //CSRRW
            3'b010:  csr_wdata_int = csr_rdata | rd1_data;                      //CSRRS
            3'b011:  csr_wdata_int = csr_rdata & ~rd1_data;                     //CSRRC
            3'b101:  csr_wdata_int = {27'b0, instr_in[19:15]};                  //CSRRWI
            3'b110:  csr_wdata_int = csr_rdata | {27'b0, instr_in[19:15]};      //CSRRSI
            3'b111:  csr_wdata_int = csr_rdata & ~{27'b0, instr_in[19:15]};     //CSRRCI
            default: csr_wdata_int = 32'b0;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sleeping <= 1'b0;
        
        else if (interrupt_pending)
            sleeping <= 1'b0;
            
        else if (is_wfi)
            sleeping <= 1'b1;
    end

    alu_decode control_alu(
        .alu_op(alu_op),
        .funct3(instr_in[14:12]),
        .funct7_b5(instr_in[30]),
        .alu_ctrl(alu_ctrl)
    );

    // ========================================================================
    // Load/Store Unit
    // ========================================================================
    wire [31:0] load_data_internal;
    wire        misaligned_exc;

    load_store_unit lsu (
        .clk            (clk),
        .addr           (alu_result),
        .store_data     (rd2_data),
        .funct3         (instr_in[14:12]),
        .mem_read       (data_re),
        .mem_write      (mem_write_internal),
        .mem_rdata      (data_rdata),
        .data_addr      (data_addr),
        .data_wdata     (data_wdata),
        .data_be        (data_be),
        .load_data      (load_data_internal),
        .misaligned_exc (misaligned_exc)
    );



    // ========================================================================
    // Datapath Instantiations
    // ========================================================================

    // Register File
    regfile rf (
        .clk        (clk),
        .reset      (rst_n),
        .we         (reg_write),
        .rs1_addr   (instr_in[19:15]),
        .rs2_addr   (instr_in[24:20]),
        .rd_addr    (instr_in[11:7]),
        .w_data     (write_data),
        .rs1_data   (rd1_data),
        .rs2_data   (rd2_data)
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
        case (reg_mux)
            2'b00: write_data = alu_result;
            2'b01: write_data = load_data_internal;
            2'b10: write_data = pc_plus_4;
            2'b11: write_data = csr_rdata;
            default: write_data = 32'b0;
        endcase
    end


    pc_mux pc_logic (
        .pc(pc_current),
        .imm(imm_ext),
        .rs1_data(rd1_data),
        .funct3(instr_in[14:12]),
        .alu_result(alu_result),
        .alu_zero(alu_zero),
        .mret_taken(mret_taken),
        .trap_taken(trap_taken),
        .branch(branch),
        .jump(jump),
        .jalr(jalr),
        .trap_target_pc(trap_target_pc),
        .pc_next(pc_next)
    );

    csr_regfile csr_reg (
        .clk(clk),
        .rst_n(rst_n),
        .instr_retired(instr_retired),
        .ext_irq(ext_irq),
        .csr_access(csr_access),
        .csr_ilgl_instr(csr_ilgl_instr),
        .csr_we(csr_write),
        .csr_waddr(csr_addr),
        .csr_raddr(csr_addr),
        .csr_wdata(csr_wdata),
        .csr_rdata(csr_rdata),
        .csr_mstatus(csr_mstatus),
        .csr_mepc(csr_mepc),
        .csr_mtvec(csr_mtvec),
        .csr_mtval(csr_mtval),
        .csr_mcause(csr_mcause),
        .csr_misa(csr_misa),
        .csr_mscratch(csr_mscratch),
        .csr_mcycle(csr_mcycle),
        .csr_minstret(csr_minstret),
        .csr_mie(csr_mie),
        .csr_mip(csr_mip),
        .trap_we(csr_trap_we),
        .trap_mcause(trap_mcause),
        .trap_mepc(trap_mepc),
        .trap_mstatus(trap_mstatus),
        .trap_mtval(trap_mtval)
    );

    assign csr_addr = instr_in[31:20];
    assign csr_access = (csr_op != 3'b000);
    assign instr_retired = !trap_taken && rst_n && !sleeping; //every cycle: instruction completes successfully or a trap occurs (basic implementation for single cycle)

    trap_ctrl trap_ctrl (
        .pc(pc_current),
        .fault_instr(instr_in[31:0]),
        .fault_addr(alu_result),
        .illegal_instr(illegal_instr),
        .instr_misalign(instr_misalign),
        .load_misalign(load_misalign),
        .store_misalign(store_misalign),
        .ecall(is_ecall),
        .ebreak(is_ebreak),
        .ext_irq(ext_irq),
        .csr_mstatus(csr_mstatus),
        .csr_mepc(csr_mepc),
        .csr_mtvec(csr_mtvec),
        .csr_mtval(csr_mtval),
        .csr_mcause(csr_mcause),
        .csr_mie(csr_mie),
        .csr_mip(csr_mip),
        .csr_mret(csr_mret),
        .trap_taken(trap_taken),
        .mret_taken(mret_taken),
        .interrupt_pending(interrupt_pending),
        .trap_target_pc(trap_target_pc),
        .csr_trap_we(csr_trap_we),
        .trap_mcause(trap_mcause),
        .trap_mepc(trap_mepc),
        .trap_mstatus(trap_mstatus),
        .trap_mtval(trap_mtval)
    );

    // assign ext_irq        = 1'b0; //hardcoded till added as an input to top
    assign instr_misalign = 1'b0;
    assign store_misalign = misaligned_exc && mem_write_internal;
    assign load_misalign  = misaligned_exc && data_re;

endmodule
