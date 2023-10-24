.PHONY: clean

include ../../mk/toolchain.mk

CFLAGS = -march=rv32i_zicsr_zifencei -mabi=ilp32 -Wall -Ofast

OBJS = \
    getcycle.o \
    code.o
BIN = code.elf


%.o: %.S
	$(CROSS_COMPILE)gcc $(CFLAGS) -c -o $@ $<

all: $(BIN)

code.S: code.c
	$(CROSS_COMPILE)gcc $(CFLAGS) -S -o $@ $<

$(BIN): $(OBJS)
	 $(CROSS_COMPILE)gcc -o $@ $^

clean:
	$(RM) $(BIN) $(OBJS) code.S
