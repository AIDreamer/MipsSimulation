/*
 TungstenHammer CSCI320
 Michael Hammer - Son Pham - Tung Phan
 MIPS CPU Implementation
 Based on Harris & Harris' "Digital Design and Computer Architecture" (2012)
 */

/*
 ALU - Main ALU model to perform arithmetic/logical operations
 
 Inputs:
 data_1, data_2: 32-bit inputs to compute
 ALUOp: Control signals coming from the control module. All control signals included in include/mips.h
 shamt: shift amount. Used in shifting operations
 
 Outputs:
 data_out: 32-bit output result of the operation
 loHi_out: 64-bit output result of the div/mult operations
 */
`include "include/mips.h"
module ALU(data_1, data_2, ALUOp, shamt, data_out, loHi_out);
   parameter WIDTH = 32;
   parameter DELAY = 120;
   
   input [WIDTH-1:0] data_1;
   input [WIDTH-1:0] data_2;
   input [3:0] 	     ALUOp;
   input [4:0] 	     shamt;
   
   output [WIDTH-1:0] data_out;
   output [WIDTH*2-1:0] loHi_out;
   
   reg [WIDTH-1:0]    data_temp;
   reg [WIDTH*2-1:0]    loHi_temp;
   
   
   assign #DELAY data_out = data_temp;
   assign #DELAY loHi_out = loHi_temp;
   
   always @(*)
     begin
	case (ALUOp)
	  `ALU_AND:
	    data_temp <= data_1 & data_2;
	  `ALU_OR:
	    data_temp <= data_1 | data_2;
	  `ALU_ADD:
	    data_temp <= data_1 + data_2;
	  `ALU_SUB:
	    data_temp <= data_1 - data_2;
	  `ALU_SLT:
	    data_temp <= (data_1 < data_2) ? 32'b1 : 32'b0;
	  `ALU_NOR:
	    data_temp <= data_1 ~| data_2;
	  `ALU_XOR:
	    data_temp <= data_1 ^ data_2;
	  `ALU_DIV: begin
	     loHi_temp[63:32] <= data_1 % data_2;
	     loHi_temp[31:0] <= data_1 / data_2;
	  end
	  `ALU_MULT: begin
	     loHi_temp = data_1 * data_2;
	  end
	  `ALU_SLL:
	    data_temp <= data_2 << shamt;
	  `ALU_SRL:
	    data_temp <= data_2 >> shamt;
	  `ALU_SRA:
	    data_temp <= $signed(data_2) >>> shamt;
	  default:
	    data_temp <= 0;
	endcase // case (ALUOp)
     end // always @ (*)
endmodule // ALU

   
