`timescale 1ns / 1ps

module tb_regfile;

    reg clk;
    reg reset;
    reg we;
    reg [4:0]rs1_addr;
    reg [4:0]rs2_addr;
    reg [4:0]rd_addr;
    reg [31:0] w_data;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    regfile uut (
        .clk(clk),
        op1_src = 1;
        mem_to_reg = 2'b10;
        alu_op = 3'b000;
    end
    5'b11001: begin // JALR
        jump = 1;
        alu_src = 1;
        mem_to_reg = 2'b10;
        reg_write = 1;
        alu_op = 3'b000;
    end
        .reset(reset),
        .we(we),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .w_data(w_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("regfile.vcd");
        $dumpvars(0, tb_regfile);

        clk = 0;
        reset = 0;
        we = 0;
        rs1_addr = 0;
        rs2_addr = 0;
        rd_addr = 0;
        w_data = 0;

        #10 reset = 1;
        
        $display("Test 1: Write 0xDEADBEEF to x1");
        rd_addr = 5'd1;
        w_data = 32'hDEADBEEF;
        we = 1;
        #10;
        we = 0;
        
        rs1_addr = 5'd1;
        #1;
        if (rs1_data == 32'hDEADBEEF) $display("PASS: x1 holds DEADBEEF");
        else $display("FAIL: x1 = %h", rs1_data);

        $display("Test 3: Attempt to write 0xFFFFFFFF to x0");
        rd_addr = 5'd0;
        w_data = 32'hFFFFFFFF;
        we = 1;
        #10;
        we = 0;

        rs1_addr = 5'd0;
        #1;
        if (rs1_data == 32'h0) $display("PASS: x0 is still 0");
        else $display("FAIL: x0 = %h", rs1_data);

        $finish;
    end

endmodule