
# ----- STUDENT CODE BELOW -----
# proj05.s
#
# CSc 252 Fall 16 - Project 5
#
# Name: Yujia Lin

.text


execInstruction:
	# function prologue
	addiu	$sp, $sp, -28				# allocate stack space -- default of 24
	lw	$t9, 24($sp)				# get 5th argument
	sw	$a3, 20($sp)				# save parameter value
	sw	$a2, 16($sp)				# save parameter value
	sw	$a1, 12($sp)				# save parameter value
	sw	$a0, 8($sp)				# save parameter value
	sw      $ra, 4($sp)				# save return address
	sw      $fp, 0($sp)				# save frame pointer of caller
	addiu   $fp, $sp, 24				# setup frame pointer

	addiu	$sp, $sp, -32				# allocate stack space
	sw	$s7, 28($sp)				# save $s7 value
	sw	$s6, 24($sp)				# save $s6 value
	sw	$s5, 20($sp)				# save $s5 value
	sw	$s4, 16($sp)				# save $s4 value
	sw	$s3, 12($sp)				# save $s3 value
	sw	$s2, 8($sp)				# save $s2 value
	sw	$s1, 4($sp)				# save $s1 value
	sw	$s0, 0($sp)				# save $s0 value
	
getOpcode:
	#
	srl	$s0, $a0, 26				# opcode
	
	sll	$s1, $a0, 6
	srl	$s1, $s1, 27				# rs
	
	sll	$s2, $a0, 11
	srl	$s2, $s2, 27				# rt
	
	sll	$s3, $a0, 16
	srl	$s3, $s3, 27				# rd
	
	sll	$s4, $a0, 21
	srl	$s4, $s4, 27				# shamt
	
	sll	$s5, $a0, 26
	srl	$s5, $s5, 26				# funct
	
	sll	$s6, $a0, 16
	sra	$s6, $s6, 16				# imm
# ================================
checkOpcode:	
	beq	$s0, 8, addiOpcode			# addi  - opencode == 8
	beq	$s0, 9, addiOpcode			# addiu - opencode == 9
	beq	$s0, 2, jOpencode			# j     - opencode == 2
	beq	$s0, 5, bneOpencode			# bne   - opencode == 5
	beq	$s0, 4, beqOpencode			# beq   - opencode == 4
	beq	$s0, 3, jalOpencode			# jal   - opencode == 3
	beq	$s0, 35, lwOpencode			# lw    - opencode == 35
	beq	$s0, 43, swOpencode			# sw    - opencode == 43
	
	beq	$s0, $zero, ifOpcodeEqualsZero
	
	j	errorOne
	
ifOpcodeEqualsZero:
	beq	$s5, 32, addFunct			# funct == 32
	beq	$s5, 34, subFunct			# funct == 34
	
	beq	$s5, 42, sltFunct
	
	beq	$s5, 12, syscallFunct			# funct == 12
	
	beq	$s5, 8, jrFunct				# funct == 8
	
	j	errorOne

addFunct:
	# add rd, rs, rt
	j	loadRsValueFromReg
	
addFunctLoadRt:
	j	loadRtValueFromReg
addFunctLoadRtDone:
	j	writeRdValueToReg
	
subFunct:
	# sub rd, rs, rt
	j	loadRsValueFromReg

subFunctLoadRt:
	j	loadRtValueFromReg
subFunctLoadRtDone:
	j	writeRdValueToReg

sltFunct:
	# slt rd, rs, rt
	j	loadRsValueFromReg
sltFunctLoadRt:
	j	loadRtValueFromReg
sltFunctLoadRtDone:
	j	writeRdValueToReg
			
jOpencode:
	sll	$t0, $a0, 6
	sra	$t0, $t0, 6
	
	add	$t0, $t0, $t0
	add	$t0, $t0, $t0
	
	# get upper 4 bits
	add	$t1, $a1, 4
	srl	$t1, $t1, 28
	sll	$t1, $t1, 28
	
	
	add	$v0, $t1, $t0
	#add	$v0, $zero, $t0
	addi	$v1, $v1, 0				# no error
	j	execInstructionDone
	
jalOpencode:
	sll	$t0, $a0, 6
	sra	$t0, $t0, 6
	
	add	$t0, $t0, $t0
	add	$t0, $t0, $t0
	
	addi	$t1, $zero, 124				# index for $ra (31)
	
	add	$t1, $t1, $a2				# mem[31] = $ra
	
	addi	$t2, $a1, 4				# PC + 4
	
	sw	$t2, 0($t1)				# 
	
	# get upper 4 bits
	add	$t1, $a1, 4
	srl	$t1, $t1, 28
	sll	$t1, $t1, 28
	
	
	add	$v0, $t1, $t0
	#add	$v0, $zero, $t0
	addi	$v1, $v1, 0				# no error
	j	execInstructionDone
	
