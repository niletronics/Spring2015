module stagerred_add(A,B,Cin,S,Cout,clk);
parameter WIDTH = 16;
parameter PW = WIDTH/2;
input [WIDTH-1:0] A,B; 		// 16 Bit Inputs to the module
input clk,Cin;
output reg [WIDTH-1:0] S;		// 16 Bit Output from the module
output reg Cout;

wire [PW-1:0] net_LSB_result;
wire [PW-1:0] net_MSB_result;
wire net_LSB_Carry;
wire net_MSB_Carry;

reg [PW-1:0] DF_EX1_LSB_A;
reg [PW-1:0] DF_EX1_MSB_A;
reg [PW-1:0] DF_EX1_LSB_B;
reg [PW-1:0] DF_EX1_MSB_B;
reg DF_EX1_Cin;

reg [PW-1:0] EX1_EX2_LSB_result;
reg [PW-1:0] EX1_EX2_MSB_A;
reg [PW-1:0] EX1_EX2_MSB_B;
reg EX1_EX2_LSB_Carry;

reg [PW-1:0] EX2_WB_LSB_result;
reg [PW-1:0] EX2_WB_MSB_result;
reg EX2_WB_MSB_Carry;


generate 
if(PW==8) begin
NbitAdder EX1_8(.A(DF_EX1_LSB_A),.B(DF_EX1_LSB_B),.Cin(DF_EX1_Cin),.S(net_LSB_result),.Cout(net_LSB_Carry));
NbitAdder EX2_8(.A(EX1_EX2_MSB_A),.B(EX1_EX2_MSB_B),.Cin(EX1_EX2_LSB_Carry),.S(net_MSB_result),.Cout(net_MSB_Carry));
end
else if(PW==4) begin
leafadder EX1_4(.A(DF_EX1_LSB_A),.B(DF_EX1_LSB_B),.Cin(DF_EX1_Cin),.S(net_LSB_result),.Cout(net_LSB_Carry)); 
leafadder EX2_4(.A(EX1_EX2_MSB_A),.B(EX1_EX2_MSB_B),.Cin(EX1_EX2_LSB_Carry),.S(net_MSB_result),.Cout(net_MSB_Carry)); 
end
endgenerate



always@(posedge clk) begin
// Stage : 1 Inputs Fetch 
	DF_EX1_LSB_A 		<= A[PW-1:0];							//Sampling LSB From Data A				
	DF_EX1_MSB_A 		<= A[WIDTH-1:PW];                         //Sampling MSB From Data A
	DF_EX1_LSB_B 		<= B[PW-1:0];                          //Sampling LSB From Data B
	DF_EX1_MSB_B 		<= B[WIDTH-1:PW];                         //Sampling MSB From Data B
	DF_EX1_Cin	 		<= Cin;								//Sampling Carry Input
// Stage : 2 EX1, LSB Sum
	EX1_EX2_MSB_A 		<= DF_EX1_MSB_A;
	EX1_EX2_MSB_B 		<= DF_EX1_MSB_B;
	EX1_EX2_LSB_result	<= net_LSB_result;
	EX1_EX2_LSB_Carry	<= net_LSB_Carry;
// Stage 3 : EX2, MSB Sum
	EX2_WB_LSB_result 	<= EX1_EX2_LSB_result;
	EX2_WB_MSB_result	<= net_MSB_result;
	EX2_WB_MSB_Carry	<= net_MSB_Carry;
// Stage 4 : WB Write-Back
	S[WIDTH-1:0] 		<= {EX2_WB_MSB_result,EX2_WB_LSB_result};
	Cout		 		<= EX2_WB_MSB_Carry;

end

endmodule



