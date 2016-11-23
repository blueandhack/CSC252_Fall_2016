
.data

REGS:
	.space	128       # 32 words



PROGRAM:
	.word	0x20080000         # addi    $t0, $zero, 0
	.word	0x2009000a         # addi    $t1, $zero, 10
		                   # LOOP_1
	.word	0x20020001         # addi    $v0, $zero, 1
	.word	0x01002020         # add     $a0, $t0, $zero
	.word	0x0000000c         # syscall
	.word   0x21080001         # addi $t0, $t0, 1
	.word	0x0109502a         # slt    $t2, $t0, $t1
	.word	0x1540fffa         # bne    $t2, $zero, LOOP_1

	.word	0x2002000a         # addi    $v0, $zero, 10
	.word   0x0000000c         # syscall  (10=exit)
END_PROGRAM:



MEMORY:
	.space	16384              # 16 KB
END_MEMORY:



.text


main:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20


	# in this function, we'll use the following registers:
	#     s0 - address of register file
	#     s1 - address of program (in real memory)
	#     s2 - length of program
	#     s3 - address of virtual memory buffer, in real memory
	#     s4 - length of virtual memory
	#     s5 - current program counter

	la      $s0, REGS         # s0 = &regs

	la      $s1, PROGRAM      # s1 = &program_start

	la      $s2, END_PROGRAM
	sub     $s2, $s2, $s1             # s2 = &program_end - &program_start

	la      $s3, MEMORY       # s3 = &program_start

	la      $s4, END_MEMORY
	sub     $s4, $s4, $s3             # s4 = &mem_end - &mem_start

	addi    $s5, $zero, 0             # PC = 0


main_PROGRAM_LOOP:
	# print out all of the data about the current instruction
.data
main_MSG1:	.asciiz	"PC: "

.text
	addi    $v0, $zero, 4             # print_str(MSG1)
	la      $a0, main_MSG1
	syscall

	add     $a0, $s5, $zero           # printHex(PC, 8)
	addi    $a1, $zero, 8
	jal     printHex

	addi    $v0, $zero, 11            # print_char(newline)
	addi    $a0, $zero, 0xa
	syscall


	# is the program counter outside of the valid range?
	slt     $t0, $s5, $zero           # t0 = PC < 0
	bne     $t0, $zero, main_PC_INVALID

	slt     $t0, $s5, $s2             # t0 = PC < programSize
	beq     $t0, $zero, main_PC_INVALID


	# the instruction address is valid (although it might not be aligned!)
	# Go ahead and run it.

	# args 1-4 are in registers; the fifth arg is on the stack.
	add     $t0, $s1, $s5             # t0 = &program[PC]
	lw      $a0, 0($t0)               # a0 =  program[PC]

	add     $a1, $s5, $zero           # a1 = PC

	add     $a2, $s0, $zero           # a2 = regs

	add     $a3, $s3, $zero           # a3 = mem

	sw      $s4, -4($sp)              # arg5 = memSize

	jal     execInstruction

	# update the program counter
	add     $s5, $v0, $zero

	# if this is an error, then jump to the error handler.
	bne     $v1, $zero, main_END_ERROR

	j       main_PROGRAM_LOOP


main_PC_INVALID:
.data
main_PC_INVALID_msg:	.asciiz "ERROR: The program counter is invalid.  PC="
.text

	addi    $v0, $zero, 4
	la      $a0, main_PC_INVALID_msg
	syscall

	add     $a0, $s5, $zero
	addi    $a1, $zero, 8
	jal     printHex

	addi    $v0, $zero, 11
	addi    $a0, $zero, 0xa    # print_char('\n')
	syscall

	j       main_DONE


main_END_ERROR:
	addi    $t0, $zero, -1
	beq     $v1, $t0, main_DONE    # normal end - syscall 10

.data
main_END_ERROR_msg:	.asciiz	"ERROR: The program failed with error code "
.text
	addi    $v0, $zero, 4
	la      $a0, main_END_ERROR_msg
	syscall

	addi    $v0, $zero, 1
	add     $a0, $v1, $zero
	syscall

	addi    $v0, $zero, 11
	addi    $a0, $zero, 0xa    # print_char('\n')
	syscall

	j       main_DONE


main_DONE:
	add     $a0, $s5, $zero
	jal     dumpState

	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra




# HELPER FUNCTION: printHex(value, minChars)
#
# This basically implements printf("%nx", value) , where 'n' is minChars
printHex:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20


	# if value == 0 && minChars <= 0, then this call is a NOP.
	bne    $a0, $zero, printHex_doPrint

	slt    $t0, $zero, $a1
	bne    $t0, $zero, printHex_doPrint

	# if we get here, then we don't have any reason to print.
	j      printHex_DONE

