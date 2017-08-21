/*
 TungstenHammer CSCI320
 Michael Hammer - Son Pham - Tung Phan
 MIPS CPU Implementation
 Based on Harris & Harris' "Digital Design and Computer Architecture" (2012)
 */

`timescale 1ns/1ns
`include "include/mips.h"

/*
 processor.v - Our master module to wire multiple components together to 
 make the pipelined CPU
 There are many different wires divided into different stages of the pipeline.
 There is only 1 variable reg - the CLK signal to sync various modules up.
 To disable/enable debug printing, change accordingly in include/mips.h
 */
module processor;

   //Printing debug information
   parameter DEBUG_PRINT = `DEBUG_PRINT;
   //Printing performance statistics information
   parameter STATS_PRINT = `STATS_PRINT;
   
   
   reg CLK;

   //wires for Hazard Unit
   wire [1:0] ForwardAE, ForwardBE;
   wire [1:0] ForwardLoE, ForwardHiE;
   wire StallF, StallD, FlushE, ForwardAD, ForwardBD;

   //Wires for Control Unit and pipelines
   wire        RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD, BranchD,
	       JumpD, LinkD, JumpRegD, ReadHiD, ReadLoD, WriteLoHiD, 
	       StoreByteD, LoadByteD;
   wire [1:0]  ImmExD;
   wire [3:0]  ALUControlD;
   wire [2:0]  CompareModeD;
   
   wire        RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE,
	       JumpE, LinkE, JumpRegE, ReadHiE, ReadLoE, WriteLoHiE, 
	       StoreByteE, LoadByteE;
   wire [3:0]  ALUControlE;
   
   wire        RegWriteM, MemtoRegM, MemWriteM,
	       JumpM, LinkM, JumpRegM, WriteLoHiM, StoreByteM, LoadByteM;
   
   wire        RegWriteW, MemtoRegW,
	       JumpW, LinkW, JumpRegW, WriteLoHiW;
   
   //wires for F stage
   wire [31:0] PC;
   wire [31:0] PCF;
   wire [31:0] PCPlus4F;
   wire [31:0] InstrF;
   wire [31:0] InstructF;

   //wires for D stage
   wire [31:0] InstrD;
   wire [31:0] PCPlus4D, PCBranchD;
   wire [31:0] SignImmD;
   wire [4:0]  RsD, RtD, RdD, ShAmt;
   wire [25:0] Target;
   wire [31:0] JumpAddrD;
   wire [31:0] PCPlus8D;
   wire [31:0] ReadData1D, ReadData2D;
   wire [31:0] Data1D, Data2D;
   wire        EqualD, PCSrcD;
   wire        FlushD;
   wire [31:0] InstructD;
   
   
   //wires for E stage
   wire [4:0]  RsE, RtE, RdE;
   wire [4:0]  WriteRegE;
   wire [31:0] Data1E, Data2E;
   wire [31:0] SrcAE, SrcBE;
   wire [31:0] ALUOutE;
   wire [31:0] WriteDataE;
   wire [31:0] SignImmE;
   wire [31:0] InstructE;
   wire [31:0] PCPlus8E;
   wire [31:0] JumpAddrE;
   wire [63:0] loHi_dataE;
   wire [31:0] SrcAEnoLoHi;
      
   //wires for M stage
   wire [31:0] ALUOutM;
   wire [31:0] WriteDataM;
   wire [4:0]  WriteRegM;
   wire [31:0] ReadDataM;
   wire [31:0] InstructM;
   wire [31:0] SrcAM, SrcBM;
   wire [31:0] PCPlus8M;
   wire [31:0] JumpAddrM;
   wire [63:0] loHi_dataM;
      
   //wires for W stage
   wire [4:0]  WriteRegW;
   wire [31:0] ReadDataW, ALUOutW, ResultW;
   wire [31:0] InstructW;
   wire [31:0] PCPlus8W;
   wire [31:0] JumpAddrW;
   wire [31:0] ALUorReadW;
   wire [31:0] PCJumpW;
   wire [31:0] PCNextW;
   wire [63:0] loHi_dataW;

   //Wiring for Hazard Unit
   hazardControl hazardModule( .rsD(RsD), .rsE(RsE), .rtD(RtD), .rtE(RtE),
			       .WriteRegE(WriteRegE), .WriteRegM(WriteRegM), 
			       .WriteRegW(WriteRegW), .BranchD(BranchD), 
			       .RegWriteE(RegWriteE), .RegWriteM(RegWriteM), 
			       .RegWriteW(RegWriteW), .MemtoRegE(MemtoRegE), 
			       .MemtoRegM(MemtoRegM), .WriteLoHiM(WriteLoHiM), 
			       .WriteLoHiW(WriteLoHiW), .ReadLoE(ReadLoE), 
			       .ReadHiE(ReadHiE),
			       .StallF(StallF), .StallD(StallD), 
			       .FlushE(FlushE), .ForwardAD(ForwardAD), 
			       .ForwardBD(ForwardBD), .ForwardAE(ForwardAE), 
			       .ForwardBE(ForwardBE), .ForwardLoE(ForwardLoE),
			       .ForwardHiE(ForwardHiE));

   //Wiring for Control Unit
   control controlModule(.opcode(InstrD[`op]), .funct(InstrD[`function]),
			 .rt(RtD), 
			 .RegDst(RegDstD), .Branch(BranchD),
			 .Jump(JumpD), .Link(LinkD), .JumpReg(JumpRegD),
			 .MemRead(), .MemToReg(MemtoRegD), .RegWrite(RegWriteD), 
			 .ALUSrc(ALUSrcD), .MemWrite(MemWriteD), .ImmEx(ImmExD),
			 .ReadHi(ReadHiD), .ReadLo(ReadLoD), 
			 .WriteLoHi(WriteLoHiD),
			 .ALUOp(ALUControlD), .CompareMode(CompareModeD),
			 .StoreByte(StoreByteD), .LoadByte(LoadByteD)
			 );
   
   //Wiring for F stage
   pipeReg_PC pcModule(.CLK(CLK), .StallF(StallF), .pcF(PCF), .pc(PC));
   instrMem instr(.read_addr(PCF[31:2]), .memout(InstrF), 
		  .ori_memout(InstructF));
   adder add4Module(.in1(PCF), .in2(32'd4), .out(PCPlus4F));

   //Pipeline FD
   pipeReg_FD pipeReg_fd(.CLK(CLK), .StallD(StallD), .Clear(FlushD), 
			 .RDF(InstrF), .PCPlus4F(PCPlus4F), .RDD(InstrD), 
			 .PCPlus4D(PCPlus4D), .InstructF(InstructF), 
			 .InstructD(InstructD));
   
   //Wiring for D stage
   assign PCSrcD = BranchD & EqualD;
   assign RsD = InstrD[`rs];
   assign RtD = InstrD[`rt];
   assign RdD = InstrD[`rd];
   assign ShAmt = InstrD[`sa];
   assign Target = InstrD[`target];
   
   assign JumpAddrD = {PCPlus4D[31:28], Target, 2'b0};

   comparer branchComparer(.in0(Data1D), .in1(Data2D), 
			   .CompareMode(CompareModeD), 
			   .result(EqualD)
			   );
   
   flushJump flushDModule(.CLK(CLK), .Jump(JumpD), .Flush(FlushD));
   registers registersModule(.clk(CLK), .reg_write(RegWriteW), 
			     .rs(RsD), .rt(RtD), 
			     .rd(WriteRegW), .write_data(ResultW),
			     .ReadHi(ReadHiD), .ReadLo(ReadLoD), 
			     .WriteLoHi(WriteLoHiW), .lohi_data(loHi_dataW),
			     .read_data1(ReadData1D), .read_data2(ReadData2D)
			     );
   dataMuxer register1D(.in0(ReadData1D), .in1(ALUOutM), 
			.select(ForwardAD), .out(Data1D)
			);
   dataMuxer register2D(.in0(ReadData2D), .in1(ALUOutM), .select(ForwardBD), 
			.out(Data2D)
			);
   signExtend extend(.immediate(InstrD[`immediate]), 
		     .extended_immediate(SignImmD), .ImmEx(ImmExD)
		     );
   adder addImmModule(.in1({SignImmD[29:0],2'b0}), .in2(PCPlus4D), 
		      .out(PCBranchD)
		      );
   adder add8PCModule(.in1(PCPlus4D), .in2(32'd4), .out(PCPlus8D));
   
   //Pipeline DE
   pipeReg_DE pipeReg_de(.CLK(CLK), .FlushE(FlushE), 
			 .RegWriteD(RegWriteD), .MemtoRegD(MemtoRegD), 
			 .MemWriteD(MemWriteD), 
			 .JumpD(JumpD), .LinkD(LinkD), .JumpRegD(JumpRegD),
			 .ALUControlD(ALUControlD), 
			 .ALUSrcD(ALUSrcD), .RegDstD(RegDstD), 
			 .BranchD(BranchD), .RD1D(Data1D),
			 .RD2D(Data2D), .RsD(RsD), .RtD(RtD), .RdD(RdD), 
			 .SignImmD(SignImmD), .PCPlus8D(PCPlus8D),
			 .JumpAddrD(JumpAddrD), .InstructD(InstructD),
			 .WriteLoHiD(WriteLoHiD), .StoreByteD(StoreByteD), 
			 .LoadByteD(LoadByteD),
			 .ReadHiD(ReadHiD), .ReadLoD(ReadLoD),
			 
			 .RegWriteE(RegWriteE), .MemtoRegE(MemtoRegE), 
			 .MemWriteE(MemWriteE), 
			 .JumpE(JumpE), .LinkE(LinkE), .JumpRegE(JumpRegE),
			 .ALUControlE(ALUControlE),
			 .ALUSrcE(ALUSrcE), .RegDstE(RegDstE), 
			 .BranchE(BranchE), .RD1E(Data1E),
			 .RD2E(Data2E), .RsE(RsE), .RtE(RtE), .RdE(RdE),
			 .SignImmE(SignImmE), .PCPlus8E(PCPlus8E),
			 .JumpAddrE(JumpAddrE), .InstructE(InstructE),
			 .WriteLoHiE(WriteLoHiE), .StoreByteE(StoreByteE), 
			 .LoadByteE(LoadByteE),
			 .ReadHiE(ReadHiE), .ReadLoE(ReadLoE)
			 );
   //Wiring for E stage
   triStateMuxer dataA(.in00(Data1E), .in01(ResultW), .in10(ALUOutM), 
		       .select(ForwardAE), .out(SrcAEnoLoHi));

   triStateMuxer dataB(.in00(Data2E), .in01(ResultW), .in10(ALUOutM), 
		       .select(ForwardBE), .out(WriteDataE));

   dataMuxer ImmMuxerE(.in0(WriteDataE), .in1(SignImmE), .select(ALUSrcE), 
		       .out(SrcBE));

   ALU alu(.data_1(SrcAE), .data_2(SrcBE), .ALUOp(ALUControlE), 
	   .data_out(ALUOutE), .loHi_out(loHi_dataE), .shamt(InstructE[`sa]));

   triStateRegisterMuxer regMuxerE(.in00(RtE), .in01(RdE), .in10(`ra), 
				   .select({LinkE, RegDstE}), .out(WriteRegE));

   loHiForwardMuxer loHiMux(.normal(SrcAEnoLoHi), 
			    .forwardDataLoE(loHi_dataM[31:0]), 
			    .forwardDataHiE(loHi_dataM[63:32]), 
			    .forwardDataLoM(loHi_dataW[31:0]), 
			    .forwardDataHiM(loHi_dataW[63:32]), 
			    .ForwardLoE(ForwardLoE), .ForwardHiE(ForwardHiE),
			    .out(SrcAE));
   
   //Pipeline EM
   pipeReg_EM pipeReg_em(.CLK(CLK),
			 .MemtoRegE(MemtoRegE), .MemWriteE(MemWriteE),
			 .JumpE(JumpE), .LinkE(LinkE), .JumpRegE(JumpRegE), 
			 .ALUOutE(ALUOutE), .WriteDataE(WriteDataE), 
			 .WriteRegE(WriteRegE), .RegWriteE(RegWriteE),
			 .InstructE(InstructE), .SrcAE(SrcAE), .SrcBE(SrcBE),
			 .PCPlus8E(PCPlus8E), .JumpAddrE(JumpAddrE),
			 .WriteLoHiE(WriteLoHiE), .loHi_dataE(loHi_dataE),
			 .StoreByteE(StoreByteE), .LoadByteE(LoadByteE),
			 
			 .MemtoRegM(MemtoRegM), .MemWriteM(MemWriteM),
			 .JumpM(JumpM), .LinkM(LinkM), .JumpRegM(JumpRegM),
			 .ALUOutM(ALUOutM), .WriteDataM(WriteDataM), 
			 .WriteRegM(WriteRegM), .RegWriteM(RegWriteM),
			 .InstructM(InstructM), .SrcAM(SrcAM), .SrcBM(SrcBM),
			 .PCPlus8M(PCPlus8M), .JumpAddrM(JumpAddrM),
			 .WriteLoHiM(WriteLoHiM), .loHi_dataM(loHi_dataM),
			 .StoreByteM(StoreByteM), .LoadByteM(LoadByteM)
			 );
   //Wiring for M stage

   dataMemory dataMem(.clk(CLK), .memWrite(MemWriteM), .address(ALUOutM), 
		      .write_data(WriteDataM), .read_data(ReadDataM), 
		      .inst(InstructM), .store_byte(StoreByteM), .load_byte(LoadByteM),
		      .a0(SrcAM), .v0(SrcBM));

   //Pipeline MW
   pipeReg_MW pipreReg_mw( .CLK(CLK), .InstructM(InstructM),
			   .RegWriteM(RegWriteM), .MemtoRegM(MemtoRegM),
			   .JumpM(JumpM), .LinkM(LinkM), .JumpRegM(JumpRegM),
			   .ReadDataM(ReadDataM), .ALUOutM(ALUOutM), 
			   .WriteRegM(WriteRegM),
			   .PCPlus8M(PCPlus8M), .JumpAddrM(JumpAddrM),
			   .WriteLoHiM(WriteLoHiM), .loHi_dataM(loHi_dataM),
			   
			   .RegWriteW(RegWriteW), .MemtoRegW(MemtoRegW),
			   .JumpW(JumpW), .LinkW(LinkW), .JumpRegW(JumpRegW),
			   .ReadDataW(ReadDataW), .ALUOutW(ALUOutW), 
			   .WriteRegW(WriteRegW), 
			   .PCPlus8W(PCPlus8W), .JumpAddrW(JumpAddrW),
			   .WriteLoHiW(WriteLoHiW), .loHi_dataW(loHi_dataW), 
			   .InstructW(InstructW)
			   );
   //Wiring for W stage
   dataMuxer writeW(.in0(ALUOutW), .in1(ReadDataW), .select(MemtoRegW), 
		    .out(ALUorReadW));
   dataMuxer linkMuxW(.in0(ALUorReadW), .in1(PCPlus8W), .select(LinkW),
			.out(ResultW));
   dataMuxer jumpRegMuxW(.in0(JumpAddrW), .in1(ResultW), .select(JumpRegW), 
			 .out(PCJumpW));

   triStateMuxer jumpBranchMux(.in00(PCPlus4F), .in01(PCBranchD), .in10(PCJumpW), .select({JumpW, PCSrcD}), .out(PC));


   // Initialize the CLK and monitor
   initial
     begin
	CLK = 0;
        if (DEBUG_PRINT) $monitor($time, " in %m, CLK = %1b, PCF = %08x, InstructD = %08x, ResultW = %08x",
 		 CLK, PCF, InstructD, ResultW);
     end

   always @(posedge CLK) begin
      if (DEBUG_PRINT) $display("\n||==================================||\n");
   end

   
   //Switch the clock signal
   always
     #1000 CLK = ~CLK;

   //Counting the clock cycles
   reg [31:0] inst_count = 0;
   reg [31:0] clock_count = 0;
   
   always @(posedge CLK) begin
      $display("%8d|%08x|%08x|%08x|%08x|%08x|%b|%b|%b|%b|%b|%b|%b|%b|%b|%b|%b|%b|%b|%b|%b|%b|%b|%b", clock_count, InstructF, InstructD, InstructE, InstructM, InstructW, 
	RegWriteD, MemtoRegD, MemWriteD, ALUControlD, ALUSrcD, RegDstD, BranchD,
	RegWriteE, MemtoRegE, MemWriteE, ALUControlE, ALUSrcE, RegDstE,
	RegWriteM, MemtoRegM, MemWriteM,
	RegWriteW, MemtoRegW
	 );
      clock_count = clock_count + 1;
   end

   always @(InstructW) begin
      inst_count = inst_count + 1;
   end

   initial if (STATS_PRINT) $monitor("clock_cycles: %d, inst_count: %d", clock_count, inst_count);
   
endmodule // processor
