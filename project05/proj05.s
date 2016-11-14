# ----- STUDENT CODE BELOW -----
# proj05.s
#
# CSc 252 Fall 16 - Project 5
#
# Name: Yujia Lin

.text


execInstruction:
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


execInstructionDone:
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
