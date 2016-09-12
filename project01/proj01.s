.data

print:  .word   1
sum:    .word   0
multiply:   .word   0
minimum:    .word   1

foo:    .byte   0
bar:    .word   42
baz:    .word   17
fred:   .half   -123

str:  .ascii  "Printing the four vlues:"
newline:  .ascii "\n"

.text
    main:
        la  $a0,str
        addi  $v0,$zero,4
        la  $a1,newline
        addi  $v1,$zero,4
        syscall

        la  $a0,42
        addi  $v0,$zero,1
        syscall
