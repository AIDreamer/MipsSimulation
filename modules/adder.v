/*
 TungstenHammer CSCI320
 Michael Hammer - Son Pham - Tung Phan
 MIPS CPU Implementation
 Based on Harris & Harris' "Digital Design and Computer Architecture" (2012)
 */

/*
 adder - add in1 and in2, output to out
 */
module adder(in1, in2, out);
   input [31:0] in1, in2;
   output [31:0] out;

   parameter DELAY = 100;
   
   reg [31:0] 	 out_next;

   assign #DELAY out = out_next;
   always @(*)
     out_next <= in1 + in2;
endmodule // adder
