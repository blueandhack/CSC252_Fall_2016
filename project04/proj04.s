
# ----- STUDENT CODE BELOW -----
.text

printRev:
	# $s0 = i

	# function prologue
	addiu	$sp, $sp, -24				# allocate stack space -- default of 24
	sw	$a0, 8($sp)				# save parameter value
	sw      $ra, 4($sp)				# save return address
	sw      $fp, 0($sp)				# save frame pointer of caller
	addiu   $fp, $sp, 20				# setup frame pointer

	addiu	$sp, $sp, -32				#
	sw	$s7, 28($sp)				#
	sw	$s6, 24($sp)				#
	sw	$s5, 20($sp)				#
	sw	$s4, 16($sp)				#
	sw	$s3, 12($sp)				#
	sw	$s2, 8($sp)				#
	sw	$s1, 4($sp)				#
	sw	$s0, 0($sp)				#

	addi	$s0, $zero, 0				# i = 0
	addi	$s1, $a0, 0				# put String address to $s1

	lb	$s2, 0($s1)
	beq	$s2, $zero, getLengthEnd

getLength:
	lb	$s2, 0($s1)				# get String[i]
	beq	$s2, $zero, getLengthEnd
	addi	$s0, $s0, 1				# i++
	addi	$s1, $s1, 1				# $a0++
	j	getLength

getLengthEnd:
	#addiu	$sp, $sp, -256				# we add 256 bytes to the size of the stack.
	addiu	$sp, $sp, -4
	addi	$s4, $sp, 0

	addi	$s1, $a0, 0				# put String address to $s1
	add	$s5, $zero, $s0				# check if String length is zero
	beq	$s5, $zero, whenStrIsZeroPutStackEnd	# if String length is zerp jump to whenStrIsZeroPutStackEnd
	
	srl	$s6, $s0, 2
	addi	$s7, $s6, 0

	addi	$s0, $s0, -1				# i--
	
growStack:
	beq	$s6, $zero, growStackEnd
	addiu	$sp, $sp, -4
	addi	$s6, $s6, -1
	
	j	growStack
	
growStackEnd:
	addi	$s4, $sp, 0


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
	sb	$zero, 0($s4)				#
	add	$a0, $sp, 0				#
	j	printTheStr

whenStrIsZeroPutStackEnd:
	sb	$zero, 0($s4)				#
	add	$a0, $sp, 0				#

printTheStr:
	jal	printStr

printRevDone:
	add	$v0, $s5, $zero				# return length

	#addiu	$sp, $sp, 256				# restore the caller's stack pointer
	
restoreStack:
	beq	$s5, $zero, restoreStackEnd
	beq	$s7, $zero, restoreStackEnd
	addiu	$sp, $sp, 4
	addi	$s7, $s7, -1
	j	restoreStack
	
restoreStackEnd:
	addiu	$sp, $sp, 4
	
	lw	$s7, 28($sp)				#
	lw	$s6, 24($sp)				#
	lw	$s5, 20($sp)				#
	lw	$s4, 16($sp)				#
	lw	$s3, 12($sp)				#
	lw	$s2, 8($sp)				#
	lw	$s1, 4($sp)				#
	lw	$s0, 0($sp)				#
	addiu	$sp, $sp, 32				# restore the caller's stack pointer

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


	addiu	$sp, $sp, -28				#
	sw	$s6, 24($sp)				#
	sw	$s5, 20($sp)				#
	sw	$s4, 16($sp)				#
	sw	$s3, 12($sp)				#
	sw	$s2, 8($sp)				#
	sw	$s1, 4($sp)				#
	sw	$s0, 0($sp)				#

	addi	$s0, $zero, 0				# i = 0
	addi 	$s1, $zero, 0				# count = 0

	addiu	$sp, $sp, -4				#
	sw	$a0, 0($sp)				# put $a0(value) to $sp

loopBegin:
	beq	$s0, 4, loopEnd				# if i == 0 jump to loopEnd

	add	$s3, $sp, $s0				# put $sp address to $s3
	lb	$s4, 0($s3)				# load value



