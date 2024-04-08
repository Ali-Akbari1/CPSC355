

/*
Ali Akbari 
UCID: 30171539
 */


fmt:  .string "x = %d\ny = %d\nCurrent Minimum = %d\n\n" // Creating format string and assigning its output



      .balign 4 // Allign Instructions
      .global main // Declare Main function
main: stp     x29, x30, [sp, -16]! // Saves the state
      mov     x29, sp // Saves the state


      mov     x19, -10 //Start loop at -10
      b       test // Go to branch test

      // Macro for value of y
      // Macro for current total
      // Macro for value of x and also the loop counter
      // Macro for constant value
      // Macro for the current minimum


top:  // Start and top of the loop

      mul     x24, x19, x19 // Multiply current x value to get x^2 and store it in the current total
      mul     x24, x19, x24 // Multiply current x value to get x^3 and store it in the current total
      mov     x23, 3 // Store 3 into the macro for constants
      mul     x24, x24, x23 // Multiply current total by 3 to get 3x^3
      mov     x20, x24 // Move the current total to the Macro for the value of y

      mul     x24, x19, x19 // Multiply current x value to get x^2 and store it in the current total
      mov     x23, 31 // Store 31 into the macro for constants
      madd    x20, x24, x23, x20 // Multiply 31 and x^2 and add it to the value of y

      mov     x23, -15 // Store -15 into the macro for constants
      madd    x20, x19, x23, x20 // Multiply current x value and -15 to get -15x and add it to the value of y

      add     x20, x20, -127 // Add -127 to the value of y

      cmp     x19, -10 // Compare current x value and -10
      b.eq    next // If x and -10 is equal go to branch next


      cmp     x20, x21 // Compare current y value with current minimum 
      b.lt    next // If y value is less than current minimum go to branch next
      b       output // If Current minimum is not updated go to the output branch


next: // Branch next, which updates the current minimum
      mov     x21, x20 // Update the current minimum, move value of y to current minimum
      b       output // Go to output branch







output: // Output branch which prints out the x value, y value, and current minimum
      adrp    x0, fmt // Address of the string     
      add     x0, x0, :lo12:fmt // Address of the string  
      mov     x1, x19 // x value
      mov     x2, x20 // y value
      mov     x3, x21 // Current Minimum
      bl      printf // Call printf function


      

      add     x19, x19, 1 // Update loop counter or x value by 1
test: cmp     x19, 4 // Compare current x value or loop counter with 4
      b.le    top // If loop is less than or equal to 4 keep running the loop and go back to the top




      ldp     x29, x30, [sp], 16 // Restore state of the program
      ret // Restore state of the program
