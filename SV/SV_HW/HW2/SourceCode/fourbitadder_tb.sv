module fourbitadder_tb();
parameter width = 4;
reg [width-1:0] A,B;
wire [width-1:0] DS, CS;
reg Cin;
wire DCout, CCout;

leafadder #(.NoBitsLeaf(width)) l1(.A(A), .B(B), .Cin(Cin), .S(DS), .Cout(DCout));
adderchecker #(.width(width)) a1(.A(A),.B(B),.Cin(Cin),.S(CS),.Cout(CCout));

initial begin
$display ("A \t B \t Cin \t\t DesignS \t DesignCout \t CheckerS \t CheckerCout");
repeat(1000) begin
	A = $random;
	B = $random;
	Cin = 1'b0;
	#5;
$display(" %d \t %d \t %d \t\t   %d   \t    %d      \t    %d     \t   %d",A,B,Cin,DS,DCout,CS,CCout);
	if(DCout == CCout && DS == CS) 	$display("Test Passed ");
	end
end

endmodule
