
# ----- STUDENT CODE BELOW -----
# proj04.s
#
# CSc 252 Fall 16 - Project 3
#
# Name: Yujia Lin
#
# includes three function that printRev, nibbleScan and multiply


.text

printRev:
	# function prologue
	addiu	$sp, $sp, -24				# allocate stack space -- default of 24
	sw	$a0, 8($sp)				# save parameter value
	sw      $ra, 4($sp)				# save return address
	sw      $fp, 0($sp)				# save frame pointer of caller
	addiu   $fp, $sp, 20				# setup frame pointer

	addiu	$sp, $sp, -32				# allocate stack space
	sw	$s7, 28($sp)				# save $s7 value
	sw	$s6, 24($sp)				# save $s6 value
	sw	$s5, 20($sp)				# save $s5 value
	sw	$s4, 16($sp)				# save $s4 value
	sw	$s3, 12($sp)				# save $s3 value
	sw	$s2, 8($sp)				# save $s2 value
	sw	$s1, 4($sp)				# save $s1 value
	sw	$s0, 0($sp)				# save $s0 value

	# $s0 - i
	# $s1 - String length
	# $s2 - String[i] 
	
	addi	$s0, $zero, 0				# i = 0
	addi	$s1, $a0, 0				# put String address to $s1

	lb	$s2, 0($s1)				# if String[0] = '\0' jump to getLengthEnd
	beq	$s2, $zero, getLengthEnd		#

getLength:
	lb	$s2, 0($s1)				# get String[i]
	beq	$s2, $zero, getLengthEnd		# if i = 0 jump getLengthEnd
	addi	$s0, $s0, 1				# i++
	addi	$s1, $s1, 1				# $a0++
	j	getLength

getLengthEnd:
	addiu	$sp, $sp, -4				# first move $sp for 4 bytes 
	addi	$s4, $sp, 0				# $s4 = $sp

	addi	$s1, $a0, 0				# put String address to $s1
	add	$s5, $zero, $s0				# check if String length is zero
	beq	$s5, $zero, whenStrIsZeroPutStackEnd	# if String length is zero jump to whenStrIsZeroPutStackEnd
	
	srl	$s6, $s0, 2				# the String length / 2
	addi	$s7, $s6, 0				# copy $s6 to $s7

	addi	$s0, $s0, -1				# i--
	
growStack:
	beq	$s6, $zero, growStackEnd		# if $s6 == 0 jump to growStackEnd
	addiu	$sp, $sp, -4				# allocate stack space
	addi	$s6, $s6, -1				# $s6 -- 
	
	j	growStack				# jump to growStack
	
growStackEnd:
	addi	$s4, $sp, 0				# $s4 = $sp

putStack:
	add	$s1, $a0, $s0				# $a0 - i
	lb	$s2, 0($s1)				# load value from memory
	sb	$s2, 0($s4)				# save value to stack memory
	beq	$s0, $zero, putStackEnd			# if value == 0 stop to put
	addi	$s4, $s4, 1				# $s4++
	addi	$s0, $s0, -1				# i--
	j	putStack

putStackEnd:
	addi	$s4, $s4, 1				# i++
	sb	$zero, 0($s4)				# save String[i] to memory
	add	$a0, $sp, 0				# 
	j	printTheStr				# jump to printTheStr

whenStrIsZeroPutStackEnd:
	sb	$zero, 0($s4)				# save '\0' to memory
	add	$a0, $sp, 0				# pass parameter

printTheStr:
	jal	printStr				# call printStr

printRevDone:
	add	$v0, $s5, $zero				# put the length to $v0, return length
	
restoreStack:
	beq	$s5, $zero, restoreStackEnd		# if length == 0 jump to restoreStackEnd
	beq	$s7, $zero, restoreStackEnd		# if i == 0 jump to restoreStackEnd
	addiu	$sp, $sp, 4				# restore stack pointer
	addi	$s7, $s7, -1				# 
	j	restoreStack				#
	
