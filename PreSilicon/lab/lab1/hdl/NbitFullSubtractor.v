module NbitFullSubtractor(a,b,bin,diff,bout);
parameter width = 8;
input [width :1] a,b;
input bin;
output [width:1] diff;
output bout;
wire [width:0]c;

genvar i;
assign c[0]=bin;
generate 
for (i=1;i<=width;i=i+1) 
onebitfullsubtractor Y(.a(a[i]),.b(b[i]),.bin(c[i-1]),.diff(diff[i]),.bout(c[i]));
endgenerate
assign bout = c[width];


endmodule