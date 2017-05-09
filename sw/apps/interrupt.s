	.text
	.align	2
	.globl	_interrupt
_interrupt:
	add	sp,sp,-32
	sw	s0,28(sp)
	add	s0,sp,32
	sw	a4,-20(s0)
	sw	a5,-24(s0)
	sw  a0, -28(s0)
	sw  ra, -32(s0)
	li	a5,32768
	add	a5,a5,8
	li	a4,65536
	add	a4,a4,-1
	sw	a4,0(a5)
	li	a5,32768
	add	a5,a5,20
	li	a4,255
	sw	a4,0(a5)
	li	a5,9998336
	add	a0,a5,1664
	call	delay
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	lw  a0,-28(s0)
	lw  ra,-32(s0) 
	lw	s0,28(sp)
	add	sp,sp,32
	csrrs t0, mepc, zero
	jr t0