restoreStackEnd:
	addiu	$sp, $sp, 4
	
	lw	$s7, 28($sp)				# restore $s7
	lw	$s6, 24($sp)				# restore $s6
	lw	$s5, 20($sp)				# restore $s5
	lw	$s4, 16($sp)				# restore $s4
	lw	$s3, 12($sp)				# restore $s3
	lw	$s2, 8($sp)				# restore $s2
	lw	$s1, 4($sp)				# restore $s1
	lw	$s0, 0($sp)				# restore $s0
	addiu	$sp, $sp, 32				# restore stack pointer

	# Function epilogue -- restore stack & frame pointers and return
	lw	$a0, 8($sp)
        lw    	$ra, 4($sp)				# get return address from stack
        lw    	$fp, 0($sp)				# restore the caller's frame pointer
        addiu 	$sp, $sp, 24				# restore the caller's stack pointer
        jr    	$ra					# return to caller's code


.text

nibbleScan:
	# Function prologue
	addiu	$sp, $sp, -24				# allocate stack space -- default of 24
	sw	$a1, 12($sp)				# save parameter value
	sw	$a0, 8($sp)				# save parameter value
	sw      $ra, 4($sp)				# save return address
	sw      $fp, 0($sp)				# save frame pointer of caller
	addiu   $fp, $sp, 20				# setup frame pointer


	addiu	$sp, $sp, -32				# allocate stack space
	sw	$s7, 28($sp)				# save $s7 value
	sw	$s6, 24($sp)				# save $s6 value
	sw	$s5, 20($sp)				# save $s5 value
	sw	$s4, 16($sp)				# save $s4 value
	sw	$s3, 12($sp)				# save $s3 value
	sw	$s2, 8($sp)				# save $s2 value
	sw	$s1, 4($sp)				# save $s1 value
	sw	$s0, 0($sp)				# save $s0 value

	# $s0 - i
	# $s1 - count
	# $s3 - $sp
	# $s4 - a byte

	addi	$s0, $zero, 0				# i = 0
	addi 	$s1, $zero, 0				# count = 0

	addiu	$sp, $sp, -4				#
	sw	$a0, 0($sp)				# put $a0(value) to $sp

loopBegin:
	beq	$s0, 4, loopEnd				# if i == 0 jump to loopEnd

	add	$s3, $sp, $s0				# put $sp address to $s3
	lb	$s4, 0($s3)				# load value

getRightFourBits:
	add	$s5, $s4, $zero				# $s5 = $s4
	sll	$s6, $s5, 28				# shift left
	srl	$s6, $s6, 28				# shift right
	beq	$s6, $zero, getLeftFourBits

	addi	$s1, $s1, 1				# count ++

	addi	$a0, $s0, 0				# pass two parameter
	add	$a0, $a0, $a0				#
	addi	$a1, $s6, 0				# 

	jal	printNibble				# call printNibble

	j	getLeftFourBits				# jump to getLeftFourBits

getLeftFourBits:
	add	$s5, $s4, $zero				# $s5 = $s4
	srl	$s6, $s5, 4				# shift right 
	sll	$s6, $s6, 28				# shift left
	srl	$s6, $s6, 28				# shift right
	beq	$s6, $zero, jumpToLoopBegin		# if the number == 0 jump to jumpToLoopBegin

	addi	$s1, $s1, 1				# count ++

	add	$a0, $s0, $s0				# pass two parameter
	addi	$a0, $a0, 1				# 
	addi	$a1, $s6, 0				# 

	jal	printNibble				# call printNibble

jumpToLoopBegin:
	addi	$s0, $s0, 1				# i++
	j	loopBegin				# jump to loopBegin

loopEnd:
	add	$v0, $s1, $zero				# return value that a count of how many nibbles were nonzero.

