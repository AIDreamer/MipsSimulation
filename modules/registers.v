/*
 TungstenHammer CSCI320
 Michael Hammer - Son Pham - Tung Phan
 MIPS CPU Implementation
 Based on Harris & Harris' "Digital Design and Computer Architecture" (2012)
 */

`include"include/mips.h"
/*
 registers - module to model read and write operations to registers of the CPU
 
 INPUTS
 clk - CLK signal that syncs the various modules in CPU
 rs, rd, rt: 5-bit index of the registers to read/write
 write_data: write_data to be written to rd index
 lohi_data: 64-bit data to be written to lo-hi registers
 ReadHi, ReadLo: 1-bit control signal to indicate we read from Lo/Hi or neither
 WriteLoHi: 1-bit control signal to indicate if we are writing data to lohi regs
 */
module registers(clk, reg_write, rs, rt, rd, write_data, lohi_data, 
		 ReadHi, ReadLo, WriteLoHi, 
		 read_data1, read_data2);

   /* parameter */
   parameter READ_DELAY = 0;
   parameter WRITE_DELAY = 0;
   
   /* input */
   input clk;
   input reg_write;
   input [4 : 0] rs;
   input [4 : 0] rd;
   input [4 : 0] rt;
   input [31 : 0] write_data;
   input [63 : 0] lohi_data;
   input 	  ReadHi, ReadLo, WriteLoHi;

   /* reg */
   reg [31 : 0] registers [31 : 0];
   reg [31 : 0] lo, hi;
   reg [31 : 0] read_data1_next, read_data2_next;
   reg 		temp_write_data;
   
 	 
   /* output */
   output [31 : 0] 	 read_data1;
   output [31 : 0] 	 read_data2;

   //temp variables
   integer 		 i;
   
   initial begin
      for (i=0; i < 32; i = i+1) begin
	 registers[i] = 32'b0;
      end
      lo = 32'b0;
      hi = 32'b0;
   end

   assign #READ_DELAY read_data1 = read_data1_next;
   assign #READ_DELAY read_data2 = read_data2_next;

   always @(posedge clk) begin
      //$display("reg_write: %b", reg_write);
      /* Write cycle */
      #5
      if (reg_write) begin
	 #WRITE_DELAY registers[rd] =  #5 (rd == `zero) ? 32'b0 : write_data;
      end
      if (WriteLoHi) begin
	 #WRITE_DELAY hi =  lohi_data[63 : 32];
	 #WRITE_DELAY lo =  lohi_data[31 : 0];
      end
   end // always @ (posedge clk)

   always@(negedge clk) begin
      #5
      /* Read cycle */
      if (ReadLo) begin
	 read_data1_next <= #10 lo;
	 read_data2_next <= #10 32'b0;
      end else if (ReadHi) begin
	 read_data1_next <= #10 hi;
	 read_data2_next <= #10 32'b0;
      end else begin
	 read_data1_next <= #10 registers[rs];
	 read_data2_next <= #10 registers[rt];
      end      
   end // always@ (negedge clk)
endmodule // registers
