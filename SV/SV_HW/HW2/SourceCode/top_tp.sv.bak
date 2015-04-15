module tb();
parameter CLK_WIDTH = 50;
parameter width = 16;
reg [width-1:0]A,B;
reg clk,Cin;
reg [width-1:0]S;
integer file,r,i,clock_count;
reg [15:0]exp_sum;
reg [7:0] exp_carry;
reg [15:0]sum_queue[7:0];
reg carry_queue[7:0];

always #CLK_WIDTH clk = ~clk;

initial begin
clock_count = 0;
i=0;
clk = 1'b0;
file = $fopen("data.data","r");
$monitor("clock_count : %0d \t A = %0h B = %0h Cin = %h Sum = %0h  Cout = %0h exp_sum(-4) = %h exp_carry = %0b",clock_count,A,B,Cin,S,Cout,exp_sum,exp_carry);
end

stagerred_add pipe(.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout), .clk(clk));
//adderchecker checker(.A(A),.B(B),.Cin(Cin),.S_(S),.Cout(Cout));

always@(negedge clk) begin
	if(!$feof(file)) begin
	r = $fscanf(file,"%h %h %b %h %b",A,B,Cin,exp_sum,exp_carry);
	sum_queue[i] = exp_sum;
	carry_queue[i] = exp_carry;
	//$display("Registered sum_queue = %0h Registered carry_queue = %b for index %d",sum_queue[i],carry_queue[i],i);
	i=i+1;
	end
	else begin
	$display("Reached End of File");
	//$fclose(file);
	end

end

// Checking 
always@(posedge clk) begin
clock_count=clock_count+1'b1;
end


endmodule


