/*
 *  TungstenHammer CSCI320
 *   Michael Hammer - Son Pham - Tung Phan
 *    MIPS CPU Implementation
 *     Based on Harris & Harris' "Digital Design and Computer Architecture"
 *     (2012)
 */


/**
 * pipeReg_DE
 * This module represents the piipeline register between the Decode
 * and Execute stages.
 * INPUTS:
 * A clock to control releasing and updating values in the register.
 * A control signal to flush the values in the register.
 * Values to store in the register from the Decode stage.
 * OUTPUTS:
 * Values to output into the Execute stage.
 */
module pipeReg_DE(CLK, FlushE, 
		  InstructD, RegWriteD, MemtoRegD, MemWriteD, ALUControlD,
		  ALUSrcD, RegDstD, JumpD, LinkD, JumpRegD, BranchD, 
		  RD1D, RD2D, RsD, RtD, RdD, SignImmD,
		  PCPlus8D, JumpAddrD, WriteLoHiD, StoreByteD, LoadByteD,
		  ReadHiD, ReadLoD,
		  
                  InstructE, RegWriteE, MemtoRegE, MemWriteE, ALUControlE, 
		  ALUSrcE, RegDstE, JumpE, LinkE, JumpRegE, BranchE, 
		  RD1E, RD2E, RsE, RtE, RdE, SignImmE,
		  PCPlus8E, JumpAddrE, WriteLoHiE, StoreByteE, LoadByteE,
		  ReadHiE, ReadLoE);
   // Control Input
   input CLK;
   input FlushE; // clear

   input [31:0] InstructD;
   input 	RegWriteD;
   input 	MemtoRegD;
   input 	MemWriteD;
   input [3:0] 	ALUControlD;
   input 	ALUSrcD;
   input 	RegDstD;
   input 	JumpD;
   input 	LinkD;
   input 	JumpRegD; 
   input 	BranchD;
   input [31:0] RD1D;
   input [31:0] RD2D;
   input [4:0] 	RsD;
   input [4:0] 	RtD;
   input [4:0] 	RdD;
   input [31:0] SignImmD;
   input [31:0] PCPlus8D;
   input [31:0] JumpAddrD;
   input        WriteLoHiD;
   input 	StoreByteD;
   input 	LoadByteD;
   input 	ReadLoD;
   input 	ReadHiD;
   
   output [31:0] InstructE;
   output 	 RegWriteE;
   output 	 MemtoRegE;
   output 	 MemWriteE;
   output [3:0]  ALUControlE;
   output 	 ALUSrcE;
   output 	 RegDstE;
   output 	 JumpE;
   output	 LinkE;
   output 	 JumpRegE;
   output 	 BranchE;
   output [31:0] RD1E;
   output [31:0] RD2E;
   output [4:0]  RsE;
   output [4:0]  RtE;
   output [4:0]  RdE;
   output [31:0] SignImmE;
   output [31:0] PCPlus8E;
   output [31:0] JumpAddrE;
   output 	 WriteLoHiE;
   output 	 StoreByteE;
   output 	 LoadByteE;
   output 	 ReadLoE;
   output 	 ReadHiE;
   

   // Registers to temporarily store inputs
   reg [31:0]    InstructD_buf = 0;
   reg 		 RegWriteD_buf = 0;
   reg 		 MemtoRegD_buf = 0;
   reg 		 MemWriteD_buf = 0;
   reg [3:0] 	 ALUControlD_buf = 0;
   reg 		 ALUSrcD_buf = 0;
   reg 		 RegDstD_buf = 0;
   reg 		 JumpD_buf = 0;
   reg 		 LinkD_buf = 0;
   reg 		 JumpRegD_buf = 0;
   reg 		 BranchD_buf = 0;
   reg [31:0] 	 RD1D_buf = 0;
   reg [31:0] 	 RD2D_buf = 0;
   reg [4:0] 	 RsD_buf = 0;
   reg [4:0] 	 RtD_buf = 0;
   reg [4:0] 	 RdD_buf = 0;
   reg [31:0] 	 SignImmD_buf = 0;
   reg [31:0] 	 PCPlus8D_buf = 0;
   reg [31:0] 	 JumpAddrD_buf = 0;
   reg 		 WriteLoHiD_buf = 0;
   reg 		 StoreByteD_buf = 0;
   reg 		 LoadByteD_buf = 0;
   reg 		 ReadLoD_buf = 0;
   reg 		 ReadHiD_buf = 0;
		 
   // Assign register values to outputs
   assign InstructE = InstructD_buf;
   assign RegWriteE = RegWriteD_buf;
   assign MemtoRegE = MemtoRegD_buf;
   assign MemWriteE = MemWriteD_buf;
   assign ALUControlE = ALUControlD_buf;
   assign ALUSrcE = ALUSrcD_buf;
   assign RegDstE = RegDstD_buf;
   assign JumpE = JumpD_buf;
   assign LinkE = LinkD_buf;
   assign JumpRegE = JumpRegD_buf;
   assign BranchE = BranchD_buf;
   assign RD1E = RD1D_buf;
   assign RD2E = RD2D_buf;
   assign RsE = RsD_buf;
   assign RtE = RtD_buf;
   assign RdE = RdD_buf;
   assign SignImmE = SignImmD_buf;
   assign PCPlus8E = PCPlus8D_buf;
   assign JumpAddrE = JumpAddrD_buf;
   assign WriteLoHiE = WriteLoHiD_buf;
   assign StoreByteE = StoreByteD_buf;
   assign LoadByteE = LoadByteD_buf;
   assign ReadLoE = ReadLoD_buf;
   assign ReadHiE = ReadHiD_buf;
      
   // Temporarily store input values to registers
   always @(posedge CLK) begin
      if ( FlushE ) begin
	 InstructD_buf <= 32'b0;
	 RegWriteD_buf <= 1'b0;
	 MemtoRegD_buf <= 1'b0;
	 MemWriteD_buf <= 1'b0;
	 ALUControlD_buf <= 4'd0;
	 ALUSrcD_buf <= 1'b0;
	 RegDstD_buf <= 1'b0;
	 JumpD_buf <= 1'b0;
	 LinkD_buf <= 1'b0;
	 JumpRegD_buf <= 1'b0;
	 BranchD_buf <= 1'b0;
	 RD1D_buf <= 32'd0;
	 RD2D_buf <= 32'd0;
	 RsD_buf <= 5'd0;
	 RtD_buf <= 5'd0;
	 RdD_buf <= 5'd0;
	 SignImmD_buf <= 32'd0;
	 PCPlus8D_buf <= 32'd0;
	 JumpAddrD_buf <= 32'd0;
	 WriteLoHiD_buf <= 1'b0;
	 StoreByteD_buf <= 1'b0;
	 LoadByteD_buf <= 1'b0;
	 ReadHiD_buf <= 1'b0;
	 ReadLoD_buf <= 1'b0;
	 
      end else begin 
	 InstructD_buf <= InstructD;
	 RegWriteD_buf <= RegWriteD;
	 MemtoRegD_buf <= MemtoRegD;
	 MemWriteD_buf <= MemWriteD;
	 ALUControlD_buf <= ALUControlD;
	 ALUSrcD_buf <= ALUSrcD;
	 RegDstD_buf <= RegDstD;
	 JumpD_buf <= JumpD;
	 LinkD_buf <= LinkD;
	 JumpRegD_buf <= JumpRegD;
	 BranchD_buf <= BranchD;
	 RD1D_buf <= RD1D;
	 RD2D_buf <= RD2D;
	 RsD_buf <= RsD;
	 RtD_buf <= RtD;
	 RdD_buf <= RdD;
	 SignImmD_buf <= SignImmD;
	 PCPlus8D_buf <= PCPlus8D;
	 JumpAddrD_buf <= JumpAddrD;
	 WriteLoHiD_buf <= WriteLoHiD;
	 StoreByteD_buf <= StoreByteD;
	 LoadByteD_buf <= LoadByteD;
	 ReadHiD_buf <= ReadHiD;
	 ReadLoD_buf <= ReadLoD;
      end
   end
endmodule