nibbleScanDone:
	addiu	$sp, $sp, 4

	lw	$s7, 28($sp)				# restore $s7
	lw	$s6, 24($sp)				# restore $s6
	lw	$s5, 20($sp)				# restore $s5
	lw	$s4, 16($sp)				# restore $s4
	lw	$s3, 12($sp)				# restore $s3
	lw	$s2, 8($sp)				# restore $s2
	lw	$s1, 4($sp)				# restore $s1
	lw	$s0, 0($sp)				# restore $s0
	addiu	$sp, $sp, 32				# restore stack pointer

	# Function epilogue -- restore stack & frame pointers and return
	lw	$a1, 12($sp)
	lw	$a0, 8($sp)
        lw    	$ra, 4($sp)				# get return address from stack
        lw    	$fp, 0($sp)				# restore the caller's frame pointer
        addiu 	$sp, $sp, 24				# restore the caller's stack pointer
        jr    	$ra		 			# return to caller's code


.text

multiply:
	# Function prologue
	addiu	$sp, $sp, -24				# allocate stack space -- default of 24
	sw	$a1, 12($sp)				# save parameter value
	sw	$a0, 8($sp)				# save parameter value
	sw      $ra, 4($sp)				# save return address
	sw      $fp, 0($sp)				# save frame pointer of caller
	addiu   $fp, $sp, 20				# setup frame pointer


	addiu	$sp, $sp, -32				# allocate stack space
	sw	$s7, 28($sp)				# save $s7 value
	sw	$s6, 24($sp)				# save $s6 value
	sw	$s5, 20($sp)				# save $s5 value
	sw	$s4, 16($sp)				# save $s4 value
	sw	$s3, 12($sp)				# save $s3 value
	sw	$s2, 8($sp)				# save $s2 value
	sw	$s1, 4($sp)				# save $s1 value
	sw	$s0, 0($sp)				# save $s0 value

	# $a0 - multiplicand
	# $a1 - multiplier
	# $s0 - result
	# $s1 - the LSB of the multiplier
	# $s2 - the mask for the right bit

	addi	$s0, $zero, 0				# set product = 0
	
	beq	$a0, $zero, multiplyDone		# if val1 == 0 jump to multiplyDone
	beq	$a1, $zero, multiplyDone		# if val2 == 0 jump to multiplyDone

	addi	$s2, $zero, 1				# initialize the mask 
	addi	$s1, $zero, 0				# initialize the LSB result

multiplicationLoop:
	beq	$a1, $zero, multiplicationEnd		# if the multiplier is zero we done
	and	$s1, $s2, $a1				# get the LSB
	beq	$s1, 1, multiplicationDoAdd		# if the LSB != zero jump to multiplicationDoAdd
	beq	$s1, 0, multiplicationDoShift		# if the LSB == zero jump to multiplicationDoShift

multiplicationDoAdd: 
	addu	$s0, $s0, $a0				#

multiplicationDoShift:
	sll	$a0, $a0, 1				# shift left the multiplicand
	srl	$a1, $a1, 1				# shift right the multiplier

	j	multiplicationLoop			# back to the loop

multiplicationEnd:
	j	multiplyDone				# jump to multiplyDone

multiplyDone:
	add	$v0, $zero, $s0				# return product

	lw	$s7, 28($sp)				# restore $s7
	lw	$s6, 24($sp)				# restore $s6
	lw	$s5, 20($sp)				# restore $s5
	lw	$s4, 16($sp)				# restore $s4
	lw	$s3, 12($sp)				# restore $s3
	lw	$s2, 8($sp)				# restore $s2
	lw	$s1, 4($sp)				# restore $s1
	lw	$s0, 0($sp)				# restore $s0
	addiu	$sp, $sp, 32				# restore stack pointer

	# Function epilogue -- restore stack & frame pointers and return
	lw	$a1, 12($sp)
	lw	$a0, 8($sp)
        lw    	$ra, 4($sp)				# get return address from stack
        lw    	$fp, 0($sp)				# restore the caller's frame pointer
        addiu 	$sp, $sp, 24				# restore the caller's stack pointer
        jr    	$ra					# return to caller's code
