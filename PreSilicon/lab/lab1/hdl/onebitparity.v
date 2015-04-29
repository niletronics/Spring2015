module onebitparity(a,b,parity);
input a,b;
output parity;

assign parity = a^b;

endmodule