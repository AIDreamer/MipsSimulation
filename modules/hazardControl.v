/*
 *  TungstenHammer CSCI320
 *   Michael Hammer - Son Pham - Tung Phan
 *   MIPS CPU Implementation
 *   Based on Harris & Harris' "Digital Design and Computer Architecture"
 *   (2012)
 */

/**
 * This module represents the hazard control until of the mips piipeline.
 * Using inputs from the pipeline it is able to determine if hazards will
 * occur and output the necessary signals to avoid them. The logic is 
 * mostly from the Harris & Harris textbook. 
 * INPUTS:
 * Registers being use.
 * Control signals.
 * OUTPUTS:
 * Signals for stalling, flushing, and forwarding.
 */
module hazardControl( rsD, rsE, rtD, rtE, 
		      WriteRegE, WriteRegM, WriteRegW,
		      BranchD, RegWriteE, RegWriteM, RegWriteW,
		      MemtoRegE, MemtoRegM, 
		      WriteLoHiM, WriteLoHiW, ReadLoE, ReadHiE,
		      
		      StallF, StallD, FlushE, ForwardAD, 
		      ForwardBD, ForwardAE, ForwardBE,
		      ForwardLoE, ForwardHiE);
   /* Define Inputs */
   input [4:0] rsD;
   input [4:0] rsE;
   input [4:0] rtD;
   input [4:0] rtE;
   input [4:0] WriteRegE;
   input [4:0] WriteRegM;
   input [4:0] WriteRegW;
   input       BranchD;
   input       BranchE;
   input       RegWriteE;
   input       RegWriteM;
   input       RegWriteW;
   input       MemtoRegE;
   input       MemtoRegM;
   input       WriteLoHiM;
   input       WriteLoHiW;
   input       ReadLoE;
   input       ReadHiE;       
   
   /* Define Outputs */
   output      StallF;
   output      StallD;
   output      FlushE;
   output      ForwardAD;
   output      ForwardBD;
   output [1:0] ForwardAE;
   output [1:0] ForwardBE;
   output [1:0]	ForwardLoE;
   output [1:0]	ForwardHiE;
   
   /* StallF, StallD, FlushE Logic */
   wire 		lwstall;
   wire 		branchstall;
   wire 		stallSignal;

   /* StallF, StallD, and FlushE logic */
   assign StallF = (stallSignal === 1'bx)? 1'b0 : stallSignal;
   assign StallD = (stallSignal === 1'bx)? 1'b0 : stallSignal;
   assign FlushE = (stallSignal === 1'bx)? 1'b0 : stallSignal;
   /* load word stall logic */
   assign lwstall = ((rsD == rtE) | (rtD == rtE)) & MemtoRegE;
   /* branch stall logic */
   assign branchstall = (BranchD & RegWriteE & (WriteRegE == rsD | WriteRegE == rtD)) | 
			(BranchD & MemtoRegM & (WriteRegM == rsD | WriteRegM == rtD));
   /* stall/flush if lwstall or branch stall is needed */
   assign stallSignal = lwstall | branchstall;

   /* ForwardLoHi Logic */
   assign ForwardLoE = {WriteLoHiM & ReadLoE, WriteLoHiW & ReadLoE};
   assign ForwardHiE = {WriteLoHiM & ReadHiE, WriteLoHiW & ReadHiE};
   
   /* ForwardAD Logic */
   wire 		regAD;
   assign ForwardAD = (regAD === 1'bx)? 1'b0 : regAD;
   assign regAD = (rsD != 0) & (rsD == WriteRegM) & RegWriteM;

   /* ForwardBD Logic */
   wire 		regBD;
   assign ForwardBD = (regBD === 1'bx)? 1'b0 : regBD;
   assign regBD =  (rtD != 0) & (rtD == WriteRegM) & RegWriteM;

   /* ForwardAE Logic */
   reg [1:0] 	regAE;
   assign ForwardAE = regAE;
   always @(*) begin
      if ((rsE != 0) & (rsE == WriteRegM) & RegWriteM) 
	regAE <= 2'b10;
      else if ((rsE != 0) & (rsE == WriteRegW) & RegWriteW)
	regAE <= 2'b01;
      else
	regAE <= 2'b00;
   end // always @ begin

   /* ForwardBE Logic */
   reg [1:0] regBE;
   assign ForwardBE = regBE;
   always @(*) begin
	if ((rtE != 0) & (rtE == WriteRegM) & RegWriteM) 
	  regBE <= 2'b10;
	else if ((rtE != 0) & (rtE == WriteRegW) & RegWriteW)
	  regBE <= 2'b01;
	else
	  regBE <= 2'b00;
   end // always @ begin

   
endmodule // hazardControl
