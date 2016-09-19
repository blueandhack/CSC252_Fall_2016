# CSc 252
# Project 02
# Name: Yujia Lin

.data 
integers:	.byte	0
forward:	.byte	1

numInts:	.word	3

ints:
	.word	10
	.word	-20
	.word	10
	
str:	.asciiz "The quick browm fox jumps over the lazy dog."

.text 

main:
	# Function prologue -- even main has one
        addiu $sp, $sp, -24   # allocate stack space -- default of 24 here
        sw    $fp, 0($sp)     # save caller's frame pointer
        sw    $ra, 4($sp)     # save return address
        addiu $fp, $sp, 20    # setup main's frame pointer
        
        # Load integers
        la	$t0, integers	# $t0 = &integers
        lb	$s0, 0($t0)	# $s0 = integers
        
        # Load forward
        la	$t0, forward	# $t0 = &forward
        lb	$s1, 0($t0)	# $s1 = forward
        
        # Load numInts
        la	$t0, numInts	# $t0 = &numInts
        lw	$s3, 0($t0)	# $s3 = numInts
        
checkIntegerForward:
	beq	$s0, $zero, checkIntegerBackward	# if integers == 0 then jump to checkIntegerBackward
	beq	$s1, $zero, checkIntegerBackward	# if forward == 0 then jump to checkIntegerBackward
	j	integerForward				# if integers != 0 && forward != 0 then jump to integerForward
	
checkIntegerBackward:
	beq	$s0, $zero, checkStringForward		# if integers == 0 then jump to checkStringForward
	bne	$s1, $zero, checkStringForward		# if forward != 0 then jump to checkStringForward
	j	integerBackward				# if integers != 0 && forward == 0 then jump to integerBackward
	
checkStringForward:
	bne	$s0, $zero, checkStringBackward		# if integers != 0 then jump to checkStringBackward
	beq	$s1, $zero, checkStringBackward		# if forward == 0 then jump to checkStringBackward
	j	stringForward			# if integers == 0 && forward != 0 then jump to stringForward

checkStringBackward:
	bne	$s0, $zero, done			# if integers != 0 then jump to done
	bne	$s1, $zero, done			# if forward != 0 then jump to done
	j	stringBackward				# if integers == 0 && forward == 0 then jump to stringBackward
	
	                
integerForward:
	addi	$t1, $zero, 0	# i = 0
	la	$t0, ints
integerForwardLoopBegin:
	# Test if for loop is done
	slt	$t2, $t1, $s3	# $t2 = i < numInts
	beq	$t2, $zero, integerForwardLoopEnd
	# Compute address of ints[i]
	add	$t3, $t1, $t1
	add	$t3, $t3, $t3	# $t3 = 4 * i
	add	$t2, $t0, $t3	# $t2 = address of ints[i]
	lw	$a0, 0($t2)
	addi	$v0, $zero, 1
	syscall
	
	addi	$t1, $t1, 1
	j	integerForwardLoopBegin
	
integerForwardLoopEnd:
	j	checkIntegerBackward

integerBackward:  

stringForward:

stringBackward:
        
done:
	# Epilogue for main -- restore stack & frame pointers and return
        lw    $ra, 4($sp)     # get return address from stack
        lw    $fp, 0($sp)     # restore the caller's frame pointer
        addiu $sp, $sp, 24    # restore the caller's stack pointer
        
