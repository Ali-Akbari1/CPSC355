/*
Ali Akbari 
UCID: 30171539


Change this so that comparison is at the top of loop
 */




fmt:  .string "x = %d\ny = %d\ncurrentminimum = %d\n\n"



      .balign 4
      .global main
main: stp     x29, x30, [sp, -16]! 
      mov     x29, sp
      
      

      mov     x19, -10 //start loop at -10
      b       test
top:  
      mul     x24, x19, x19
      mul     x24, x19, x24
      mov     x23, 3
      mul     x24, x24, x23 // 3x^3
      mov     x20, x24    // x20 running total y

      mul     x24, x19, x19
      mov     x23, 31
      mul     x24, x24, x23 // 31x^2
      add     x20, x24, x20

      mov     x23, -15
      mul     x24, x19, x23 // -15x
      add     x20, x24, x20

      add     x20, x20, -127 //-127


      cmp     x19, -10
      b.eq    next


      cmp     x20, x21
      b.lt    next
      b       output

next:
      mov     x21, x20
      b       output

 

      
      
      // first iteration set y to current minimum
      // after all calc compare y to current minimum if y < currentminimum then update currentminimum


output:
      // printf
      adrp    x0, fmt     
      add     x0, x0, :lo12:fmt  
      mov     x1, x19
      mov     x2, x20
      mov     x3, x21
      bl      printf


      

      add     x19, x19, 1
test: cmp     x19, 4
      b.le    top





      ldp     x29, x30, [sp], 16
      ret
