
.data
	FLOAT: .float -3.1415926

.text
	.include "../MACROSv24.s"

#	la t0,FLOAT
#	flw fa0,0(t0)

	li a7,106
	ecall


	li a1,10
	li a2,10
	li a3,0x0FF
	li a4,0

	li a7,2
	ecall

	li a7, 102
	ecall
	
	li a7,10
	ecall


	.include "../SYSTEMv24.s"