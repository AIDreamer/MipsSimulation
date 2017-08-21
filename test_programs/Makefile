# TungstenHammer CSCI320
# Michael Hammer - Son Pham - Tung Phan
# MIPS CPU Implementation
# Based on Harris & Harris' "Digital Design and Computer Architecture" (2012)

HELLO = ./hello
FIB = ./fib
CIPH = ./cipher

all: hello fib cipher

hello:
	make -C $(HELLO) all

fib:
	make -C $(FIB) all

cipher:
	make -C $(CIPH) all

clean: hello_clean fib_clean ciph_clean

hello_clean:
	make -C $(HELLO) clean

fib_clean:
	make -C $(FIB) clean

ciph_clean:
	make -C $(CIPH) clean

# Make clean doesn't really work yet
