`include "fileoperation.sv"
import fileoperation::*;

module hw2_tb();
parameter CLK_WIDTH		= 50;
parameter WIDTH 		= 16;
parameter RUNTIME 		= 10000; 
localparam TRUE 		= 1'b1;
localparam FALSE 		= 1'b0;

parameter DIRECTIONAL 	= 2'b00;
parameter RANDOMIZED 	= 2'b01;
parameter EXHAUSTIVE 	= 2'b10;
logic 	[WIDTH:0]	ActualResult_Q[$];
logic 	[WIDTH:0]	ExpectedResult_Q[$];
logic   [WIDTH:0]	ActualValue, ExpectedValue, ExpRes;
reg 	[1:0]		TYPEOFTEST;

reg 	clk;
reg 	[256:0]i;
reg 	pad;
reg 	[1:0] done;

logic [WIDTH-1:0] random_A, random_B;
logic random_C;


struct{
logic	[WIDTH-1:0]A,B;
logic	Cin,Cout;
logic	[WIDTH-1:0]S;
}Sdata;

integer file,r,clock_count,randtest,dirtest,exhtest,testcount,passtest,failtest;

always #CLK_WIDTH clk = ~clk;

initial begin
clock_count = 0; i=0; clk = 1'b0; Sdata.A=0;Sdata.B=0;Sdata.Cin=0;pad=0;done=0; 
randtest=0;dirtest=0;exhtest=0;testcount=0;passtest=0;failtest=0;TYPEOFTEST=RANDOMIZED;
file = $fopen("data.data","r");
end

stagerred_add #(.WIDTH(WIDTH)) pipe(.A(Sdata.A), .B(Sdata.B), .Cin(Sdata.Cin), .S(Sdata.S), .Cout(Sdata.Cout), .clk(clk));

always@(negedge clk) begin

	case(TYPEOFTEST) 	
		DIRECTIONAL : begin
			if(!$feof(file)) begin
				r = $fscanf(file,"%h %h %b",Sdata.A,Sdata.B,Sdata.Cin);
				ExpRes=Sdata.A+Sdata.B+Sdata.Cin;
				ExpectedResult_Q.push_front(ExpRes);
				dirtest = dirtest + 1;
			end
			else begin
				$display("Reached End of File");
				done = done + 1'b1;
			end
		end
	
	RANDOMIZED : begin	
			
			Sdata.A  = random_A;
			Sdata.B  = random_B;
			Sdata.Cin = random_C;
			randtest = randtest + 1;
			ExpRes=Sdata.A+Sdata.B+Sdata.Cin;
			ExpectedResult_Q.push_front(ExpRes);
			if(clock_count>=RUNTIME+4) begin
				done = 2'd2;
			end
		end
	
	EXHAUSTIVE: begin
		if({pad,Sdata.Cin,Sdata.A,Sdata.B} <={1'b0,1'b1,{WIDTH{1'b1}},{WIDTH{1'b1}}} + 3'd4) begin
			{pad,Sdata.Cin,Sdata.A,Sdata.B} = {pad,Sdata.Cin,Sdata.A,Sdata.B} + 1'b1;
			ExpRes=Sdata.A+Sdata.B+Sdata.Cin;
			ExpectedResult_Q.push_front(ExpRes);
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

if(clock_count>=4) begin
		ActualResult_Q.push_front({Sdata.Cout,Sdata.S});
		VerifyResult();
end
end

always@(posedge clk) begin
	clock_count=clock_count+1'b1;
end


always@(negedge clk) begin
	static int random_delay = $random%4'd11;
	repeat(random_delay)@(negedge clk);
	random_A=$random;
	random_B=$random;
	random_C=$random;	
end

task summary();
	begin
	$display("*************************Summary of Results****************************");
	$display("*************Total Number of Test Executed			: %0d",dirtest+exhtest+randtest);
	$display("*************Total Number of RANDOMIZED Tests Executed 	: %0d",randtest);
	$display("*************Total Number of DIRECTIONAL Tests Executed 	: %0d",dirtest);
	$display("*************Total Number of EXHAUSTIVE Tests Executed 	: %0d",exhtest);
	$display("*************Total Number of Tests Passed 			: %0d",passtest);
	$display("*************Total Number of Tests Failed 			: %0d",failtest);
	$fclose(file);
	$finish;
end
endtask

task VerifyResult();
begin
	ActualValue=ActualResult_Q.pop_back();
	ExpectedValue=ExpectedResult_Q.pop_back();
	if(ActualValue==ExpectedValue)begin
		passtest = passtest + 1;
		if($test$plusargs("DEBUG")) begin
			$display("Test Passed: Actual Sum = %h Expected Sum = %h",ActualValue,ExpectedValue);
		end
	end
	else begin 
		failtest = failtest + 1;
		$display("Test Failed: Actual Sum = %h Expected Sum = %h",ActualValue,ExpectedValue);
	end
	
	if(done==2) begin
		summary();
    end
end
endtask
endmodule
