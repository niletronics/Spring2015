`include fileoperations.sv
import fileoperation::*;

module tb_16();
parameter CLK_WIDTH		= 50;
parameter WIDTH 		= 16;
parameter COMB_DELAY 	= 10;
parameter RUNTIME 		= 10000; 
localparam TRUE 		= 1'b1;
localparam FALSE 		= 1'b0;

parameter DIRECTIONAL 	= 2'b00;
parameter RANDOMIZED 	= 2'b01;
parameter EXHAUSTIVE 	= 2'b10;


reg 	[1:0]TYPEOFTEST;

reg 	[WIDTH-1:0]A,B;
reg 	clk,Cin;
reg 	[WIDTH-1:0]S;

reg 	[15:0]exp_sum;
reg 	exp_carry;

reg 	[15:0]sum_queue[650000:0];
reg 	carry_queue[650000:0];
reg 	[256:0]i;
reg 	pad;
reg 	[1:0] done;

integer file,r,clock_count,randtest,dirtest,exhtest,testcount,passtest,failtest;

always #CLK_WIDTH clk = ~clk;

initial begin
clock_count = 0; i=0; clk = 1'b0;A=0;B=0;Cin=0;pad=0;done=0; 
randtest=0;dirtest=0;exhtest=0;testcount=0;passtest=0;failtest=0;TYPEOFTEST=DIRECTIONAL;
file = $fopen("data.data","r");
end

stagerred_add #(.WIDTH(WIDTH)) pipe(.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout), .clk(clk));
adderchecker #(.WIDTH(WIDTH), .COMB_DELAY(COMB_DELAY)) ckr(.A(A),.B(B),.Cin(Cin),.S(exp_sum),.Cout(exp_carry));

always@(negedge clk) begin

	case(TYPEOFTEST) 	
		DIRECTIONAL : begin
			if(!$feof(file)) begin
				r = $fscanf(file,"%h %h %b",A,B,Cin);
				dirtest = dirtest + 1;
			end
			else begin
				$display("Reached End of File");
				done = done+1;
				TYPEOFTEST = RANDOMIZED;
			end
		end
	
	RANDOMIZED : begin			
			A=$random;
			B=$random;
			Cin=$random;
			randtest = randtest + 1;
			if(clock_count>=RUNTIME+4) begin
			done = done+1;
			TYPEOFTEST = DIRECTIONAL;
			end
		end
	
	EXHAUSTIVE: begin
		if({pad,Cin,A,B} <={1'b0,1'b1,{WIDTH{1'b1}},{WIDTH{1'b1}}} + 3'd4) begin
			{pad,Cin,A,B} = {pad,Cin,A,B} + 1'b1;
			exhtest = exhtest + 1;
		end
		else begin
				$display("EXHAUSTIVE Testing Complete");
				done = 1'b1;
			end
	end
	
	default : begin
		$display("Invalid Test Type, Proceeding with DIRECTIVE Testing");
	end
	
endcase
	
		sum_queue[i+3] = exp_sum;
		carry_queue[i+3] = exp_carry;
		

		if ((sum_queue[i]==S) && (carry_queue[i] == Cout) && (clock_count>=4)) begin
			passtest = passtest + 1;
			if($test$plusargs("DEBUG")) begin
				$display("test Passed : A = %h B=%h C=%b Sum=%h Carry = %h Expected Sum = %h Expected Carry = %b",A,B,Cin,S,Cout,sum_queue[i],carry_queue[i]);
			end
		end
		else if(sum_queue[i]!=S && carry_queue[i] != Cout && clock_count>=4) begin
		failtest = failtest + 1;
			$display("test Failed : A = %h B=%h C=%b Sum=%h Carry = %h Expected Sum = %h Expected Carry = %b",A,B,Cin,S,Cout,sum_queue[i],carry_queue[i]);
		end
		
		i=i+1;
		
end

always@(posedge clk) begin
	clock_count=clock_count+1'b1;
end


always@(posedge clk) begin
	if(done==2) begin
	summary();
	end
end

task summary();
	begin
	$display("*************************Summary of Results****************************");
	$display("*************Total Number of Test Executed			: %0d",dirtest+exhtest+randtest-3);
	$display("*************Total Number of RANDOMIZED Tests Executed 	: %0d",randtest);
	$display("*************Total Number of DIRECTIONAL Tests Executed 	: %0d",dirtest-3);
	$display("*************Total Number of EXHAUSTIVE Tests Executed 	: %0d",exhtest);
	$display("*************Total Number of Tests Passed 			: %0d",passtest);
	$display("*************Total Number of Tests Failed 			: %0d",failtest);
	$fclose(file);
	$finish;
end
endtask

endmodule
