

/*
Ali Akbari 
UCID: 30171539
Assignment 2
Lecture 01
Leonard Manzara
Tutorial 02
 */



 // Macro for multiplier which is a 32 bit register
 // Macro for multiplicand which is a 32 bit register
 // Macro for product which is a 32 bit register
 // Macro for i value which is a 32 bit register
 // Macro for negative which is a 32 bit register
 // Macro for temporary bit which is a 32 bit register
 // Macro for temporary bit which is a 32 bit register

      
 // Macro for result which is a 64 bit register
 // Macro for temp1 which is a 64 bit register
 // Macro for temp2 which is a 64 bit register

// Define Format Strings
fmt:  .string "\nmultiplier = 0x%08x (%d) multiplicand = 0x%08x (%d)\n\n" // Creating format string and assigning its output
fmt1: .string "product = 0x%08x multiplier = 0x%08x\n\n"// Creating the second format string and assigning its output
fmt2: .string "64-bit result = 0x%016lx (%ld)\n\n"// Creating the third format string and assigning its output




      .balign 4 // Allign instructions
      .global main // Declare main function
main: stp     x29,                 x30,        [sp, -16]! // Saves the state
      mov     x29,                 sp                     // Saves the state

      mov     w20,      -16843010 // Move -16843010 into multiplicand register 
      mov     w19,        70 // Move 70 into multiplier register 
      mov     w21,           0 // Initialize product register at 0
      mov     w22,                 0 // Start the loop at 0


      adrp    x0,                  fmt                     // Address of the string
      add     x0,                  x0,          :lo12:fmt  // Address of the string
      mov     w1,                  w19                     // Output Multiplier
      mov     w2,                  w19                     // Output Multiplier
      mov     w3,                  w20                     // Output Multiplicand
      mov     w4,                  w20                     // Output Multiplicand
      bl      printf                                       // Call printf function


      cmp     w19,        0 // Compare multiplier with 0 to see if it is negative

      b.lt    next                   // If multiplier is less than 0 go to next branch
      mov     w23,          0 // Otherwise set negative to 0
      b       test                   // Go to the loop



next: // Next branch
      mov     w23,          1 // If multiplier is negative move 1 into it
      b       test                   // Go to the loop




top: // Top of the loop

      // Body of the Loop
      and     w24,               w19, 0x1 // Do multiplier AND 1 and store it in the bit register
      cmp     w24,               0                 // Compare the bit register with 0
      b.gt    if_branch                              // If the AND is equal to 1, go to the if branch



after: // After if statement while still in the loop
      asr     w19,        w19, 1          // Arithmetic shift right the multiplier by 1
      and     w25,              w21,    0x1        // Do product AND 1 and store it in the bit register
      cmp     w25,              0                        // Compare bit register with 0
      b.eq    else                                          // If the AND is equal to 1 go to the else branch
      orr     w19,        w19, 0x80000000 // If the AND is equal to 0 do multiplier orr
      b       after1                                        // Go to branch after1 which is after the if else statement



if_branch: // Inside if statement branch
      add     w21,           w21,    w20 // Add product and multiplicand and store in the product register
      b       after                                             // Go back to the loop



else: // Else branch of if statement
      and    w19,         w19, 0x7FFFFFFF // Do AND with multiplier and 0x7FFFFFFF
      b      after1                                         // Go to branch after1 which is after the if else statement




after1: // After1 branch which is after the if else statement
      asr    w21,            w21,    1 // Arithmetic shift right the product by 1




      add     w22,                 w22,          1 // Update loop counter i by 1 
test: cmp     w22,                 32              // Compare loop counter with 32, which means the loop goes until it hits 32
      b.lt    top                                  // if i is less than 32 go to the top of the loop and start it again

      cmp     w23,          0 // Compare negative with 0 which is false
      b.eq    after2                // If negative is false go to the after2 branch 
      sub     w21,           w21,    w20 // If negative is true subtract product by the multiplicand




after2: // After2 branch which is after the if statement of the negative
      adrp    x0,                  fmt1                      // Address of the string
      add     x0,                  x0,           :lo12:fmt1  // Address of the string
      mov     w1,                  w21                       // Output the product
      mov     w2,                  w19                       // Output the multiplier
      bl      printf                                         // Call printf function

      sxtw    x27,             w21                 // Extend size of register to 64 bits 
      and     x27,             x27,       0xFFFFFFFF // Do product AND temp1 register
      lsl     x27,             x27,       32         // Logical shift left temp1 by 32 bits

      sxtw    x28,             w19              // Extend size of register to 64 bits 
      and     x28,             x28,       0xFFFFFFFF // Do product AND temp2 register

      add     x26,            x27,       x28    // Add temp1 and temp2 to the result register


      adrp    x0,                  fmt2                       // Address of the string
      add     x0,                  x0,            :lo12:fmt2  // Address of the string
      mov     x1,                  x26                        // Output result
      mov     x2,                  x26                        // Output result
      bl      printf                                          // Call printf function



done: // Done branch which is the end of the program
      
      ldp     x29,                 x30,            [sp], 16 // Restore state of the program
      ret                                                   // Restore state of the program

