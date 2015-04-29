`define WIDTH 8

`timescale 1ns/1ps

module tb_old;

wire  clk;
wire reset_n,opcode_valid,opcode,done,overflow;
wire [`WIDTH-1:0] result,data;


clkgen_driver clkgen(.clk(clk));
alu_test_old   i1(.clk(clk),.reset_n(reset_n),.opcode_valid(opcode_valid),.opcode(opcode),.data(data),.done(done),.overflow(overflow),.result(result), .simulation_end(simulation_end));
simple_alu i2(.clk(clk),.reset_n(reset_n),.opcode_valid(opcode_valid),.opcode(opcode),.data(data),.done(done),.overflow(overflow),.result(result));
alu_chkr chkr1(.clk(clk),.reset_n(reset_n),.opcode_valid(opcode_valid),.opcode(opcode),.data(data),.done(done),.overflow(overflow),.result(result), .simulation_end(simulation_end));

endmodule
