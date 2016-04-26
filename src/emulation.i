

.set TRAPINST,		0x4ef80000
.set TRAPTYPE,		0x0004
.set TRAPTYPENR,		0x0005

.set	REG68K_D0,		0
.set	REG68K_D1,		4
.set	REG68K_D2,		8
.set	REG68K_D3,		12
.set 	REG68K_D4,		16
.set	REG68K_D5,		20
.set	REG68K_D6,		24
.set	REG68K_D7,		28
.set	REG68K_A0,		32
.set	REG68K_A1,		36
.set	REG68K_A2,		40
.set	REG68K_A3,		44
.set 	REG68K_A4,		48
.set	REG68K_A5,		52
.set	REG68K_A6,		56
.set	REG68K_A7,		60

.set	REG68K_FP0,		64
.set	REG68K_FP1,		72
.set	REG68K_FP2,		80
.set	REG68K_FP3,		88
.set	REG68K_FP4,		96
.set	REG68K_FP5,		104
.set	REG68K_FP6,		112
.set	REG68K_FP7,		120

.macro	jmp	function
	.ualong	TRAPINST
	.short	TRAPTYPE
	.ualong	\function
.endm

