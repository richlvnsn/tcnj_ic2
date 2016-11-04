SRC := $(wildcard *.c)

all : assemble compile dump

assemble: ; $(foreach src,$(SRC), riscv32-unknown-elf-gcc -S $(src) &&) :

compile: ; riscv32-unknown-elf-gcc -c crt.s
	$(foreach src,$(SRC), riscv32-unknown-elf-gcc -nostdlib -nostartfiles -Tlink.ld -o $(src:.c=) $(src:.c=.s) &&) :
	rm crt.o

dump: ; -$(foreach src,$(SRC), riscv32-unknown-elf-objdump -d $(src:.c=) > $(src:.c=.dump) &&) :

clean:
	-rm $(SRC:.c=) $(SRC:.c=.s) $(SRC:.c=.dump)
