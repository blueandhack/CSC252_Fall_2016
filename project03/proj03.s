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
	.asciiz "AAABVVV"
STR_CONST__fifteen:
	.asciiz "AAAB"


s1:
	.byte   15
s2:
	.byte   14
c:
	.half   0
	
debug:
	.asciiz "Debug"
	
# ----- STUDENT CODE BELOW -----	
# proj03.s
#
# CSc 252 Fall 16 - Project 3
#
# Name: Yujia Lin
#
# Prints Invalid Mode, String, char, and sort two Strings


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
	# 
	# These will be used at various places in the program below.
	# 	$s0 = mode
	#	$s1 = strings
	#	$s2 = numStrs
	#	$s3 = s1
	#	$s4 = s2
	#	$s5 = c
	
	la	$t0, mode				# $t0 = &mode
	lb	$s0, 0($t0)				# $s0 = mode
	
	la	$s1, strings				# $s1 = &strings
	
	la	$t0, numStrs				# $t0 = &numStrs
	lb	$s2, 0($t0)				# $s2 = numStrs
	
	la	$t0, s1					# $t0 = &s1
	lb	$s3, 0($t0)				# $s3 = s1
	
	la	$t0, s2					# $t0 = &s2
	lb	$s4, 0($t0)				# $s4 = s2
	
	la	$t0, c					# $t0 = &c
	lh	$s5, 0($t0)				# $s5 = c
	
ifEqualsOne:
	beq	$s0, 0x1, printInvalidMode		# if(mode == 1) jump printInvalidMode
ifEqualsTwo:
	beq	$s0, 0x2, printStringMode		# if(mode == 2) jump printStringMode
ifEqualsThree:
	beq	$s0, 0x3, doubleIndexMode		# if(mode == 3) jump doubleIndexMode
ifEqualsFour:
	beq	$s0, 0x4, compareAndSwapTwoString	# if(mode == 4) jump compareAndSwapTwoString
	
	j	done					# if(mode != 1 && mode != 2 && mode != 3 && mode != 4) jump done
	
printInvalidMode:
	# Print "Invalid Mode." When Mode is 1
	# 
	# if(mode == 1)
	# 	printf("Invalid Mode.\n");
	#
	
	la	$a0, invalidMode	# print "Invalid Mode."
	addi	$v0, $zero, 4		#
	syscall				#
	
	addi	$a0, $zero, 0xa		# print_char('\n')
	add	$v0, $zero, 11		#
	syscall				#
	
	j	done			# jump done
	
printStringMode:
	# Print String Array
	# int i = 0;
	# for(i = 0; i < numStrs; i++){
	#	printf("%s", strings[i]);
	# }
	# 
	# In this loop, we have additional variables:
	# $t1 - i
	# $t2 - temporaries
	# $t3 - strings[i]
	
	addi	$t1, $zero, 0				# i = 0

printStringModeLoop:
	beq	$s2, $t1, printStringModeLoopEnd 	# if (i == numStrs) jump printStringModeLoopEnd
	add	$t0, $t1, $t1				# $t0 = i * 2
	add	$t0, $t0, $t0				# $t0 = i * 4
	add	$t2, $s1, $t0				# $t2 = &string[$t0]
	
	lw	$t3, 0($t2)				# $t3 = string[i]
	add	$a0, $zero, $t3				# print string[i]
	addi	$v0, $zero, 4				#
	syscall						#
	
	addi	$a0, $zero, 0xa				# print_char('\n')
	add	$v0, $zero, 11				#
	syscall						#
	
	addi	$t1, $t1, 1				# i ++
	j	printStringModeLoop			# jump to printStringModeLoop
	
printStringModeLoopEnd:
	j	done					# jump done
	
	
doubleIndexMode:
	# Print a char that from a String
	# char s[] = string[s1];
	# char *pointer = s
	# printf("%c", *(pointer + c));
	# 
	# We have additional variables:
	# $t1 - i
	# $t2 - &string[i]
	# $t3 - string[i]
	
	addi	$t1, $s3, 0				# i = s1
	
	add	$t0, $t1, $t1				# 
	add	$t0, $t0, $t0				#
	add	$t2, $s1, $t0				# $t2 = &string[s1]
	
	lw	$t3, 0($t2)				# $t3 = string[s1]
	
	add	$t4, $t3, $s5				# $t4 = string[s1][c]
	lb	$a0, 0($t4)				#
	addi	$v0, $zero, 11				# print string[s1][c]
	syscall
	
	addi	$a0, $zero, 0xa				# print_char('\n')
	add	$v0, $zero, 11				#
	syscall						#
	
	j	done					# jump done
	
