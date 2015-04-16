module top();
reg [1:0] TYPEOFTEST;
parameter DIRECTIONAL = 2'b00;
parameter RANDOMIZED = 2'b01;
parameter EXHAUSTIVE = 2'b10;


tb #(.WIDTH(16)) i9(change_test,TYPEOFTEST);

initial begin
TYPEOFTEST = DIRECTIONAL;
end


always@(change_test)
begin
	if(change_test) begin
		case(TYPEOFTEST)
			DIRECTIONAL : begin
				TYPEOFTEST = RANDOMIZED;
			end
			RANDOMIZED  : begin
				TYPEOFTEST = DIRECTIONAL ;
			end
			EXHAUSTIVE  : begin
				$display("God Bless you");
			end
		endcase
	end

end         

endmodule