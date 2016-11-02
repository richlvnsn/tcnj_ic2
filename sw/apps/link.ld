OUTPUT_ARCH( "riscv" )
ENTRY( main )
SECTIONS
{
. = 0x200;
.text.init : { crt.o(.text) }
/* text: test code section, arbitrarily placed at 0x800 for now */
. = 0x800;
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
