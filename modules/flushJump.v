/*
 TungstenHammer CSCI320
 Michael Hammer - Son Pham - Tung Phan
 MIPS CPU Implementation
 Based on Harris & Harris' "Digital Design and Computer Architecture" (2012)
 */

`include "include/mips.h"
/*
 flushJumpBranch - A finite state machine that flushes the pipeline to avoid 
 Jump hazards while still maintaining single delay slot.
 */
module flushJump(CLK, Jump, Flush);

   parameter DEBUG_PRINT = `DEBUG_PRINT;
   
   input CLK;
   input Jump;
   
   output Flush;

   reg [2:0]	  instrCount;
   initial begin
      instrCount <= 0;
   end

   assign Flush = (~(instrCount == 0));

   //FSM for counting number of instructions to flush
   //It will flush 3 out of the 4 instructions after the Jump.
   
   always @(posedge CLK)
     begin
	if (Jump) 
	  begin
	     instrCount <= 1;
	     if(DEBUG_PRINT) $display("Stall for Jump Hazard");
	  end
	else
	  begin
	     if (instrCount == 0 | instrCount == 3)
	       instrCount <= 0;
	     else
	       begin
		  instrCount <= instrCount + 1;
		  if(DEBUG_PRINT) $display("Stall for Jump Hazard");
	       end
	  end // else: !if(Jump)
     end // always @ (negedge CLK)
endmodule // flushJumpBranch
