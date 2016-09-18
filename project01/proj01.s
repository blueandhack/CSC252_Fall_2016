# CSc 252 Fall 2016
# Name: Yujia Lin
# Project 01
# The program has four function that can print four numbers,
# print sum, print multiply, print minimum

.data

printStr:	.asciiz "Printing the four values:\n"
sumStr:		.asciiz "Running totals:\n"
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
        
        # Put foo value to $s1
	la	$t0, foo	# $t0 = &foo
        lb	$s1, 0($t0)	# $s1 = foo
        
        # Put bar value to $s2
        la	$t0, bar	# $t0 = &bar
        lw	$s2, 0($t0)	# $s2 = bar
        
        # Put baz value to $s3
        la	$t0, baz	# $t0 = &baz
        lw	$s3, 0($t0)	# $s3 = baz
        
        # Put fred value to $s4
        la	$t0, fred	# $t0 = &fred
        lh	$s4, 0($t0)	# $s4 = fred
        
checkPrint:
        la	$t0, print	# $t0 = &print
        lw	$s0, 0($t0)	# $s0 = print
        bne	$s0, $zero, printNumber	# if print != 0 then go to printNumber
        
checkSum:
	la	$t0, sum	# $t0 = &sum
	lw	$s0, 0($t0)	# $s0 = sum
	bne	$s0, $zero, printSum	# if sum != 0 then go to printSum
	
checkMultiply:
	la	$t0, multiply	# $t0 = &multiply
	lw	$s0, 0($t0)	# $s0 = multiply
	bne	$s0, $zero, printMultiply	# if minimum != 0 then go to printMultiply
	
checkMinimum:
	la	$t0, minimum	# $t0 = &minimum
        lw	$s0, 0($t0)	# $s0 = minimum
        bne	$s0, $zero, printMinimum	# if print != 0 then go to printMinimum
        j	done

printNumber:
	# print "Printing the four vlues:"
	la	$a0, printStr	#
	addi	$v0, $zero, 4	# Print printStr 
	syscall 		#

	# Print foo
	add	$a0, $s1, $zero	#
	addi	$v0, $zero, 1	# Print foo
	syscall			#
	
	# Print newLine
	la	$a0, newline	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	
	# Print bar
	add	$a0, $s2, $zero	#
	addi	$v0, $zero, 1	# Print bar
	syscall			#
	
	# Print newLine
	la	$a0, newline	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	
	# print baz
	add	$a0, $s3, $zero	#
	addi	$v0, $zero, 1	# Print baz
	syscall			#
	
	# Print newLine
	la	$a0, newline	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	
	# Print fred
	add	$a0, $s4, $zero	#
	addi	$v0, $zero, 1	# Print fred
	syscall			#
	
	# Print newLine
	la	$a0, newline	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	
	# Print newLine
	la	$a0, newline	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	
	j	checkSum	# Jump to checkSum
	
printSum:
	# print "Running totals:"
	la	$a0, sumStr	#
	addi	$v0, $zero, 4	# Print sumStr
	syscall			#
	
	# print foo + 0
	add	$t0, $s1, $zero	# $t0 = foo
	add	$a0, $t0, $zero	#
	addi	$v0, $zero, 1	# Print foo
	syscall			#
	la	$a0, newline	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	
	# print foo + bar
	add	$t0, $t0, $s2	# $t0 = foo + bar
	add	$a0, $t0, $zero	#
	addi	$v0, $zero, 1	# Print foo + bar
	syscall			#
	la	$a0, newline	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	
	# print foo + bar + baz
	add	$t0, $t0, $s3	# $t0 = foo + bar + baz
	add	$a0, $t0, $zero	#
	addi	$v0, $zero, 1	# Print foo + bar + baz
	syscall			#
	la	$a0, newline	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	
	#print foo + bar + baz + fred
	add	$t0, $t0, $s4	# $t0 = foo + bar + baz + fred
	add	$a0, $t0, $zero	#
	addi	$v0, $zero, 1	# Print foo + bar + baz + fred
	syscall			#
	la	$a0, newline	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	
	# print newline
	la	$a0, newline	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#

	j	checkMultiply	# Jump to checkMultiply
	
