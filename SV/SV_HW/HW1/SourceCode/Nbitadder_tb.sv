module Nbitadder_tb();
parameter width = 8;
reg [width-1:0] A,B;
reg [3:0] A4,B4;
wire [3:0] DS4, CS4;
wire [width-1:0] DS, CS;
reg Cin,Cin4;
wire DCout, CCout, DCout4, CCout4;
int i,j,k;
int passcount,failcount,passcount_4bit,failcount_4bit;

leafadder #(.NoBitsLeaf(4)) leaf1(.A(A4), .B(B4), .Cin(Cin4), .S(DS4), .Cout(DCout4));	// Leaf Level Adder Module Instantiation 
adderchecker #(.width(4)) chkr1(.A(A4),.B(B4),.Cin(Cin4),.S(CS4),.Cout(CCout4));	  	// Checker for leaf level module Instantiation
NbitAdder #(.width(width)) Nbit1(.A(A), .B(B), .Cin(Cin), .S(DS), .Cout(DCout));		// N bit Adder Module Instantiation
adderchecker #(.width(width)) ckr2(.A(A),.B(B),.Cin(Cin),.S(CS),.Cout(CCout));		// Checker for N bit Adder Instantiation


initial begin
A = '0; B = '0; A4 = '0; B4 = '0; Cin = '0; Cin4 = '0; 
if($test$plusargs("DEBUG")) begin
	$display("---------------Checking Leaf Level CarryLookAhead Adder-------------");
	$display ("A \t B \t Cin \t\t DesignS \t DesignCout \t CheckerS \t CheckerCout");
end

for (i=0;i<=15;i++) begin
	for (j=0;j<=15;j++) begin
		for (k=0;k<=1;k++) begin
			#5;
			A4= i ; B4 = j ; Cin4 = k;
			if( (DS4==CS4) && (DCout4==CCout4) ) begin
				if($test$plusargs("DEBUG")) 
				$display(" %d \t %d \t %d \t\t   %d   \t    %d      \t    %d     \t   %d   Test Passed for Checker ",A4,B4,Cin4,DS4,DCout4,CS4,CCout4);
				passcount_4bit++;
				end
			else begin
				$display("Test Failed at A = %0d, B = %0d, Cin = %0d, DesignSum = %0d, CheckerSum = %0d", A4,B4,Cin4,{DCout4,DS4},{CCout4,CS4});
				failcount_4bit++;
				end
			end
		end
	end
	
for (i=0;i<=2**width-1;i++) begin
	for (j=0;j<=2**width-1;j++) begin
		for (k=0;k<=1;k++) begin
			#10;
			A= i ; B = j ; Cin = k;
			if( (DS==CS) && (DCout==CCout) ) begin
				if($test$plusargs("DEBUG"))
				$display(" %d \t %d \t %d \t\t   %d   \t    %d      \t    %d     \t   %d   Test Passed for %0dBitAdder ",A,B,Cin,DS,DCout,CS,CCout,width);
				passcount++;
				end
			else begin
				$display("Test Failed at A = %0d, B = %0d, Cin = %0d, DesignSum = %0d, CheckerSum = %0d", A,B,Cin,{DCout,DS},{CCout,CS});
				failcount++;
				end
			end
		end
	end

summary();

end

task summary;
$display("------------Summary of Results for Homework:1 for Nilesh Dattani --------------------------");
$display("------------------------------For Four-Bit Adder-----------------------------------------");
$display("********************----------------------------------------Total Number of Tests : %0d",(passcount_4bit+failcount_4bit));
$display("********************----------------------------------------Number of Tests Passed : %0d",passcount_4bit);
$display("********************----------------------------------------Number of Tests Failed : %0d\n",failcount_4bit);

$display("------------------------------For %0d-Bit Adder-----------------------------------------",width);
$display("********************----------------------------------------Total Number of Tests  : %0d",(passcount+failcount));
$display("********************----------------------------------------Number of Tests Passed : %0d",passcount);
$display("********************----------------------------------------Number of Tests Failed : %0d",failcount);
endtask





endmodule
