`timescale 1ns/1ps

module immgen_tb;

	reg  [31:0] instr;
	wire [31:0] imm;
	reg ok;

	imm_gen dut (
		.instr(instr),
		.imm(imm)
	);

	initial begin
		ok = 1;
	
		//I-type.
		//ADDI x1, x2, 10
		//imm = 10
		instr = 32'b000000001010_00010_000_00001_0010011;
		#10;
		$display("imm = %0d", imm);
		if (imm !== 10) begin
			$display("FAIL: imm = %0d (expected 10)", imm);
			ok = 0;
		end

		//S-type.
		//SW x1 8(x2)
		//imm = 8
		instr = 32'b0000000_00001_00010_010_01000_0100011;
		#10;
		$display("imm = %0d", imm);
		if (imm !== 8) begin
			$display("FAIL: imm = %0d (expected 8)", imm);
			ok = 0;
		end

		//B-type.
		//BEQ x1 x2 16
		//imm = 16
		instr = 32'b0000000_00010_00001_000_10000_1100011;
		#10;
		$display("imm = %0d", imm);
		if (imm !== 16) begin
			$display("FAIL: imm = %0d (expected 16)", imm);
			ok = 0;
		end

		//U-type.
		//LUI x1, 0xABCDE
		//imm = 0xABCDE000
		instr = 32'b10101011110011011110_00001_0110111;
		#10;
		$display("imm = 0x%h", imm);
		if (imm !== 32'hABCDE000) begin
			$display("FAIL: imm = 0x%h (expected 0xabcde000)", imm);
			ok = 0;
		end

		//J-type.
		//JAL x1, 16
		//16
		instr = 32'b0_0000001000_0_00000000_00001_1101111;
		#10;
		$display("imm = %0d", imm);
		if (imm !== 16) begin
			$display("FAIL: imm = %0d (expected 16)", imm);
			ok = 0;
		end

		if (ok) begin
			$display("IMM_GEN TEST PASSED");
		end else begin
			$display("IMM_GEN TEST FAILED");
		end
		$finish;

	end
	
endmodule