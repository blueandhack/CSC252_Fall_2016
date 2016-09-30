.data
mask: .word 0xF0F0F0F0
number: .word 1
.text
main:

	addi $s1, $zero, -1	
	andi $s2, $s1, 0xffff
	add $a0, $zero, $s2
	addi $v0, $zero, 1
	syscall
	
	addi	$a0, $zero, 0xa		# print_char('\n')
	add	$v0, $zero, 11
	syscall
	
	ori $s3, $zero, 0xffff
	add $a0, $zero, $s3
	addi $v0, $zero, 1
	syscall
	
	addi	$a0, $zero, 0xa		# print_char('\n')
	add	$v0, $zero, 11
	syscall

	la	$t0, number
	lw	$s0, 0($t0)
	
	sll	$s1, $s0, 1
	add	$s1, $s1, $s0
	sll	$s1, $s1, 2
	add	$s1, $s1, $s0
	
	add	$a0, $zero, $s1
	addi	$v0, $zero, 1
	syscall
	
	