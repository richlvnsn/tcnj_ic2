SRC := $(wildcard *.c)

cc = riscv32-unknown-elf-gcc
cflags = -nostdlib -nostartfiles -Tlink.ld
asmfiles = delay.s
objdump = riscv32-unknown-elf-objdump
elf2hex = elf2hex 8 1024

all : assemble compile dump hex

assemble: ; $(foreach src,$(SRC), $(cc) -S $(src) &&) :

compile: ; riscv32-unknown-elf-gcc -c crt.s
	riscv32-unknown-elf-gcc -c interrupt.s
	$(foreach src,$(SRC), $(cc) $(asmfiles) $(cflags) -o $(src:.c=) $(src:.c=.s) &&) :
	rm crt.o interrupt.o

dump: ; -$(foreach src,$(SRC), $(objdump) -d $(src:.c=) > $(src:.c=.dump) &&) :

hex: ; -$(foreach src,$(SRC), $(elf2hex) $(src:.c=) > ../hex/$(src:.c=.hex) &&) :
	$(foreach src,$(SRC), python ../tools/spiconverter.py -i ../hex/$(src:.c=.hex) -o ../hex/$(src:.c=_spi.hex) &&) :
	$(foreach src,$(SRC), python ../tools/hexconverter.py -i ../hex/$(src:.c=_spi.hex) -o ../hex/fpga_$(src:.c=.hex) &&) :
	$(foreach src,$(SRC), rm  ../hex/$(src:.c=.hex) &&) :

clean:
	-rm $(SRC:.c=) $(SRC:.c=.s) $(SRC:.c=.dump)
	$(foreach src,$(SRC), rm  ../hex/fpga_$(src:.c=.hex) ../hex/$(src:.c=_spi.hex) &&) :