printMultiply:
	# print "Multiplying" each value by 7:"
	la	$a0, multiplyStr	#
	addi	$v0, $zero, 4	# Print multiplyStr
	syscall			#
	
	# foo * 7
	add	$t0, $s1, $zero	# $t0 = foo
	add	$t0, $t0, $s1	# $t0 = $t0 (foo) + foo
	add	$t0, $t0, $s1	# $t0 = $t0 (foo + foo) + foo
	add	$t0, $t0, $s1	# $t0 = $t0 (foo + foo + foo) + foo
	add	$t0, $t0, $s1	# $t0 = $t0 (foo + foo + foo + foo) + foo
	add	$t0, $t0, $s1	# $t0 = $t0 (foo + foo + foo + foo + foo) + foo
	add	$t0, $t0, $s1	# $t0 = $t0 (foo + foo + foo + foo + foo + foo) + foo
	add	$a0, $t0, $zero	# $a0 = $t0 (foo * 7)
	addi	$v0, $zero, 1	# Print foo * 7
	syscall			#
	
	# Print whitespaces
	la	$a0, whitespaces	#
	addi	$v0, $zero, 4	# Print whitespaces
	syscall			#
	
	# bar * 7
	add	$t0, $s2, $zero	# $t0 = bar
	add	$t0, $t0, $s2	# $t0 = $t0 (bar) + bar
	add	$t0, $t0, $s2	# $t0 = $t0 (bar + bar) + bar
	add	$t0, $t0, $s2	# $t0 = $t0 (bar + bar + bar) + bar
	add	$t0, $t0, $s2	# $t0 = $t0 (bar + bar + bar + bar) + bar
	add	$t0, $t0, $s2	# $t0 = $t0 (bar + bar + bar + bar + bar) + bar
	add	$t0, $t0, $s2	# $t0 = $t0 (bar + bar + bar + bar + bar + bar) + bar
	add	$a0, $t0, $zero	# $a0 = $t0 (bar * 7)
	addi	$v0, $zero, 1	# Print bar * 7
	syscall			#
	
	# Print whitespaces
	la	$a0, whitespaces	#
	addi	$v0, $zero, 4	# Print whitespaces
	syscall			#
	
	# baz * 7
	add	$t0, $s3, $zero	# $t0 = baz
	add	$t0, $t0, $s3	# $t0 = $t0 (baz) + baz
	add	$t0, $t0, $s3	# $t0 = $t0 (baz + baz) + baz
	add	$t0, $t0, $s3	# $t0 = $t0 (baz + baz + baz) + baz
	add	$t0, $t0, $s3	# $t0 = $t0 (baz + baz + baz + baz) + baz
	add	$t0, $t0, $s3	# $t0 = $t0 (baz + baz + baz + baz + baz) + baz
	add	$t0, $t0, $s3	# $t0 = $t0 (baz + baz + baz + baz + baz + baz) + baz
	add	$a0, $t0, $zero	# $t0 = $t0 (baz * 7)
	addi	$v0, $zero, 1	# Print baz * 7
	syscall			#
	
	# Print whitespaces
	la	$a0, whitespaces	#
	addi	$v0, $zero, 4	# Print whitespaces
	syscall			#
	
	# fred * 7
	add	$t0, $s4, $zero	# $t0 = fred
	add	$t0, $t0, $s4	# $t0 = $t0 (fred) + fred
	add	$t0, $t0, $s4	# $t0 = $t0 (fred + fred) + fred
	add	$t0, $t0, $s4	# $t0 = $t0 (fred + fred + fred) + fred
	add	$t0, $t0, $s4	# $t0 = $t0 (fred + fred + fred + fred) + fred
	add	$t0, $t0, $s4	# $t0 = $t0 (fred + fred + fred + fred + fred) + fred
	add	$t0, $t0, $s4	# $t0 = $t0 (fred + fred + fred + fred + fred + fred) + fred
	add	$a0, $t0, $zero	# $t0 = $t0 (fred * 7)
	addi	$v0, $zero, 1	# Print fred * 7
	syscall			#
	
	# Print newLine
	la	$a0, newline	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	
	# Print newline
	la	$a0, newline	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	
	j	checkMinimum	# Jump to checkMinmum
	
printMinimum:

	# print "Minimum:"
	la	$a0, minimumStr	#
	addi	$v0, $zero, 4	# Print minimumStr
	syscall			#
	
	slt	$t0, $s1, $s2	# if $s1 < $s2
	beq	$t0, $zero, oneBigger # else go to oneBigger
	add	$t1, $s1, $zero	# $t1 = $s1
	
	j	checkLastPart	# Jump to checkLastPart
	
oneBigger:
	add	$t1, $s2, $zero # Get minimum number between two number
	
	j	checkLastPart	# Jump to checkLastPart
	
checkLastPart:
	slt	$t0, $s3, $s4	# If $s3 < $s4
	beq	$t0, $zero, threeBigger	# else jump to threeBigger
	add	$t2, $s3, $zero	# $t2 = $s3
	
	j	finalCheckMin	# Jump to finalCheckMin
	
threeBigger:
	add	$t2, $s4, $zero	# $t2 = $s4
	
	j	finalCheckMin	# Jump to finalCheckMin
	
finalCheckMin:
	slt	$t0, $t1, $t2	# If $1 < $2
	beq	$t0, $zero, firstBigger	# else jump to firstBigger
	add	$t3, $t1, $zero	# $t3 = $t1
	add	$a0, $t3, $zero	#
	addi	$v0, $zero, 1	# Print minimum number
	syscall			#
	
	# Print double newLine
	la	$a0, newline	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	la	$a0, newline	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	
	j	done		# Jump to done
	
firstBigger:
	add	$t3, $t2, $zero	# $t3 = $t2
	add	$a0, $t3, $zero	#
	addi	$v0, $zero, 1	# Print minimum number
	syscall			#
	
	# Print double newLine
	la	$a0, newline	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	la	$a0, newline	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	
	j	done		# Jump to done
	
done:
	# Epilogue for main -- restore stack & frame pointers and return
        lw    $ra, 4($sp)     # get return address from stack
        lw    $fp, 0($sp)     # restore the caller's frame pointer
        addiu $sp, $sp, 24    # restore the caller's stack pointer
        jr    $ra             # return to caller's code
