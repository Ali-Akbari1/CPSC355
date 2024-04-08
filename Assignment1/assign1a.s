

/*
Ali Akbari 
UCID: 30171539
 */


fmt:  .string "x = %d\ny = %d\nCurrentMinimum = %d\n\n" // Creating format string and assigning its output



      .balign 4 // Allign instructions
      .global main // Declare main function
main: stp     x29, x30, [sp, -16]! // Saves the state
      mov     x29, sp // Saves the state
      
      

      // Start of the loop

      mov     x19, -10 //Start loop counter at -10
test: cmp     x19, 4 // Compare loop counter with 4
      b.gt    done // If loop counter is greater than 4 then the loop is finished and go to branch done
      mul     x24, x19, x19 // Multiply current x value to get x^2 and store it in register x24
      mul     x24, x19, x24 // // Multiply current x value to get x^3 and store it in register x24
      mov     x23, 3 // Move 3 into x23 register
      mul     x24, x24, x23 // Multiply x^3 with 3 and store it in x24 register, x24 register is current total
      mov     x20, x24    // Move what was in x24 register to x20 register, x20 register is overall total

      mul     x24, x19, x19 // Multiply current x value to get x^2 and store it in register x24
      mov     x23, 31 // Move 31 into x23 register
      mul     x24, x24, x23 // Multiply 31 with x^2 to get 31x^2 and store it in current total register
      add     x20, x24, x20 // Add current total to overall total and store it in overall total register

      mov     x23, -15 // Move -15 into x23 register
      mul     x24, x19, x23 // Multiply current x value by -15 and store it in current total register
      add     x20, x24, x20 // Add current total to overall total and store it in overall total register

      add     x20, x20, -127 // Add overall total by -127


      cmp     x19, -10 // Compare loop counter with -10
      b.eq    next // If loop counter is equal to -10 go to branch next


      cmp     x20, x21 // Compare overall total with current minimum
      b.lt    next // If overall total is less than current minimum go to branch next
      b       output // If we do not change current minimum go to the output branch

next: // Branch next, which updates the current minimum
      mov     x21, x20 // Move contents from overall total to current minimum
      b       output // Go to output branch


output: // Output branch which prints out the x value, y value, and current minimum
      adrp    x0, fmt // Address of the string
      add     x0, x0, :lo12:fmt  // Address of the string
      mov     x1, x19 // x value
      mov     x2, x20 // y value
      mov     x3, x21 // current minimum
      bl      printf // Call printf function


      

      add     x19, x19, 1 // Update loop counter by 1
      b       test // Go back to beginning of loop


done: // Done branch which is the end of the program
      
      ldp     x29, x30, [sp], 16 // Restore state of the program
      ret // Restore state of the program
