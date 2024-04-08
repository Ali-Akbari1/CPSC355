define(i_r, w19)
define(argc_r, w20)
define(argv_r, x21)

        .text
fmt1:   .string "argv[%d] = %s\n"
fmt2:   .string "argv[%d] = %d\n"

        .balign 4
        .global main


main:
        stp     x29, x30, [sp, -16]!
        mov     x29, sp

        mov     argc_r, w0                      // copy argc
        mov     argv_r, x1                      // copy argv

        mov     i_r, 0
        b       test

top:
        ldr     x0, [argv_r, i_r, SXTW 3]
        bl      atoi
        mov     w2, w0

        adrp    x0, fmt2
        add     x0, x0, :lo12:fmt2

        mov     w1, i_r

        bl      printf

        add     i_r, i_r, 1

test:
        cmp     i_r, argc_r
        b.lt    top

exit:
        ldp     x29, x30, [sp], 16
        ret