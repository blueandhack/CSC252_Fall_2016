.data

value:	.word	0x12345678

start_regs:
	.word	0xdeadbeef
	.word	0xc0d4f00d
	.word	0x01010101
	.word	0xF0F0F0F0
	.word	0x12345678
	.word	0
	.word	-1
	.word	start_regs

sp_save:	.word   0    # will be *WRITTEN TO*
fp_save:        .word   0    # will be *WRITTEN TO*



.text

main:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20


	# preload every s register with a value, to confirm that the student
	# code preserved it.
	la      $t0, start_regs    # t0 = &start_regs[0]
	lw      $s0,  0($t0)       # s0 =  start_regs[0]
	lw      $s1,  4($t0)       # s1 =  start_regs[1]
	lw      $s2,  8($t0)       # s2 =  start_regs[2]
	lw      $s3, 12($t0)       # s3 =  start_regs[3]
	lw      $s4, 16($t0)       # s4 =  start_regs[4]
	lw      $s5, 20($t0)       # s5 =  start_regs[5]
	lw      $s6, 24($t0)       # s6 =  start_regs[6]
	lw      $s7, 28($t0)       # s7 =  start_regs[7]

	# save the current $sp and $fp for later comparison
	la      $t0, sp_save       # t0 = &sp_save
	sw      $sp, 0($t0)        # sp_save = $sp
	la      $t0, fp_save       # t0 = &fp_save
	sw      $fp, 0($t0)        # fp_save = $fp


	# call nibbleScan(value)
	la      $a0, value
	lw      $a0, 0($a0)
	jal     nibbleScan

	# print out the return value
	add     $a0, $v0, $zero
	addi    $v0, $zero, 1
	syscall

	# print_char('\n')
	addi    $v0, $zero, 11     # print_char
	addi    $a0, $zero, 0xa    # ASCII '\n'
	syscall


	# do comparison of all of the registers
	la      $t0, start_regs     # we'll use this base over and over

	lw      $t1,  0($t0)
	beq     $t1, $s0, main_DO_COMPARE_1

	# if we get here, then we had a MISCOMPARE on s0.  We need to report
	# it.
	addi	$a0, $zero, 0
	add 	$a1, $t1, $zero
	add 	$a2, $s0, $zero
	jal     reportMismatch

	# after we call the reporting function, we have to restore the $t1
	# variable, which might not be valid anymore.
	la      $t0, start_regs

	# NOTE: From here on, we'll not comment; we'll just do the same thing
	#       over and over, once for each s register.

main_DO_COMPARE_1:
	lw      $t1,  4($t0)
	beq     $t1, $s1, main_DO_COMPARE_2

	addi	$a0, $zero, 1
	add 	$a1, $t1, $zero
	add 	$a2, $s1, $zero
	jal     reportMismatch

	la      $t0, start_regs

main_DO_COMPARE_2:
	lw      $t1,  8($t0)
	beq     $t1, $s2, main_DO_COMPARE_3

	addi	$a0, $zero, 2
	add 	$a1, $t1, $zero
	add 	$a2, $s2, $zero
	jal     reportMismatch

	la      $t0, start_regs

main_DO_COMPARE_3:
	lw      $t1, 12($t0)
	beq     $t1, $s3, main_DO_COMPARE_4

	addi	$a0, $zero, 3
	add 	$a1, $t1, $zero
	add 	$a2, $s3, $zero
	jal     reportMismatch

	la      $t0, start_regs

main_DO_COMPARE_4:
	lw      $t1, 16($t0)
	beq     $t1, $s4, main_DO_COMPARE_5

	addi	$a0, $zero, 4
	add 	$a1, $t1, $zero
	add 	$a2, $s4, $zero
	jal     reportMismatch

	la      $t0, start_regs

main_DO_COMPARE_5:
	lw      $t1, 20($t0)
	beq     $t1, $s5, main_DO_COMPARE_6

	addi	$a0, $zero, 5
	add 	$a1, $t1, $zero
	add 	$a2, $s5, $zero
	jal     reportMismatch

	la      $t0, start_regs

main_DO_COMPARE_6:
	lw      $t1, 24($t0)
	beq     $t1, $s6, main_DO_COMPARE_7

	addi	$a0, $zero, 6
	add 	$a1, $t1, $zero
	add 	$a2, $s6, $zero
	jal     reportMismatch

	la      $t0, start_regs

main_DO_COMPARE_7:
	lw      $t1, 28($t0)
	beq     $t1, $s7, main_COMPARISONS_DONE

	addi	$a0, $zero, 7
	add 	$a1, $t1, $zero
	add 	$a2, $s7, $zero
	jal     reportMismatch

	la      $t0, start_regs

main_COMPARISONS_DONE:

main_DONE:
	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra



.data

mismatch_str1:	.asciiz "MISMATCH: register s"
mismatch_str2:	.asciiz                   " was not saved during a function call.  Orig value: "
mismatch_str3:	.asciiz " after the call: "

.text

reportMismatch:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20

	# save the three parameters.  We do this because we make heavy use of
	# syscalls in this function.
	sw      $a0,  8($sp)
	sw      $a1, 12($sp)
	sw      $a2, 16($sp)


	# print the leading part of the string...
	addi    $v0, $zero, 4        # print_str
	la	$a0, mismatch_str1
	syscall

	# register number - essentially this is %d
	addi    $v0, $zero, 1        # print_int
	lw      $a0, 8($sp)
	syscall

	# print the second part of the string...
	addi    $v0, $zero, 4        # print_str
	la	$a0, mismatch_str2
	syscall

	# original value - again, this is %d
	addi    $v0, $zero, 1        # print_int
	lw      $a0, 12($sp)
	syscall

	# print the second part of the string...
	addi    $v0, $zero, 4        # print_str
	la	$a0, mismatch_str3
	syscall

	# actual value - again, this is %d
	addi    $v0, $zero, 1        # print_int
	lw      $a0, 16($sp)
	syscall

	# ending newline
	addi    $v0, $zero, 11       # print_char
	addi    $a0, $zero, 0xa      # ASCII '\n'
	syscall


	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra



printStr:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20


	# print_str(a0)
	addi 	$v0, $zero, 4
	syscall

	# print_char('\n')
	addi    $v0, $zero, 11
	addi    $a0, $zero, 0xa
	syscall


	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra



.text
printNibble:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20
	# save a0, a1
	sw      $a0,  8($sp)
	sw      $a1, 12($sp)


	# printf("%d %d\n", a0, a1);

	addi    $v0, $zero, 1       # print_int(a0)
	syscall

	addi    $v0, $zero, 11      # print_char
	addi    $a0, $zero, 0x20    # ASCII space
	syscall

	addi 	$v0, $zero, 1       # print_int
	lw      $a0, 12($sp)        # print_int(2nd arg)
	syscall

	addi    $v0, $zero, 11      # print_char
	addi    $a0, $zero, 0xa     # ASCII '\n'
	syscall


	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra




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
	
	
	
nibbleScanDone:

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