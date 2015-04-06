`define WIDTH 8

`timescale 1ns/1ps

module top;

reg clk;
wire reset_n,opcode_valid,opcode,done,overflow;
wire [`WIDTH-1:0] result,data;

parameter TRUE=1'b1;
parameter FALSE = 1'b0;
parameter CLOCK_WIDTH=10;

initial
begin

clk=FALSE;
end

always #CLOCK_WIDTH clk=~clk;

alu_test   i1(.clk(clk),.reset_n(reset_n),.opcode_valid(opcode_valid),.opcode(opcode),.data(data),.done(done),.overflow(overflow),.result(result));
simple_alu i2(.clk(clk),.reset_n(reset_n),.opcode_valid(opcode_valid),.opcode(opcode),.data(data),.done(done),.overflow(overflow),.result(result));

endmodule
