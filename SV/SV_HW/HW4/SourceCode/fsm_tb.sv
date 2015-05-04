`timescale 1ns/1ps
`include "fsm_enums.sv"
//`define DEBUG
import fsm_enums::*;

module fsm_tb();
parameter CLOCK_PERIOD = 10;
parameter cost = fortydollars;
localparam TRUE = 1'b1;
localparam FALSE = 1'b0;

			
logic	clk,						// Clock Input
		rst_n,					// Reset Input
		ten,						// Sensor indication : Ten Dollars
		twenty,					// Sensor indication : Twenty Dollars
		ready,				// Output : To show that the system is ready to begin a transaction
		bill,				// Output : To show that additional bills must be inserted to reach $40
		dispense,			// Output : Dispense the ticket/bill
		returnten;			// Output : Overpayment made return $10
	
int ticketcount;
int returntencount;

state_encode tb_state,allstate[$],state_stack[$],state_stack_uni[$],uncoveredstates[$];

fsm  #(.cost(cost)) fsm1(.*);
clkgen #(.CLOCK_PERIOD(CLOCK_PERIOD)) clkgen1(.*);

always@(ten, twenty, fsm1.state, posedge clk) begin :statenotentered
	state_stack.push_front(fsm1.state);			// Push the present state onto the queue
	state_stack_uni = state_stack.unique;		// No need to delete the state_stack_uni queue as it gets reassigned everytime
	if(fsm1.state==fsm1.state.last) begin 
		state_stack.delete;
		statechecking;
	end
	`ifdef DEBUG
	
	$display("Present State Queue = %p",state_stack_uni);
	//state_stack.print;
	`endif
end : statenotentered

