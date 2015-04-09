compile : 
	vlib work
	vmap work work
	vlog ./SourceCode/*.sv
	
simulate :
	vsim -c -novopt Nbitadder_tb -do $(dofile)

clean :
	rm -rf ./work transcript modelsim.in

all :
	vlib work
	vmap work work
	vlog ./SourceCode/*.sv
	vsim -c -novopt Nbitadder_tb -do 4bitdo.do
	rm -rf ./work transcript modelsim.ini

debug :  
	vlib work
	vmap work work
	vlog ./SourceCode/*.sv
	vsim -c -novopt Nbitadder_tb -do 4bitdo.do +DEBUG
	rm -rf ./work transcript modelsim.ini


