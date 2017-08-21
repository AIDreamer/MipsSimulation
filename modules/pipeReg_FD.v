/*
 *  TungstenHammer CSCI320
 *   Michael Hammer - Son Pham - Tung Phan
 *    MIPS CPU Implementation
 *     Based on Harris & Harris' "Digital Design and Computer Architecture"
 *     (2012)
 */

`include "include/mips.h"
/**
 * pipeReg_FD
 * This module represents the pipeline register between the Fetch
 * and Decode stages.
 * INPUTS:
 * A clock to control the releasing and updating values in the register.
 * Control signals to clear and stall the register.
 * Input values to store in the register from the Fetch stage.
 * OUTPUTS:
 * Output values for the Decode stage.
 */
module pipeReg_FD(CLK, StallD, Clear, InstructF, RDF, PCPlus4F, InstructD, RDD, PCPlus4D);
   // Control Inputs
   input CLK;
   input StallD; // Stalling
   input Clear; // Flushing

   input [31:0] InstructF;
   input [31:0] RDF;
   input [31:0] PCPlus4F;

   output [31:0] InstructD;
   output [31:0] RDD;
   output [31:0] PCPlus4D;

   // Registers to temporarily store inputs
   reg [31:0]    InstructF_buf;
   reg [31:0] 	 RDF_buf;
   reg [31:0] 	 PCPlus4F_buf;

   initial begin
      InstructF_buf <= `zero32;
      RDF_buf <= `zero32;
      PCPlus4F_buf <= `zero32;     
   end
   // Assign register values to outputs
   assign InstructD = InstructF_buf;
   assign RDD = RDF_buf;
   assign PCPlus4D = PCPlus4F_buf;

   // Temporarily store input values to registers
   always @(posedge CLK) begin
      if (StallD) begin
	 InstructF_buf <= InstructF_buf;
	 RDF_buf <= RDF_buf;
	 PCPlus4F_buf <= PCPlus4F_buf;
      end else if (Clear) begin
	 InstructF_buf <= 32'd0;
	 RDF_buf <= 32'd0;
	 PCPlus4F_buf <= 32'd0;
      end else begin
	 InstructF_buf <= InstructF;
	 RDF_buf <= RDF;
	 PCPlus4F_buf <= PCPlus4F;
      end
   end
endmodule
