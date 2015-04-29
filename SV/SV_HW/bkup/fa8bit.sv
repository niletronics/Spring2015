module fa8bit(A,B,Cin,S,Cout);

parameter width = 8;
input [width-1:0]A,B;
input Cin;
output [width-1:0] S;
output Cout;

assign {Cout,S} = A + B + Cin;

endmodule
