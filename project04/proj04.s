
# ----- STUDENT CODE BELOW -----	
.text
        
printRev:
	# $s0 = i
	
	# function prologue
	addiu	$sp, $sp, -24			# allocate stack space -- default of 24
	sw	$a0, 8($sp)			# save parameter value
	sw      $ra, 4($sp)			# save return address
	sw      $fp, 0($sp)			# save frame pointer of caller
	addiu   $fp, $sp, 20			# setup frame pointer
	
	addiu	$sp, $sp, -24
	sw	$s5, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)			# 
	sw	$s2, 8($sp)			# 
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	
	addi	$s0, $zero, 0			# i = 0
	addi	$s1, $a0, 0			# put String address to $s1

	lb	$s2, 0($s1)
	beq	$s2, $zero, getLengthEnd
	
getLength:
	lb	$s2, 0($s1)			# get String[i]
	beq	$s2, $zero, getLengthEnd
	addi	$s0, $s0, 1			# i++
	addi	$s1, $s1, 1			# $a0++
	j	getLength
	
getLengthEnd:
	addiu	$sp, $sp, -256			# we add 256 bytes to the size of the stack.
	addi	$s4, $sp, 0
	
	addi	$s1, $a0, 0			# put String address to $s1
	add	$s5, $zero, $s0
	beq	$s5, $zero, whenStrIsZeroPutStackEnd
	
	addi	$s0, $s0, -1			# i--
	
putStack:
	add	$s1, $a0, $s0
	lb	$s2, 0($s1)
	
	sb	$s2, 0($s4)
	
	beq	$s0, $zero, putStackEnd
	
	addi	$s4, $s4, 1			# $s4++
	addi	$s0, $s0, -1			# i--
	j	putStack
	
putStackEnd:
	addi	$s4, $s4, 1			# i++
	sb	$zero, 0($s4)			# 
	add	$a0, $sp, 0			#
	j	printTheStr

whenStrIsZeroPutStackEnd:
	sb	$zero, 0($s4)			# 
	add	$a0, $sp, 0			#

printTheStr:
	jal	printStr
	
printRevDone:
	add	$v0, $s5, $zero
	addiu	$sp, $sp, 256			# restore the caller's stack pointer
	
	lw	$s5, 20($sp)
	lw	$s4, 16($sp)
	lw	$s3, 12($sp)			
	lw	$s2, 8($sp)			
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addiu	$sp, $sp, 24			# restore the caller's stack pointer
	
	# Function epilogue -- restore stack & frame pointers and return
	lw	$a0, 8($sp)
        lw    	$ra, 4($sp)     		# get return address from stack
        lw    	$fp, 0($sp)     		# restore the caller's frame pointer
        addiu 	$sp, $sp, 24    		# restore the caller's stack pointer
        jr    	$ra             		# return to caller's code
	

.text

nibbleScan:
	# Function prologue
	addiu	$sp, $sp, -24			# allocate stack space -- default of 24
	sw	$a1, 12($sp)			# save parameter value
	sw	$a0, 8($sp)			# save parameter value
	sw      $ra, 4($sp)			# save return address
	sw      $fp, 0($sp)			# save frame pointer of caller
	addiu   $fp, $sp, 20			# setup frame pointer
	
	
	addiu	$sp, $sp, -28
	sw	$s6, 24($sp)
	sw	$s5, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)			# 
	sw	$s2, 8($sp)			# 
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	
	addi	$s0, $zero, 0			# i = 0
	addi 	$s1, $zero, 0			# count = 0
	
	addiu	$sp, $sp, -4
	sw	$a0, 0($sp)		
	
loopBegin:
	beq	$s0, 4, loopEnd
	
	add	$s3, $sp, $s0			# put $sp address to $s3
	lb	$s4, 0($s3)
	
	
	
getRightFourBits:
	add	$s5, $s4, $zero
	sll	$s6, $s5, 28
	srl	$s6, $s6, 28
	beq	$s6, $zero, getLeftFourBits
	
	addi	$s1, $s1, 1			# count ++
	
	addi	$a0, $s0, 0
	add	$a0, $a0, $a0
	addi	$a1, $s6, 0
	
	jal	printNibble
	
	j	getLeftFourBits
	
getLeftFourBits:
	add	$s5, $s4, $zero
	srl	$s6, $s5, 4
	sll	$s6, $s6, 28
	srl	$s6, $s6, 28
	beq	$s6, $zero, jumpToLoopBegin
	
	addi	$s1, $s1, 1			# count ++
	
	add	$a0, $s0, $s0
	addi	$a0, $a0, 1
	addi	$a1, $s6, 0
	
	jal	printNibble

jumpToLoopBegin:
	addi	$s0, $s0, 1			# i++
	j	loopBegin
	
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
	addiu	$sp, $sp, 28			# restore the caller's stack pointer

	# Function epilogue -- restore stack & frame pointers and return
	lw	$a1, 12($sp)
	lw	$a0, 8($sp)
        lw    	$ra, 4($sp)     		# get return address from stack
        lw    	$fp, 0($sp)     		# restore the caller's frame pointer
        addiu 	$sp, $sp, 24    		# restore the caller's stack pointer
        jr    	$ra             		# return to caller's code


.text

multiply:
	# Function prologue
	addiu	$sp, $sp, -24			# allocate stack space -- default of 24
	sw	$a1, 12($sp)			# save parameter value
	sw	$a0, 8($sp)			# save parameter value
	sw      $ra, 4($sp)			# save return address
	sw      $fp, 0($sp)			# save frame pointer of caller
	addiu   $fp, $sp, 20			# setup frame pointer
	
	
	addiu	$sp, $sp, -28
	sw	$s6, 24($sp)
	sw	$s5, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)			# 
	sw	$s2, 8($sp)			# 
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	
	
multiplyDone:
	lw	$s6, 24($sp)
	lw	$s5, 20($sp)
	lw	$s4, 16($sp)
	lw	$s3, 12($sp)			
	lw	$s2, 8($sp)			
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addiu	$sp, $sp, 28			# restore the caller's stack pointer

	# Function epilogue -- restore stack & frame pointers and return
	lw	$a1, 12($sp)
	lw	$a0, 8($sp)
        lw    	$ra, 4($sp)     		# get return address from stack
        lw    	$fp, 0($sp)     		# restore the caller's frame pointer
        addiu 	$sp, $sp, 24    		# restore the caller's stack pointer
        jr    	$ra             		# return to caller's code