compareAndSwapTwoString:
	# Compare two String and sort them
        # int strcmp(char *str1, char *str2)
	# {
	# 	int i = 0;
	#
	# 	while (str1[i] != ’\0’ && str2[i] != ’\0’)
	# 	{
	# 		// do we have a mismatched character?
	# 		if (str1[i] < str2[i])
	# 			return -1;
	# 		if (str1[i] > str2[i])
	# 			return 1;
	# 		i++;
	# 	}
	#
	# 	// str1 or str2 (or both) have hit the end of their
	# 	// strings; they were identical up to that point.
	#
	# 	if (str2[i] != ’\0’)
	# 		return -1; // str1 is shorter than str2
	# 	if (str1[i] != ’\0’)
	# 		return 1; // str2 is shorter than str1
	# 	// exact match!
	#
	# 	return 0;
	# }
	#
	# We have additional variables:
	# $t0 - i
	# $t3 - strings[s1]
	# $t4 - strings[s2]
	# $t5 - strings[s1][i]
	# $t6 - strings[s2][i]
	
        addi	$t1, $s3, 0				# i = s1
        
        add	$t0, $t1, $t1				#
        add	$t0, $t0, $t0				#
        add	$t2, $s1, $t0				# $t2 = &string[s1]
        
        lw	$t3, 0($t2)				# $t3 = strings[s1]
        
        addi	$t1, $s4, 0				# i = s2
        
        add	$t0, $t1, $t1				#
        add	$t0, $t0, $t0				#
        add	$t2, $s1, $t0				# $t2 = &strings[s2]
        
        lw	$t4, 0($t2)				# $t4 = strings[s2]
        
        addi	$t0, $zero, 0				# i = 0
        
compareLoop:
	add	$t1, $t3, $t0				#
	lb	$t5, 0($t1)				# $t5 = strings[s1][i]
	
	add	$t1, $t4, $t0				#
	lb	$t6, 0($t1)				# $t6 = strings[s2][i]
        
        beq	$t5, $zero, compareLoopEnd		# if(strings[s1][i] == '\0') jump compareLoopEnd
        beq	$t6, $zero, compareLoopEnd		# if(strings[s2][i] == '\0') jump compareLoopEnd
        
        slt	$t1, $t5, $t6				# $t1 = strings[s1][i] < strings[s2][i]
        bne	$t1, $zero, s1smalls2			# if(strings[s1][i] < strings[s2][i]) jump s1smalls2
        
        slt	$t1, $t6, $t5				# $t1 = strings[s2][i] < strings[s1][i]
        bne	$t1, $zero, s2smalls1			# if(strings[s1][i] > strings[s2][i]) jump s2smalls1
        
        addi	$t0, $t0, 1				# i ++
        
        j	compareLoop				# jump compareLoop
        
compareLoopEnd:
	bne	$t5, $zero, s2smalls1			# if(strings[s1][i] == '\0') jump s2smalls1
	bne	$t6, $zero, s1smalls2			# if(strings[s2][i] == '\0') jump s1smalls2
	
	j	printStringMode				# jump printStringMode
	
s1smalls2:
	slt	$t1, $s3, $s4				# $t1 = s1 < s2
	bne	$t1, $zero, compareEnd			# if(s1 < s2) jump compareEnd
	
	# if(s1 > s2) do below
	addi	$t1, $s3, 0				# i = s1
        
        add	$t0, $t1, $t1				#
        add	$t0, $t0, $t0				#
        add	$t2, $s1, $t0				#
        sw	$t4, 0($t2)				# strings[s2] pointer &strings[s1]
        
        addi	$t1, $s4, 0				# i = s2
        
        add	$t0, $t1, $t1				#
        add	$t0, $t0, $t0				#
        add	$t2, $s1, $t0				#
	sw	$t3, 0($t2)				# strings[s1] pointer &strings[s2]
	
s2smalls1:	
	slt	$t1, $s4, $s3				# $t1 = s2 < s1
	bne 	$t1, $zero, compareEnd			# if(s2 < s1) jump comapreEnd
	
	# if(s2 > s1) do below
	addi	$t1, $s3, 0				# i = s1
        
        add	$t0, $t1, $t1				#
        add	$t0, $t0, $t0				#
        add	$t2, $s1, $t0				#
        sw	$t4, 0($t2)				# strings[s2] pointer &strings[s1]
        
        addi	$t1, $s4, 0				# i = s2
        
        add	$t0, $t1, $t1				#
        add	$t0, $t0, $t0				#
        add	$t2, $s1, $t0				#
	sw	$t3, 0($t2)				# strings[s1] pointer &strings[s2] 
		
compareEnd:
        j	printStringMode				# jump printStringMode
        
done:
	# Epilogue for main -- restore stack & frame pointers and return
        lw	$ra, 4($sp)     # get return address from stack
        lw	$fp, 0($sp)     # restore the caller's frame pointer
        addiu	$sp, $sp, 24    # restore the caller's stack pointer
        jr	$ra             # return to caller's code
