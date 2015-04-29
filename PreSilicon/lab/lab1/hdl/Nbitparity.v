module Nbitparity (a,b,parity);
parameter width = 8;
input [width-1:0]a,b;
output [width-1:0]parity;

genvar i;

generate 
for (i=0;i<width;i=i+1) 
onebitparity A(.a(a[i]),.b(b[i]),.parity(parity[i]));
endgenerate

endmodule