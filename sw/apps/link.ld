OUTPUT_ARCH( "riscv" )
ENTRY( main )
SECTIONS
{
/* text: test code section */
. = 0x200;
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
