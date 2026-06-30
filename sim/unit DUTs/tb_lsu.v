`timescale 1ns/1ps

module tb_lsu;

    reg         clk;
    reg  [31:0] addr;
    reg  [31:0] store_data;
    reg  [2:0]  funct3;
    reg         mem_read;
    reg         mem_write;
    reg  [31:0] mem_rdata;

    wire [31:0] data_addr;
    wire [31:0] data_wdata;
    wire [3:0]  data_be;
    wire [31:0] load_data;
    wire        misaligned_exc;

    load_store_unit dut (
        .clk(clk),
        .addr(addr),
        .store_data(store_data),
        .funct3(funct3),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_rdata(mem_rdata),
        .data_addr(data_addr),
        .data_wdata(data_wdata),
        .data_be(data_be),
        .load_data(load_data),
        .misaligned_exc(misaligned_exc)
    );

    always #5 clk = ~clk;

    initial begin

    // ========================================================================
    // initialize values
    // ========================================================================

    clk = 0;
    addr = 32'h0;
    store_data = 32'hFFFFFFFF;
    funct3 = 3'b0;
    mem_read = 0;
    mem_write = 0;
    mem_rdata = 32'hEEEEEEEE;

    #20;

    // ========================================================================
    // check addr
    // ========================================================================

    $display("data addr is = %h", data_addr);

    if (data_addr != addr)
        $fatal(1, "addr assignment not working");

    #20;

    // ========================================================================
    // byte generation + store + load
    // ========================================================================

    mem_write = 1;
    funct3 = 3'b000;
    addr = 32'h0;

    #10;

    if (misaligned_exc)
        $fatal(1, "misaligned even tho shouldnt be");

    $display("data byte enable is = %h", data_be);

    if (data_be != 4'b0001)
        $fatal(1, "SB.1 did not work");

    mem_write = 0;

    #20;
    
    $display("data_wdata os = %h", data_wdata);

    if (data_wdata != {24'b0, store_data[7:0]})
        $fatal(1, "SB.1 did not work");

    mem_read = 1;

    #20;
    
    $display("load dta us = %h", load_data);

    if (load_data != {{24{mem_rdata[7]}}, mem_rdata[7:0]})
        $fatal(1, "LB.1 did not work");

    #20;

    mem_read = 0;
    mem_write = 1;
    funct3 = 3'b000;
    addr = 32'h1;

    #10;

    $display("data byte enable is = %h", data_be);

    if (data_be != 4'b0010)
        $fatal(1, "SB.2 did not work");

    $display("data_wdata os = %h", data_wdata);

    if (data_wdata != {16'b0, store_data[7:0], 8'b0})
        $fatal(1, "SB.2 did not work");

    mem_write = 0;
    mem_read = 1;

    #20;

    $display("load dta us = %h", load_data);

    if (load_data != {{24{mem_rdata[15]}}, mem_rdata[15:8]})
        $fatal(1, "LB.2 did not work");

    #20;

    mem_read = 0;
    mem_write = 1;
    funct3 = 3'b000;
    addr = 32'h2;

    #10;

    $display("data byte enable is = %h", data_be);

    if (data_be != 4'b0100)
        $fatal(1, "SB.3 did not work");

    $display("data_wdata os = %h", data_wdata);

    if (data_wdata != {8'b0, store_data[7:0], 16'b0})
        $fatal(1, "SB.3 did not work");

    mem_write = 0;
    mem_read = 1;

    #20;

    $display("load dta us = %h", load_data);

    if (load_data != {{24{mem_rdata[23]}}, mem_rdata[23:16]})
        $fatal(1, "LB.3 did not work");

    #20;
    
    mem_read = 0;
    mem_write = 1;
    funct3 = 3'b000;
    addr = 32'h3;

    #10;

    $display("data byte enable is = %h", data_be);

    if (data_be != 4'b1000)
        $fatal(1, "SB.4 did not work");

    $display("data_wdata os = %h", data_wdata);

    if (data_wdata != {store_data[7:0], 24'b0})
        $fatal(1, "SB.4 did not work");

    mem_write = 0;
    mem_read = 1;
    
    #20;

    $display("load dta us = %h", load_data);

    if (load_data != {{24{mem_rdata[31]}}, mem_rdata[31:24]})
        $fatal(1, "LB.4 did not work");

    #20;

    mem_read = 0;
    mem_write = 1;
    funct3 = 3'b001;
    addr = 32'h0;

    #10;

    if (misaligned_exc)
        $fatal(1, "misaligned even tho shouldnt be");

    $display("data byte enable is = %h", data_be);

    if (data_be != 4'b0011)
        $fatal(1, "SH.1 did not work");

    mem_write = 0;

    $display("data_wdata os = %h", data_wdata);

    if (data_wdata != {16'b0, store_data[15:0]})
        $fatal(1, "SH.1 did not work");

    mem_write = 0;
    mem_read = 1;

    #20;

    $display("load dta us = %h", load_data);

    if (load_data != {{16{mem_rdata[15]}}, mem_rdata[15:0]})
        $fatal(1, "LH.1 did not work");

    #20;

    mem_read = 0;
    mem_write = 1;
    funct3 = 3'b001;
    addr = 32'h2;

    #10;

    $display("data byte enable is = %h", data_be);

    if (data_be != 4'b1100)
        $fatal(1, "SH.2 did not work");

    $display("data_wdata os = %h", data_wdata);

    if (data_wdata != {store_data[15:0], 16'b0})
        $fatal(1, "SH.2 did not work");

    mem_write = 0;
    mem_read = 1;

    #20;

    $display("load dta us = %h", load_data);

    if (load_data != {{16{mem_rdata[31]}}, mem_rdata[31:16]})
        $fatal(1, "LH.2 did not work");

    #20;

    mem_read = 0;
    mem_write = 1;
    funct3 = 3'b010;
    addr = 32'h0;

    #10;

    if (misaligned_exc)
        $fatal(1, "misaligned even tho shouldnt be");

    $display("data byte enable is = %h", data_be);

    if (data_be != 4'b1111)
        $fatal(1, "SW did not work");
    
    $display("data_wdata os = %h", data_wdata);

    if (data_wdata != store_data)
        $fatal(1, "SW did not work");

    mem_write = 0;
    mem_read = 1;

    #20;

    $display("load dta us = %h", load_data);

    if (load_data != mem_rdata)
        $fatal(1, "LW did not work");

    #20;

    funct3 = 3'b100;
    addr = 32'h0;

    #10;

    $display("load dta us = %h", load_data);

    if (load_data != {24'b0, mem_rdata[7:0]})
        $fatal(1, "LBU.1 did not work");

    #20;

    addr = 32'h1;

    #10;

    $display("load dta us = %h", load_data);

    if (load_data != {24'b0, mem_rdata[15:8]})
        $fatal(1, "LBU.2 did not work");

    #20;

    addr = 32'h2;

    #10;

    $display("load dta us = %h", load_data);

    if (load_data != {24'b0, mem_rdata[23:16]})
        $fatal(1, "LBU.3 did not work");

    #20;

    addr = 32'h3;

    #10;

    $display("load dta us = %h", load_data);

    if (load_data != {24'b0, mem_rdata[31:24]})
        $fatal(1, "LBU.4 did not work");

    #20;

    funct3 = 3'b101;

    addr = 32'h0;

    #10;

    $display("load dta us = %h", load_data);

    if (load_data != {16'b0, mem_rdata[15:0]})
        $fatal(1, "LHU.1 did not work");

    #20;

    addr = 32'h2;

    #10;

    $display("load dta us = %h", load_data);

    if (load_data != {16'b0, mem_rdata[31:16]})
        $fatal(1, "LHU.2 did not work");

    #20;

    funct3 = 3'b11;

    #10;

    if (data_be != 4'b0)
        $fatal(1, "byte enable should NOT have value");

    #20;

    funct3 = 3'b0;
    addr = 32'h0;
    mem_write = 0;

    #20;

    if (data_be != 4'b0)
        $fatal(1, "byte enable should NOT have value");

    // ========================================================================
    // misaligned
    // ========================================================================

    mem_read = 1;
    funct3 = 3'b001;
    addr = 32'h1;

    #10;

    if(!misaligned_exc)
        $fatal(1,"Halfword misalignment not detected");

    #20;

    addr = 32'h3;

    #10;

    if(!misaligned_exc)
        $fatal(1,"Halfword.2 misalignment not detected");

    #20;

    funct3 = 3'b010;
    addr = 1;

    #10;

    if(!misaligned_exc)
        $fatal(1, "sw.1 not work");

    #20;

    addr = 2;

    #10;

    if(!misaligned_exc)
        $fatal(1, "sw.2 not work");

    #20;

    addr = 3;

    #10;

    if(!misaligned_exc)
        $fatal(1, "sw.3 not work");

    #20;

    $display("");
    $display("==================================");
    $display("     ALL LSU TESTS PASSED");
    $display("==================================");
    $display("");

    $finish;

    end

endmodule
