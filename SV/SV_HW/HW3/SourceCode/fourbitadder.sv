module leafadder(A,B,Cin,S,Cout);
parameter NoBitsLeaf = 4;
input [NoBitsLeaf-1:0] A, B;
input Cin;
output [NoBitsLeaf-1:0] S;
output Cout;
wire [NoBitsLeaf-1:0] G,P;
wire [3:0]C;



assign G = A & B;
assign P = A | B;

assign C[0] = Cin;
assign C[1] = G[0] || (P[0] && Cin);
assign C[2] = G[1] || (P[1] && G[0]) || (P[1] && P[0] && Cin);
assign C[3] = G[2] || (P[2] && G[1]) || (P[2] && P[1] && G[0]) || (P[2] && P[1] && P[0] && Cin);
assign #5 Cout = G[3] || (P[3] && G[2]) || (P[3] && P[2] && G[1]) || (P[3] && P[2] && P[1] && G[0]) || (P[3] && P[2] && P[1] && P[0] && Cin);

assign #5 S = A^B^C;

endmodule





