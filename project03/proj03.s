.data

mode:
	.byte	1

invalidMode:
	.asciiz 	"Invalid Mode."


.text
main:
	# Function prologue -- even main has one
        addiu	$sp, $sp, -24	# allocate stack space -- default of 24 here
        sw	$fp, 0($sp)	# save caller's frame pointer
        sw	$ra, 4($sp)	# save return address
        addiu	$fp, $sp, 20	# setup main's frame pointer
        
loadSomehings:
	la	$t0, mode	# $t0 = &mode
	lb	$s0, 0($t0)	# $s0 = mode
	
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
	la	$t0, invalidMode	# print "Invalid Mode."
	add	$a0, 0($t0)
	addi	$v0, $zero, 4
	syscall
	
	addi	$a0, $zero, 0xa		# print_char('\n')
	add	$v0, $zero, 11
	syscall
	
printStringMode:

doubleIndexMode:

compareAndSwapTwoString:   
        
        
        
done:
	# Epilogue for main -- restore stack & frame pointers and return
        lw	$ra, 4($sp)     # get return address from stack
        lw	$fp, 0($sp)     # restore the caller's frame pointer
        addiu	$sp, $sp, 24    # restore the caller's stack pointer
        jr	$ra             # return to caller's code
