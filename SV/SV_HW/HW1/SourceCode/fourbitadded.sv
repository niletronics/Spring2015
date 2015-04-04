module leafadder(A,B,Cin,S,Cout);
parameter NoBitsLeaf = 4;
input [NoBitsLeaf-1:0] A, B;
input Cin;
output [NoBitsLeaf-1:0] S,
output Cout;
wire [NoBitsLeaf-1:0] G,P;



assign G = A & B;
assign P = A | B;
assign S = A ^ B;
assign 
assign Cout = G[3] || (G[2] && P[3]) || (G[1] && P[2] && P[3]) || ( G[0] && P[1] && P[2] && P[3] ) ; // Trying to make this also generic 


endmodule





