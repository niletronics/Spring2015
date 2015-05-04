clean :
	rm -rf work/ modelsim.ini transcript
env:
	vlib work
	vmap work work
compile:
	vlog -f ./SourceCode/svfile.f
simulate:
	vsim -c ${top} -do do.do
runnew:
	rm -rf work modelsim.ini transcript
	vlib work 
	vmap work work
	vlog -f ./SourceCode/svfile.f
	vsim -c ${top} -do do.do
	
run:
	vlog -f ./SourceCode/svfile.f
	vsim -c ${top} -do do.do
