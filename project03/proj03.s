.data

mode:
	.byte		4

strings:
	.word		one
	.word		two
	.word		three
	.word		four
	.word		five
	.word		six
one:
	.asciiz		"One"
two:
	.asciiz 	"Two"
three:
	.asciiz 	"Three"
four:
	.asciiz 	"Four"
five:
	.asciiz 	"Five"
six:
	.asciiz 	"Six"

numStrs:
	.byte 		6
	
s1:
	.byte		0

s2:
	.byte		1
	
c:
	.half		1
	
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
        
        lw	$t3, 0($t2)				# string[s1]
        
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
        
        lw	$t4, 0($t2)				# string[s2]
	        
        # add	$a0, $zero, $t4
        # addi	$v0, $zero, 4
        # syscall
        
        j	done
        
done:
	# Epilogue for main -- restore stack & frame pointers and return
        lw	$ra, 4($sp)     # get return address from stack
        lw	$fp, 0($sp)     # restore the caller's frame pointer
        addiu	$sp, $sp, 24    # restore the caller's stack pointer
        jr	$ra             # return to caller's code