printHex_doPrint:
	# if we get here, then we *DO* want to print.  Recurse first - but
	# save the 'value' argument before that.
	sw     $a0, 8($sp)         # save a0 into its slot

	srl    $a0, $a0, 4         # printHex(value >> 4, minChars-1)
	addi   $a1, $a1, -1
	jal    printHex

	# restore that argument register.  Note that we didn't save minChars,
	# since it wasn't required later in this function.
	lw     $a0, 8($sp)

	# finally, print out this one character.  We extract the nibble first,
	# and then figure out whether or not it is a decimal or letter to
	# print.
	andi   $t0, $a0, 0xf       # t0 = value & 0xf

	slti   $t1, $t0, 10        # t1 = (value & 0xf) < 10
	bne    $t1, $zero, printHex_IS_A_DIGIT


	# t0 contains a number more than 9, but less than 16.  Print it out
	# as a character.
	addi   $v0, $zero, 11      # print_char('a'-10+ (value & 0xf))
	addi   $a0, $t0, 87
	syscall

	j      printHex_DONE


printHex_IS_A_DIGIT:
	# t0 contains a number less than 10, which we want to print.
	addi   $v0, $zero, 1       # print_int(value & 0xf)
	add    $a0, $t0, $zero
	syscall


printHex_DONE:
	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra



dumpState:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20


	# save the sX registers that we'll be using
	sw      $s0,  -4($sp)
	sw      $s1,  -8($sp)
	sw      $s2, -12($sp)
	addiu   $sp, $sp, -12


.data
dumpState_MSG1:	.asciiz	"PC="
dumpState_MSG2:	.asciiz	" regs:"
.text


	# save the PC register, so that it's not messed up by the syscall.
	add    $s0, $a0, $zero

	# print out the first string...
	addi   $v0, $zero, 4
	la     $a0, dumpState_MSG1
	syscall

	# ...then the PC value...
	addi   $v0, $zero, 1
	add    $a0, $s0, $zero
	syscall

	# ...then the second string...
	addi   $v0, $zero, 4
	la     $a0, dumpState_MSG2
	syscall

	# ...then a loop over all of the regsiters.
	addi   $s0, $zero, 0
	la     $s1, REGS
	addi   $s2, $zero, 32

dumpState_LOOP:
	# print a space...
	addi   $v0, $zero, 11
	addi   $a0, $zero, ' '
	syscall

	# ...then the register number...
	addi   $v0, $zero, 1
	add    $a0, $s0, $zero
	syscall

	# ...then a colon...
	addi   $v0, $zero, 11
	addi   $a0, $zero, ':'
	syscall

	# ...then the register value
	lw     $a0, 0($s1)              # printHex(regs[s0], 1)
	addi   $a1, $zero, 1
	jal    printHex

	addi   $s0, $s0, 1
	addi   $s1, $s1, 4

	slt    $t0, $s0, $s2
	bne    $t0, $zero, dumpState_LOOP

	addi   $v0, $zero, 11           # print_char(newline)
	addi   $a0, $zero, 0xa
	syscall


dumpState_DONE:
	# restore the sX registers
	addiu   $sp, $sp, 12
	lw      $s0,  -4($sp)
	lw      $s1,  -8($sp)
	lw      $s2, -12($sp)

	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra



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
	beq	$s0, 8, addiOpcode			# opencode == 8
	beq	$s0, 9, addiOpcode			# opencode == 9
	beq	$s0, 2, jOpencode			# opencode == 2
	beq	$s0, 5, bneOpencode			# opencode == 5
	beq	$s0, 4, beqOpencode			# opencode == 4
	
	beq	$s0, $zero, ifOpcodeEqualsZero
	
	j	errorOne
	
ifOpcodeEqualsZero:
	beq	$s5, 32, addFunct			# funct == 32
	beq	$s5, 34, subFunct			# funct == 34
	
	beq	$s5, 42, sltFunct
	
	beq	$s5, 12, syscallFunct			# funct == 12
	
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
	srl	$t0, $t0, 6
	
	add	$t0, $t0, $t0
	add	$t0, $t0, $t0
	
	add	$v0, $zero, $t0
	addi	$v1, $v1, 0				# no error
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
	addi	$a1, $a1, 4				# PC + 4
	add	$v0, $a1, $zero

	addi	$v1, $v1, 0				# no error
	j	execInstructionDone
errorOne:
	add	$v0, $a1, $zero
	addi	$v1, $v1, 1				# invalid opcode or func ﬁeld
	j	execInstructionDone
errorTwo:
	add	$v0, $a1, $zero
	addi	$v1, $v1, 2				# alignment exception (on lw/sw)
	j	execInstructionDone
errorThree:
	add	$v0, $a1, $zero
	addi	$v1, $v1, 3				# load/store address is outside of the ‘memSize’ bounds
	j	execInstructionDone
errorNegativeOne:
	add	$v0, $a1, $zero
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
