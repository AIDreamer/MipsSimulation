/*
 TungstenHammer CSCI320
 Michael Hammer - Son Pham - Tung Phan
 MIPS CPU Implementation
 Based on Harris & Harris' "Digital Design and Computer Architecture" (2012)
 */

/*
 instrMem - module to model instruction memory of our CPU.
 
 INPUT
 read_addr: 32-bit address of the intruction
 
 OUTPUT
 memout: 32-bit instruction for the CPU, altered in situations like syscalls
 ori_memout: 32-bit unmodified instruction for monitoring and syscall handling
 */
module instrMem(read_addr, memout, ori_memout);

   /* Param */
   parameter INST_DELAY = 250;
   parameter SYSCALL_INST = 32'h0000000C;
   parameter SYSCALL_SUBS_INST = 32'h00820020;
   parameter NOP_INST = 32'h00000000;
   
   /* Input */
   input [29 : 0] read_addr;
   
   /* Regs */
   reg [31:0] memout_next, ori_memout_next;
   reg [31:0] mymem [32'h00100000 : 32'h00100400];
   
   /* Output */
   output [31 : 0] memout;
   output [31 : 0] ori_memout;
   
   assign #INST_DELAY ori_memout = ori_memout_next;
   assign #INST_DELAY memout = memout_next;
   
   initial
     begin
	$readmemh("include/inst_mem.in", mymem);
     end
   always @(*) 
     begin
	case(mymem[read_addr])
	  SYSCALL_INST:
	    memout_next <= SYSCALL_SUBS_INST;
	  32'bx:
	    memout_next <= NOP_INST;
	  default:
	    memout_next <= mymem[read_addr];
	endcase // case (mymem[read_addr])
	ori_memout_next <= mymem[read_addr];
     end // always @ (*)
endmodule // instrMem
