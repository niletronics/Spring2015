compile : 
	vlib work
	vmap work work
	vlog ./hdl/*.v
	
simulate :
	vsim -c -novopt top

clean :
	rm -rf ./work transcript modelsim.in

all :
	vlib work
	vmap work work
	vlog ./hdl/*.v
	vsim -c -novopt top -do $(dofile)
	rm -rf ./work transcript modelsim.ini


