Readme.txt for Nilesh_D HOMEWORK:4

I have included the transcript file, which is relatively small as it was requested by professor for the homework assignment.
All the documents are present in folder docs at the same level as that of SourceCode. (Root location for the zip file)

There are suppresable displays for WARNING
1. `define WARNING in the design
2. `define DEBUG in testbench

Assumptions :
1. One input at a time, more than one will throw a warning if WARNING is defined
2. No cash should be given to machine when not ready or when in reset or when dispensing the ticket, this also would throw warning if WARNING is defined
3. Adding sequencial logic to next state logic is fine and is still a moore machine.

To run the code, copy and extract the SourceCode in your present working directory
Give following command to run all

$ make runnew top=fsm_tb

To compile or other operations refer to Makefile commands as below:

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

