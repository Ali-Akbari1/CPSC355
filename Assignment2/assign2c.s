

/*
Ali Akbari 
UCID: 30171539
Lec #

Tut #
Prof name
tutorial TA name



Questions: 

How to format do i have to move print f stuff too

What am i supposed to print out 

How do i print out multiple different things 



m4 assign2a.asm > assign2a.s
 */


      
      
      
      
      
      
      

      
      
      

fmt:  .string "\nmultiplier = 0x%08x (%d) multiplicand = 0x%08x (%d)\n\n" // Creating format string and assigning its output
fmt1: .string "product = 0x%08x multiplier = 0x%08x\n\n"
fmt2: .string "64-bit result = 0x%016lx (%ld)\n\n"




      .balign 4 // Allign instructions
      .global main // Declare main function
main: stp     x29, x30, [sp, -16]! // Saves the state
      mov     x29, sp // Saves the state

      mov     w20, -252645136
      mov     w19,   -256
      mov     w21,      0
      mov     w22,            0


      adrp    x0, fmt // Address of the string
      add     x0, x0, :lo12:fmt  // Address of the string
      mov     w1, w19 // multiplier
      mov     w2, w19 // multiplier
      mov     w3, w20 // multiplicand
      mov     w4, w20 // multiplicand
      bl      printf // Call printf function

      cmp     w19,   0

      b.lt    next
      mov     w23,     0
      b       test


next:
      mov     w23,     1
      b       test


top:

      and     w24, w19, 0x1 
      cmp     w24, 0
      b.gt    if_branch1

after:

      asr     w19,        w19, 1
      and     w25, w21,   0x1
      cmp     w25, 0
      b.eq    else
      orr     w19,        w19, 0x80000000
      b       after1
      

if_branch1:
      add     w21, w21, w20
      b       after

else:
      and    w19, w19, 0x7FFFFFFF
      b      after1

after1:
      asr    w21,    w21,    1




      add     w22, w22, 1 // Update loop counter or x value by 1
test: cmp     w22, 32
      b.lt    top


      cmp     w23, 0
      b.eq    after2
      sub     w21,  w21, w20

after2: 

      adrp    x0, fmt1 // Address of the string
      add     x0, x0, :lo12:fmt1  // Address of the string
      mov     w1, w21 // product
      mov     w2, w19 // multiplier
      bl      printf // Call printf function

      sxtw    x27, w21
      and     x27, x27, 0xFFFFFFFF
      lsl     x27, x27,   32

      sxtw    x28, w19
      and     x28, x28, 0xFFFFFFFF

      add     x26, x27, x28


      adrp    x0, fmt2 // Address of the string
      add     x0, x0, :lo12:fmt2  // Address of the string
      mov     x1,x26 // result
      mov     x2,x26 // result
      bl      printf // Call printf function

done: // Done branch which is the end of the program
      
      ldp     x29, x30, [sp], 16 // Restore state of the program
      ret // Restore state of the program

