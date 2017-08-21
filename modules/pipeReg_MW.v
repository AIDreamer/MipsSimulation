/*
 *  TungstenHammer CSCI320
 *   Michael Hammer - Son Pham - Tung Phan
 *   MIPS CPU Implementation
 *   Based on Harris & Harris' "Digital Design and Computer Architecture"
 *   (2012)
 */


/**
 * This module represents the pupeline register between the Memory
 * and Write stages.
 * INPUTS:
 * A clock signal to control updating and releasing values in the register.
 * Values to store from the Memory stage.
 * OUTPUTS:
 * Values for the Write stage.
 */
module 
pipeReg_MW( CLK, InstructM, 
	    RegWriteM, MemtoRegM, 
	    JumpM, LinkM, JumpRegM,
	    ReadDataM, ALUOutM, WriteRegM, 
	    PCPlus8M, JumpAddrM,
	    WriteLoHiM, loHi_dataM,

            RegWriteW, MemtoRegW, 
	    JumpW, LinkW, JumpRegW,
	    ReadDataW, ALUOutW, WriteRegW,
	    PCPlus8W, JumpAddrW,
	    WriteLoHiW, loHi_dataW, InstructW
	    );

   input CLK;
   input [31:0] InstructM;
   input RegWriteM;
   input MemtoRegM;
   input JumpM;
   input LinkM;
   input JumpRegM; 
   input [31:0] ReadDataM;
   input [31:0] ALUOutM;
   input [4:0] WriteRegM;
   input [31:0] PCPlus8M;
   input [31:0] JumpAddrM;
   input 	WriteLoHiM;
   input [63:0] loHi_dataM;
   

   output 	RegWriteW;
   output 	MemtoRegW;
   output 	JumpW;
   output 	LinkW;
   output 	JumpRegW;
   output [31:0] ReadDataW;
   output [31:0] ALUOutW;
   output [4:0] WriteRegW;
   output [31:0] PCPlus8W;
   output [31:0] JumpAddrW;
   output 	 WriteLoHiW;
   output [63:0] loHi_dataW;
   output [31:0] InstructW; 
   
   // Registers to temporarily store inputs
   reg 		 RegWriteM_buf = 0;
   reg 		 MemtoRegM_buf = 0;
   reg 		 JumpM_buf = 0;
   reg 		 LinkM_buf = 0;
   reg 		 JumpRegM_buf = 0;
   reg [31:0] 	 ReadDataM_buf = 0;
   reg [31:0] 	 ALUOutM_buf = 0;
   reg [4:0] 	 WriteRegM_buf = 0;
   reg [31:0] 	 PCPlus8M_buf = 0;
   reg [31:0] 	 JumpAddrM_buf = 0;
   reg 		 WriteLoHiM_buf = 0;
   reg [63:0] 	 loHi_dataM_buf = 0;
   reg [31:0] 	 InstructM_buf = 0;
   
   // Assign register values to outputs
   assign RegWriteW = RegWriteM_buf;
   assign MemtoRegW = MemtoRegM_buf;
   assign JumpW = JumpM_buf;
   assign LinkW = LinkM_buf;
   assign JumpRegW = JumpRegM_buf;
   assign ReadDataW = ReadDataM_buf;
   assign ALUOutW = ALUOutM_buf;
   assign WriteRegW = WriteRegM_buf;
   assign PCPlus8W = PCPlus8M_buf;
   assign JumpAddrW = JumpAddrM_buf;
   assign WriteLoHiW = WriteLoHiM_buf;
   assign loHi_dataW = loHi_dataM_buf;
   assign InstructW = InstructM_buf;
   
   // Temporarily store input values to registers
   always @(posedge CLK) begin
      RegWriteM_buf <= RegWriteM;
      MemtoRegM_buf <= MemtoRegM;
      ReadDataM_buf <= ReadDataM;
      ALUOutM_buf <= ALUOutM;
      WriteRegM_buf <= WriteRegM;
      JumpM_buf <= JumpM;
      LinkM_buf <= LinkM;
      JumpRegM_buf <= JumpRegM;
      PCPlus8M_buf <= PCPlus8M;
      JumpAddrM_buf <= JumpAddrM;
      WriteLoHiM_buf <= WriteLoHiM;
      loHi_dataM_buf <= loHi_dataM;
      InstructM_buf <= InstructM;
            
      if ( InstructM[31:26] == 6'h00 & InstructM[5:0] == 6'h0D ) begin 
        $display("BREAK!! BreakPoint Exception."); 
	$finish();
	end
      else begin

      end
   end
endmodule

