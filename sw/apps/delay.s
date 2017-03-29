	.text
	.align	2
	.global	delay
	.func delay, delay

delay:
	add	a0, a0, -1
	bnez	a0, delay
	jr	ra

