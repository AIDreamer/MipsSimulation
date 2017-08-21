/*
 *  TungstenHammer CSCI320
 *   Michael Hammer - Son Pham - Tung Phan
 *    MIPS CPU Implementation
 *     Based on Harris & Harris' "Digital Design and Computer Architecture"
 *     (2012)
 */

/** 
 * pipeReg_PC
 * This module represents the pipeline regester for the Program Counter entering 
 * the Fetch Stage.
 * INPUTS:
 * A clock signal to control when the regester releases and updates its
 * values.
 * A control signal to cause the register to not update its values.
 * An input signal for the value of pc.
 * OUTPUTS:
 * An output value for the pc in the Fetch stage.
 */
module pipeReg_PC(CLK, StallF, pc, pcF);
   // Control Input
   input CLK;
   input StallF; // enable

   input [31:0] pc;

   output [31:0] pcF;

   // Registers to temporarily store inputs
   reg [31:0] 	 pc_buf;

   initial
     pc_buf <= 32'h00400030;
   
   // Assign register values to outputs
   assign pcF = pc_buf;

   // Temporarily store input values to registers
   always @(posedge CLK) begin
      if ( !StallF ) // if it should not stall
	pc_buf <= pc;
      else
	pc_buf <= pc_buf;
   end
endmodule
