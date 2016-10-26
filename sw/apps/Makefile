SRC := $(wildcard *.c)

all : assemble compile dump

assemble: ; $(foreach src,$(SRC), riscv32-unknown-elf-gcc -S $(src) &&) :

compile: ; $(foreach src,$(SRC), riscv32-unknown-elf-gcc -nostdlib -nostartfiles -Tlink.ld -o $(src:.c=) $(src:.c=.s) &&) :

dump: ; -$(foreach src,$(SRC), riscv32-unknown-elf-objdump -d $(src:.c=) > $(src:.c=.dump) &&) :

clean:
	-rm $(SRC:.c=) $(SRC:.c=.s) $(SRC:.c=.dump)
