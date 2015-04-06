module simple_alu(clk,reset_n,opcode_valid,opcode,data, done, result, overflow);
parameter ALU_SIZE = 8;
input clk,reset_n,opcode_valid,opcode;
input [ALU_SIZE-1:0] data;
output [ALU_SIZE-1:0]result;
output done,overflow;
reg [ALU_SIZE-1:0]result;
reg done,overflow;

reg [ALU_SIZE-1:0] data_A,data_B;
wire [ALU_SIZE-1:0] result_add,result_comp,result_parity,result_sub;
//reg add_overflow, sub_overflow;
reg [3:0] state,nextstate;
reg [1:0] demux_opcode;


//State Encoding
parameter RESET 	= 4'd0,
		  IDLE		= 4'd1,
		  DATA_A 	= 4'd2,
		  DATA_B 	= 4'd3,
		  ADD		= 4'd4,
		  SUB 		= 4'd5,
		  PAR 		= 4'd6,
		  COMP		= 4'd7,
		  DONE		= 4'd8;
		  
parameter opr_ADD 	= 2'b00,
		  opr_SUB	= 2'b01,
		  opr_PAR 	= 2'b10,
		  opr_COMP 	= 2'b11;
		  
parameter TRUE = 1'b1,
		  FALSE = 1'b0;




NbitFullAdder		#(.width(ALU_SIZE))	add_i1(.a(data_A),.b(data_B),.cin(1'b0),.sum(result_add),.cout(add_overflow));
Nbitcomparator 		#(.width(ALU_SIZE))	comp_i1(.a(data_A),.b(data_B),.comp(result_comp));
Nbitparity 			#(.width(ALU_SIZE))	parity_i1(.a(data_A),.b(data_B),.parity(result_parity));
NbitFullSubtractor	#(.width(ALU_SIZE))	sub_i1(.a(data_A),.b(data_B),.bin(1'b0),.diff(result_sub),.bout(sub_overflow));

// Next State Assignment 
always@(posedge clk)  begin
	if (reset_n == 1'b0) begin
		state = RESET;
	end
	else begin
		state = nextstate ;
	end
end

// Next State Generation
always@(state or reset_n or opcode_valid or opcode) begin

case(state)	
RESET 	:begin
			if(reset_n == 1'b1) begin
				nextstate = IDLE;
			end
			else begin
				nextstate = RESET;
			end
		end
IDLE	:begin
			if(opcode_valid == TRUE) begin
				nextstate = DATA_A;
			end
			else begin
				nextstate = IDLE;
			end
		end

DATA_A	: begin
			if(opcode_valid == TRUE) begin
				nextstate = DATA_B;
			end
			else begin
				nextstate = IDLE;
			end
		end
			

DATA_B : begin
		#0.1;
			if(opcode_valid == TRUE && demux_opcode == opr_ADD) begin
				nextstate = ADD;
			end
			else if (opcode_valid == TRUE && demux_opcode == opr_SUB) begin
				nextstate = SUB;
			end
			else if (opcode_valid == TRUE && demux_opcode == opr_PAR) begin
				nextstate = PAR;
			end
			else if(opcode_valid == TRUE && demux_opcode == opr_COMP) begin
				nextstate = COMP;
			end
			else if(opcode_valid == FALSE) begin
				nextstate = IDLE;
			end
			else $display("demux_opcode Error");
		end

ADD	: begin
			nextstate = DONE;
		end
		
SUB	: begin
			nextstate = DONE;
		end
		
PAR	: begin
			nextstate = DONE;
		end
		
COMP: begin
			nextstate = DONE;
		end

DONE : begin
			nextstate = IDLE;
		end
endcase

end


//Output definition for each state

always@(state) begin

case(state) 
RESET   : begin
		result = 'b0;
		done = FALSE;
		overflow = FALSE;
		end

IDLE	: begin
		end
		
DATA_A  : begin
		data_A = data;
		demux_opcode[0]=opcode;
		end
		
DATA_B  : begin
		data_B = data;
		demux_opcode[1]=opcode;
		end
		
ADD	    : begin
		result = result_add;
		overflow = add_overflow;
		end
		
SUB 	: begin
		result = result_sub;
		overflow = sub_overflow;
		end
		
PAR 	: begin
		result = result_parity;
		overflow = FALSE;
		end
		
COMP	: begin
		result = result_comp;
		overflow = FALSE;
		end
		
DONE	: begin
		done = TRUE;
		end
endcase
end

endmodule