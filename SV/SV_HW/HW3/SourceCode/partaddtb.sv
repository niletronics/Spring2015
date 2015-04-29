// Nilesh Dattani
// Assumptions : ALU is not supposed to be implemented;
// Padding is and sum calculation are provided only for evaluation purpose and for expected result.
// Actual Application Sum should be calculated by ALU and "rawSum" variable can be used for assigning the same
// To display all define DEBUG
// Input Assumption in file with format like <opcode> <first data> <Second Data>
// 22-April-2015



`include "packagefile.sv"
`define INSTRUCTION_COUNT 4
`define EVAL
//`define DEBUG

import partaddtype_hw3::data;
import fileoperation::*;
data A,B,Sum;				// From partaddtype_hw3 package
bit pad,Cout,Cin;

module partaddtb();
parameter ALU_WIDTH = 64;

reg [ALU_WIDTH-1:0] rawA,rawB,rawSum;		// Decided my ALU Width

enum {quad_word, double_word, word, halfword} opcode;


initial begin
openfile;
readfile;
repeat(`INSTRUCTION_COUNT) begin 
	readoperands;
	`ifdef DEBUG
		display1;
	`endif
	
	`ifndef EVAL
		storeresults;
	`endif
	
	end
end

task display1;
begin
$display("A.byte1[1] = %h,\nA.byte1[2] = %h,\nA.byte1[3] = %h,\nA.byte1[4] = %h,\nA.byte1[5] = %h,\nA.byte1[6] = %h,\nA.byte1[7] = %h,\nA.byte1[0] = %h,\nB.byte1[1] = %h,\nB.byte1[2] = %h,\nB.byte1[3] = %h,\nB.byte1[4] = %h,\nB.byte1[5] = %h,\nB.byte1[6] = %h,\nB.byte1[7] = %h,\nB.byte1[0] = %h,\nSum.byte1[1] = %h,\nSum.byte1[2] = %h,\nSum.byte1[3] = %h,\nSum.byte1[4] = %h,\nSum.byte1[5] = %h,\nSum.byte1[6] = %h,\nSum.byte1[7] = %h,\nSum.byte1[0] = %h,\nA.W[1] = %h,\nA.W[2] = %h,\nA.W[3] = %h,\nA.W[0] = %h,\nB.W[1] = %h,\nB.W[2] = %h,\nB.W[3] = %h,\nB.W[0] = %h,\nSum.W[0] = %h,\nSum.W[1] = %h,\nSum.W[2] = %h,\nSum.W[3] = %h,\nA.DW[0] = %h,\nA.DW[1] = %h,\nB.DW[0] = %h,\nB.DW[1] = %h,\nSum.DW[0] = %h,\nSum.DW[1] = %h,\n",A.byte1[1],A.byte1[2],A.byte1[3],A.byte1[4],A.byte1[5],A.byte1[6],A.byte1[7],A.byte1[0],B.byte1[1],B.byte1[2],B.byte1[3],B.byte1[4],B.byte1[5],B.byte1[6],B.byte1[7],B.byte1[0],Sum.byte1[1],Sum.byte1[2],Sum.byte1[3],Sum.byte1[4],Sum.byte1[5],Sum.byte1[6],Sum.byte1[7],Sum.byte1[0],A.W[1],A.W[2],A.W[3],A.W[0],B.W[1],B.W[2],B.W[3],B.W[0],Sum.W[0],Sum.W[1],Sum.W[2],Sum.W[3],A.DW[0],A.DW[1],B.DW[0],B.DW[1],Sum.DW[0],Sum.DW[1]);
end
endtask

task readfile;
begin
	if(!$feof(file)) begin
		r = $fscanf(file,"%d %h %h",opcode,rawA,rawB);
	end
	
	else begin
		$display("Error Reading From File, please specify a valid file at valid location : %m");
	end
end
endtask

task readoperands;

case(opcode) 
	quad_word : begin
					A.QWORD = rawA[63:0];												// Quad Words Loading
					B.QWORD = rawB[63:0];
					`ifdef EVAL
					{Cout,Sum.QWORD} = A.QWORD + B.QWORD + Cin;
					$display("Expected Result : Opcode = %s \t \t: %d + %d = %d",opcode,A.QWORD,B.QWORD,{Cout,Sum.QWORD});
					`endif
					readfile;
				end
				
	double_word : begin
					for(int i=0;i<=1;i++) begin
						A.DW[i] = rawA[31:0];											// Double Words Loading	
						B.DW[i] = rawB[31:0];
						`ifdef EVAL
						{pad,Sum.DW[i]} = A.DW[i] + B.DW[i];
						$display("Expected Result : Opcode = %s \t: %d + %d = %d",opcode,A.DW[i],B.DW[i],{pad,Sum.DW[i]});
						`endif
						readfile;
					end
				end
	
	word		: begin
					for(int i=0;i<=3;i++) begin
						A.W[i] = rawA[15:0];											// Words Loading
						B.W[i] = rawB[15:0];
						`ifdef EVAL
						{pad,Sum.W[i]} = A.W[i] + B.W[i];
						$display("Expected Result : Opcode = %s \t \t: %d + %d = %d",opcode,A.W[i],B.W[i],{pad,Sum.W[i]});
						`endif
						readfile;
					end
				end
						
	halfword	: begin
					for(int i=0;i<=7;i++) begin
						A.byte1[i] = rawA[7:0];											// Bytes Loading
						B.byte1[i] = rawB[7:0];
						{pad,Sum.byte1[i]} = A.byte1[i] + A.byte1[i];
						$display("Expected Result : Opcode = %s \t\t: %d + %d = %d",opcode,A.byte1[i],B.byte1[i],{pad,Sum.byte1[i]});
						readfile;
					end
				end
	endcase
	
endtask

task storeresults;
case(opcode)
	quad_word : begin
					Sum.QWORD = rawSum[ALU_WIDTH-1:0];
				end
				
	double_word : begin	
					for(int i=0;i<=1;i++) begin
					Sum.DW[i] = rawSum[31:0];
					end
				end
	
	word		: begin
					for(int i=0;i<=3;i++) begin
						Sum.W[i] = rawSum[15:0];
					end
				end
						
	halfword	: begin
					for(int i=0;i<=7;i++) begin
						Sum.byte1[i] = rawSum[7:0];
					end
				end
	endcase
endtask



endmodule