getRightFourBits:
	add	$s5, $s4, $zero				# 
	sll	$s6, $s5, 28				# shift left
	srl	$s6, $s6, 28				# shift right
	beq	$s6, $zero, getLeftFourBits

	addi	$s1, $s1, 1				# count ++

	addi	$a0, $s0, 0				#
	add	$a0, $a0, $a0				#
	addi	$a1, $s6, 0				#

	jal	printNibble

	j	getLeftFourBits

getLeftFourBits:
	add	$s5, $s4, $zero				#
	srl	$s6, $s5, 4				# shift right 
	sll	$s6, $s6, 28				# shift left
	srl	$s6, $s6, 28				# shift right
	beq	$s6, $zero, jumpToLoopBegin		#

	addi	$s1, $s1, 1				# count ++

	add	$a0, $s0, $s0				#
	addi	$a0, $a0, 1				#
	addi	$a1, $s6, 0				#

	jal	printNibble				#

jumpToLoopBegin:
	addi	$s0, $s0, 1				# i++
	j	loopBegin				#

loopEnd:
	add	$v0, $s1, $zero

nibbleScanDone:
	addiu	$sp, $sp, 4

	lw	$s6, 24($sp)
	lw	$s5, 20($sp)
	lw	$s4, 16($sp)
	lw	$s3, 12($sp)
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addiu	$sp, $sp, 28				# restore the caller's stack pointer

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


	addiu	$sp, $sp, -32				#
	sw	$s7, 28($sp)				#
	sw	$s6, 24($sp)				#
	sw	$s5, 20($sp)				#
	sw	$s4, 16($sp)				#
	sw	$s3, 12($sp)				#
	sw	$s2, 8($sp)				#
	sw	$s1, 4($sp)				#
	sw	$s0, 0($sp)				#

	addi	$s0, $zero, 0				# set product = 0
	
	beq	$a0, $zero, multiplyDone		# if val1 == 0 jump to multiplyDone
	beq	$a1, $zero, multiplyDone		# if val2 == 0 jump to multiplyDone
	
	
	# $a0 - Multiplicand
	# $a1 - Multiplier
	# $s0 - Result
	# $s2 - The mask for the right bit
	# $s1 - The LSB of the multiplier

	addi $s2, $zero, 1				# Initialize the mask 
	addi $s1, $zero, 0				# Initialize the LSB result

Multiplication_loop:
	beq $a1, $zero, Multiplication_end		# If the multiplier is zero we finished
	and $s1, $s2, $a1				# Get the LSB
	beq $s1, 1, Multiplication_do_add		# If the LSB is not zero add the multiplicand to the result
	beq $s1, 0, Multiplication_do_shift		# If the LSB is zero add just do the shifts

Multiplication_do_add: 
	addu $s0, $s0, $a0		

Multiplication_do_shift:
	sll $a0, $a0, 1					# Shift left the multiplicand
	srl $a1, $a1, 1					# Shift right the multiplier

	j Multiplication_loop				# Back to the loop

Multiplication_end:
	

multiplyDone:
	add	$v0, $zero, $s0				# return product

	lw	$s7, 28($sp)				#
	lw	$s6, 24($sp)				#
	lw	$s5, 20($sp)				#
	lw	$s4, 16($sp)				#
	lw	$s3, 12($sp)				#
	lw	$s2, 8($sp)				#
	lw	$s1, 4($sp)				#
	lw	$s0, 0($sp)
	addiu	$sp, $sp, 32				# restore the caller's stack pointer

	# Function epilogue -- restore stack & frame pointers and return
	lw	$a1, 12($sp)
	lw	$a0, 8($sp)
        lw    	$ra, 4($sp)				# get return address from stack
        lw    	$fp, 0($sp)				# restore the caller's frame pointer
        addiu 	$sp, $sp, 24				# restore the caller's stack pointer
        jr    	$ra					# return to caller's code
