/*
 TungstenHammer CSCI320
 Michael Hammer - Son Pham - Tung Phan
 MIPS CPU Implementation
 Based on Harris & Harris' "Digital Design and Computer Architecture" (2012)
 */

`include "include/mips.h"

/*
 comparer - Module that handles all comparing operations required for the branch
 instructions
 
 input:
 in01, in1: 32-bit values to compare
 CompareMode: control signals from control module, signaling which type of compare we need. All CompareMode are listed in include/mips.h
 
 output:
 result: 1-bit value result indicating if the condition is met or not
 */
module comparer(in0, in1, CompareMode, result);
   input [31:0] in0;
   input [31:0] in1;
   input [2:0]	CompareMode;
   
   output reg	result;

   wire 	beq_result;
   wire 	bne_result;
   wire 	bltz_result;
   wire 	bgtz_result;
   

   initial
     begin
	result <= `false;
     end
   
   assign beq_result = (in0 == in1);
   assign bne_result = ~(in0 == in1);
   assign bltz_result = (in0[31] == 1'b1);
   assign bgtz_result = (in0[31] == 1'b0) & (in0[30:0] != 31'b0);   

   always @(*)
     begin
	case(CompareMode)
	  `Compare_NULL:
	    result <= `false;
	  `Compare_BEQ:
	    result <= beq_result;
	  `Compare_BNE:
	    result <= bne_result;
	  `Compare_BLTZ:
	    result <= bltz_result;
	  `Compare_BGTZ:
	    result <= bgtz_result;
	  default:
	    result <= `false;
	endcase // case (CompareMode)
     end
endmodule // comparer
