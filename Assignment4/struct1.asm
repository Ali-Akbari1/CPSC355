str:    .string "age=%d, type=%d\n"

        person_age = 0
        person_type = 4
        person_struct_size = 8

        p_s = 16

        alloc = -(16 + person_struct_size) & -16
        dealloc = -alloc

fp      .req    x29
lr      .req    x30

        .balign 4
        .global main

main:
        stp     fp, lr, [sp, alloc]!
        mov     fp, sp

        add     x8, fp, p_s				// pass in a pointer using x8
        bl      new_person

        add     x0, fp, p_s				// pass in address of p_s as an argument
        bl      print_person

        ldp     fp, lr, [sp], dealloc
        ret

print_person:
        stp     fp, lr, [sp, alloc]!
        mov     fp, sp

        mov     x9, x0

        adrp    x0, str
        add     x0, x0, :lo12:str
        ldr     w1, [x9, person_age]
        ldr     w2, [x9, person_type]
        bl      printf

        ldp     fp, lr, [sp], dealloc
        ret

new_person:
        stp     fp, lr, [sp, alloc]!
        mov     fp, sp

        // store struct in local stack
        mov     w9, 23
        str     w9, [fp, p_s + person_age]
        mov     w9, 1
        str     w9, [fp, p_s + person_type]

        // copy local struct into main struct
        ldr     w9, [fp, p_s + person_age]
        str     w9, [x8, person_age]

        ldr     w9, [fp, p_s + person_type]
        str     w9, [x8, person_type]

        ldp     fp, lr, [sp], dealloc
        ret

