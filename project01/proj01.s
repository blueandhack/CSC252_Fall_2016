# CSc 252 Fall 2016
# Name: Yujia Lin
# Project 01

.data
printStr:	.asciiz "Printing the four values:\n"
sumStr:	.asciiz "Running totals:\n"
multiplyStr:	.asciiz "\"Multiplying\" each value by 7:\n"
minimumStr:	.asciiz "Minimum: "
newline:	.asciiz "\n"
whitespaces:	.asciiz "  "

.text

main:
	# Function prologue -- even main has one
        addiu $sp, $sp, -24   # allocate stack space -- default of 24 here
        sw    $fp, 0($sp)     # save caller's frame pointer
        sw    $ra, 4($sp)     # save return address
        addiu $fp, $sp, 20    # setup main's frame pointer
        
        
	la	$t0, foo	# $t0 = &foo
        lb	$s1, 0($t0)	# $s1 = foo
        
        la	$t0, bar	# $t0 = &bar
        lw	$s2, 0($t0)	# $s2 = bar
        
        la	$t0, baz	# $t0 = &baz
        lw	$s3, 0($t0)	# $s3 = baz
        
        la	$t0, fred	# $t0 = &fred
        lh	$s4, 0($t0)	# $s4 = fred
        
checkPrint:
        la	$t0, print	# $t0 = &print
        lw	$s0, 0($t0)	# $s0 = print
        bne	$s0, $zero, printNumber	# if print != 0 then go to printNumber
checkSum:
	la	$t0, sum	# $t0 = &sum
	lw	$s0, 0($t0)	# $s0 = sum
	bne	$s0, $zero, printSum	# if sum == 0 then go to printSum
checkMultiply:
	la	$t0, multiply	# $t0 = &multiply
	lw	$s0, 0($t0)	# $s0 = multiply
	bne	$s0, $zero, printMultiply	# if minimum == 0 then go to printMultiply
checkMinimum:
	la	$t0, minimum	# $t0 = &minimum
        lw	$s0, 0($t0)	# $s0 = minimum
        bne	$s0, $zero, printMinimum	# if print != 0 then go to printMinimum
        j	done

printNumber:
	# print "Printing the four vlues:"
	la	$a0, printStr
	addi	$v0, $zero, 4
	syscall 

	# print foo
	add	$a0, $s1, $zero
	addi	$v0, $zero, 1
	syscall
	la	$a0, newline
	addi	$v0, $zero, 4
	syscall
	
	# print bar
	add	$a0, $s2, $zero
	addi	$v0, $zero, 1
	syscall
	la	$a0, newline
	addi	$v0, $zero, 4
	syscall
	
	# print baz
	add	$a0, $s3, $zero
	addi	$v0, $zero, 1
	syscall
	la	$a0, newline
	addi	$v0, $zero, 4
	syscall
	
	# print fred
	add	$a0, $s4, $zero
	addi	$v0, $zero, 1
	syscall
	la	$a0, newline
	addi	$v0, $zero, 4
	syscall
	
	# print newline
	la	$a0, newline
	addi	$v0, $zero, 4
	syscall
	
	j	checkSum
	
printSum:
	# print "Running totals:"
	la	$a0, sumStr
	addi	$v0, $zero, 4
	syscall
	
	# print foo + 0
	add	$t0, $s1, $zero
	add	$a0, $t0, $zero
	addi	$v0, $zero, 1
	syscall
	la	$a0, newline
	addi	$v0, $zero, 4
	syscall
	
	# print foo + bar
	add	$t0, $t0, $s2
	add	$a0, $t0, $zero
	addi	$v0, $zero, 1
	syscall
	la	$a0, newline
	addi	$v0, $zero, 4
	syscall
	
	# print foo + bar + baz
	add	$t0, $t0, $s3
	add	$a0, $t0, $zero
	addi	$v0, $zero, 1
	syscall
	la	$a0, newline
	addi	$v0, $zero, 4
	syscall
	
	#print foo + bar + baz + fred
	add	$t0, $t0, $s4
	add	$a0, $t0, $zero
	addi	$v0, $zero, 1
	syscall
	la	$a0, newline
	addi	$v0, $zero, 4
	syscall
	
	# print newline
	la	$a0, newline
	addi	$v0, $zero, 4
	syscall

	j	checkMultiply
	
