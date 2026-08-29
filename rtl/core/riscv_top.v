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
    // Declarations (at top to avoid declaration order issues)
    // ========================================================================
    `include "config/predictor_cfg.vh"
    // Predictor signals
    wire predict_taken;
    // Statistics counters
    reg [31:0] total_branch_cnt = 0;
    reg [31:0] mispredict_cnt = 0;
    wire [31:0] pc_current;
    wire [31:0] pc_next;
    wire [31:0] pc_plus_4;

    // Control Signals (from Decoder in ID stage)
    wire        reg_write;
    wire        alu_src;
    wire        mem_write;
    wire        mem_read;
    wire [1:0]  reg_mux;
    wire [2:0]  alu_op;
    wire        branch;
    wire        jump;
    wire        op1_src;
    wire        is_ecall;
    wire        is_ebreak;
    wire        is_wfi;
    wire        csr_write;
    wire        jalr;
    wire [2:0]  csr_op;
    wire        csr_mret;
    wire        decode_ilgl_instr;

    // Datapath Signals
    wire [31:0] rd1_data;
    wire [31:0] rd2_data;
    wire [31:0] operand_a;
    wire [31:0] operand_b;
    wire [31:0] alu_result;
    wire        alu_zero;
    wire [31:0] imm_ext;
    wire [3:0]  alu_ctrl;
    
    // CSR & Trap Signals in MEM Stage
    wire [11:0] csr_addr;
    wire [31:0] csr_rdata;
    wire [31:0] csr_wdata;
    wire [31:0] csr_mstatus;
    wire [31:0] csr_mepc;
    wire [31:0] csr_mtvec;
    wire [31:0] csr_mcause;
    wire [31:0] csr_mtval;
    wire [31:0] csr_misa;
    wire [31:0] csr_mscratch;
    wire [31:0] csr_mcycle;
    wire [31:0] csr_minstret;
    wire [31:0] csr_mie;
    wire [31:0] csr_mip;
    wire        csr_ilgl_instr;

    wire        csr_trap_we;
    wire [31:0] trap_mepc;
    wire [31:0] trap_mcause;
    wire [31:0] trap_mtval;
    wire [31:0] trap_mstatus;
    wire [31:0] trap_target_pc;
    wire        trap_taken_mem;
    wire        mret_taken_mem;
    wire        interrupt_pending;
    
    wire        load_misalign;
    wire        store_misalign;
    wire        misaligned_exc;
    wire        instr_retired;

    // Helper wires/regs declared at the top
    wire        csr_access_id;
    reg  [31:0] operand_a_forwarded;
    reg  [31:0] operand_b_forwarded;
    wire [31:0] load_data_internal;
    reg  [31:0] write_data_wb;
    reg  [31:0] write_data_mem;
    reg         take_branch_ex;
    wire [1:0]  forward_a;
    wire [1:0]  forward_b;

    // Processor Status
    reg         sleeping;

    // ========================================================================
    // Pipeline Registers
    // ========================================================================

    // IF/ID Registers
    reg [31:0] pc_id;
    reg [31:0] pc_plus_4_id;
    reg [31:0] instr_id;
    reg        valid_id;

    // ID/EX Registers
    reg [31:0] pc_ex;
    reg [31:0] pc_plus_4_ex;
    reg [31:0] rd1_data_ex;
    reg [31:0] rd2_data_ex;
    reg [31:0] imm_ext_ex;
    reg [31:0] instr_ex;
    reg [3:0]  alu_ctrl_ex;
    reg        reg_write_ex;
    reg        alu_src_ex;
    reg        mem_write_ex;
    reg        mem_read_ex;
    reg [1:0]  reg_mux_ex;
    reg        branch_ex;
    reg        jump_ex;
    reg        op1_src_ex;
    reg        jalr_ex;
    reg        is_ecall_ex;
    reg        is_ebreak_ex;
    reg        is_wfi_ex;
    reg        csr_write_ex;
    reg [2:0]  csr_op_ex;
    reg        csr_mret_ex;
    reg        csr_access_ex;
    reg [11:0] csr_addr_ex;
    reg        decode_ilgl_instr_ex;
    reg        valid_ex;

    // EX/MEM Registers
    reg [31:0] pc_mem;
    reg [31:0] pc_plus_4_mem;
    reg [31:0] alu_result_mem;
    reg [31:0] store_data_mem;
    reg [4:0]  rd_mem;
    reg [31:0] instr_mem;
    reg        reg_write_mem;
    reg        mem_write_mem;
    reg        mem_read_mem;
    reg [1:0]  reg_mux_mem;
    reg        is_ecall_mem;
    reg        is_ebreak_mem;
    reg        is_wfi_mem;
    reg        csr_write_mem;
    reg [2:0]  csr_op_mem;
    reg        csr_mret_mem;
    reg        csr_access_mem;
    reg [11:0] csr_addr_mem;
    reg [31:0] rd1_data_mem;
    reg        decode_ilgl_instr_mem;
    reg        valid_mem;

    // MEM/WB Registers
    reg [31:0] pc_wb;
    reg [31:0] alu_result_wb;
    reg [31:0] load_data_wb;
    reg [31:0] pc_plus_4_wb;
    reg [31:0] csr_rdata_wb;
    reg [4:0]  rd_wb;
    reg        reg_write_wb;
    reg [1:0]  reg_mux_wb;
    reg        valid_wb;

    // ========================================================================
    // Stalling and Flushing Control signals
    // ========================================================================
    wire stall_pc;
    wire stall_if_id;
    wire bubble_id_ex;

    wire flush_if_id;
    wire flush_id_ex;
    wire flush_ex_mem;

    wire branch_jump_taken_ex;

    // Branch predictor output (prediction does not affect functional flow)
    assign branch_jump_taken_ex = (branch_ex && take_branch_ex) || jump_ex || jalr_ex;

    assign flush_if_id  = branch_jump_taken_ex || trap_taken_mem || mret_taken_mem;
    assign flush_id_ex  = branch_jump_taken_ex || trap_taken_mem || mret_taken_mem || bubble_id_ex;
    assign flush_ex_mem = trap_taken_mem || mret_taken_mem;

    // ========================================================================
    // Pipeline Register Control Block
    // ========================================================================

    // IF/ID Register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_id        <= 32'b0;
            pc_plus_4_id <= 32'b0;
            instr_id     <= 32'h00000013; // ADDI x0, x0, 0 (NOP)
            valid_id     <= 1'b0;
        end else if (flush_if_id) begin
            pc_id        <= 32'b0;
            pc_plus_4_id <= 32'b0;
            instr_id     <= 32'h00000013;
            valid_id     <= 1'b0;
        end else if (!stall_if_id) begin
            pc_id        <= pc_current;
            pc_plus_4_id <= pc_plus_4;
            instr_id     <= instr_in;
            valid_id     <= 1'b1;
        end
    end

    // ID/EX Register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_ex                <= 32'b0;
            pc_plus_4_ex         <= 32'b0;
            rd1_data_ex          <= 32'b0;
            rd2_data_ex          <= 32'b0;
            imm_ext_ex           <= 32'b0;
            instr_ex             <= 32'h00000013;
            alu_ctrl_ex          <= 4'b0;
            reg_write_ex         <= 1'b0;
            alu_src_ex           <= 1'b0;
            mem_write_ex         <= 1'b0;
            mem_read_ex          <= 1'b0;
            reg_mux_ex           <= 2'b00;
            branch_ex            <= 1'b0;
            jump_ex              <= 1'b0;
            op1_src_ex           <= 1'b0;
            jalr_ex              <= 1'b0;
            is_ecall_ex          <= 1'b0;
            is_ebreak_ex         <= 1'b0;
            is_wfi_ex            <= 1'b0;
            csr_write_ex         <= 1'b0;
            csr_op_ex            <= 3'b0;
            csr_mret_ex          <= 1'b0;
            csr_access_ex        <= 1'b0;
            csr_addr_ex          <= 12'b0;
            decode_ilgl_instr_ex <= 1'b0;
            valid_ex             <= 1'b0;
        end else if (flush_id_ex) begin
            pc_ex                <= 32'b0;
            pc_plus_4_ex         <= 32'b0;
            rd1_data_ex          <= 32'b0;
            rd2_data_ex          <= 32'b0;
            imm_ext_ex           <= 32'b0;
            instr_ex             <= 32'h00000013;
            alu_ctrl_ex          <= 4'b0;
            reg_write_ex         <= 1'b0;
            alu_src_ex           <= 1'b0;
            mem_write_ex         <= 1'b0;
            mem_read_ex          <= 1'b0;
            reg_mux_ex           <= 2'b00;
            branch_ex            <= 1'b0;
            jump_ex              <= 1'b0;
            op1_src_ex           <= 1'b0;
            jalr_ex              <= 1'b0;
            is_ecall_ex          <= 1'b0;
            is_ebreak_ex         <= 1'b0;
            is_wfi_ex            <= 1'b0;
            csr_write_ex         <= 1'b0;
            csr_op_ex            <= 3'b0;
            csr_mret_ex          <= 1'b0;
            csr_access_ex        <= 1'b0;
            csr_addr_ex          <= 12'b0;
            decode_ilgl_instr_ex <= 1'b0;
            valid_ex             <= 1'b0;
        end else begin
            pc_ex                <= pc_id;
            pc_plus_4_ex         <= pc_plus_4_id;
            rd1_data_ex          <= rd1_data;
            rd2_data_ex          <= rd2_data;
            imm_ext_ex           <= imm_ext;
            instr_ex             <= instr_id;
            alu_ctrl_ex          <= alu_ctrl;
            reg_write_ex         <= reg_write && valid_id;
            alu_src_ex           <= alu_src;
            mem_write_ex         <= mem_write && valid_id;
            mem_read_ex          <= mem_read && valid_id;
            reg_mux_ex           <= reg_mux;
            branch_ex            <= branch && valid_id;
            jump_ex              <= jump && valid_id;
            op1_src_ex           <= op1_src;
            jalr_ex              <= jalr;
            is_ecall_ex          <= is_ecall && valid_id;
            is_ebreak_ex         <= is_ebreak && valid_id;
            is_wfi_ex            <= is_wfi && valid_id;
            csr_write_ex         <= csr_write && valid_id;
            csr_op_ex            <= csr_op;
            csr_mret_ex          <= csr_mret && valid_id;
            csr_access_ex        <= csr_access_id && valid_id;
            csr_addr_ex          <= csr_addr;
            decode_ilgl_instr_ex <= decode_ilgl_instr && valid_id;
            valid_ex             <= valid_id;

            // Branch predictor statistics
            if (branch_ex && valid_ex) begin
                total_branch_cnt <= total_branch_cnt + 1;
                if (predict_taken != take_branch_ex) begin
                    mispredict_cnt <= mispredict_cnt + 1;
                end
            end
        end
    end

    // EX/MEM Register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_mem                <= 32'b0;
            pc_plus_4_mem         <= 32'b0;
            alu_result_mem        <= 32'b0;
            store_data_mem        <= 32'b0;
            rd_mem                <= 5'b0;
            instr_mem             <= 32'h00000013;
            reg_write_mem         <= 1'b0;
            mem_write_mem         <= 1'b0;
            mem_read_mem          <= 1'b0;
            reg_mux_mem           <= 2'b00;
            is_ecall_mem          <= 1'b0;
            is_ebreak_mem         <= 1'b0;
            is_wfi_mem            <= 1'b0;
            csr_write_mem         <= 1'b0;
            csr_op_mem            <= 3'b0;
            csr_mret_mem          <= 1'b0;
            csr_access_mem        <= 1'b0;
            csr_addr_mem          <= 12'b0;
            rd1_data_mem          <= 32'b0;
            decode_ilgl_instr_mem <= 1'b0;
            valid_mem             <= 1'b0;
        end else if (flush_ex_mem) begin
            pc_mem                <= 32'b0;
            pc_plus_4_mem         <= 32'b0;
            alu_result_mem        <= 32'b0;
            store_data_mem        <= 32'b0;
            rd_mem                <= 5'b0;
            instr_mem             <= 32'h00000013;
            reg_write_mem         <= 1'b0;
            mem_write_mem         <= 1'b0;
            mem_read_mem          <= 1'b0;
            reg_mux_mem           <= 2'b00;
            is_ecall_mem          <= 1'b0;
            is_ebreak_mem         <= 1'b0;
            is_wfi_mem            <= 1'b0;
            csr_write_mem         <= 1'b0;
            csr_op_mem            <= 3'b0;
            csr_mret_mem          <= 1'b0;
            csr_access_mem        <= 1'b0;
            csr_addr_mem          <= 12'b0;
            rd1_data_mem          <= 32'b0;
            decode_ilgl_instr_mem <= 1'b0;
            valid_mem             <= 1'b0;
        end else begin
            pc_mem                <= pc_ex;
            pc_plus_4_mem         <= pc_plus_4_ex;
            alu_result_mem        <= alu_result;
            store_data_mem        <= operand_b_forwarded;
            rd_mem                <= instr_ex[11:7];
            instr_mem             <= instr_ex;
            reg_write_mem         <= reg_write_ex && valid_ex;
            mem_write_mem         <= mem_write_ex && valid_ex;
            mem_read_mem          <= mem_read_ex && valid_ex;
            reg_mux_mem           <= reg_mux_ex;
            is_ecall_mem          <= is_ecall_ex && valid_ex;
            is_ebreak_mem         <= is_ebreak_ex && valid_ex;
            is_wfi_mem            <= is_wfi_ex && valid_ex;
            csr_write_mem         <= csr_write_ex && valid_ex;
            csr_op_mem            <= csr_op_ex;
            csr_mret_mem          <= csr_mret_ex && valid_ex;
            csr_access_mem        <= csr_access_ex && valid_ex;
            csr_addr_mem          <= csr_addr_ex;
            rd1_data_mem          <= operand_a_forwarded;
            decode_ilgl_instr_mem <= decode_ilgl_instr_ex && valid_ex;
            valid_mem             <= valid_ex;
        end
    end

    // MEM/WB Register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_wb         <= 32'b0;
            alu_result_wb <= 32'b0;
            load_data_wb  <= 32'b0;
            pc_plus_4_wb  <= 32'b0;
            csr_rdata_wb  <= 32'b0;
            rd_wb         <= 5'b0;
            reg_write_wb  <= 1'b0;
            reg_mux_wb    <= 2'b00;
            valid_wb      <= 1'b0;
        end else if (trap_taken_mem || mret_taken_mem) begin
            pc_wb         <= 32'b0;
            alu_result_wb <= 32'b0;
            load_data_wb  <= 32'b0;
            pc_plus_4_wb  <= 32'b0;
            csr_rdata_wb  <= 32'b0;
            rd_wb         <= 5'b0;
            reg_write_wb  <= 1'b0;
            reg_mux_wb    <= 2'b00;
            valid_wb      <= 1'b0;
        end else begin
            pc_wb         <= pc_mem;
            alu_result_wb <= alu_result_mem;
            load_data_wb  <= load_data_internal;
            pc_plus_4_wb  <= pc_plus_4_mem;
            csr_rdata_wb  <= csr_rdata;
            rd_wb         <= rd_mem;
            reg_write_wb  <= reg_write_mem && valid_mem;
            reg_mux_wb    <= reg_mux_mem;
            valid_wb      <= valid_mem;
        end
    end

    // ========================================================================
    // Fetch Stage (IF)
    // ========================================================================

    pc pc_unit (
        .clk(clk),
        .rst(rst_n),
        .sleeping(sleeping),
        .stall(stall_pc),
        .pc_next(pc_next),
        .pc(pc_current)
    );

    assign pc_plus_4 = pc_current + 4;
    assign pc_out    = pc_current;

    // ========================================================================
    // Decode Stage (ID)
    // ========================================================================

    main_decode control (
        .opcode     (instr_id[6:0]),
        .funct3     (instr_id[14:12]),
        .funct12    (instr_id[31:20]),
        .reg_write  (reg_write),
        .alu_src    (alu_src),
        .mem_write  (mem_write),
        .mem_read   (mem_read),
        .reg_mux    (reg_mux),
        .alu_op     (alu_op),
        .branch     (branch),
        .jump       (jump),
        .op1_src    (op1_src),
        .is_ecall   (is_ecall),
        .is_ebreak  (is_ebreak),
        .is_wfi     (is_wfi),
        .csr_write  (csr_write),
        .jalr       (jalr),
        .csr_op     (csr_op),
        .csr_mret   (csr_mret),
        .decode_ilgl_instr(decode_ilgl_instr),
        .csr_src    (instr_id[19:15])
    );

    alu_decode control_alu(
        .alu_op(alu_op),
        .funct3(instr_id[14:12]),
        .funct7_b5(instr_id[30]),
        .alu_ctrl(alu_ctrl)
    );

    // Register File
    regfile rf (
        .clk        (clk),
        .reset      (rst_n),
        .we         (reg_write_wb),
        .rs1_addr   (instr_id[19:15]),
        .rs2_addr   (instr_id[24:20]),
        .rd_addr    (rd_wb),
        .w_data     (write_data_wb),
        .rs1_data   (rd1_data),
        .rs2_data   (rd2_data)
    );

    // Immediate Generator
    imm_gen ig (
        .instr      (instr_id),
        .imm        (imm_ext)
    );

    assign csr_access_id = (instr_id[6:2] == 5'b11100) && (instr_id[14:12] != 3'b000);
    assign csr_addr = instr_id[31:20];

    // ========================================================================
    // Execute Stage (EX)
    // ========================================================================

    // Forwarding Muxes
    always @(*) begin
        case (forward_a)
            2'b10:   operand_a_forwarded = write_data_mem;
            2'b01:   operand_a_forwarded = write_data_wb;
            default: operand_a_forwarded = rd1_data_ex;
        endcase
    end

    always @(*) begin
        case (forward_b)
            2'b10:   operand_b_forwarded = write_data_mem;
            2'b01:   operand_b_forwarded = write_data_wb;
            default: operand_b_forwarded = rd2_data_ex;
        endcase
    end

    // ALU Input Muxes
    assign operand_a = (op1_src_ex) ? pc_ex : operand_a_forwarded;
    assign operand_b = (alu_src_ex) ? imm_ext_ex : operand_b_forwarded;

    // ALU
    alu main_alu (
        .a          (operand_a),
        .b          (operand_b),
        .alu_ctrl   (alu_ctrl_ex),
        .op         (alu_result),
        .zero       (alu_zero)
    );

    // Branch condition evaluator in EX
    always @(*) begin
        case (instr_ex[14:12])
            3'b000:  take_branch_ex = alu_zero;          // BEQ
            3'b001:  take_branch_ex = !alu_zero;         // BNE
            3'b100:  take_branch_ex = alu_result[0];     // BLT
            3'b101:  take_branch_ex = !alu_result[0];    // BGE
            3'b110:  take_branch_ex = alu_result[0];     // BLTU
            3'b111:  take_branch_ex = !alu_result[0];    // BGEU
            default: take_branch_ex = 1'b0;
        endcase
    end

    // PC multiplexer logic
    reg [31:0] branch_jump_target_ex;
    always @(*) begin
        if (jalr_ex)
            branch_jump_target_ex = (operand_a_forwarded + imm_ext_ex) & ~32'b1;
        else
            branch_jump_target_ex = pc_ex + imm_ext_ex;
    end
    // Instantiate predictor wrapper
    predictor_wrapper u_predictor (
        .clk(clk),
        .reset(!rst_n),
        .pc(pc_current),
        .resolve_taken(take_branch_ex),
        .resolve_valid(branch_ex && valid_ex),
        .predict_taken(predict_taken)
    );

    // Predict next PC using predictor (speculative, but functional flow remains unchanged)
    wire [31:0] pc_predicted = predict_taken ? branch_jump_target_ex : pc_plus_4;
    assign pc_next = (trap_taken_mem || mret_taken_mem) ? trap_target_pc :
                     (branch_jump_taken_ex)             ? branch_jump_target_ex :
                                                           pc_predicted;

    // ========================================================================
    // Memory Stage (MEM)
    // ========================================================================

    // Forwarding logic value helper in MEM stage
    always @(*) begin
        case (reg_mux_mem)
            2'b00:   write_data_mem = alu_result_mem;
            2'b10:   write_data_mem = pc_plus_4_mem;
            2'b11:   write_data_mem = csr_rdata;
            default: write_data_mem = alu_result_mem; // Load data can't be forwarded in MEM
        endcase
    end

    wire [3:0] lsu_data_be;

    // Load/Store Unit
    load_store_unit lsu (
        .clk            (clk),
        .addr           (alu_result_mem),
        .store_data     (store_data_mem),
        .funct3         (instr_mem[14:12]),
        .mem_read       (mem_read_mem && valid_mem),
        .mem_write      (mem_write_mem && valid_mem),
        .mem_rdata      (data_rdata),
        .data_addr      (data_addr),
        .data_wdata     (data_wdata),
        .data_be        (lsu_data_be),
        .load_data      (load_data_internal),
        .misaligned_exc (misaligned_exc)
    );

    assign data_be = lsu_data_be & {4{!trap_taken_mem}};
    assign data_re = mem_read_mem && valid_mem && !trap_taken_mem;

    // CSR write data calculation in MEM stage
    reg [31:0] csr_wdata_int;
    assign csr_wdata = csr_wdata_int;

    always @(*) begin
        case (csr_op_mem)
            3'b001:  csr_wdata_int = rd1_data_mem;                              // CSRRW
            3'b010:  csr_wdata_int = csr_rdata | rd1_data_mem;                  // CSRRS
            3'b011:  csr_wdata_int = csr_rdata & ~rd1_data_mem;                 // CSRRC
            3'b101:  csr_wdata_int = {27'b0, instr_mem[19:15]};                 // CSRRWI
            3'b110:  csr_wdata_int = csr_rdata | {27'b0, instr_mem[19:15]};     // CSRRSI
            3'b111:  csr_wdata_int = csr_rdata & ~{27'b0, instr_mem[19:15]};    // CSRRCI
            default: csr_wdata_int = 32'b0;
        endcase
    end

    // CSR Regfile
    csr_regfile csr_reg (
        .clk            (clk),
        .rst_n          (rst_n),
        .instr_retired  (instr_retired),
        .ext_irq        (ext_irq),
        .csr_access     (csr_access_mem && valid_mem),
        .csr_ilgl_instr (csr_ilgl_instr),
        .csr_we         (csr_write_mem && valid_mem),
        .csr_waddr      (csr_addr_mem),
        .csr_raddr      (csr_addr_mem),
        .csr_wdata      (csr_wdata),
        .csr_rdata      (csr_rdata),
        .csr_mstatus    (csr_mstatus),
        .csr_mepc       (csr_mepc),
        .csr_mtvec      (csr_mtvec),
        .csr_mtval      (csr_mtval),
        .csr_mcause     (csr_mcause),
        .csr_misa       (csr_misa),
        .csr_mscratch   (csr_mscratch),
        .csr_mcycle     (csr_mcycle),
        .csr_minstret   (csr_minstret),
        .csr_mie        (csr_mie),
        .csr_mip        (csr_mip),
        .trap_we        (csr_trap_we),
        .trap_mepc      (trap_mepc),
        .trap_mstatus   (trap_mstatus),
        .trap_mtval     (trap_mtval),
        .trap_mcause    (trap_mcause)
    );

    // Exception tracking
    assign load_misalign  = misaligned_exc && mem_read_mem && valid_mem;
    assign store_misalign = misaligned_exc && mem_write_mem && valid_mem;
    assign instr_retired  = valid_mem && !trap_taken_mem && rst_n && !sleeping;

    // Trap Controller
    trap_ctrl trap_control (
        .pc             (pc_mem),
        .fault_instr    (instr_mem),
        .fault_addr     (alu_result_mem),
        .illegal_instr  ((decode_ilgl_instr_mem || csr_ilgl_instr) && valid_mem),
        .ecall          (is_ecall_mem && valid_mem),
        .ebreak         (is_ebreak_mem && valid_mem),
        .instr_misalign (1'b0),
        .load_misalign  (load_misalign),
        .store_misalign (store_misalign),
        .ext_irq        (ext_irq),
        .csr_mstatus    (csr_mstatus),
        .csr_mepc       (csr_mepc),
        .csr_mtvec      (csr_mtvec),
        .csr_mtval      (csr_mtval),
        .csr_mcause     (csr_mcause),
        .csr_mie        (csr_mie),
        .csr_mip        (csr_mip),
        .csr_mret       (csr_mret_mem && valid_mem),
        .trap_taken     (trap_taken_mem),
        .mret_taken     (mret_taken_mem),
        .interrupt_pending (interrupt_pending),
        .trap_target_pc (trap_target_pc),
        .csr_trap_we    (csr_trap_we),
        .trap_mepc      (trap_mepc),
        .trap_mcause    (trap_mcause),
        .trap_mtval     (trap_mtval),
        .trap_mstatus   (trap_mstatus)
    );

    // Sleeping status handling (WFI)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sleeping <= 1'b0;
        else if (interrupt_pending)
            sleeping <= 1'b0;
        else if (is_wfi_mem && valid_mem && !trap_taken_mem)
            sleeping <= 1'b1;
    end

    // ========================================================================
    // Writeback Stage (WB)
    // ========================================================================

    always @(*) begin
        case (reg_mux_wb)
            2'b00:   write_data_wb = alu_result_wb;
            2'b01:   write_data_wb = load_data_wb;
            2'b10:   write_data_wb = pc_plus_4_wb;
            2'b11:   write_data_wb = csr_rdata_wb;
            default: write_data_wb = 32'b0;
        endcase
    end

    // ========================================================================
    // Hazard & Forwarding Unit
    // ========================================================================

    hazard_unit hazard_ctrl (
        .rs1_ex          (instr_ex[19:15]),
        .rs2_ex          (instr_ex[24:20]),
        .rd_mem          (rd_mem),
        .rd_wb           (rd_wb),
        .reg_write_mem   (reg_write_mem && valid_mem),
        .reg_write_wb    (reg_write_wb && valid_wb),
        .rs1_id          (instr_id[19:15]),
        .rs2_id          (instr_id[24:20]),
        .rd_ex           (instr_ex[11:7]),
        .mem_read_ex     (mem_read_ex && valid_ex),
        .csr_access_id   (csr_access_id && valid_id),
        .is_ecall_id     (is_ecall && valid_id),
        .is_ebreak_id    (is_ebreak && valid_id),
        .csr_mret_id     (csr_mret && valid_id),
        .is_wfi_id       (is_wfi && valid_id),
        .valid_ex        (valid_ex),
        .valid_mem       (valid_mem),
        .valid_wb        (valid_wb),
        .forward_a       (forward_a),
        .forward_b       (forward_b),
        .stall_pc        (stall_pc),
        .stall_if_id     (stall_if_id),
        .bubble_id_ex    (bubble_id_ex)
    );

endmodule
