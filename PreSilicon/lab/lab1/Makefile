env :
	vlib work
	vmap work work
compile : 
	vlog -f ./hdl/vfiles.f
	
simulate :
	vsim -c -novopt $(top)

clean :
	rm -rf ./work transcript modelsim.ini

all :
	vlib work
	vmap work work
	vlog -v ./hdl/vfiles.f
	vsim -c -novopt $(top)
usage:
	cat Makefile


