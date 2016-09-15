#Name: zhangpeng Liao
#Proj: 01
#Due : 15/09/2016

.data
printAllNumStr:	.asciiz "Printing the four values:\n"
printTotalsStr:	.asciiz "Running totals:\n"
printMultiStr:	.asciiz "\"Multiplying\" each value by 7:\n"
printMinStr:	.asciiz "Minimum: "
newLine:	.asciiz "\n"
twoSpaces:	.asciiz "  "

.text

main:
	# Function prologue
	addiu	$sp, $sp, -24
	sw	$fp, 0($sp)
	sw	$ra, 4($sp)
	addiu	$fp, $sp, 20

	la	$t0, foo	#load address of foo
	lb	$s1, 0($t0)	#load the value of foo

	la	$t0, bar	#load address of bar
	lw	$s2, 0($t0)	#load the value of bar

	la	$t0, baz	#load address of baz
	lw	$s3, 0($t0)	#load the value of baz

	la	$t0, fred	#load address of fred
	lh	$s4, 0($t0)	#load the value of fred

	la	$t0, print	#load the address of print
	lw	$s0, 0($t0)	#load the value of print
	bne	$s0, $zero, printNum	# if print != 0,go to printNum

branchSum:
	la	$t0, sum	#load the address of sum
	lw	$s0, 0($t0)	#load the value of sum
	bne	$s0, $zero, printSum	#if sum != 0,go to printSum

branchMultiply:
	la	$t0, multiply	#load address of multiply
	lw	$s0, 0($t0)	#load the value of multiply
	bne	$s0, $zero, printMultiply	#if multiply != 0,go to printMultiply
branchMinimum:
	la	$t0, minimum	#load address of minimum
	lw	$s0, 0($t0)	#load the value of minimum
	bne	$s0, $zero, printMinimum	#if minimum != 0, go to printMinimum
	j	done		#else go to done
printNum:

	la	$a0, printAllNumStr	#load address of the printAllNumStr
	addi	$v0, $zero, 4	#copy printAllNumStr to v0,print string, code 4
	syscall			#print out string

	add	$a0, $s1, $zero	#
	addi	$v0, $zero, 1	# print out foo
	syscall			#
	la	$a0, newLine	#
	addi	$v0, $zero, 4	# pirnt out new line
	syscall			#

	add	$a0, $s2, $zero	#
	addi	$v0, $zero, 1	# print out bar
	syscall			#
	la	$a0, newLine	#
	addi	$v0, $zero, 4	# print out new line
	syscall			#

	add	$a0, $s3, $zero	#
	addi	$v0, $zero, 1	# print out baz
	syscall			#
	la	$a0, newLine	#
	addi	$v0, $zero, 4	# print out new line
	syscall			#

	add	$a0, $s4, $zero	#
	addi	$v0, $zero, 1	# print out fred
	syscall			#
	la	$a0, newLine	#
	addi	$v0, $zero, 4	# print out new line
        syscall			#

        la      $a0, newLine	#
        addi    $v0, $zero, 4	# print out new line
	syscall			#

	j	branchSum	# jump back to ask if sum is not 0
printSum:

	la	$a0, printTotalsStr	#load address of printTotalsStr
	addi	$v0, $zero, 4		#copy printTotalsStr to v0
	syscall				#print out printTotalsStr

	add	$a0, $s1, $zero		# a0 =  foo + 0
	addi	$v0, $zero, 1		# copy foo to v0
	syscall				# print out foo which is first total number
	la	$a0, newLine		#
	addi	$v0, $zero, 4		# print out new line
	syscall				#

	add	$a0, $s1, $s2		# a0 = foo + bar
	addi	$v0, $zero, 1		# copy their sum to v0
	syscall				# print out current total number which is sum of foo and bar
	la	$a0, newLine		#
	addi	$v0, $zero, 4		# print out new line
	syscall				#

	add	$t0, $s1, $s2		# t0 = foo + bar
	add	$t0, $t0, $s3		# t0 = t0 + baz
	add	$a0, $t0, $zero		# a0 = t0 + 0
	addi	$v0, $zero, 1		# copy foo, bar and baz 's sum
	syscall				# print out their sum
	la	$a0, newLine		#
	addi	$v0, $zero, 4		# print out new line
	syscall				#

	add	$t0, $t0, $s4		# t0 = t0 + fred
	add	$a0, $t0, $zero		# a0 = t0 + 0
	addi	$v0, $zero, 1		# copy four number's sum to v0
	syscall				# print out thir sum
	la	$a0, newLine		#
	addi	$v0, $zero, 4		# print out new line
	syscall				#
	la	$a0, newLine		#
	addi	$v0, $zero, 4		# print out new line
	syscall				#

	j	branchMultiply		# jump back to ask if multiply is 0

