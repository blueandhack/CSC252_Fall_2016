# CSc 252
# Project 02
# Name: Yujia Lin

.data 
newLine:	.asciiz "\n"

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
	addi	$t1, $zero, 0	# $t1 = i = 0
	la	$t0, ints
integerForwardLoopBegin:
	# Test if for loop is done
	slt	$t2, $t1, $s3	# $t2 = i < numInts
	beq	$t2, $zero, integerForwardLoopEnd
	# Compute address of ints[i]
	add	$t3, $t1, $t1
	add	$t3, $t3, $t3	# $t3 = 4 * i
	add	$t2, $t0, $t3	# $t2 = address of ints[i]
	lw	$t4, 0($t2)
	bne	$t4, $zero, printIntegersForForward	# if ints[i] != 0 then jump to printIntegersForForward
	j	integerForwardPlus	# if ints[i] == 0 then jump to integerForwardLoopBegin
printIntegersForForward:
	lw	$a0, 0($t2)	#
	addi	$v0, $zero, 1	# Print ints[i]
	syscall			#
	
	la	$a0, newLine	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	j	integerForwardPlus

integerForwardPlus:	
	addi	$t1, $t1, 1	# i ++
	j	integerForwardLoopBegin
	
integerForwardLoopEnd:
	j	checkIntegerBackward


integerBackward:  
	sub	$t1, $s3, 1	# $t1 = numInts - 1
	la	$t0, ints
integerBackwardLoopBegin:
	# Test if for loop is done
	slt	$t2, $t1, $zero	# $t2 = i < 0
	bne	$t2, $zero, integerBackwardLoopEnd
	# Compute address of ints[i]
	add	$t3, $t1, $t1
	add	$t3, $t3, $t3
	add	$t2, $t0, $t3
	lw	$a0, 0($t2)
	addi	$v0, $zero, 1
	syscall
	
	la	$a0, newLine	#
	addi	$v0, $zero, 4	# Print newLine
	syscall	
	
	sub	$t1, $t1, 1
	j	integerBackwardLoopBegin
integerBackwardLoopEnd:
	j	checkStringForward


stringForward:
	addi	$t1, $zero, 0	# i = 0
	la	$t0, str
	
stringForwardBegin:
	add	$t2, $t0, $t1
	lb	$t3, 0($t2)
	beq	$t3, $zero, checkStringBackward # if str[i] = '\0' then jump to checkStringBackward
	add	$t3, $t1, $t0
	lb	$s4, 0($t3)
	slti	$t5, $s4, 65
	bne	$t5, $zero, do
	slti	$t5, $s4, 91
	bne	$t5, $zero, stringForwardPlus
	
do:
	lb	$a0, 0($t3) 
	addi	$v0, $zero, 11
	syscall
	
	la	$a0, newLine	#
	addi	$v0, $zero, 4	# Print newLine
	syscall
	
stringForwardPlus:
	addi	$t1, $t1, 1	# i ++
	j	stringForwardBegin


stringBackward:
	addi	$t1, $zero, 0	# i = 0
	la	$t0, str

stringBackwardBegin:
	add	$t2, $t0, $t1
	lb	$t3, 0($t2)
	beq	$t3, $zero, setIndex # if str[i] = '\0' then jump to setIndex
	add	$t3, $t1, $t0
	addi	$t1, $t1, 1	# i ++
	j	stringBackwardBegin

setIndex:
	sub	$t1, $t1, 1 
	la	$t0, str
	
stringBackwardLoopBegin:
	slt	$t3, $t1, $zero
	bne	$t3, $zero, done
	
	add	$t3, $t1, $t0
	lb	$s4, 0($t3)
		
stringBackwardPrint:
	lb	$a0, 0($t3) 
	addi	$v0, $zero, 11
	syscall
	
	la	$a0, newLine	#
	addi	$v0, $zero, 4	# Print newLine
	syscall
	
	sub	$t1, $t1, 1	# i --
	j	stringBackwardLoopBegin
        
done:
	# Epilogue for main -- restore stack & frame pointers and return
        lw    $ra, 4($sp)     # get return address from stack
        lw    $fp, 0($sp)     # restore the caller's frame pointer
        addiu $sp, $sp, 24    # restore the caller's stack pointer
        jr    $ra             # return to caller's code