lwOpencode:

	# find rs what reg it has
	sll	$t0, $s1, 2				# load rs
	add	$t0, $t0, $a2
	
	# find reg value
	lw	$s1, 0($t0)				# load value from rs
	
	# imm + rs
	add	$t0, $s6, $s1				# get memory address
	
	# check imm
	sll	$t5, $t0, 30
	srl	$t5, $t5, 30
	bne	$t5, 0, errorTwo
	
	sll	$t5, $t9, 2
	add	$t5, $t5, $a3
	
	# *mem + imm + rs
	add	$t0, $t0, $a3
	
	
	#debug
	#add	$t7, $zero, $a0
	#add	$a0, $t0, $zero
	#addi	$v0, $zero, 1
	#syscall
	#add	$a0, $zero, $t7
	#
	
	# check memory bounds
	slt	$t1, $t0, $a3				# less than
	bne	$t1, 0, errorThree
	
	# max memory bounds
	add	$t5, $a3, $t9
	slt	$t1, $t5, $t0
	beq	$t1, 1, errorThree
	
	# load word						
	lw	$t1, 0($t0)				# get a value
	
	# find rt what reg it has
	sll	$s2, $s2, 2				# load rt
	add	$s2, $a2, $s2				# *reg + rt
	
	sw	$t1, 0($s2)
	
	j	errorZero
	
swOpencode:
	
	sll	$t0, $s1, 2				# load rs
	add	$t0, $t0, $a2				# *reg + rs
	
	lw	$s1, 0($t0)				# load value from rs

	# rs + imm
	add	$t0, $s6, $s1				# get memory address
		
	# check imm + rs
	sll	$t5, $t0, 30
	srl	$t5, $t5, 30
	bne	$t5, 0, errorTwo
	
	# *mem + imm + rs
	add	$t0, $a3, $t0
	
	# check memory bounds
	slt	$t1, $t0, $a3				# less than
	bne	$t1, 0, errorThree
	
	# max memory bounds
	add	$t5, $a3, $t9
	slt	$t1, $t5, $t0
	beq	$t1, 1, errorThree
									
	#lw	$t1, 0($t0)				# get a value
	
	sll	$s2, $s2, 2				# load rt
	add	$s2, $a2, $s2				# 
	
	lw	$t1, 0($s2)				# find value what reg we used
	
	sw	$t1, 0($t0)
	
	j	errorZero
	
jrFunct:
	j	loadRsValueFromReg
jrFunctLoadRsDone:
	add	$v0, $zero, $s1
	addi	$v1, $v1, 0
	j	execInstructionDone
	
bneOpencode:	
	# bne rs, rt, label
	j	loadRsValueFromReg
bneOpencodeLoadRt:
	j	loadRtValueFromReg
bneOpencodeLoadRtDone:	
	beq	$s1, $s2, bneOpencodeDone
	
	add	$s6, $s6, $s6
	add	$s6, $s6, $s6
	
	addi	$s6, $s6, 4
	
	add	$v0, $a1, $s6
	addi	$v1, $v1, 0				# no error
	j	execInstructionDone
	
bneOpencodeDone:
	add	$v0, $a1, 4
	addi	$v1, $v1, 0				# no error
	j	execInstructionDone
	
beqOpencode:
	# beq rs, rt, label
	j	loadRsValueFromReg
beqOpencodeLoadRt:
	j	loadRtValueFromReg
beqOpencodeLoadRtDone:
	bne	$s1, $s2, beqOpencodeDone
	
	add	$s6, $s6, $s6
	add	$s6, $s6, $s6
	
	addi	$s6, $s6, 4
	
	add	$v0, $a1, $s6
	addi	$v1, $v1, 0				# no error
	j	execInstructionDone
	
beqOpencodeDone:
	add	$v0, $a1, 4
	addi	$v1, $v1, 0				# no error
	j	execInstructionDone
	
syscallFunct:
	lw	$t0, 8($a2)
	
	beq	$t0, 10, errorNegativeOne
	
	beq	$t0, 4, syscallFunctPrintString
	
	lw	$t1, 16($a2)
	add	$a0, $zero, $t1
	add	$v0, $zero, $t0
	syscall
	
	j	errorZero

syscallFunctPrintString:
	lw	$t1, 16($a2)				# load $a0
	slt	$t2, $t9, $t1				# check memSize < $a0
	beq	$t2, 1, errorThree			# 
	
	add	$t2, $t1, $a3
	la	$a0, 0($t2)
	addi	$v0, $zero, 4
	syscall
	
	j	errorZero
	
