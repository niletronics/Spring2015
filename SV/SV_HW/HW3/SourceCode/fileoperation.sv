package fileoperation;
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