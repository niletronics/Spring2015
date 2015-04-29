clean :
	rm -rf work/ modelsim.ini transcript
env:
	vlib work
	vmap work work
compile1:
	vlog -f ./SourceCode/svfile1.f
compile2:
	vlog -f ./SourceCode/svfile2.f
compile3:
	vlog -f ./SourceCode/svfile3.f	
compile :
	vlog -f ./SourceCode/svfile1.f
	vlog -f ./SourceCode/svfile2.f
	vlog -f ./SourceCode/svfile3.f
simulate:
	vsim -c ${top} -do do.do