printMultiply:

	la	$a0, printMultiStr	# load address of printMultiStr
	addi	$v0, $zero, 4		# copy printMultiStr to v0
	syscall				# print out printMultiStr

	# here start at multiply each number by 7

	add	$t0, $s1, $s1		# this is whole is to multiply
	add	$t0, $t0, $s1		# foo by 7
	add	$t0, $t0, $s1		# t0 = foo * 7
	add	$t0, $t0, $s1		#
	add	$t0, $t0, $s1		#
	add	$t0, $t0, $s1		#

	add	$a0, $t0, $zero		# a0 = t0 + 0
	addi	$v0, $zero, 1		# v0 will get value of foo * 7
	syscall				# print out foo * 7
	la	$a0, twoSpaces		#
	addi	$v0, $zero, 4		# print out two spaces
	syscall				#

	add	$t0, $s2, $s2		#
	add	$t0, $t0, $s2		#
	add	$t0, $t0, $s2		# t0 =  bar * 7
	add	$t0, $t0, $s2		#
	add	$t0, $t0, $s2		#
	add	$t0, $t0, $s2		#

	add	$a0, $t0, $zero		#
	addi	$v0, $zero, 1		# print out bar * 7
	syscall				#
	la	$a0, twoSpaces		#
	addi	$v0, $zero, 4		# print out two spaces
	syscall				#

	add	$t0, $s3, $s3		#
	add	$t0, $t0, $s3		#
	add	$t0, $t0, $s3		# t0 = baz * 7
	add	$t0, $t0, $s3		#
	add	$t0, $t0, $s3		#
	add	$t0, $t0, $s3		#

	add	$a0, $t0, $zero		#
	addi	$v0, $zero, 1		# print out baz * 7
	syscall				#
	la	$a0, twoSpaces		#
	addi	$v0, $zero, 4		# print out two spaces
	syscall				#

	add	$t0, $s4, $s4		#
	add	$t0, $t0, $s4		#
	add	$t0, $t0, $s4		# t0 = fred 8 7
	add	$t0, $t0, $s4		#
	add	$t0, $t0, $s4		#
	add	$t0, $t0, $s4		#

	add	$a0, $t0, $zero		#
	addi	$v0, $zero, 1		# print out fred * 7
	syscall				#
	la	$a0, newLine		#
	addi	$v0, $zero, 4		# print out two spaces
	syscall				#

	la	$a0, newLine		#
	addi	$v0, $zero, 4		# print out new line
	syscall				#

	j	branchMinimum		# jump back to ask if minimum is 0

printMinimum:
	la	$a0, printMinStr	# load address of printMinStr
	addi	$v0, $zero, 4		# v0 get copy of printMinStr
	syscall				# print out printMinStr

	slt	$t0, $s1, $s2		# t0 =(s1 < s2)
	beq	$t0, $zero firstFirstGreater	# if s1 >= s2 go to firstFirstGreater
	add	$t0, $s1, $zero		# else, it is s1 < s2, t0 = s1
	j	firstCompareEnd		# jump to firstCompareEnd
firstFirstGreater:
	add	$t0, $s2, $zero		# s1 >= s2, so t0 = s2
	j	firstCompareEnd		# jump to firstCompareEnd

firstCompareEnd:
	slt	$t1, $t0, $3		# t1 = (t0 < s3)
	beq	$t1, $zero, secondFirstGreater	# if s1 >= s3, go to secondFirstGreater
	add	$t1, $t0, $zero		# else, it is s1 < s3,  t1 = t0 = s1
	j	secondCompareEnd	# jump to secondCpareEnd

secondFirstGreater:
	add	$t1, $s3, $zero		# s1 >= s3, t1 = s3
	j	secondCompareEnd	# jump to secondCompareEnd

secondCompareEnd:
	slt	$t2, $t1, $s4		# t2 =(t1 < s4)
	beq	$t2, $zero, thirdFirstGreater	# if t1 >= s4 go to thridFirstGreater
	add	$t2, $t1, $zero		# else, it is t1 < s4, t2 = t1
	j	thirdCompareEnd		# jump to thirdCompareEnd

thirdFirstGreater:
	add	$t2, $s4, $zero		# t2 >= s4, t2 = s4
	j	thirdCompareEnd		# jump to thirdCompareEnd

thirdCompareEnd:
	add	$a0, $t2, $zero		# a0 = t2 + 0
	addi	$v0, $zero, 1		# t2 is the smallest number
	syscall				# print out smallest number
	la	$a0, newLine		#
	addi	$v0, $zero, 4		# print out new line
	syscall				#
	la	$a0, newLine		#
	addi	$v0, $zero, 4		# print out new line
	syscall				#
done:
	lw	$ra, 4($sp)
	lw	$fp, 0($sp)
	addiu	$sp, $sp, 24
	jr	$ra
