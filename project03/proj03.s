.data
mode:
	.byte   4       # strcmp

numStrs:
	.byte   16
strings:
	.word	STR_CONST__zero
	.word	STR_CONST__one
	.word	STR_CONST__two
	.word	STR_CONST__three
	.word	STR_CONST__four
	.word	STR_CONST__five
	.word	STR_CONST__six
	.word	STR_CONST__seven
	.word	STR_CONST__eight
	.word	STR_CONST__nine
	.word	STR_CONST__ten
	.word	STR_CONST__eleven
	.word	STR_CONST__twelve
	.word	STR_CONST__thirteen
	.word	STR_CONST__fourteen
	.word	STR_CONST__fifteen

STR_CONST__zero:
	.asciiz "zero"
STR_CONST__one:
	.asciiz "one"
STR_CONST__two:
	.asciiz "two"
STR_CONST__three:
	.asciiz "three"
STR_CONST__four:
	.asciiz "four"
STR_CONST__five:
	.asciiz "five"
STR_CONST__six:
	.asciiz "six"
STR_CONST__seven:
	.asciiz "seven"
STR_CONST__eight:
	.asciiz "eight"
STR_CONST__nine:
	.asciiz "nine"
STR_CONST__ten:
	.asciiz "ten"
STR_CONST__eleven:
	.asciiz "eleven"
STR_CONST__twelve:
	.asciiz "twelve"
STR_CONST__thirteen:
	.asciiz "thirteen"
STR_CONST__fourteen:
	.asciiz "fourteen"
STR_CONST__fifteen:
	.asciiz "fifteen"


s1:
	.byte   14
s2:
	.byte   15
c:
	.half   0
	
debug:
	.asciiz "Debug"
	
# ----- STUDENT CODE BELOW -----	

.data 

invalidMode:
	.asciiz 	"Invalid Mode."


.text

main:
	# Function prologue -- even main has one
        addiu	$sp, $sp, -24	# allocate stack space -- default of 24 here
        sw	$fp, 0($sp)	# save caller's frame pointer
        sw	$ra, 4($sp)	# save return address
        addiu	$fp, $sp, 20	# setup main's frame pointer
        
	# LOAD THE COMMON VARIABLES
	la	$t0, mode	# $t0 = &mode
	lb	$s0, 0($t0)	# $s0 = mode
	
	la	$s1, strings	# $s1 = &strings
	
	la	$t0, numStrs	# $t0 = &numStrs
	lb	$s2, 0($t0)	# $s2 = numStrs
	
	la	$t0, s1		# $t0 = &s1
	lb	$s3, 0($t0)	# $s3 = s1
	
	la	$t0, s2		# $t0 = &s2
	lb	$s4, 0($t0)	# $s4 = s2
	
	la	$t0, c
	lh	$s5, 0($t0)	# $s5 = c
	
ifEqualsOne:
	beq	$s0, 0x1, printInvalidMode
ifEqualsTwo:
	beq	$s0, 0x2, printStringMode
ifEqualsThree:
	beq	$s0, 0x3, doubleIndexMode
ifEqualsFour:
	beq	$s0, 0x4, compareAndSwapTwoString
	j	done
	
printInvalidMode:
	# Print "Invalid Mode." When Mode is 1
	# 
	# if(mode == 1)
	# 	printf("Invalid Mode.\n");
	
	la	$a0, invalidMode	# print "Invalid Mode."
	addi	$v0, $zero, 4
	syscall
	
	addi	$a0, $zero, 0xa		# print_char('\n')
	add	$v0, $zero, 11
	syscall
	
	j	done
	
printStringMode:
	# Print String Array
	# int i = 0;
	# for(i = 0; i < numStrs; i++){
	#	printf("%s", strings[i]);
	# }
	
	addi	$t1, $zero, 0		# i = 0

printStringModeLoop:
	beq	$s2, $t1, printStringModeLoopEnd 
	add	$t0, $t1, $t1				# i = i * 2
	add	$t0, $t0, $t0				# i = i * 4
	add	$t2, $s1, $t0				# $t2 = &string[i]
	
	lw	$t3, 0($t2)				# $t3 = string[i]
	add	$a0, $zero, $t3				# Print string[i]
	addi	$v0, $zero, 4				#
	syscall
	
	addi	$a0, $zero, 0xa				# print_char('\n')
	add	$v0, $zero, 11
	syscall
	
	addi	$t1, $t1, 1				# i = i + 1
	j	printStringModeLoop			# Jump to printStringModeLoop
	
