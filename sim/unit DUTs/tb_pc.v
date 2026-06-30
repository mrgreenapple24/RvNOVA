`timescale 1ns/1ps

module tb_pc;

    reg  [31:0] pc;
    reg  [31:0] imm;
    reg  [31:0] rs1_data;

    reg  [2:0]  funct3;
    reg  [31:0] alu_result;
    reg         alu_zero;
    reg         trap_taken;
    reg         mret_taken;
    reg         branch;
    reg         jump;
    reg         jalr;

    reg  [31:0] trap_target_pc;

    wire [31:0] pc_next;

    pc_mux dut (
        .pc(pc),
        .imm(imm),
        .rs1_data(rs1_data),
        .funct3(funct3),
        .alu_result(alu_result),
        .alu_zero(alu_zero),
        .trap_taken(trap_taken),
        .mret_taken(mret_taken),
        .branch(branch),
        .jump(jump),
        .jalr(jalr),
        .trap_target_pc(trap_target_pc),
        .pc_next(pc_next)
    );

    initial begin

    // ========================================================================
    // initialize values
    // ========================================================================

    pc = 32'h0;
    imm = 32'h22222222;
    rs1_data = 32'hFFFFFFFF;
    funct3 = 3'b010;
    alu_result = 32'b0;
    alu_zero = 0;
    trap_taken = 0;
    mret_taken = 0;
    branch = 0;
    jump = 0;
    jalr = 0;
    trap_target_pc = 32'h0F0F0F0F;

    #20;

    // ========================================================================
    // trap/mret
    // ========================================================================
    
    trap_taken = 1;
    mret_taken = 0;

    #10;

    $display("pc next = %h", pc_next);

    #20;

    if (pc_next != 32'h0F0F0F0F)
        $fatal(1, "TRAP FAILED");

    #20;

    // ========================================================================
    // jump
    // ========================================================================
        

    trap_taken = 0;
    mret_taken = 0;

    jump = 1;
    pc = 32'h11111111;

    $display("pc next = %h", pc_next);

    #20;

    if (pc_next != 32'h33333333)
        $fatal(1, "jump FAILED");

    #20;

    jalr = 1;

    #20;

    $display("pc next = %h", pc_next);

    #20;

    if (pc_next != 32'h22222220)
        $fatal(1, "jalr FAILED");

    #20;

    // ========================================================================
    // beq
    // ========================================================================
        
    jump = 0;

    branch = 1;
    funct3 = 3'b0;
    pc = 32'h22222222;

    #20;

    $display("pc next = %h", pc_next);

    #20;

    if (pc_next == 32'h44444444)
        $fatal(1, "beq passed even tho shoulda failed");

    #20;

    alu_zero = 1;

    $display("pc next = %h", pc_next);

    #20;

    if (pc_next != 32'h44444444)
        $fatal(1, "beq FAILED");

    #20;

    // ========================================================================
    // bne
    // ========================================================================

    funct3 = 3'b001;
    pc = 32'h11111111;

    #20;

    $display("pc next = %h", pc_next);

    #20;

    if (pc_next == 32'h33333333)
        $fatal(1, "bne passed even tho shoulda failed");

    #20;

    alu_zero = 0;

    $display("pc next = %h", pc_next);

    #20;

    if (pc_next != 32'h33333333)
        $fatal(1, "bne FAILED");

    #20;

    // ========================================================================
    // blt
    // ========================================================================

    funct3 = 3'b100;
    pc = 32'h22222222;

    #20;

    $display("pc next = %h", pc_next);

    #20;

    if (pc_next == 32'h44444444)
        $fatal(1, "blt passed even tho shoulda failed");

    #20;

    alu_result = 32'b1;

    $display("pc next = %h", pc_next);

    #20;

    if (pc_next != 32'h44444444)
        $fatal(1, "blt FAILED");

    #20;

    // ========================================================================
    // bltu
    // ========================================================================

    funct3 = 3'b110;
    pc = 32'h11111111;
    alu_result = 32'b0;

    #20;

    $display("pc next = %h", pc_next);

    #20;

    if (pc_next == 32'h33333333)
        $fatal(1, "bltu passed even tho shoulda failed");

    #20;

    alu_result = 32'b1;

    $display("pc next = %h", pc_next);

    #20;

    if (pc_next != 32'h33333333)
        $fatal(1, "bltu FAILED");

    #20;

    // ========================================================================
    // bge
    // ========================================================================

    funct3 = 3'b101;
    pc = 32'h22222222;
    alu_result = 32'b1;

    #20;

    $display("pc next = %h", pc_next);

    #20;

    if (pc_next == 32'h44444444)
        $fatal(1, "bge passed even tho shoulda failed");

    #20;

    alu_result = 32'b0;

    $display("pc next = %h", pc_next);

    #20;

    if (pc_next != 32'h44444444)
        $fatal(1, "bge FAILED");

    #20;

    // ========================================================================
    // bgeu
    // ========================================================================

    funct3 = 3'b111;
    pc = 32'h11111111;
    alu_result = 32'b1;

    #20;

    $display("pc next = %h", pc_next);

    #20;

    if (pc_next == 32'h33333333)
        $fatal(1, "bgeu passed even tho shoulda failed");

    #20;

    alu_result = 32'b0;

    $display("pc next = %h", pc_next);

    #20;

    if (pc_next != 32'h33333333)
        $fatal(1, "bgeu FAILED");

    #20;

    // ========================================================================
    // normal
    // ========================================================================

    funct3 = 3'b010;
    pc = 32'h0;
    alu_result = 32'b1;

    #20;

    $display("pc next = %h", pc_next);

    #20;

    if (pc_next != 32'h4)
        $fatal(1, "normal pc failed");

    #20;

    $display("");
    $display("==================================");
    $display("     ALL PC TESTS PASSED");
    $display("==================================");
    $display("");

    $finish;

    end

endmodule