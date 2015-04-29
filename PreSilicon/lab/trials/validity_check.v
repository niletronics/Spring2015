module validity_check;

wire output_valid_test;
reg [7:0]opcode, data;

parameter TRUE = 1'b1;
parameter FALSE = 1'b0;
reg data_reduction,data_valid;

assign output_valid_test = ( ((opcode ^ ~opcode) == 8'hff) && ((data ^ ~data) == 8'hff)) ? TRUE : FALSE;
always@(*) begin
	
	data_reduction = ^data;
	if(data_reduction == 1'b1 || data_reduction == 1'b0) 
		data_valid = TRUE;
	else
		data_valid = FALSE;
end

initial begin
$monitor("data = %b, data_reduction = %b, data_valid = %b",data,data_reduction,data_valid);
opcode = 8'h00;
data = 8'h00;
#20;
opcode = 8'h10;
data = 8'haa;


#20;
data = 8'b0101_x000;
opcode = 8'bxxxx_xxxx;


#20;
opcode = 8'bz;
data = 8'b0101_z000;

#20;
opcode = 8'b1;
data = 8'b1111_1111;

#20;
opcode = 8'bx;
data = 8'bxxxx_xxxx;

#20;
opcode = 8'bz;
data = 8'bzzzz_zzzz;

#20;
opcode = 8'bz;
data = 8'b1110000;

end

endmodule