printMultiply:
	# print "Multiplying" each value by 7:"
	la	$a0, multiplyStr
	addi	$v0, $zero, 4
	syscall
	
	# foo * 7
	add	$t0, $s1, $zero
	add	$t0, $t0, $s1
	add	$t0, $t0, $s1
	add	$t0, $t0, $s1
	add	$t0, $t0, $s1
	add	$t0, $t0, $s1
	add	$t0, $t0, $s1
	add	$a0, $t0, $zero
	addi	$v0, $zero, 1
	syscall
	la	$a0, whitespaces
	addi	$v0, $zero, 4
	syscall
	
	# bar * 7
	add	$t0, $s2, $zero
	add	$t0, $t0, $s2
	add	$t0, $t0, $s2
	add	$t0, $t0, $s2
	add	$t0, $t0, $s2
	add	$t0, $t0, $s2
	add	$t0, $t0, $s2
	add	$a0, $t0, $zero
	addi	$v0, $zero, 1
	syscall
	la	$a0, whitespaces
	addi	$v0, $zero, 4
	syscall
	
	# baz * 7
	add	$t0, $s3, $zero
	add	$t0, $t0, $s3
	add	$t0, $t0, $s3
	add	$t0, $t0, $s3
	add	$t0, $t0, $s3
	add	$t0, $t0, $s3
	add	$t0, $t0, $s3
	add	$a0, $t0, $zero
	addi	$v0, $zero, 1
	syscall
	la	$a0, whitespaces
	addi	$v0, $zero, 4
	syscall
	
	# fred * 7
	add	$t0, $s4, $zero
	add	$t0, $t0, $s4
	add	$t0, $t0, $s4
	add	$t0, $t0, $s4
	add	$t0, $t0, $s4
	add	$t0, $t0, $s4
	add	$t0, $t0, $s4
	add	$a0, $t0, $zero
	addi	$v0, $zero, 1
	syscall
	la	$a0, newline
	addi	$v0, $zero, 4
	syscall
	
	# print newline
	la	$a0, newline
	addi	$v0, $zero, 4
	syscall
	
	j	checkMinimum
	
printMinimum:

	# print "Minimum:"
	la	$a0, minimumStr
	addi	$v0, $zero, 4
	syscall
	
	slt	$t0, $s1, $s2	# if $s1 < $s2
	beq	$t0, $zero, oneBigger # else go to oneBigger
	add	$t1, $s1, $zero
	j	checkLastPart
	
oneBigger:
	add	$t1, $s2, $zero
	j	checkLastPart
	
checkLastPart:
	slt	$t0, $s3, $s4
	beq	$t0, $zero, threeBigger
	add	$t2, $s3, $zero
	j	finalCheckMin
	
threeBigger:
	add	$t2, $s4, $zero
	j	finalCheckMin
	
finalCheckMin:
	slt	$t0, $t1, $t2
	beq	$t0, $zero, firstBigger
	add	$t3, $t1, $zero
	add	$a0, $t3, $zero
	addi	$v0, $zero, 1
	syscall
	la	$a0, newline
	addi	$v0, $zero, 4
	syscall
	la	$a0, newline
	addi	$v0, $zero, 4
	syscall
	j	done
	
firstBigger:
	add	$t3, $t2, $zero
	add	$a0, $t3, $zero
	addi	$v0, $zero, 1
	syscall
	la	$a0, newline
	addi	$v0, $zero, 4
	syscall
	la	$a0, newline
	addi	$v0, $zero, 4
	syscall
	j	done
	
done:
	# Epilogue for main -- restore stack & frame pointers and return
        lw    $ra, 4($sp)     # get return address from stack
        lw    $fp, 0($sp)     # restore the caller's frame pointer
        addiu $sp, $sp, 24    # restore the caller's stack pointer
        jr    $ra             # return to caller's code
	
	
	
        
