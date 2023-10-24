.PHONY: clean

include ../../mk/toolchain.mk

ASFLAGS = -march=rv32i_zicsr_zifencei -mabi=ilp32
LDFLAGS = --oformat=elf32-littleriscv

%.o: %.S
	$(CROSS_COMPILE)as -R $(ASFLAGS) -o $@ $<

all: code.elf

code.elf: code.o getcycle.o
	 $(CROSS_COMPILE)ld -o $@ -T code.ld $(LDFLAGS) $<

clean:
	$(RM) code.elf code.o
