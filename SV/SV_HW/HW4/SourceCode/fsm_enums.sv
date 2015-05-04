package fsm_enums;
typedef enum logic [4:0] {	RESET 		= 5'b00000,
							RDY			= 5'b00001,
							COLLECT		= 5'b00010,
							RETTEN		= 5'b00100,
							DISPENSE	= 5'b01000
						}state_encode;

typedef enum  bit[7:0] {zerodollar		= 	8'b0000_0001,
						tendollars 		= 	8'b0000_0010,
						twentydollars	=	8'b0000_0100,
						thirtydollars 	=	8'b0000_1000,
						fortydollars	=	8'b0001_0000,
						fiftydollars	=	8'b0010_0000,
						sixtydollars	=	8'b0100_0000		// For future price increase..!!
						//seventydollars	=	8'b1000_0000	// For future future price increase...!!!
						}onehotcash;	


						 
						 
endpackage