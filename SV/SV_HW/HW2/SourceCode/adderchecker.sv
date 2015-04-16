module adderchecker(A,B,Cin,S,Cout);
parameter WIDTH = 4;
parameter COMB_DELAY = 10;
input [WIDTH-1:0]A,B;
input Cin;
output [WIDTH-1:0] S;
output Cout;

assign #COMB_DELAY {Cout,S} = A + B + Cin;
//assign {Cout,S} = A + B + Cin;

endmodule
