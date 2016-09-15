.data
print:	.word   1
sum:    .word   0
multiply:   .word   0
minimum:    .word   1

foo:    .byte   0
bar:    .word   42
baz:    .word   17
fred:	.half   -123

printStr:	.ascii  "Printing the four vlues:\n"
sumStr:		.ascii	"Running totals:\n"
multiplyStr:	.ascii 	"\"Multiplying\" each value by 7:"
minimumStr:	.ascii 	"Minimum:"
newline:	.ascii	"\n"

.text

main:
	la	$t0, foo
        lb	$s1, 0($t0)
        
        la	$t0, bar
        lw	$s2, 0($t0)
        
        la	$t0, baz
        lw	$s3, 0($t0)
        
        la	$t0, fred
        lh	$s4, 0($t0)
        
        la	$t0, print
        lw	$s0, 0($t0)
        bne	$s0, $zero, printNumber
        
printNumber:
	la	$t0, printStr
	addi	$v0, $t0, $zero
	syscall 

	add	$a0, $s1, $zero
	addi	$v0, $zero, 1
	
        
