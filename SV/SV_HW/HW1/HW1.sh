#!/bin/sh

display_usage()
{
echo "Usage : ./HW1.sh <dofilename>"
}

display_usage
vlib work
vmap work work
vlog ./SourceCode/*.sv
vsim -c Nbitadder_tb -do $1
rm -rf work modelsim.ini
