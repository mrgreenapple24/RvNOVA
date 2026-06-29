module instr_mem (
    input  [31:0] addr,
    output [31:0] instr
);

    reg [31:0] mem [0:16383];

    initial begin

        $display("Loading firmware...");
        $readmemh("build/firmware.hex", mem);

        $display("mem[0] = %h", mem[0]);
        $display("mem[1] = %h", mem[1]);
        $display("mem[2] = %h", mem[2]);
        $display("mem[3] = %h", mem[3]);
        
    end

    assign instr = mem[addr[15:2]];

endmodule
