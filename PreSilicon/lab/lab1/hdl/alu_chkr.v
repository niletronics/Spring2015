`define DATA_WIDTH 8
`define RULE_1
`define RULE_2
`define RULE_3
`define RULE_4
`define RULE_5

module alu_chkr(clk,reset_n,opcode_valid,opcode,data,done,overflow,result,simulation_end);
input clk, reset_n, overflow, done,opcode,opcode_valid,simulation_end;
input [`DATA_WIDTH-1:0] data,result;
reg [`DATA_WIDTH-1:0]data_A,data_B;
reg [`DATA_WIDTH-1:0]result_checker;
reg [63:0]clk_cnt=0;
reg data_reduction,data_valid,overflow_checker,checker_done,data_latched;
reg [1:0] demux_opcode;
reg [3:0] fsm_regsiter;

integer rst_test_p, rst_test_f, validity_test_p, validity_test_f,result_check_p,result_check_f,overflow_test_p,overflow_test_f,done_test_p,done_test_f;

parameter TRUE		 = 1'b1;
parameter FALSE 	 = 1'b0;

initial begin
	rst_test_p 		= 1'b0;		rst_test_f 		= 1'b0;
	validity_test_p = 1'b0; 	validity_test_f	= 1'b0;
	result_check_p	= 1'b0;		result_check_f	= 1'b0;
	overflow_test_p	= 1'b0;		overflow_test_f	= 1'b0;
	done_test_p		= 1'b0;		done_test_f		= 1'b0;
	data_latched	= 1'b0;	
// $monitor("RESET TEST: PASSED = %0d \n RESET TEST : FAILED = %0d \n VALIDITY TEST : PASSED = %0d \n VALIDITY TEST: FAILED = %0d \n DONE TEST : PASSED = %0d \n DONE TEST : FAILED = %0d \n RESULT CHECK	: PASSED = %0d \n RESULT CHECK : FAILED = %0d \n OVERFLOW CHECK : PASSED = %0d \n OVERFLOW CHECK : FAILED = %0d \n ",rst_test_p, rst_test_f, validity_test_p, validity_test_f,done_test_p,done_test_f,overflow_test_p,overflow_test_f,overflow_test_p,overflow_test_f);
end                                       

assign output_zero = ((result == {`DATA_WIDTH{1'b0}}) && (overflow == 1'b0) && (done == 1'b0)) ? TRUE : FALSE;

always@(data) begin	
	data_reduction = ^data;
	if(data_reduction == 1'b1 || data_reduction == 1'b0) 
		data_valid = TRUE;
	else
		data_valid = FALSE;
end

always@(*) begin
	if(opcode_valid == 1'b1) begin
	repeat(1)@(posedge clk);
	data_A = data;
	demux_opcode [0] = opcode;
	
	repeat(2)@(posedge clk);
	if(opcode_valid == 1'b1) begin
	 //@(posedge clk);
		data_B = data;
		demux_opcode[1] = opcode;
		data_latched = 1'b1;
	end
end
	//@(posedge clk);
	
	if(opcode_valid == 1'b1) begin
		case(demux_opcode) 
			2'b00 : {overflow_checker,result_checker} =  data_A + data_B;
			2'b01 : {overflow_checker,result_checker} =  data_A - data_B;
			2'b10 : {overflow_checker,result_checker} =  {1'b0,data_A ^ data_B};
			2'b11 : {overflow_checker,result_checker} =  {1'b0,data_A ~^ data_B};
		endcase
	end
	//repeat(1)@(posedge clk);
	data_latched = 1'b0;
end


//1. When reset_n is asserted (driven to 0), all outputs become 0 within 1 clock cycle. : reset_test
`ifdef RULE_1
always@(negedge reset_n) begin
		repeat(2)@(posedge clk);	
		if(output_zero) begin
			rst_test_p = rst_test_p + 1'b1;
		end
		else begin
			rst_test_f = rst_test_f + 1'b1;
			$display("RULE_1 Failed");
		end
end
`endif
//2. When opcode_valid is asserted, valid opcode and valid data (no X or Z) must be driven on the same cycle.
`ifdef RULE_2
always@(*) begin
	if(opcode_valid == 1'b1 && reset_n) begin
		@(posedge clk);
		if( data_valid && (opcode || ~opcode) )begin
				validity_test_p = validity_test_p + 1'b1;
			end
			else begin
				validity_test_f = validity_test_f + 1'b1;
				$display("RULE_2 Failed");
			end
		end	
end
`endif

//3. Output "done" must be asserted within 2 cycles after both valid data have been captured : done test
`ifdef RULE_3
always@(posedge data_latched) begin
	repeat(2) @(posedge clk);
	if(done == 1'b1) begin	
		done_test_p = done_test_p + 1'b1;
	end	
	else begin
		done_test_f = done_test_f + 1'b1;
		$display("RULE_3 Failed");
	end		
end
`endif

//4. Once "done" is asserted, output "result" must be correct on the same cycle : Result Check
`ifdef RULE_4
always@(posedge done) begin
	if(result == result_checker) begin
		result_check_p=result_check_p + 1'b1;
	end
	else begin
		result_check_f=result_check_f + 1'b1;
		$display("RULE_4 Failed");
	end
end
 `endif  

//5. Once "done" is asserted, output "overflow" must be correct on the same cycle
`ifdef RULE_5
always@(posedge done) begin
	if(overflow == overflow_checker)begin
		overflow_test_p = overflow_test_p + 1'b1;
	end
	else begin	
	overflow_test_f = overflow_test_f + 1'b1;
	$display("RULE_5 Failed");
	end
end
`endif

always@(posedge simulation_end)
begin
  $display("----------------------------------------SUMMARY------------------------------------------------\n");
 `ifdef RULE_1 $display("DATTANI : RESET TEST\t\t(RULE_1):PASSED = %0d\t\tFAILED = %0d ", rst_test_p,rst_test_f); `endif
 `ifdef RULE_2 $display("DATTANI : VALIDITY TEST\t(RULE_2):PASSED = %0d\t\tFAILED = %0d ", validity_test_p,validity_test_f);`endif 
 `ifdef RULE_3 $display("DATTANI : DONE TEST\t\t(RULE_3):PASSED = %0d\t\tFAILED = %0d ", done_test_p, done_test_f); `endif
 `ifdef RULE_4 $display("DATTANI : RESULT CHECK\t(RULE_4):PASSED = %0d\t\tFAILED = %0d ", result_check_p,result_check_f); `endif
 `ifdef RULE_5 $display("DATTANI : OVERFLOW CHECK\t(RULE_5):PASSED = %0d\t\tFAILED = %0d ", overflow_test_p,overflow_test_f); `endif
 $display("-----------------------------------------------------------------------------------------------");
$finish; 
 end

endmodule




