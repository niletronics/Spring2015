module struct_example(A,B,S,Cout);
parameter width = 16;
input [width-1:0] A,B; 		// 16 Bit Inputs to the module
output [width-1:0] S;		// 16 Bit Output from the module
output Cout;

typedef struct {
reg [7:0] data_a;
reg [7:0] data_b;
reg [7:0] result;
reg pass;
} pipeline_reg;

pipeline_reg IF_EX1;
pipeline_reg EX1_EX2;


initial begin
$monitor("pipeline register values EX1_EX2.data_b = %h EX1_EX2.data_a =%h EX1_EX2.result = %h EX1_EX2.pass = %b \n pipeline register values IF_EX1.data_a = %h IF_EX1.data_b =%h IF_EX1.result = %h IF_EX1.pass = %b", EX1_EX2.data_a, EX1_EX2.data_b,EX1_EX2.result, EX1_EX2.pass, IF_EX1.data_a, IF_EX1.data_b, IF_EX1.result,IF_EX1.pass);
end

initial begin
#1;{IF_EX1.data_a, IF_EX1.data_b, IF_EX1.result,IF_EX1.pass} = {8'h00,8'h00,8'h00,1'b0};{EX1_EX2.data_a, EX1_EX2.data_b, EX1_EX2.result,EX1_EX2.pass} = {8'h00,8'h00,8'h00,1'b0};
#1;{IF_EX1.data_a, IF_EX1.data_b, IF_EX1.result,IF_EX1.pass} = {8'h01,8'h00,8'h00,1'b0};
#1;{IF_EX1.data_a, IF_EX1.data_b, IF_EX1.result,IF_EX1.pass} = {8'h02,8'h00,8'h00,1'b0};
#1;{IF_EX1.data_a, IF_EX1.data_b, IF_EX1.result,IF_EX1.pass} = {8'h03,8'h00,8'h00,1'b0};
#1;{IF_EX1.data_a, IF_EX1.data_b, IF_EX1.result,IF_EX1.pass} = {8'h04,8'h00,8'h00,1'b0};
#1;{IF_EX1.data_a, IF_EX1.data_b, IF_EX1.result,IF_EX1.pass} = {8'h05,8'h00,8'h00,1'b0};
#1;{IF_EX1.data_a, IF_EX1.data_b, IF_EX1.result,IF_EX1.pass} = {8'h06,8'h00,8'h00,1'b0};
#1;{IF_EX1.data_a, IF_EX1.data_b, IF_EX1.result,IF_EX1.pass} = {8'h07,8'h00,8'h00,1'b0};
#1;{IF_EX1.data_a, IF_EX1.data_b, IF_EX1.result,IF_EX1.pass} = {8'h08,8'h00,8'h00,1'b0};
#1;{EX1_EX2.data_a, EX1_EX2.data_b, EX1_EX2.result,EX1_EX2.pass} = {8'h00,8'h00,8'h00,1'b0};
#1;{EX1_EX2.data_a, EX1_EX2.data_b, EX1_EX2.result,EX1_EX2.pass} = {8'h01,8'h00,8'h00,1'b0};
#1;{EX1_EX2.data_a, EX1_EX2.data_b, EX1_EX2.result,EX1_EX2.pass} = {8'h02,8'h00,8'h00,1'b0};
#1;{EX1_EX2.data_a, EX1_EX2.data_b, EX1_EX2.result,EX1_EX2.pass} = {8'h03,8'h00,8'h00,1'b0};
#1;{EX1_EX2.data_a, EX1_EX2.data_b, EX1_EX2.result,EX1_EX2.pass} = {8'h04,8'h00,8'h00,1'b0};
end

endmodule



