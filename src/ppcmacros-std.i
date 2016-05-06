
.macro loadreg register, value
	.if 	(\value >= -0x8000) && (\value <= 0x7fff)
        	li      \register, \value
	.else
		lis     \register, \value@h
		ori     \register, \register, \value@l
	.endif
.endm

.macro CALLOS interface, function
	lwz	r0,\function(\interface)
	mr	r3,\interface
	mtctr	r0
	bctrl
.endm

.macro	ldaddr register, label
	lis	\register,\label@ha
	addi	\register,\register,\label@l
.endm	
	

.macro prolog stacksize
	.ifb	\stacksize
		stwu	r1,-1080(r1)
		stw	r13,1076(r1)
	.else
		stwu	r1,-(\stacksize+56)(r1)
		stw	r13,\stacksize+52(r1)
	.endif
		lwz	r13,0(r1)
		subi	r13,r13,4
		mflr	r0
		stwu	r0,-4(r13)
		mfcr	r0
		stw	r0,-4(r13)
.endm

.macro	epilog
		lwz     r13,0(r1)
		lwz     r0,-8(r13)
		mtlr    r0
		lwz     r0,-12(r13)
		mtcr    r0
		lwz	r13,-4(r13)
		lwz	r1,0(r1)
		blr
.endm

.macro	illegal
		.long	0
.endm