printStringModeLoopEnd:
	j	done
	
	
doubleIndexMode:
	# Print index of String Array and index of char in String
	# printf("%c", string[s1][c]);
	# 
	
	addi	$t1, $s3, 0
	
	add	$t0, $t1, $t1
	add	$t0, $t0, $t0
	add	$t2, $s1, $t0				# $t2 = &string[s1]
	
	lw	$t3, 0($t2)				# $t3 = string[s1]
	
	add	$t4, $t3, $s5				# $t4 = string[s1][c]
	lb	$a0, 0($t4)				#
	addi	$v0, $zero, 11				# print string[s1][c]
	syscall
	
	addi	$a0, $zero, 0xa				# print_char('\n')
	add	$v0, $zero, 11
	syscall
	
	j	done
	
compareAndSwapTwoString:   
        addi	$t1, $s3, 0				# i = s1
        
        add	$t0, $t1, $t1				#
        add	$t0, $t0, $t0				#
        add	$t2, $s1, $t0				#
        
        lw	$t3, 0($t2)				# $t3 = string[s1]
        
        # add	$a0, $zero, $t3
        # addi	$v0, $zero, 4
        # syscall
        
        # addi	$a0, $zero, 0xa				# print_char('\n')
	# add	$v0, $zero, 11
	# syscall
        
        addi	$t1, $s4, 0				# i = s2
        
        add	$t0, $t1, $t1				#
        add	$t0, $t0, $t0				#
        add	$t2, $s1, $t0				#
        
        lw	$t4, 0($t2)				# $t4 = string[s2]
	        
        # add	$a0, $zero, $t4
        # addi	$v0, $zero, 4
        # syscall
        
        # $t3 = s1  $t4 = s2
        addi	$t0, $zero, 0				# i = 0
        
compareLoop:
	add	$t1, $t3, $t0
	lb	$t5, 0($t1)
	
	add	$t1, $t4, $t0
	lb	$t6, 0($t1)
        
        beq	$t5, $zero, compareLoopEnd
        beq	$t6, $zero, compareLoopEnd
        
        slt	$t1, $t5, $t6				# if str1[i] < str2[i]
        bne	$t1, $zero, s1smalls2
        slt	$t1, $t6, $t5				# if str1[i] > str2[i]
        bne	$t1, $zero, s2smalls1
        
        addi	$t0, $t0, 1				# i ++
        
        j	compareLoop
        
compareLoopEnd:
	
	j	printStringMode
s1smalls2:
	slt	$t1, $s3, $s4				# s1 < s2
	bne	$t1, $zero, compareEnd
	# s1 > s2
	# $t3 address for str1 $t4 address for str2
	addi	$t1, $s3, 0				# i = s1
        
        add	$t0, $t1, $t1				#
        add	$t0, $t0, $t0				#
        add	$t2, $s1, $t0				#
        sw	$t4, 0($t2)
        
        addi	$t1, $s4, 0				# i = s2
        
        add	$t0, $t1, $t1				#
        add	$t0, $t0, $t0				#
        add	$t2, $s1, $t0				#
	sw	$t3, 0($t2)
	
s2smalls1:	
	slt	$t1, $s4, $s3				# s2 < s1
	bne 	$t1, $zero, compareEnd
	# s1 < s2
	addi	$t1, $s3, 0				# i = s1
        
        add	$t0, $t1, $t1				#
        add	$t0, $t0, $t0				#
        add	$t2, $s1, $t0				#
        sw	$t4, 0($t2)
        
        addi	$t1, $s4, 0				# i = s2
        
        add	$t0, $t1, $t1				#
        add	$t0, $t0, $t0				#
        add	$t2, $s1, $t0				#
	sw	$t3, 0($t2)
	
	
	
compareEnd:
        j	printStringMode	
        
done:
	# Epilogue for main -- restore stack & frame pointers and return
        lw	$ra, 4($sp)     # get return address from stack
        lw	$fp, 0($sp)     # restore the caller's frame pointer
        addiu	$sp, $sp, 24    # restore the caller's stack pointer
        jr	$ra             # return to caller's code
