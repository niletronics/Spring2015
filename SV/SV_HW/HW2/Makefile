env:
	vlib work
	vmap work work
compile:
	vlog -f ./SourceCode/svfile.f

simulate:
	vsim -c ${top} -do do.do +${DEBUG}
clean :
	rm -rf work/ modelsim.ini transcript
debug :
	vsim -c ${top} -do do.do +DEBUG

