/*
 TungstenHammer CSCI320
 Michael Hammer - Son Pham - Tung Phan
 MIPS CPU Implementation
 Based on Harris & Harris' "Digital Design and Computer Architecture" (2012)
 */

`include "include/mips.h"

/*
 signExtend - module to handle different situations of extending the immediate
 value.
 
 INPUT
 ImmEx: 2-bit control signal from control module to indicate which mode of 
 extending we are using
 immediate: 16-bit immediate value to be extended
 
 OUTPUT
 extended_immediate: 32-bit extended immediate value
 */
module signExtend(ImmEx, immediate, extended_immediate);
   input [1:0] ImmEx;
   input [15:0] immediate;
   output [31:0] extended_immediate;

   reg [31:0] 	 extended_immediate_next;

   assign extended_immediate = extended_immediate_next;

   always @(*)
     begin
	case (ImmEx)
	  `ZeroExImm:
	    extended_immediate_next = {16'b0,immediate};
	  `ZeroExUpImm:
	    extended_immediate_next = {immediate, 16'b0};
	  `SignExImm:
	    extended_immediate_next = {{16{immediate[15]}},immediate};
	  default:
	    extended_immediate_next = `dc32;
	endcase // case (ImmEx)	
     end

endmodule // signExtend
