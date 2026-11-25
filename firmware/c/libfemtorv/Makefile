OBJECTS =  microwait.o  milliwait.o  wait_cycles.o  femtorv32.o  uart.o cycles_32.o print.o printf.o
CROSS   = riscv64-unknown-elf
CC      = $(CROSS)-gcc
AS      = $(CROSS)-as
LD      = $(CROSS)-ld
AR      = $(CROSS)-ar
RANLIB  = $(CROSS)-ranlib
OBJCOPY = $(CROSS)-objcopy
OBJDUMP = $(CROSS)-objdump
AFLAGS  = -march=rv32i -mabi=ilp32
CFLAGS  = -Iinclude -I. -fno-pic -march=rv32i -mabi=ilp32 -fno-stack-protector -w -Wl,--no-relax


all: libfemtorv.a crt0_baremetal.o

libfemtorv.a: $(OBJECTS) 
	$(AR) cq $@ $(OBJECTS)
	$(RANLIB) $@	
%.o: %.c
	$(CC) $(CFLAGS) -c $<
%.o: %.S
	$(AS) $(AFLAGS) -c $< -o $@
clean:
	rm -rf  $(OBJECTS) *.elf *.bin .*~ *~ *.map *.d *.hex *.o libfemtorv.a
.PHONY: clean
