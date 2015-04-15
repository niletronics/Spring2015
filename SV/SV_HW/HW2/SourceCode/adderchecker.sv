module adderchecker(A,B,Cin,S,Cout);

parameter width = 4;
input [width-1:0]A,B;
input Cin;
output [width-1:0] S;
output Cout;

assign #5 {Cout,S} = A + B + Cin;

endmodule
