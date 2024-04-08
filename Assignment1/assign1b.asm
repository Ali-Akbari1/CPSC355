

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

      define(y_r, x20)// Macro for value of y
      define(a_r, x24)// Macro for current total
      define(x_r, x19)// Macro for value of x and also the loop counter
      define(c_r, x23)// Macro for constant value
      define(m_r, x21) // Macro for the current minimum


top:  // Start and top of the loop

      mul     a_r, x_r, x_r // Multiply current x value to get x^2 and store it in the current total
      mul     a_r, x_r, a_r // Multiply current x value to get x^3 and store it in the current total
      mov     c_r, 3 // Store 3 into the macro for constants
      mul     a_r, a_r, c_r // Multiply current total by 3 to get 3x^3
      mov     y_r, a_r // Move the current total to the Macro for the value of y

      mul     a_r, x_r, x_r // Multiply current x value to get x^2 and store it in the current total
      mov     c_r, 31 // Store 31 into the macro for constants
      madd    y_r, a_r, c_r, y_r // Multiply 31 and x^2 and add it to the value of y

      mov     c_r, -15 // Store -15 into the macro for constants
      madd    y_r, x_r, c_r, y_r // Multiply current x value and -15 to get -15x and add it to the value of y

      add     y_r, y_r, -127 // Add -127 to the value of y

      cmp     x_r, -10 // Compare current x value and -10
      b.eq    next // If x and -10 is equal go to branch next


      cmp     y_r, m_r // Compare current y value with current minimum 
      b.lt    next // If y value is less than current minimum go to branch next
      b       output // If Current minimum is not updated go to the output branch


next: // Branch next, which updates the current minimum
      mov     m_r, y_r // Update the current minimum, move value of y to current minimum
      b       output // Go to output branch







output: // Output branch which prints out the x value, y value, and current minimum
      adrp    x0, fmt // Address of the string     
      add     x0, x0, :lo12:fmt // Address of the string  
      mov     x1, x_r // x value
      mov     x2, y_r // y value
      mov     x3, m_r // Current Minimum
      bl      printf // Call printf function


      

      add     x_r, x_r, 1 // Update loop counter or x value by 1
test: cmp     x_r, 4 // Compare current x value or loop counter with 4
      b.le    top // If loop is less than or equal to 4 keep running the loop and go back to the top




      ldp     x29, x30, [sp], 16 // Restore state of the program
      ret // Restore state of the program
