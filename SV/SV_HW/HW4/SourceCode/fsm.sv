//Nilesh Dattani
// Homework : 4
// Date : 4/30/2014
// Assumptions :		
//				1. Sensor inputs are de-bounced and conditioned to work with system clock
// Draft 0.1
// Changes made :
// 1. 
`include "fsm_enums.sv"
//`define WARNING
import fsm_enums::*;


module fsm(	input clk,						// Clock Input
			input rst_n,					// Reset Input
			input ten,						// Sensor indication : Ten Dollars
			input twenty,					// Sensor indication : Twenty Dollars
			output logic ready,				// Output : To show that the system is ready to begin a transaction
			output logic bill,				// Output : To show that additional bills must be inserted to reach $40
			output logic dispense,			// Output : Dispense the ticket/bill
			output logic returnten);		// Output : Overpayment made return $10


						
parameter cost = fortydollars;
localparam costplus10 = cost<<1;
// Parameter for calculation of available cash, this is to simplify Arithmetic, the shifts could be used adder operations
// Special care has been taken to assign relative weights, i.e. tendollars < twentydollars in absolute terms
// Parameter for State Variable						
// Declaration Space
onehotcash total;				// Keeping track of cash-inflow
state_encode state,next;		// State Variable


// Next State Assignment 
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n)
		state <= RESET; 				// Reset to reset to state
	else 
		state <= next;
end

/*always_ff @(posedge clk, negedge rst_n, posedge dispense) begin
	if (!rst_n || dispense)
		total <= zerodollar;				// Reset to reset to state
	else if((ten || twenty) && (bill === 1'b0 && ready ===1'b0)) begin $display("Illegal cash input............."); total <=total; end
	else if(ten && !twenty)
		total <= total.next;
	else if(!ten && twenty)
		total <= total.next(2);
	else if(!ten && !twenty)
		total <=total;
	else if(ten && twenty)
		$display("Error: Both Ten and Twenty are given at the same time");	
	 
end*/

always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n || dispense)
		total <= zerodollar;				// Reset to reset to state
	else if((ten || twenty) && (total>=cost)) begin 
		`ifdef WARNING
		$display("||     Illegal $$ input.-->If $$ not returned, note down the errorcode = %0t,%0b.%0b and contact admin  ||",$time,twenty,ten); 
		`endif
		 end 
	else if(ten && !twenty)
		total <= total.next;
	else if(!ten && twenty)
		total <= total.next(2);
	else if(!ten && !twenty)
		total <=total;
	else if(ten && twenty) begin
		`ifdef WARNING
		$display("Error: Both Ten and Twenty are given at the same time");	
		`endif
		end	 
end

always_comb begin: set_next_state
	next = state;
	unique case(state)
		RESET : begin
			if(rst_n) next = RDY;
		end
		
		RDY : begin
		if(total > zerodollar) next = COLLECT; 	
		end
		
		COLLECT: begin
			if(total == cost) next = DISPENSE;
			else if(total == costplus10) begin next = RETTEN;  end
			else if(total > costplus10) begin  $display("Error total exceeded maximum possible value"); end
		end
		
		RETTEN	 : begin
			next = DISPENSE;		
		end
		
		DISPENSE : begin
			next = RDY;
		end
		
	endcase
end :set_next_state

always_comb begin : set_variables_outputs
	
	unique case(state) 
		RESET : begin
			 ready		= 1'b0;						// FSM in reset state, not ready for transaction
			 bill		= 1'b0;						// FSM in reset state, so user should not be prompted for cash
		     dispense   = 1'b0;						// No dispense required
             returnten  = 1'b0;						// No return required
		end
			 
		RDY : begin
			 ready		= 1'b1;						// FSM Ready for transaction
			 bill		= 1'b0;						// Waiting for user to begin the transaction
		     dispense   = 1'b0;						// No dispense required
             returnten  = 1'b0;						// No return required
		end
			
				
		COLLECT : begin
			ready		= 1'b0;						// FSM Processing a transaction, so not ready for new transaction
			bill		= 1'b1;						// To show that additional bills must be inserted to reach $40
		    dispense  	= 1'b0;						// No dispense required
			returnten  	= 1'b0;						// No return required 
			//$display("From Design ********************State : COLLECT, total = %s",total.name);
		end
		
		RETTEN : begin
			ready		= 1'b0;						// FSM Processing a transaction, so not ready for new transaction
			bill		= 1'b0;						// To show that additional cash is not required
		    dispense  	= 1'b0;						// No dispense required
			returnten  	= 1'b1;						// Return Ten Dollars 
			//$display("From Design**********************State : RETTEN, total = %s",total.name);		
		end
		
		DISPENSE : begin
			ready		= 1'b0;						// FSM Processing a transaction, so not ready for new transaction
			bill		= 1'b0;						// To show that additional cash is not required
			returnten  	= 1'b0;					// No return required
			dispense  	= 1'b1;						// Dispense the ticket as required cash has been acquired
		end
endcase
end
endmodule



