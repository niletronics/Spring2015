// =======================================================================
//   Filename:     clkgen.sv

`timescale 1ns/1ps

// Define module
module clkgen
  (
   output clk
   );

   // Define parameters
   parameter CLOCK_PERIOD = 10;

   // Define internal registers
   reg int_clk;

   // Generate fixed frequency internal clock
   initial begin
      int_clk = 0;
      forever #(CLOCK_PERIOD/2) int_clk = ~int_clk;
   end
   
   

   // Continuous assignment to output
   assign clk     = int_clk;

endmodule