task statechecking;
bit match;
	foreach(allstate[i]) begin
		foreach(state_stack_uni[j]) begin
			if(state_stack_uni[j] == allstate[i]) begin
				match = 1'b1;
				break;
			end
			else begin 
				match = 1'b0;
			end
		end
		if(match == 1'b0)uncoveredstates.push_front(allstate[i]);
	end
	
	if(uncoveredstates.size != 0) begin
	#1;
		$display("||======================================================================================================||");
		$display("\t\t STATES THAT WERE NOT ENTERED DURING THE TRANSACTION = %0p \t\t\t\t",uncoveredstates);
		$display("||======================================================================================================||\n");
		//$display("||======================================================================================================||");
		//$display("|| Reset | Ten | Twenty |    Total      |   State  |   NextState  | Bill | Ready | Dispense | ReturnTen ||");
		//$display("||======================================================================================================||");
		uncoveredstates.delete;
		@(negedge dispense);
	end

endtask

task statelisting;
	tb_state = tb_state.first;
	for (int i=0;i<tb_state.num;i++) begin
		allstate.push_front(tb_state.next(i));
	end
	allstate = allstate.unique;			//Not required just for fun
	`ifdef DEBUG
	$display("List of all the states = %p",allstate);
	`endif
endtask

initial begin
$display("||                             #######Start Of Simulation FSM###########                                ||\n||--------------Cost of the ticket = %0s\t\t\tCLOCK_PERIOD = %0d ----------------||",cost,CLOCK_PERIOD);
$display("||======================================================================================================||");
$display("|| Reset | Ten | Twenty |    Total      |   State  |   NextState  | Bill | Ready | Dispense | ReturnTen ||");
$display("||======================================================================================================||");
$monitor("||  %3b  | %2b  | %6b | %13s | %8s |  %9s   | %3b  |  %3b  |   %4b   |   %5b   ||",rst_n,ten,twenty,fsm1.total.name,fsm1.state.name,fsm1.next.name,bill,ready,dispense,returnten);
end

initial begin
	statelisting;
	reset;
	defaultcase;
	onlytens;
	onlytwenties;
	pulsingtens;
	overpayment;
	randominputs;
	random_delay_random_inputs;
	resetduringtransaction;
	@(negedge clk);
	@(negedge clk);
	summary;
	$finish;
end

task defaultcase;
$display("||===============================Test Case Default Payment 10,20,10=====================================||");
$display("|| Reset | Ten | Twenty |    Total      |   State  |   NextState  | Bill | Ready | Dispense | ReturnTen ||");
$display("||======================================================================================================||");
@(negedge clk);
ten = TRUE;
@(negedge clk);			 // total = $10
ten = FALSE;
twenty = TRUE;
@(negedge clk);			// total = $30
twenty = FALSE;
@(negedge clk);
ten = TRUE;				//total = $40
@(negedge clk);
ten=FALSE;
@(negedge clk);
@(negedge clk);

$display("||===============================Test Case Default Payment 20,10,10=====================================||");
$display("|| Reset | Ten | Twenty |    Total      |   State  |   NextState  | Bill | Ready | Dispense | ReturnTen ||");
$display("||======================================================================================================||");
@(negedge clk);
{ten,twenty} = {FALSE,TRUE};	// total = $20
@(negedge clk);			 
{ten,twenty} = {TRUE,FALSE};	// total = $30
@(negedge clk);			
{ten,twenty} = {TRUE,FALSE};	// total = $40
@(negedge clk);
{ten,twenty} = {FALSE,FALSE};	
@(negedge clk);
@(negedge clk);
endtask

task overpayment;
$display("||===============================Test Case Overpayment Payment 10,20,20=================================||");
$display("|| Reset | Ten | Twenty |    Total      |   State  |   NextState  | Bill | Ready | Dispense | ReturnTen ||");
$display("||======================================================================================================||");
@(negedge clk);
ten = TRUE;
@(negedge clk); 	// total = 10
ten = FALSE;
twenty = TRUE;
@(negedge clk);		// total = 30
twenty = FALSE;
@(negedge clk);
twenty = TRUE;		//$50
@(negedge clk);
twenty = FALSE;
@(negedge clk);
@(negedge clk);

$display("||===============================Test Case Overpayment Payment 20,10,20=================================||");
$display("|| Reset | Ten | Twenty |    Total      |   State  |   NextState  | Bill | Ready | Dispense | ReturnTen ||");
$display("||======================================================================================================||");
@(negedge clk);
{ten,twenty} = {FALSE,TRUE};	// total = $20
@(negedge clk);			 
{ten,twenty} = {TRUE,FALSE};	// total = $30
@(negedge clk);			
{ten,twenty} = {FALSE,TRUE};	// total = $50//Overpayment
@(negedge clk);
{ten,twenty} = {FALSE,FALSE};	
@(negedge clk);
@(negedge clk);
endtask

task onlytens;
$display("||===============================Test Case OnlyTens Payment 10,10..=====================================||");
$display("|| Reset | Ten | Twenty |    Total      |   State  |   NextState  | Bill | Ready | Dispense | ReturnTen ||");
$display("||======================================================================================================||");
@(negedge clk);
ten = 1'b1;
repeat(10)@(negedge clk);
ten = 1'b0;
@(negedge clk);
endtask

task onlytwenties;
$display("||===============================Test Case OnlyTwenties Payment 20, 20...===============================||");
$display("|| Reset | Ten | Twenty |    Total      |   State  |   NextState  | Bill | Ready | Dispense | ReturnTen ||");
$display("||======================================================================================================||");
@(negedge clk);
twenty = 1'b1;
repeat(2)@(negedge clk);
twenty = 1'b0;
@(negedge clk);
endtask

task pulsingtens;
$display("||===============================Test Case Pulsing Tens Payment 10,0,10,0...============================||");
$display("|| Reset | Ten | Twenty |    Total      |   State  |   NextState  | Bill | Ready | Dispense | ReturnTen ||");
$display("||======================================================================================================||");
repeat(4) begin
	@(negedge clk);
	ten = 1'b1;
	@(negedge clk);
	ten = 1'b0;
end
	@(negedge clk);
endtask

task randominputs;
$display("||===============================Random Mutually Exclusive Inputs, Verification required..!!============||");
$display("|| Reset | Ten | Twenty |    Total      |   State  |   NextState  | Bill | Ready | Dispense | ReturnTen ||");
$display("||======================================================================================================||");
repeat(4) begin						// Making Ten random first
	@(negedge clk);
	ten = $random;
	if(ten == TRUE)	twenty = FALSE;
	else twenty = $random;
end
@(negedge clk);
@(negedge clk);

$display("||===============================Random Mutually Exclusive Inputs, Verification required..!!============||");
$display("|| Reset | Ten | Twenty |    Total      |   State  |   NextState  | Bill | Ready | Dispense | ReturnTen ||");
$display("||======================================================================================================||");
repeat(4) begin					// Making Twenty random first
	@(negedge clk);
	twenty = $random;
	if(twenty == TRUE)	ten = FALSE;
	else ten = $random;
end
@(negedge clk);
@(negedge clk);

endtask

task resetduringtransaction;
$display("||=============================== Reset during a normal transaction ====================================||");
$display("|| Reset | Ten | Twenty |    Total      |   State  |   NextState  | Bill | Ready | Dispense | ReturnTen ||");
$display("||======================================================================================================||");
@(negedge clk);
ten = TRUE;
@(negedge clk);			 // total = $10
ten = FALSE;
twenty = TRUE;
@(negedge clk);			// total = $30
reset;
repeat(2)@(negedge clk);
@(negedge clk);
{ten,twenty} = {FALSE,TRUE};	// total = $20
@(negedge clk);			 
{ten,twenty} = {TRUE,FALSE};	// total = $30
@(negedge clk);			
{ten,twenty} = {TRUE,FALSE};	// total = $40
@(negedge clk);
{ten,twenty} = {FALSE,FALSE};	
@(negedge clk);
@(negedge clk);
endtask

task random_delay_random_inputs;
int N;
$display("||=================Mutually Exclusive Random Inputs with Random Delays, Verification required..!!=======||");
$display("|| Reset | Ten | Twenty |    Total      |   State  |   NextState  | Bill | Ready | Dispense | ReturnTen ||");
$display("||======================================================================================================||");
twenty = 0;
ten = 0;
repeat (8) begin
	N=$random_range(10);
	repeat(N) @(negedge clk);
		ten = $random;
		twenty= !ten;
		@(negedge clk);
end
@(negedge clk);
endtask

task reset;
rst_n = 1'b0;
ten = FALSE;
twenty = FALSE;
repeat(2)@(posedge clk);
@(negedge clk);
rst_n = 1'b1;
endtask

always@(posedge dispense) ticketcount++;
always@(posedge returnten) returntencount++;
task summary;
$display("**Error Code Information = Time,twenty.ten                                                              ||");
$display("||===================================    SUMMARY    ====================================================||");
$display("||===========================    No of tickets dispensed = %0d    =======================================||",ticketcount);
$display("||===========================    No of tickets $10s returned = %0d    ====================================||",returntencount);
endtask


endmodule