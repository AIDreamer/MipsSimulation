/*
 TungstenHammer CSCI320
 Michael Hammer - Son Pham - Tung Phan
 MIPS CPU Implementation
 Based on Harris & Harris' "Digital Design and Computer Architecture" (2012)
 */

`include "include/mips.h"

/*
 dataMemory - The module to implement data memory of the CPU. Also handles 
 syscalls.
 */
module dataMemory(clk, memWrite, address, write_data, store_byte, load_byte,
		  inst, v0, a0,
		  read_data);
   /* param */
   parameter SYSCALL_INST = 32'h0000000C;
   parameter DEBUG_PRINT = `DEBUG_PRINT;
   
   /* Input */
   input 	clk;
   input 	memWrite;
   input [31:0] address;
   input [31:0] write_data;
   input 	store_byte;
   input 	load_byte;
   
   input [31:0] inst;
   input [31:0]	v0;
   input [31:0]	a0;

   /* Output */
   output [31:0] read_data;

   /* Reg */
   reg [31:0] mymem [32'h00000000 : 32'h03FFFFFF];
   reg [31:0] read_temp;
   reg [31:0] a0_temp;
   reg [31:0] v0_temp;
   reg [31:0] word_temp;
   reg 	      check_break;
   reg 	      check_first;      
	      
   /* Address hack*/
   wire [31:0] new_addr;

   
   
   assign new_addr = (address > 32'h03FFFFFF) ? (address - 32'h7C000000) : address;
   
   initial begin
      $readmemh("include/inst_mem.in", mymem); // Change back to "hello.v" later	
   end
   
   assign #5 read_data = read_temp;
   
   always @(posedge clk) begin
      #5 if (load_byte == `true) begin
	 case(new_addr[1:0])
	   0:
	     read_temp = {24'b0, mymem[new_addr[31:2]][7:0]};
	   1:
	     read_temp = {24'b0, mymem[new_addr[31:2]][15:8]};
	   2:
	     read_temp = {24'b0, mymem[new_addr[31:2]][23:16]};
	   3:
	     read_temp = {24'b0, mymem[new_addr[31:2]][31:24]};
	   default:
	     read_temp = {24'b0, mymem[new_addr[31:2]][31:24]};
	 endcase // case (new_addr[1:0])
       		 
      end else read_temp = mymem[new_addr[31:2]];
      /* Handle read and write */
      if (memWrite == `true) begin
	 mymem[new_addr[31:2]] = write_data;
      end 
      else if (store_byte == `true) begin
	 case(new_addr[1:0])
	   0:
	     mymem[new_addr[31:2]][7:0] = write_data[7:0];
	   1:
	     mymem[new_addr[31:2]][15:8] = write_data[7:0];
	   2:
	     mymem[new_addr[31:2]][23:16] = write_data[7:0];
	   3:
	     mymem[new_addr[31:2]][31:24] = write_data[7:0];
	   default:
	     mymem[new_addr[31:2]][7:0] = write_data[7:0];
	 endcase // case (new_addr[1:0])
      end
   end
   
   always @(posedge clk) begin
      #5
      /* Syscall */
      a0_temp = a0;
      v0_temp = v0;
      
      if (inst == SYSCALL_INST) begin
	 case (v0_temp)
	   1: if(DEBUG_PRINT) $display(a0_temp);
	   4: begin
	      word_temp = mymem[a0_temp[31:2]];
	      check_first = 1;
	      check_break = 1;
	      
	      // The first word is treated diffrently
	      if ((word_temp[7:0] != 0) && check_break) begin
		 $write("%c", word_temp[7:0]);
		 check_first = 0;
	      end else begin
		 if (check_first == 0) check_break = 0;
	      end
	      
	      if ((word_temp[15:8] != 0) && check_break) begin
		 $write("%c", word_temp[15:8]);
		 check_first = 0;
	      end else begin
		 if (check_first == 0) check_break = 0;
	      end
	      
	      if ((word_temp[23:16] != 0) && check_break) begin
		 $write("%c", word_temp[23:16]);
		 check_first = 0;
	      end else begin
		 if (check_first == 0) check_break = 0;
	      end
	      
	      if ((word_temp[31:24] != 0) && check_break) begin
		 $write("%c", word_temp[31:24]);
		 check_first = 0;
	      end else begin
		 if (check_first == 0) check_break = 0;
	      end
	      
	      a0_temp = a0_temp + 4;

	      while (check_break == 1) begin
		 word_temp = mymem[a0_temp[31:2]];
		 if ((word_temp[7:0] != 0) && check_break) $write("%c", word_temp[7:0]);
		 else check_break = 0;
		 
		 if ((word_temp[15:8] != 0) && check_break) $write("%c", word_temp[15:8]);
		 else check_break = 0;
		 
		 if ((word_temp[23:16] != 0) && check_break) $write("%c", word_temp[23:16]);
		 else check_break = 0;
		 
		 if ((word_temp[31:24] != 0) && check_break) $write("%c", word_temp[31:24]);
		 else check_break = 0;
		 
		 a0_temp = a0_temp + 4;
	      end // while (check_break == 1)
	      if(DEBUG_PRINT) $display("======================================================================");
	   end // case: 4
	   10: begin
	      if(DEBUG_PRINT) $display("HALT!");
	      $finish;
	   end
	 endcase // case (v0)
      end
   end
endmodule
