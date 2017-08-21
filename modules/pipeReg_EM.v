/*
 *  TungstenHammer CSCI320
 *   Michael Hammer - Son Pham - Tung Phan
 *   MIPS CPU Implementation
 *   Based on Harris & Harris' "Digital Design and Computer Architecture"
 *   (2012)
 */

/**
 * This module represents the pipeline regester between the Execute
 * and Memory stages.
 * INPUTS:
 * A clock signal to control releasing and updating values in the register.
 * Values to store in the register from the Execute stage.
 * OUTPUTS:
 * Values for the Memory stage.
 */
module pipeReg_EM(CLK, 
		  InstructE, RegWriteE, MemtoRegE, MemWriteE, 
		  JumpE, LinkE, JumpRegE, ALUOutE, 
		  WriteDataE, WriteRegE, SrcAE, SrcBE, PCPlus8E, JumpAddrE,
		  WriteLoHiE, loHi_dataE, StoreByteE, LoadByteE,
		  
                  InstructM, RegWriteM, MemtoRegM, MemWriteM, 
		  JumpM, LinkM, JumpRegM, ALUOutM, 
		  WriteDataM, WriteRegM, SrcAM, SrcBM, PCPlus8M, JumpAddrM,
		  WriteLoHiM, loHi_dataM, StoreByteM, LoadByteM,
		  );

   input CLK;
   input [31:0] InstructE;
   input 	RegWriteE;
   input 	MemtoRegE;
   input 	MemWriteE;
   input 	JumpE;
   input 	LinkE;
   input 	JumpRegE; 
   input [31:0] ALUOutE;
   input [31:0] WriteDataE;
   input [4:0] 	WriteRegE;
   input [31:0] SrcAE, SrcBE;
   input [31:0] PCPlus8E;
   input [31:0] JumpAddrE;   
   input 	WriteLoHiE;
   input [63:0] loHi_dataE;
   input 	StoreByteE;
   input 	LoadByteE;
    	
   output [31:0] InstructM;
   output 	 RegWriteM;
   output 	 MemtoRegM;
   output 	 MemWriteM;
   output 	 JumpM;
   output 	 LinkM;
   output 	 JumpRegM;
   output [31:0] ALUOutM;
   output [31:0] WriteDataM;
   output [4:0]  WriteRegM;
   output [31:0] SrcAM, SrcBM;
   output [31:0] PCPlus8M;
   output [31:0] JumpAddrM;
   output 	 WriteLoHiM;
   output [63:0] loHi_dataM;
   output 	 StoreByteM;
   output 	 LoadByteM;
   
   // Registers to temporarily store inputs
   reg [31:0]    InstructE_buf = 0;
   reg 		 RegWriteE_buf = 0;
   reg 		 MemtoRegE_buf = 0;
   reg 		 MemWriteE_buf = 0;
   reg 		 JumpE_buf = 0;
   reg 		 LinkE_buf = 0;
   reg 		 JumpRegE_buf = 0;
   reg [31:0] 	 ALUOutE_buf = 0;
   reg [31:0] 	 WriteDataE_buf = 0;
   reg [4:0] 	 WriteRegE_buf = 0;
   reg [31:0] 	 SrcAE_buf, SrcBE_buf = 0;
   reg [31:0] 	 PCPlus8E_buf = 0;
   reg [31:0] 	 JumpAddrE_buf = 0;
   reg 		 WriteLoHiE_buf = 0;
   reg [63:0] 	 loHi_dataE_buf = 0;
   reg 		 StoreByteE_buf = 0;
   reg 		 LoadByteE_buf = 0;
   
   // Assign register values to outputs
   assign InstructM = InstructE_buf;
   assign RegWriteM = RegWriteE_buf;
   assign MemtoRegM = MemtoRegE_buf;
   assign MemWriteM = MemWriteE_buf;
   assign JumpM = JumpE_buf;
   assign LinkM = LinkE_buf;
   assign JumpRegM = JumpRegE_buf;
   assign ALUOutM = ALUOutE_buf;
   assign WriteDataM = WriteDataE_buf;
   assign WriteRegM = WriteRegE_buf;
   assign SrcAM = SrcAE_buf;
   assign SrcBM = SrcBE_buf;
   assign PCPlus8M = PCPlus8E_buf;
   assign JumpAddrM = JumpAddrE_buf;
   assign WriteLoHiM = WriteLoHiE_buf;
   assign loHi_dataM = loHi_dataE_buf;
   assign StoreByteM = StoreByteE_buf;
   assign LoadByteM = LoadByteE_buf;
   
   // Temporarily store input values to registers
   always @(posedge CLK) begin
      InstructE_buf <= InstructE;
      RegWriteE_buf <= RegWriteE;
      MemtoRegE_buf <= MemtoRegE;
      MemWriteE_buf <= MemWriteE;
      JumpE_buf <= JumpE;
      LinkE_buf <= LinkE;
      JumpRegE_buf <= JumpRegE;
      ALUOutE_buf <= ALUOutE;
      WriteDataE_buf <= WriteDataE;
      WriteRegE_buf <= WriteRegE;
      SrcAE_buf <= SrcAE;
      SrcBE_buf <= SrcBE;
      PCPlus8E_buf <= PCPlus8E;
      JumpAddrE_buf <= JumpAddrE;
      WriteLoHiE_buf <= WriteLoHiE;
      loHi_dataE_buf <= loHi_dataE;
      StoreByteE_buf <= StoreByteE;    
      LoadByteE_buf <= LoadByteE;
   end
endmodule