#---------------------------------
addiOpcode:
	# addi rt, rs, imm
	j	loadRsValueFromReg
addiOpcodeWriteRt:
	j	writeRtValueToReg
addiOpcodeDone:
	j	errorZero
	
#=================================
loadRsValueFromReg:
	# i - $t0
	addi	$t0, $s1, 0				#
	
	add	$t0, $t0, $t0
	add	$t0, $t0, $t0				# i * 4
	
	add	$t1, $t0, $a2
	
	lw	$s1, 0($t1)
	
loadRsValueFromRegDone:
	beq	$s0, 8, addiOpcodeWriteRt
	beq	$s0, 9, addiOpcodeWriteRt
	beq	$s0, 5, bneOpencodeLoadRt
	beq	$s0, 4, beqOpencodeLoadRt
	
	beq	$s5, 32, addFunctLoadRt
	beq	$s5, 34, subFunctLoadRt
	beq	$s5, 42, sltFunctLoadRt
	beq	$s5, 8, jrFunctLoadRsDone

#===================================
writeRtValueToReg:
	addi	$t0, $s2, 0				#
	
	add	$t0, $t0, $t0
	add	$t0, $t0, $t0				# i * 4
	
	add	$t1, $t0, $a2
	
	add	$s6, $s6, $s1
	
	sw	$s6, 0($t1)
	
	
	beq	$s0, 8,	addiOpcodeDone
	beq	$s0, 9,	addiOpcodeDone
	
#===================================
loadRtValueFromReg:
	addi	$t0, $s2, 0				#
	
	add	$t0, $t0, $t0
	add	$t0, $t0, $t0				# i * 4
	
	add	$t1, $t0, $a2
	
	lw	$s2, 0($t1)
	
	beq	$s0, 5, bneOpencodeLoadRtDone
	beq	$s0, 4, beqOpencodeLoadRtDone
	
	beq	$s5, 32, addFunctLoadRtDone		# funct == 32
	beq	$s5, 34, subFunctLoadRtDone		# funct == 34
	beq	$s5, 42, sltFunctLoadRtDone
	
#===================================
writeRdValueToReg:
	addi	$t0, $s3, 0				#
	
	add	$t0, $t0, $t0
	add	$t0, $t0, $t0				# i * 4
	
	add	$t1, $t0, $a2
	
	beq	$s5, 32, addFunctWriteRdValueToReg	# funct == 32
	beq	$s5, 34, subFunctWriteRdValueToReg	# funct == 34
	beq	$s5, 42, sltFunctWriteRdValueToReg	# funct == 42

addFunctWriteRdValueToReg:
	add	$t3, $s1, $s2
	sw	$t3, 0($t1)
	j	writeRdValueToRegDone
	
subFunctWriteRdValueToReg:
	sub	$t3, $s1, $s2
	sw	$t3, 0($t1)
	j	writeRdValueToRegDone

sltFunctWriteRdValueToReg:
	slt	$t3, $s1, $s2
	sw	$t3, 0($t1)
	j	writeRdValueToRegDone

writeRdValueToRegDone:
	j	errorZero

#===================================
errorZero:
	addi	$v0, $a1, 4				# PC + 4

	addi	$v1, $zero, 0

	addi	$v1, $v1, 0				# no error
	j	execInstructionDone
errorOne:
	add	$v0, $a1, $zero
	
	addi	$v1, $zero, 0
	addi	$v1, $v1, 1				# invalid opcode or func ﬁeld
	j	execInstructionDone
errorTwo:
	add	$v0, $a1, $zero
	
	addi	$v1, $zero, 0
	addi	$v1, $v1, 2				# alignment exception (on lw/sw)
	j	execInstructionDone
errorThree:
	add	$v0, $a1, $zero
	addi	$v1, $zero, 0
	addi	$v1, $v1, 3				# load/store address is outside of the ‘memSize’ bounds
	j	execInstructionDone
errorNegativeOne:
	add	$v0, $a1, $zero
	addi	$v1, $zero, 0
	addi	$v1, $v1, -1				# syscall 10 (exit) was executed
	j	execInstructionDone

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
	lw	$a3, 20($sp)				# load value to $a3
	lw	$a2, 16($sp)				# load value to $a2
	lw	$a1, 12($sp)				# load value to $a1
	lw	$a0, 8($sp)				# load value to $a0
        lw    	$ra, 4($sp)				# get return address from stack
        lw    	$fp, 0($sp)				# restore the caller's frame pointer
        addiu 	$sp, $sp, 28				# restore the caller's stack pointer
        jr    	$ra					# return to caller's code
