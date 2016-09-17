.data 
hermit: 
	.word	42
kaibab: 
	.word	912
tanner: 
	.word	8271
clear: 
	.word	-879
creek: 
	.word	-16
ribbon: 
	.word	2
falls: 
	.word	-95
tonto:
	.word	412

.text 
main: 
	# set $s3 = tonto 
	la $t0, tonto 
	lw $s3, 0($t0)

	# set $s4 = hermit 
	la $t0, hermit 
	lw $s4, 0($t0)

	# set $s5 = clear 
	la $t0, clear 
	lw $s5, 0($t0)

	# set $s6 = creek 
	la $t0, creek 
	lw $s6, 0($t0)
	
	slt $t0, $s3, $s4
	beq $t0, $zero, AFTER_IF
AFTER_IF:
	sub $t0, $s4, $s3
	la $t1, creek
	sw $t0, 0($t1)
	
	
	la $t0, creek 
	lw $s6, 0($t0)
	add $a0, $s6, $zero
	addi $v0, $zero, 1
	syscall
	