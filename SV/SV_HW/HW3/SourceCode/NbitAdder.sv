module NbitAdder(A,B,Cin,S,Cout);
parameter WIDTH = 8;
localparam base = WIDTH/4;
input [WIDTH-1:0] A,B;
input Cin;
output [WIDTH-1:0]S;
output Cout;
wire [base:0]C;
genvar i;

assign C[0] = Cin;

generate 
for (i=1;i<=base;i++) begin
leafadder #(.NoBitsLeaf(4)) l1(.A(A[(4*i-1):(4*i-4)]), .B(B[(4*i-1):(4*i-4)]), .Cin(C[i-1]), .S(S[(4*i-1):(4*i-4)]), .Cout(C[i]));
end
endgenerate

assign Cout = C[base];

endmodule 