/*
 TungstenHammer CSCI320
 Michael Hammer - Son Pham - Tung Phan
 MIPS CPU Implementation
 Based on Harris & Harris' "Digital Design and Computer Architecture" (2012)
 */

`include "include/mips.h"

/*
 control - The main controller of our pipelined CPU, gives out control signals 
 depending on the given MIPS instructions.
 */
module control(opcode, funct, rt,
	       RegDst, Jump, Link, JumpReg, Branch, MemRead, MemToReg, 
	       RegWrite, ALUSrc, MemWrite, ImmEx, ALUOp,  WriteLoHi, 
	       ReadLo, ReadHi, CompareMode, StoreByte, LoadByte);

   /* Parameters */
   parameter DELAY = 100;
   parameter DEBUG_PRINT = `DEBUG_PRINT;
   
   /* Input */
   input [5:0] 			funct, opcode;
   input [4:0] 			rt;


   /* Output */
   output 			RegDst, Jump, Link, JumpReg, Branch, 
				MemRead, MemToReg, RegWrite, ALUSrc, MemWrite, 
				StoreByte, LoadByte,
 				WriteLoHi, ReadLo, ReadHi;
   output [1:0] 		ImmEx;
   // This is the usual ALU Control in other formal documentations, 
   // NOT the same ALUOp
   output [3:0] 		ALUOp; 
   output [2:0] 		CompareMode;

   /* Buffer regs */
   reg 				RegDst_next, Jump_next, Link_next, JumpReg_next,
				Branch_next, MemRead_next, MemToReg_next, 
				RegWrite_next, ALUSrc_next, MemWrite_next, 
				StoreByte_next, LoadByte_next,
				WriteLoHi_next, ReadLo_next, ReadHi_next;
   reg [1:0] 			ImmEx_next;
   reg [3:0] 			ALUOp_special, ALUOp_next;
   reg [2:0] 			CompareMode_next;
   
   assign #DELAY RegDst = RegDst_next;
   assign #DELAY Jump = Jump_next;
   assign #DELAY Link = Link_next;
   assign #DELAY JumpReg = JumpReg_next;
   assign #DELAY WriteLoHi = WriteLoHi_next;
   assign #DELAY ReadLo = ReadLo_next;
   assign #DELAY ReadHi = ReadHi_next;
   assign #DELAY Branch = Branch_next;
   assign #DELAY MemRead = MemRead_next;
   assign #DELAY MemToReg = MemToReg_next; 
   assign #DELAY RegWrite = RegWrite_next;
   assign #DELAY ALUSrc = ALUSrc_next;
   assign #DELAY MemWrite = MemWrite_next;
   assign #DELAY StoreByte = StoreByte_next;
   assign #DELAY LoadByte = LoadByte_next;
   assign #DELAY ImmEx = ImmEx_next;
   assign #DELAY ALUOp = (opcode == `SPECIAL)? ALUOp_special : ALUOp_next;
   assign #DELAY CompareMode = CompareMode_next;
   
   initial
     begin
	Jump_next <= `false;
	Branch_next <= `false;
     end
   
   always @(*)
     begin
	if (opcode == `SPECIAL) begin
	   case (funct)
	     `ADD: begin
	       RegWrite_next <= `true;
	       ALUOp_special <= `ALU_ADD;
	       ReadHi_next <= `false;
	       ReadLo_next <= `false;
	       WriteLoHi_next <= `false;
	       Jump_next <= `false;
	       JumpReg_next <= `false;
	       if (DEBUG_PRINT) $display("SPECIAL - ADD");
	    end
	    `ADDU: begin
	       RegWrite_next <= `true;             
	       ALUOp_special <= `ALU_ADD;
	       ReadHi_next <= `false;
	       ReadLo_next <= `false;
	       WriteLoHi_next <= `false;
	       Jump_next <= `false;
	       JumpReg_next <= `false;
	       if (DEBUG_PRINT) $display("SPECIAL - ADDU");	  
	    end
	    `AND: begin
	       RegWrite_next <= `true;
	       ReadHi_next <= `false;
	       ReadLo_next <= `false;
	       WriteLoHi_next <= `false;
	       ALUOp_special <= `ALU_AND;
	       Jump_next <= `false;
	       JumpReg_next <= `false;
	       if (DEBUG_PRINT) $display("SPECIAL - AND");
	    end
	    `JR: begin
	       RegWrite_next <= `false;
	       ReadHi_next <= `false;
	       ReadLo_next <= `false;
	       WriteLoHi_next <= `false;
	       ALUOp_special <= `ALU_ADD;
	       Jump_next <= `true;
	       JumpReg_next <= `true;
	       if (DEBUG_PRINT) $display("SPECIAL - JR");
	    end
	    `NOR: begin
	       RegWrite_next <= `true;
	       ReadHi_next <= `false;
	       ReadLo_next <= `false;
	       WriteLoHi_next <= `false;
	       ALUOp_special <= `ALU_NOR;
	       Jump_next <= `false;
	       JumpReg_next <= `false;
	       if (DEBUG_PRINT) $display("SPECIAL - NOR");
	    end
	    `OR: begin
	       RegWrite_next <= `true;
	       ReadHi_next <= `false;
	       ReadLo_next <= `false;
	       WriteLoHi_next <= `false;
	       ALUOp_special <= `ALU_OR;
	       Jump_next <= `false;
	       JumpReg_next <= `false;
	       if (DEBUG_PRINT) $display("SPECIAL - OR");
	    end
	    `SLL: begin
	       RegWrite_next <= `true;
	       ReadHi_next <= `false;
	       ReadLo_next <= `false;
	       WriteLoHi_next <= `false;
	       ALUOp_special <= `ALU_SLL;
	       Jump_next <= `false;
	       JumpReg_next <= `false;
	       if (DEBUG_PRINT) begin
		  if (rt == 5'b0)
		    $display("NOP");
		  else
		    $display("SPECIAL - SLL");
	       end
	    end
	    `SRL: begin
	       RegWrite_next <= `true;
	       ReadHi_next <= `false;
	       ReadLo_next <= `false;
	       WriteLoHi_next <= `false;
	       ALUOp_special <= `ALU_SRL;
	       Jump_next <= `false;
	       JumpReg_next <= `false;
	       if (DEBUG_PRINT) $display("SPECIAL - SRL");
	    end
	    `SRA: begin
	       RegWrite_next <= `true;
	       ReadHi_next <= `false;
	       ReadLo_next <= `false;
	       WriteLoHi_next <= `false;
	       ALUOp_special <= `ALU_SRA;
	       Jump_next <= `false;
	       JumpReg_next <= `false;
	       if (DEBUG_PRINT) $display("SPECIAL - SRA");
	    end
	    `SLT: begin
	       RegWrite_next <= `true;
	       ReadHi_next <= `false;
	       ReadLo_next <= `false;
	       WriteLoHi_next <= `false;
	       ALUOp_special <= `ALU_SLT;
	       Jump_next <= `false;
	       JumpReg_next <= `false;
	       if (DEBUG_PRINT) $display("SPECIAL - SLT");
	    end
	    `SLTU: begin
	       RegWrite_next <= `true;
	       ReadHi_next <= `false;
	       ReadLo_next <= `false;
	       WriteLoHi_next <= `false;
	       ALUOp_special <= `ALU_SLT;
	       Jump_next <= `false;
	       JumpReg_next <= `false;
	       if (DEBUG_PRINT) $display("SPECIAL - SLTU");
	    end
	    `SUB: begin
	       RegWrite_next <= `true;
	       ReadHi_next <= `false;
	       ReadLo_next <= `false;
	       WriteLoHi_next <= `false;
	       ALUOp_special <= `ALU_SUB;
	       Jump_next <= `false;
	       JumpReg_next <= `false;
	       if (DEBUG_PRINT) $display("SPECIAL - SUB");
	    end
	    `SUBU: begin
	       RegWrite_next <= `true;
	       ReadHi_next <= `false;
	       ReadLo_next <= `false;
	       WriteLoHi_next <= `false;
	       ALUOp_special <= `ALU_SUB;
	       Jump_next <= `false;
	       JumpReg_next <= `false;
	       if (DEBUG_PRINT) $display("SPECIAL - SUBU");
	    end
	     `XOR: begin
	       RegWrite_next <= `true;
	       ReadHi_next <= `false;
	       ReadLo_next <= `false;
	       WriteLoHi_next <= `false;
	       ALUOp_special <= `ALU_XOR;
	       Jump_next <= `false;
	       JumpReg_next <= `false;
	       if (DEBUG_PRINT) $display("SPECIAL - XOR");
	    end
	    `MFHI: begin
	       RegWrite_next <= `true;
	       ReadHi_next <= `true;
	       ReadLo_next <= `false;
	       WriteLoHi_next <= `false;
	       ALUOp_special <= `ALU_ADD;
	       Jump_next <= `false;
	       JumpReg_next <= `false;
	       if (DEBUG_PRINT) $display("SPECIAL - MFHI");
	    end
	    `MFLO: begin
	       RegWrite_next <= `true;
	       ReadHi_next <= `false;
	       ReadLo_next <= `true;
	       WriteLoHi_next <= `false;
	       ALUOp_special <= `ALU_ADD;
	       Jump_next <= `false;
	       JumpReg_next <= `false;
	       if (DEBUG_PRINT) $display("SPECIAL - MFLO");
	    end
	    `DIV: begin
	       RegWrite_next <= `false;
	       ReadLo_next <= `false;
	       ReadHi_next <= `false;
	       WriteLoHi_next <= `true;
	       ALUOp_special <= `ALU_DIV;
	       Jump_next <= `false;
	       JumpReg_next <= `false;
	       if (DEBUG_PRINT) $display("SPECIAL - DIV");
	    end
	     `MULT: begin
		RegWrite_next <= `false;
		ReadLo_next <= `false;
		ReadHi_next <= `false;
		WriteLoHi_next <= `true;
		ALUOp_special <= `ALU_MULT;
		Jump_next <= `false;
		JumpReg_next <= `false;
		if (DEBUG_PRINT) $display("SPECIAL - MULT");
	    end
	  endcase // case (funct)
	end // if (opcode == `SPECIAL)
	else begin
	   ReadLo_next <= `false;
	   ReadHi_next <= `false;
	   WriteLoHi_next <= `false;
	   ALUOp_special <= `ALU_UNDEF;
	   if (opcode == `REGIMM) begin
	      case (rt)
		`BLTZ: begin
		   CompareMode_next <= `Compare_BLTZ;
		   if (DEBUG_PRINT) $display("REGIMM - BLTZ");
		end
		default: begin
		   CompareMode_next <= `Compare_NULL;
		end
	      endcase // case (rt)
	   end else begin // if (opcode == `REGIMM)
	      CompareMode_next <= `Compare_NULL;
	   end 
	end
	
	case (opcode)
	  `SPECIAL: begin
             RegDst_next <= `true;
	     Link_next <= `false;
             Branch_next <= `false;
             MemRead_next <= `false;
             MemToReg_next <= `false;
             ALUOp_next <= `ALU_UNDEF;
             ALUSrc_next <= `false;
             MemWrite_next <= `false;
	     StoreByte_next <= `false;
	     LoadByte_next <= `false;
	     ImmEx_next <= `SignExImm;
	     CompareMode_next <= `Compare_NULL;
          end // case: `SPECIAL
	  `REGIMM: begin
	     //The only REGIMM now are BLTZ & BGEZ
             RegDst_next <= `false;
             Jump_next <= `false;
	     Link_next <= `false;
	     JumpReg_next <= `false;
             Branch_next <= `true;
             MemRead_next <= `false;
             MemToReg_next <= `false;
             ALUOp_next <= `ALU_SUB;
             RegWrite_next <= `false;
             ALUSrc_next <= `false;
             MemWrite_next <= `false;
	     StoreByte_next <= `false;
	     LoadByte_next <= `false;
	     ImmEx_next <= `SignExImm;
	  end // case: `REGIMM
          `ADDI: begin
             RegDst_next <= `false;
             Jump_next <= `false;
	     Link_next <= `false;
	     JumpReg_next <= `false;
             Branch_next <= `false;
             MemRead_next <= `false;
             MemToReg_next <= `false;
             ALUOp_next <= `ALU_ADD;
             RegWrite_next <= `true;
             ALUSrc_next <= `true;
             MemWrite_next <= `false;
	     StoreByte_next <= `false;
	     LoadByte_next <= `false;
	     ImmEx_next <= `SignExImm;
	     CompareMode_next <= `Compare_NULL;
             if (DEBUG_PRINT) $display("ADDI");
          end // case: `ADDI
	  `ADDIU: begin
	     RegDst_next <= `false;
             Jump_next <= `false;
	     Link_next <= `false;
	     JumpReg_next <= `false;
             Branch_next <= `false;
             MemRead_next <= `false;
             MemToReg_next <= `false;
             ALUOp_next <= `ALU_ADD;
             RegWrite_next <= `true;
             ALUSrc_next <= `true;
             MemWrite_next <= `false;
	     StoreByte_next <= `false;
	     LoadByte_next <= `false;
	     ImmEx_next <= `SignExImm;
	     CompareMode_next <= `Compare_NULL;
             if (DEBUG_PRINT) $display("ADDIU");
	  end // case: `ADDIU
	  `ANDI: begin
	     RegDst_next <= `false;
             Jump_next <= `false;
	     Link_next <= `false;
	     JumpReg_next <= `false;
             Branch_next <= `false;
             MemRead_next <= `false;
             MemToReg_next <= `false;
             ALUOp_next <= `ALU_AND;
             RegWrite_next <= `true;
             ALUSrc_next <= `true;
             MemWrite_next <= `false;
	     StoreByte_next <= `false;
	     LoadByte_next <= `false;
	     ImmEx_next <= `ZeroExImm;
	     CompareMode_next <= `Compare_NULL;
             if (DEBUG_PRINT) $display("ANDI");
	  end // case: `ANDI
	  `BEQ: begin
             RegDst_next <= `false;
             Jump_next <= `false;
	     Link_next <= `false;
	     JumpReg_next <= `false;
             Branch_next <= `true;
             MemRead_next <= `false;
             MemToReg_next <= `false;
             ALUOp_next <= `ALU_SUB;
             RegWrite_next <= `false;
             ALUSrc_next <= `false;
             MemWrite_next <= `false;
	     StoreByte_next <= `false;
	     LoadByte_next <= `false;
	     ImmEx_next <= `SignExImm;
	     CompareMode_next <= `Compare_BEQ;
             if (DEBUG_PRINT) $display("BEQ");
          end // case: `BEQ
	  `BNE: begin
             RegDst_next <= `false;
             Jump_next <= `false;
	     Link_next <= `false;
	     JumpReg_next <= `false;
             Branch_next <= `true;
             MemRead_next <= `false;
             MemToReg_next <= `false;
             ALUOp_next <= `ALU_SUB;
             RegWrite_next <= `false;
             ALUSrc_next <= `false;
             MemWrite_next <= `false;
	     StoreByte_next <= `false;
	     LoadByte_next <= `false;
	     ImmEx_next <= `SignExImm;
	     CompareMode_next <= `Compare_BNE;
             if (DEBUG_PRINT) $display("BNE");
          end // case: `BEQ
	  `BGTZ: begin
             RegDst_next <= `false;
             Jump_next <= `false;
	     Link_next <= `false;
	     JumpReg_next <= `false;
             Branch_next <= `true;
             MemRead_next <= `false;
             MemToReg_next <= `false;
             ALUOp_next <= `ALU_SUB;
             RegWrite_next <= `false;
             ALUSrc_next <= `false;
             MemWrite_next <= `false;
	     StoreByte_next <= `false;
	     LoadByte_next <= `false;
	     ImmEx_next <= `SignExImm;
	     CompareMode_next <= `Compare_BGTZ;
             if (DEBUG_PRINT) $display("BGTZ");
          end // case: `BGTZ
          `ORI: begin
             RegDst_next <= `false;
             Jump_next <= `false;
	     Link_next <= `false;
	     JumpReg_next <= `false;
             Branch_next <= `false;
             MemRead_next <= `false;
             MemToReg_next <= `false;
             ALUOp_next <= `ALU_OR;
             RegWrite_next <= `true;
             ALUSrc_next <= `true;
             MemWrite_next <= `false;
	     StoreByte_next <= `false;
	     LoadByte_next <= `false;
	     ImmEx_next <= `ZeroExImm;
	     CompareMode_next <= `Compare_NULL;
             if (DEBUG_PRINT) $display("ORI");
          end // case: `ORI
	  `J: begin
	     RegDst_next <= `false;
             Jump_next <= `true;
	     Link_next <= `false;
	     JumpReg_next <= `false;
             Branch_next <= `false;
             MemRead_next <= `false;
             MemToReg_next <= `false;
             ALUOp_next <= `ALU_UNDEF;
             RegWrite_next <= `false;
             ALUSrc_next <= `dc;
             MemWrite_next <= `false;
	     StoreByte_next <= `false;
	     LoadByte_next <= `false;
	     ImmEx_next <= `dc2;
	     CompareMode_next <= `Compare_NULL;
	     if (DEBUG_PRINT) $display("J");
	  end // case: `J
	  `JAL: begin
             RegDst_next <= `false;
             Jump_next <= `true;
	     Link_next <= `true;
	     JumpReg_next <= `false;
             Branch_next <= `false;
             MemRead_next <= `false;
             MemToReg_next <= `false;
             ALUOp_next <= `ALU_UNDEF;
             RegWrite_next <= `true;
             ALUSrc_next <= `dc;
             MemWrite_next <= `false;
	     StoreByte_next <= `false;
	     LoadByte_next <= `false;
	     ImmEx_next <= `dc2;
	     CompareMode_next <= `Compare_NULL;
             if (DEBUG_PRINT) $display("JAL");
          end // case: `JAL
	  `LUI: begin
             RegDst_next <= `false;
             Jump_next <= `false;
	     Link_next <= `false;
	     JumpReg_next <= `false;
             Branch_next <= `false;
             MemRead_next <= `false;
             MemToReg_next <= `false;
             ALUOp_next <= `ALU_ADD;
             RegWrite_next <= `true;
             ALUSrc_next <= `true;
             MemWrite_next <= `false;
	     StoreByte_next <= `false;
	     LoadByte_next <= `false;
	     ImmEx_next <= `ZeroExUpImm;
	     CompareMode_next <= `Compare_NULL;
             if (DEBUG_PRINT) $display("LUI");
          end // case: `LUI	  
	  `LW: begin
             RegDst_next <= `false;
             Jump_next <= `false;
	     Link_next <= `false;
	     JumpReg_next <= `false;
             Branch_next <= `false;
             MemRead_next <= `true;
             MemToReg_next <= `true;
             ALUOp_next <= `ALU_ADD;
             RegWrite_next <= `true;
             ALUSrc_next <= `true;
             MemWrite_next <= `false;
	     StoreByte_next <= `false;
	     LoadByte_next <= `false;
	     ImmEx_next <= `SignExImm;
	     CompareMode_next <= `Compare_NULL;
             if (DEBUG_PRINT) $display("LW");
          end // case: `LW
	  `SW: begin
             RegDst_next <= `false;
             Jump_next <= `false;
	     Link_next <= `false;
	     JumpReg_next <= `false;
             Branch_next <= `false;
             MemRead_next <= `false;
             MemToReg_next <= `dc;
             ALUOp_next <= `ALU_ADD;
             RegWrite_next <= `false;
             ALUSrc_next <= `true;
             MemWrite_next <= `true;
	     StoreByte_next <= `false;
	     LoadByte_next <= `false;
	     ImmEx_next <= `SignExImm;
	     CompareMode_next <= `Compare_NULL;
             if (DEBUG_PRINT) $display("SW");
          end // case: `SW
	  `LBU: begin
	     RegDst_next <= `false;
             Jump_next <= `false;
	     Link_next <= `false;
	     JumpReg_next <= `false;
             Branch_next <= `false;
             MemRead_next <= `true;
             MemToReg_next <= `true;
             ALUOp_next <= `ALU_ADD;
             RegWrite_next <= `true;
             ALUSrc_next <= `true;
             MemWrite_next <= `false;
	     StoreByte_next <= `false;
	     LoadByte_next <= `true;
	     ImmEx_next <= `SignExImm;
	     CompareMode_next <= `Compare_NULL;
	     if (DEBUG_PRINT) $display("LBU");
	  end
	  `SB: begin
	     RegDst_next <= `false;
             Jump_next <= `false;
	     Link_next <= `false;
	     JumpReg_next <= `false;
             Branch_next <= `false;
             MemRead_next <= `false;
             MemToReg_next <= `dc;
             ALUOp_next <= `ALU_ADD;
             RegWrite_next <= `false;
             ALUSrc_next <= `true;
             MemWrite_next <= `false;
	     StoreByte_next <= `true;
	     LoadByte_next <= `false;
	     ImmEx_next <= `SignExImm;
	     CompareMode_next <= `Compare_NULL;
             if (DEBUG_PRINT) $display("SB");
	  end
	  default: begin
	     RegDst_next <= `false;
             Jump_next <= `false;
	     Link_next <= `false;
	     JumpReg_next <= `false;
             Branch_next <= `false;
             MemRead_next <= `false;
             MemToReg_next <= `false;
             ALUOp_next <= `ALU_UNDEF;
             RegWrite_next <= `false;
             ALUSrc_next <= `false;
             MemWrite_next <= `false;
	     StoreByte_next <= `false;
	     LoadByte_next <= `false;
	     ImmEx_next <= `true;
	     CompareMode_next <= `Compare_NULL;
	  end // case: default
	endcase // case (opcode)
     end // always @ (*)
endmodule // control
