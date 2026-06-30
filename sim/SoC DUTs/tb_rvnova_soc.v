`timescale 1ns/1ps

module tb_rvnova_soc;

    reg clk;
    reg rst_n;

    rvnova_soc dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;

        #20;
        rst_n = 1;

        #200;

        $display("x1 = %0d", dut.cpu.rf.reg_array[1]);
        $display("x2 = %0d", dut.cpu.rf.reg_array[2]);
        $display("x3 = %0d", dut.cpu.rf.reg_array[3]);

        $finish;
    end

endmodule
