.data

print:  .word   1
sum:    .word   0
multiply:   .word   0
minimum:    .word   1

foo:    .byte   0
bar:    .word   42
baz:    .word   17
fred:   .half   -123

.text
    main:
        la  $s0,foo
        lb  $s0,0($s0)
        syscall
