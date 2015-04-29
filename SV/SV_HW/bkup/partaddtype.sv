package partaddtype;

typedef union {
bit [63:0] QWORD;
bit [1:0][31:0] DW;
bit [3:0][15:0] W;
bit [7:0][7:0] byte1;
}data;
endpackage



package openfilepkg;
integer file,r;
task openfile;
integer filename;
begin
	if($value$plusargs("FILENAME=%s",filename)) begin
		$display("Reading data given file : %s",filename);
		file = $fopen(filename,"r");
		end
	else begin
		$display("No Filename Provided reading from Default file : --data.data-- : module = %m ");
		file = $fopen("data.data","r");
		$display("file = %d",file);
	end	
	if(file === 0) begin
		$display("None of the files exists kindly check the program location module = %m");
		$stop;
	end
end
endtask
endpackage

