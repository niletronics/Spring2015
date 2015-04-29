module onebitcomparator(a,b,comp);
input a,b;
output comp;

assign comp = a ~^ b;

endmodule