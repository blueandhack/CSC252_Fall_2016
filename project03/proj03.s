.data
invalidMode:	.asciiz 	"Invalid Mode."
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
        
done:
	# Epilogue for main -- restore stack & frame pointers and return
        lw	$ra, 4($sp)     # get return address from stack
        lw	$fp, 0($sp)     # restore the caller's frame pointer
        addiu	$sp, $sp, 24    # restore the caller's stack pointer
        jr	$ra             # return to caller's code
