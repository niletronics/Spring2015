module NbitFullAdder(a,b,cin,sum,cout);
parameter width = 8;
input [width :1] a,b;
input cin;
output [width:1] sum;
output cout;
reg [width:0]c;

genvar i;

generate 
c[0]=cin;
for (i=1;i<=width;i=i+1) begin
onebitfulladder(.a(a[i]),.b(b[i]),.cin(c[i-1]),.sum(sum[i]),.cout(c[i]));
end
cout = c[width];
endgenerate


endmodule