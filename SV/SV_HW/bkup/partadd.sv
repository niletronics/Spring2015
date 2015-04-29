module partadd(A,B,Cin,S,Cout);
parameter WIDTH = 64;
localparam base = WIDTH/8;
input [WIDTH-1:0] A,B;
input Cin;
output [WIDTH-1:0]S;
output Cout;
wire [base + 1 :0]C;
genvar i;

assign C[0] = Cin;

generate 
for (i=1;i<=base;i++) begin
fa8bit #(.width(base)) l1(.A(A[(base*i-1):(base*i-base)]), .B(B[(base*i-1):(base*i-base)]), .Cin(C[i-1]), .S(S[(base*i-1):(base*i-base)]), .Cout(C[i]));
end
endgenerate

assign Cout = C[base + 1];

endmodule 