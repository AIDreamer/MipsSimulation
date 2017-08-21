# TungstenHammer CSCI320
# Michael Hammer - Son Pham - Tung Phan
# MIPS CPU Implementation
# Based on Harris & Harris' "Digital Design and Computer Architecture" (2012)

# Makefile for Pipelined CPU project

SRC = ./modules
BIN = ./bin
PROG = ./test_programs

# Flags for Verilog generation

MAIN_SOURCE = $(SRC)/processor.v $(SRC)/adder.v $(SRC)/ALU.v $(SRC)/control.v $(SRC)/dataMemory.v $(SRC)/memory.v $(SRC)/muxer.v $(SRC)/registers.v $(SRC)/signExtend.v $(SRC)/hazardControl.v $(SRC)/pipeReg_FD.v $(SRC)/pipeReg_DE.v $(SRC)/pipeReg_EM.v $(SRC)/pipeReg_MW.v $(SRC)/pipeReg_PC.v $(SRC)/flushJump.v $(SRC)/comparer.v

all: main prog

main: $(MAIN_SOURCE)
	iverilog -o $(BIN)/main $(MAIN_SOURCE)
prog:
	make -C $(PROG) all
clean:
	rm -rf $(BIN)/*
run:
	@printf "\nProgram 1: Hello World\n"
	@./chngTest.sh hello/hello.v
	@./bin/main

	@printf "\n\nProgram 2: Fibonacci\n"
	@./chngTest.sh fib/fib.v
	@./bin/main

	@printf "\nProgram 3: Xor-mod cipher\n"
	@./chngTest.sh cipher/cipher.v
	@./bin/main
