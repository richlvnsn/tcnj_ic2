OUTPUT_ARCH( "riscv" )
ENTRY( _start )
SECTIONS
{
/* text: interrupt code placed at 0x160 */
. = 0x160;
.text.inter : { interrupt.o(.text) }
/* text: init code placed at 0x200, per Z-scale specs */
. = 0x200;
.text.init : { crt.o(.text) }
/* text: text code section, placed at 0x400 */
. = 0x400;
.text :
{
*(.text)
}
/* data: Initialized data segment, placed at 0x4000 */
. = 0x4000;
.data :
{
*(.data)
}
/* End of uninitialized data */
_end = .;
}
