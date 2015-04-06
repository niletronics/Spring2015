module Nbitcomparator (a,b,comp);
parameter width = 8;
input [width-1:0]a,b;
output [width-1:0]comp;

genvar i;

generate 
for (i=0;i<width-1;i=i+1) 
onebitcomparator A(.a(a[i]),.b(b[i]),.comp(comp[i]))
endgenerate

endmodule