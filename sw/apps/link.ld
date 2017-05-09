OUTPUT_ARCH( "riscv" )
ENTRY( _start )
SECTIONS
{
. = 0x160;
.text.inter : { interrupt.o(.text) }
. = 0x200;
.text.init : { crt.o(.text) }
/* text: test code section, arbitrarily placed at 0x800 for now */
. = 0x400;
.text :
{
*(.text)
}
/* data: Initialized data segment */
.data :
{
*(.data)
}
/* End of uninitialized data */
_end = .;
}
