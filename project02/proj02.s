# CSc 252 Fall 2016
# Name: Yujia Lin
# Project 02
# The project has four function that can print a integer array and print every char in a String

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
	# Do we need print the integer array forward?
	beq	$s0, $zero, checkIntegerBackward	# if integers == 0 then jump to checkIntegerBackward
	beq	$s1, $zero, checkIntegerBackward	# if forward == 0 then jump to checkIntegerBackward
	j	integerForward				# if integers != 0 && forward != 0 then jump to integerForward
	
checkIntegerBackward:
	# Do we need print the integer array backward?
	beq	$s0, $zero, checkStringForward		# if integers == 0 then jump to checkStringForward
	bne	$s1, $zero, checkStringForward		# if forward != 0 then jump to checkStringForward
	j	integerBackward				# if integers != 0 && forward == 0 then jump to integerBackward
	
checkStringForward:
	# Do we need print the String forward?
	bne	$s0, $zero, checkStringBackward		# if integers != 0 then jump to checkStringBackward
	beq	$s1, $zero, checkStringBackward		# if forward == 0 then jump to checkStringBackward
	j	stringForward				# if integers == 0 && forward != 0 then jump to stringForward

checkStringBackward:
	# Do we need print the String backward?
	bne	$s0, $zero, done			# if integers != 0 then jump to done
	bne	$s1, $zero, done			# if forward != 0 then jump to done
	j	stringBackward				# if integers == 0 && forward == 0 then jump to stringBackward
	
	                
integerForward:
	# Print the integer array forward, and we'll skip every 0 value
	# We'll check every step
	
	addi	$t1, $zero, 0	# $t1 = i = 0
	la	$t0, ints	# Load ints address

integerForwardLoopBegin:

	# Test if for loop is done
	slt	$t2, $t1, $s3				# $t2 = i < numInts
	beq	$t2, $zero, integerForwardLoopEnd	# If i < numInts then jump to integerForwardLoopEnd
	
	# Compute address of ints[i]
	add	$t3, $t1, $t1	#
	add	$t3, $t3, $t3	# $t3 = 4 * i
	add	$t2, $t0, $t3	# $t2 = address of ints[i]
	
	# Check is ints[i] == 0, that will skip 0
	lw	$t4, 0($t2)				# $t4 = ints[i]
	bne	$t4, $zero, printIntegersForForward	# if ints[i] != 0 then jump to printIntegersForForward
	j	integerForwardPlus			# if ints[i] == 0 then jump to integerForwardLoopBegin
	
printIntegersForForward:

	# Print ints[i]
	lw	$a0, 0($t2)	#
	addi	$v0, $zero, 1	# Print ints[i]
	syscall			#
	
	# Print newLine
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
	# Print the integer array backward
	# We'll check every step
	
	# numInts is number of the array, but the index less then the numInts
	# so we should minus 1 for numInts
	sub	$t1, $s3, 1	# $t1 = numInts - 1
	la	$t0, ints	# $t0 = &ints

integerBackwardLoopBegin:

	# Test if for loop is done
	slt	$t2, $t1, $zero		# $t2 = i < 0
	bne	$t2, $zero, integerBackwardLoopEnd	# If i < 0 then jump to integerBackwardLoopEnd
	
	# Compute address of ints[i]
	add	$t3, $t1, $t1	#
	add	$t3, $t3, $t3	# $t3 = 4 * i
	add	$t2, $t0, $t3	# $t2 = address of ints[i]
	
	# Print ints[i]
	lw	$a0, 0($t2)	# 
	addi	$v0, $zero, 1	# Print ints[i]
	syscall			#
	
	# Print newLine
	la	$a0, newLine	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	
	# i -- then jump to integerBackwardLoopBegin
	sub	$t1, $t1, 1	# i --
	j	integerBackwardLoopBegin
	
integerBackwardLoopEnd:
	j	checkStringForward


stringForward:
	# Print the String forward, and it skip A-Z
	# We'll check every step

	# Load str address
	addi	$t1, $zero, 0	# i = 0
	la	$t0, str	# $t0 = &str
	
stringForwardBegin:

	# Load str[i]
	add	$t2, $t0, $t1	# $t2 = &str[i]
	lb	$t3, 0($t2)	# $t3 = str[i]
	
	# Check when str[i] = '\0'
	beq	$t3, $zero, checkStringBackward # If str[i] = '\0' then jump to checkStringBackward
	
	# Compute address of str[i]
	add	$t3, $t1, $t0	# $t3 = &str[i]
	lb	$s4, 0($t3)	# $s4 = str[i]
	
	# Check if 'A' <= str[i] <= 'Z'
	slti	$t5, $s4, 65			# $t5 = str[i] < 'A'
	bne	$t5, $zero, printStringForward	# If str[i] <  'A' then jump to printStringForward
	slti	$t5, $s4, 91			# $t5 = str[i] <= 'Z'
	bne	$t5, $zero, stringForwardPlus	# If str[i] < 'Z' then jump to stringForwardPlus
	j	printStringForward		#
	
printStringForward:

	# Print str[i]
	lb	$a0, 0($t3) 	#
	addi	$v0, $zero, 11	# Print str[i]
	syscall			#
	
	# Print newLine
	la	$a0, newLine	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	
stringForwardPlus:

	# i ++ then jump to stringForwardBegin
	addi	$t1, $t1, 1		# i ++
	j	stringForwardBegin	#

stringBackward:
	# Print the String backward
	# We'll check every step

	addi	$t1, $zero, 0	# i = 0
	la	$t0, str	# $t0 = &str

stringBackwardBegin:

	# Load str[i]
	add	$t2, $t0, $t1		# $t2 = &str[i]
	lb	$t3, 0($t2)		# $t3 = str[i]
	
	# Check the str is end
	beq	$t3, $zero, setIndex 	# if str[i] = '\0' then jump to setIndex
	addi	$t1, $t1, 1		# i ++
	j	stringBackwardBegin	#

setIndex:

	# i --
	addi	$t1, $t1, -1 	# Before we got the i that the String length i = i - 1 
	
	# Load str's address
	la	$t0, str	# $t0 = &str
	
stringBackwardLoopBegin:

	# Check if for loop is done
	slt	$t3, $t1, $zero		# $t3 = i < 0
	bne	$t3, $zero, done	# If i < 0 then jump to done
	
	# Load str[i]'s address
	add	$t3, $t1, $t0		# $t3 = &str[i]
		
stringBackwardPrint:

	# Print str[i]
	lb	$a0, 0($t3) 		# a0 = str[i]
	addi	$v0, $zero, 11		# Print str[i]
	syscall				#
	
	# Print newLine
	la	$a0, newLine	#
	addi	$v0, $zero, 4	# Print newLine
	syscall			#
	
	# i -- then jump to stringBackwardLoopBegin
	addi	$t1, $t1, -1		# i --
	j	stringBackwardLoopBegin	#
        
done:
	# Epilogue for main -- restore stack & frame pointers and return
        lw    $ra, 4($sp)     # get return address from stack
        lw    $fp, 0($sp)     # restore the caller's frame pointer
        addiu $sp, $sp, 24    # restore the caller's stack pointer
        jr    $ra             # return to caller's code
