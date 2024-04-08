.text
pn: .string "input.bin"
fmt1: .string "Error opening file!"

fmt2: .string "num is %ld\n"

.balign 4
.global main


alloc = -(16 + 8) & -16
dealloc = -alloc

fd_r .req w19
i_r .req x20
bytes_read_r .req x21

main:
    stp x29, x30, [sp, alloc]!
    mov x29, sp

    mov w0, -100 // use cwd
    ldr x1, =pn  // path relative to cwd
    mov w2, 0    // open file in READ-MODE only
    mov w3,  0   // 4th arg is not used (not creating a file)

    mov x8, 56  // use system call to OPEN(56) file
    svc 0

    mov fd_r, w0 // save file descriptor


    // check if file was successfully opened
    cmp fd_r, -1
    b.gt openok

    ldr x0, =fmt1
    bl printf
    mov w0, -1 // return -1
    b exitmain

openok:
    mov i_r, 0
    b pretest

looptop:

    ldr x0, =fmt2
    ldr x1, [x29, 16] // x1 = num
    bl printf

pretest:
    
    // read(fd, &num, 8)
    mov w0, fd_r    // file descriptor of opened file
    add x1, x29, 16 // x1 = &num
    mov w2, 8       // we want to read 8 bytes
    mov x8, 63      // use svc to READ from file
    svc 0

    // bytes_read =  read(fd, &num, 8)
    mov bytes_read_r, x0    // use return value
    
    cmp bytes_read_r, 8
    b.eq looptop


breakloop:
    // close(fd)
    mov w0, fd_r // file descriptor of opened file
    mov x8, 57 // use svc to CLOSE file
    svc 0

    mov w0, 0 // return 0
exitmain:
    ldp x29, x30, [sp], dealloc
    ret
