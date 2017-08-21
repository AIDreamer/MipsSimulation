/*
 TungstenHammer CSCI320
 Michael Hammer - Son Pham - Tung Phan
 MIPS CPU Implementation
 Based on Harris & Harris' "Digital Design and Computer Architecture" (2012)
 */

/*
 dataMuxer - standard 2-state muxer that chooses based on select input
 
 INPUT
 in0, in1: 32-bit values to choose from
 select: 1-bit control signal to choose the input values
 
 OUTPUT
 out: 32-bit value chosen depending on select signal
 */
module dataMuxer(input [31:0] in0, input [31:0] in1, 
	input select, output [31:0] out);
   assign out = (select)? in1 : in0;
endmodule // dataMuxer

/*
 registerMuxer - standard 2-state muxer that chooses based on select input
 
 INPUT
 in0, in1: 5-bit values to choose from
 select: 1-bit control signal to choose the input values
 
 OUTPUT
 out: 5-bit value chosen depending on select signal
 */
module registerMuxer(input [4:0] in0, input [4:0] in1, 
	input select, output [4:0] out);
   assign out = (select)? in1 : in0;
endmodule // registerMuxer


/*
 triStateMuxer - standard 3-state muxer that chooses based on select input
 
 INPUT
 in00, in01, in10: 32-bit values to choose from
 select: 2-bit control signal to choose the input values
 
 OUTPUT
 out: 32-bit value chosen depending on select signal
 */
module triStateMuxer(in00, in01, in10, select, out);
   input [31:0] in00, in01, in10;
   input [1:0] 	select;
   output [31:0] out;

   reg [31:0] 		 out_next;

   assign out = out_next;
   always @(*)
     begin
	case (select)
	  2'b00: out_next <= in00;
	  2'b01: out_next <= in01;
	  2'b10: out_next <= in10;
	  2'b11: out_next <= in10;
	  default: out_next <= in00;
	endcase // case (select)
     end
endmodule // triStateMuxer

/*
 triStateRegisterMuxer - standard 3-state muxer that chooses based on select 
 input
 
 INPUT
 in0, in1: 5-bit values to choose from
 select: 2-bit control signal to choose the input values
 
 OUTPUT
 out: 5-bit value chosen depending on select signal
 */
module triStateRegisterMuxer(in00, in01, in10, select, out);
   input [4:0] in00, in01, in10;
   input [1:0] select;
   output [4:0] out;

   reg [4:0] 	out_next;

   assign out = out_next;
   always @(*)
     begin
	case (select)
	  2'b00: out_next <= in00;
	  2'b01: out_next <= in01;
	  2'b10: out_next <= in10;
	  2'b11: out_next <= in10;
	  default: out_next <= 5'bx;
	endcase // case (select)
     end
endmodule // triStateRegisterMuxer

/*
 loHiForwardMuxer - Specialized 5-state muxer to choose from various forwarding 
 situations for lo-hi register forwarding
 
 INPUT
 normal, forwardDataLoE, forwardDataHiE, forwardDataLoM, forwardDataHiM: 
 32-bit values coming from various locations of the pipeline
 ForwardLoE, ForwardHiE: 2-bit control signals coming from control module to
 handle selection
 
 OUTPUT
 out: 32-bit value chosen depending on select signals
 */
module loHiForwardMuxer(normal, forwardDataLoE, forwardDataHiE, forwardDataLoM, forwardDataHiM, ForwardLoE, ForwardHiE, out);
   
   input [31:0] normal, forwardDataLoE, forwardDataHiE, 
		forwardDataLoM, forwardDataHiM;
   input [1:0] 	ForwardLoE, ForwardHiE;
   output [31:0] out;
   
   reg [31:0] 	 out_next;
   
   assign out = out_next;
   always @(*) begin
      case({ForwardLoE, ForwardHiE})
	4'b0001: out_next <= forwardDataHiM;
	4'b0010: out_next <= forwardDataHiE;
	4'b0100: out_next <= forwardDataLoM;
	4'b1000: out_next <= forwardDataLoE;
	default: out_next <= normal;
      endcase // case ({ForwardLoE, ForwardHiE})
   end // always @ begin
endmodule // loHiForwardMuxer

			     
			     
			     
   
