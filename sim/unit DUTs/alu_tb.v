`timescale 1ns/1ps

module alu_tb;

	reg[31:0] a;
	reg[31:0] b;
	reg[3:0] alu_ctrl;

	wire[31:0] op;
	wire zero;

	alu dut (
		.a(a),
		.b(b),
		.alu_ctrl(alu_ctrl),
		.op(op),
		.zero(zero)
	);

	wire [3:0] ALU_ADD  = 4'b0000;
    wire [3:0] ALU_SUB  = 4'b0001;
    wire [3:0] ALU_SLL  = 4'b0010;
    wire [3:0] ALU_SLT  = 4'b0011;
    wire [3:0] ALU_SLTU = 4'b0100;
    wire [3:0] ALU_XOR  = 4'b0101;
    wire [3:0] ALU_SRL  = 4'b0110;
    wire [3:0] ALU_SRA  = 4'b0111;
    wire [3:0] ALU_OR   = 4'b1000;
    wire [3:0] ALU_AND  = 4'b1001;

	initial begin
		$monitor("Time = %0t | alu_ctrl = %b | a = %b | b = %b | op = %b | zero = %b",
			  $time, alu_ctrl, a, b , op, zero);

		a = 10; b = 20; alu_ctrl = ALU_ADD;
		#10
		a = 20; b = 20; alu_ctrl = ALU_SUB;
		#10
		a = 32'h00000001; b = 2; alu_ctrl = ALU_SLL;
		#10
		a = -10; b = 2; alu_ctrl = ALU_SLT;
		#10
		a = 32'hFFFFFFF0; b = 32'h00000001; alu_ctrl = ALU_SLTU;
		#10
		a = 32'hAAAA5555; b = 32'h5555AAAA; alu_ctrl = ALU_XOR;
		#10
		a = 32'h80000000; b = 2; alu_ctrl = ALU_SRL;
		#10
		a = 32'h80000000; b = 2; alu_ctrl = ALU_SRA;
		#10
		a = 32'h0F0F0F0F; b = 32'hF0000000; alu_ctrl = ALU_OR;
		#10
		a = 32'hFF0000FF; b = 32'h0F0000F0; alu_ctrl = ALU_AND;
		#10
		a = 10; b = 20;	 alu_ctrl = 4'b1111;

		$display("testbench successful");
		$finish;

	end

endmodule
