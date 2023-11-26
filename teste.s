.text

MAIN:	
########### zerando registradores ##########
	sub t0, t0, t0
	sub t1, t1, t1
	sub t2, t2, t2
	sub t3, t3, t3
	sub t4, t4, t4
	sub t6, t6, t6
############################################
	addi t0, t0, 30 #t0=30
	addi t1, t1, 80 #t1=80
	add s2, t0, t1 #s2 = 110
	sub s3, t1, t0 #s3 = 50
	and s4, t1, t0 # s4 = 18
	andi s5, t1, 25
	or s6, t1, t0
	ori s7, t0, 35
	slt s8, t0, t1
########## Carregando endereco 0x1001000 em t2 #############
	addi t2, t2, 2047
	addi t2, t2, 2047
	addi t2, t2, 2047
	addi t2, t2, 2047
	addi t2, t2, 2047
	addi t2, t2, 2047
	addi t2, t2, 2047
	addi t2, t2, 2047 
	addi t2, t2, 2047
	addi t2, t2, 2047
	addi t2, t2, 2047
	addi t2, t2, 2047
	addi t2, t2, 2047
	addi t2, t2, 2047
	addi t2, t2, 2047
	addi t2, t2, 2047
	addi t2, t2, 16
	add t2, t2, gp
############################################################
	lw t3, 0(t2)
	addi t4, t4, 360
	sw t4, 4(t2)
	addi t0, t0, 50
	beq t0, t1, BJUMP
	addi t6, t6, 140
	sub t6, t6, t6
BJUMP: 
	xori t6, t0, 46
	jal ra, MAIN




	
	