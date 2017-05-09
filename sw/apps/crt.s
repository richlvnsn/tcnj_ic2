	.text
	.align	2
	.globl	_start
_start:
	li t0, 1
	csrrs t1, mstatus, t0
	li t0, 256
	csrrs t1, mie, t0
	li	sp, 0x8000
	j main
