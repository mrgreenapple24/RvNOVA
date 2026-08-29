module hazard_unit (
    // Forwarding inputs
    input  wire [4:0]  rs1_ex,
    input  wire [4:0]  rs2_ex,
    input  wire [4:0]  rd_mem,
    input  wire [4:0]  rd_wb,
    input  wire        reg_write_mem,
    input  wire        reg_write_wb,

    // Stalling inputs (Load-Use)
    input  wire [4:0]  rs1_id,
    input  wire [4:0]  rs2_id,
    input  wire [4:0]  rd_ex,
    input  wire        mem_read_ex,

    // Pipeline barrier inputs (CSR/System)
    input  wire        csr_access_id,
    input  wire        is_ecall_id,
    input  wire        is_ebreak_id,
    input  wire        csr_mret_id,
    input  wire        is_wfi_id,
    input  wire        valid_ex,
    input  wire        valid_mem,
    input  wire        valid_wb,

    // Forwarding outputs
    output reg  [1:0]  forward_a,
    output reg  [1:0]  forward_b,

    // Stalling outputs
    output wire        stall_pc,
    output wire        stall_if_id,
    output wire        bubble_id_ex
);

    // ========================================================================
    // Forwarding Unit
    // ========================================================================
    // forward_a / forward_b selects:
    // 2'b00: use operand from ID/EX register (no forwarding)
    // 2'b10: forward from MEM stage (alu_result_mem or similar)
    // 2'b01: forward from WB stage (write_data_wb)

    always @(*) begin
        if (reg_write_mem && (rd_mem != 5'b0) && (rd_mem == rs1_ex)) begin
            forward_a = 2'b10;
        end else if (reg_write_wb && (rd_wb != 5'b0) && (rd_wb == rs1_ex)) begin
            forward_a = 2'b01;
        end else begin
            forward_a = 2'b00;
        end
    end

    always @(*) begin
        if (reg_write_mem && (rd_mem != 5'b0) && (rd_mem == rs2_ex)) begin
            forward_b = 2'b10;
        end else if (reg_write_wb && (rd_wb != 5'b0) && (rd_wb == rs2_ex)) begin
            forward_b = 2'b01;
        end else begin
            forward_b = 2'b00;
        end
    end

    // ========================================================================
    // Hazard Detection / Stalling Unit
    // ========================================================================
    reg stall_load_use;
    reg stall_csr_barrier;

    always @(*) begin
        // Load-use stall: instruction in EX is a load and writes to a source register of ID stage
        if (mem_read_ex && (rd_ex != 5'b0) && ((rd_ex == rs1_id) || (rd_ex == rs2_id))) begin
            stall_load_use = 1'b1;
        end else begin
            stall_load_use = 1'b0;
        end
    end

    always @(*) begin
        // CSR / system instruction pipeline barrier:
        // System instructions (CSR, ECALL, EBREAK, MRET, WFI) need to run in a drained pipeline.
        if ((csr_access_id || is_ecall_id || is_ebreak_id || csr_mret_id || is_wfi_id) &&
            (valid_ex || valid_mem || valid_wb)) begin
            stall_csr_barrier = 1'b1;
        end else begin
            stall_csr_barrier = 1'b0;
        end
    end

    assign stall_pc     = stall_load_use || stall_csr_barrier;
    assign stall_if_id  = stall_load_use || stall_csr_barrier;
    assign bubble_id_ex = stall_load_use || stall_csr_barrier;

endmodule
