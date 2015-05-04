//Nilesh Dattani
// Homework : 4
// Date : 4/30/2014
// Assumptions :		
//				1. Sensor inputs are de-bounced and conditioned to work with system clock
// Draft 0.1
// Changes made :
// 1. 

module fsm_old(	input clk,						// Clock Input
			input rst_n,					// Reset Input
			input ten,						// Sensor indication : Ten Dollars
			input twenty,					// Sensor indication : Twenty Dollars
			output logic ready,				// Output : To show that the system is ready to begin a transaction
			output logic bill,				// Output : To show that additional bills must be inserted to reach $40
			output logic dispense,			// Output : Dispense the ticket/bill
			output logic returnten);		// Output : Overpayment made return $10

// Parameter for calculation of available cash, this is to simplify Arithmetic, the shifts could be used adder operations
// Special care has been taken to assign relative weights, i.e. tendollars < twentydollars in absolute terms
typedef enum logic[7:0] {	zerodollar		= 	8'b0000_0001,
							tendollars 		= 	8'b0000_0010,
							twentydollars	=	8'b0000_0100,
							thirtydollars 	=	8'b0000_1000,
							fortydollars	=	8'b0001_0000,
							fiftydollars	=	8'b0010_0000
							//sixtydollars	=	8'b0100_0000,		// For future price increase..!!
							//seventydollars	=	8'b1000_0000	// For future future price increase...!!!
						 }onehotcash;			
		  
// Parameter for State Variable
typedef enum logic [4:0] {	RESET 		= 5'b00000,
							RDY			= 5'b00001,
							ADD10		= 5'b00010,
							ADD20		= 5'b00100,
							COMPLETE	= 5'b01000
						}state_encode;
						
parameter cost = fortydollars;
						
// Declaration Space
onehotcash total;				// Keeping track of cash-inflow
state_encode state,next;		// State Variable
int temp;

// Next State Assignment 
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n)
		state <= RESET; 				// Reset to reset to state
	else 
		state <= next;
	
	//unique case(state) 
	//RESET : total <= zerodollar;
	//RDY : total <= total;
	//ADD10 : total <= total.next;
	//ADD20 : total <= total.next(2);
	//COMPLETE : total <= zerodollar;
	//endcase
end

always@(posedge clk)$display("State = %s Next State = %s ",state,next);


always_comb begin: set_next_state
	next = state;
	unique case(state)
		RESET : begin
			if(rst_n) next = RDY;			// To show that the system is ready to begin a transaction
		end
		
		RDY : begin
			if(ten) next = ADD10;				// To add $10 to total
			if(twenty) next = ADD20;			// To add $20 to total
		end
		
		ADD10: begin 
			if((total < cost) && twenty)
				next = ADD20;
			else if(total >= cost) next = COMPLETE;
			else next = RDY;
		end
		
		ADD20 : begin
		if((total < cost) && ten)	next = ADD10;
		else if(total >= cost) next = COMPLETE;
		else next = RDY;
		end
		
		COMPLETE : next = RDY;
		
	endcase
end :set_next_state

always_comb begin : set_variables_outputs
	
	unique case(state) 
		RESET : begin
			 ready		= 1'b0;						// FSM in reset state, not ready for transaction
			 bill		= 1'b0;						// FSM in reset state, so user should not be prompted for cash
		     dispense   = 1'b0;						// No dispense required
             returnten  = 1'b0;						// No return required
			 total		= zerodollar;				// Initialize cash total to zerodollar
			 end
			 
		RDY : begin
			 ready		= 1'b1;						// FSM Ready for transaction
			 bill		= 1'b0;						// Waiting for user to begin the transaction
		     dispense   = 1'b0;						// No dispense required
             returnten  = 1'b0;						// No return required
			 total		= total;				// Initialize cash total to zerodollar
		end
			
		ADD10 : begin
			ready		= 1'b0;						// FSM Processing a transaction, so not ready for new transaction
			bill		= 1'b1;						// To show that additional bills must be inserted to reach $40
		    dispense  	= 1'b0;						// No dispense required
			returnten  	= 1'b0;						// No return required 
			$display("State : ADD10, total = %s",total);
            total = (ten) ? total.next : total;					// Cash total increased by tendollars
			//total =  total.next;					// Cash total increased by tendollars
			$display("temp = %d",temp++);
			$display("State : ADD10, total = %s",total);
		end
			
		ADD20 : begin
			ready		= 1'b0;						// FSM Processing a transaction, so not ready for new transaction
			bill		= 1'b1;						// To show that additional bills must be inserted to reach $40
		    dispense  	= 1'b0;						// No dispense required
			returnten  	= 1'b0;						// No return required 
			$display("State : ADD20, total = %s",total);
            total = (twenty) ? total.next(2):total;	// Cash total increased by twentydollars
			//total = total.next(2);	// Cash total increased by twentydollars
			$display("State : ADD20, total = %s",total);
			
		end
		
		COMPLETE : begin
			ready		= 1'b0;						// FSM Processing a transaction, so not ready for new transaction
			bill		= 1'b0;						// To show that additional cash is not required
            dispense  	= 1'b1;						// Dispense the ticket as required cash has been acquired
			$display("State : COMPLETE, total = %s",total);
            returnten  	= (total.prev(4) == zerodollar) ? 1'b0 : 1'b1;	
			$display("State : COMPLETE, total = %s",total);			
            total		= total ;					
		end
endcase
end
endmodule



