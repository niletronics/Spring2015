vlog ./SourceCode/*.sv
vsim fourbitadder_tb
run -all
quit -sim
rm -rf work/ modelsim.ini
quit
