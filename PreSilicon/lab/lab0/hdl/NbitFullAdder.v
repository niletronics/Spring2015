module NbitFullAdder(a,b,cin,sum,cout);
parameter width = 8;
input [width :1] a,b;
input cin;
output [width:1] sum;
output cout;
wire [width:0]c;

genvar i;
assign c[0]=cin;
generate 
for (i=1;i<=width;i=i+1) 
onebitfulladder A(.a(a[i]),.b(b[i]),.cin(c[i-1]),.sum(sum[i]),.cout(c[i]));
endgenerate
assign cout = c[width];


endmodule