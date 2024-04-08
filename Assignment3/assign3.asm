

/*
Ali Akbari 
UCID: 30171539
Assignment 3
Lecture 01
Leonard Manzara
Tutorial 02
 */


// Define Format Strings
fmt:         .string "\nv[%d]: %d\n"                              // Creating format string and assigning its output
fmt1:        .string "\nSorted Array:\n"                          // Creating format string and assigning its output
i_size =     4                                                    // Size of i, which is 4 bytes because it is an integer
j_size =     4                                                    // Size of j, which is 4 bytes because it is an integer
size =       50                                                   // Size of the array
t_s =        0                                                    // Size of temp which is also an integer of 4 bytes

array_size = size * 4                                             // Size of the array times 4 for each integer

alloc =      -(16 + i_size + j_size + array_size) & -16           // Allocate memory
dealloc =    -alloc                                               // Negative allocation for when deallocating memory at the end

j_s =        16                                                   // Offset for j
i_s =        j_s + j_size                                         // Offset for i
array_s =    i_s + i_size                                         // Offset for array

fp           .req x29                                             // Register equates to rename fp
lr           .req x30                                             // Register equates to rename lr


             .balign 4                                            // Allign instructions
             .global main                                         // Declare main function
main:        stp          fp,                     lr, [sp, alloc]!// Allocate memory
             mov          fp,                     sp              // Save the state


             mov          w19,                    0               // Initialize i to 0
             str          w19, [fp, i_s]                          // Store i in the stack
             mov          w20,                    0               // Initialize j to 0
             str          w20, [fp, j_s]                          // Store j in the stack
             mov          w21,                    0               // Initialize temp to 0
             str          w21, [fp, t_s]                          // Store temp in the stack

             b            test                                    // Start of first for loop go to branch test
top:                                                              // Top of first for loop

             bl           rand                                    // Call random function
             and          w22, w0,                0xFF            // And the result of rand with 256
             ldr          w19, [fp, i_s]                          // Load i into register w19
             add          x23, fp,                array_s         // Calculate array base address
             str          w22, [x23, w19, SXTW 2]                 // Store the random number into the array and then to the stack

             adrp         x0,  fmt                                // Address of the string
             add          x0,  x0,                :lo12:fmt       // Address of the string
             ldr          w1,  [fp, i_s]                          // Output i
             add          x23, fp,                array_s         // Calculate array base address
             ldr          w2,  [x23, w19, SXTW 2]                 // Output the array
             bl           printf                                  // Call print f function


             add          w19,  w19,              1               // Increment i by 1
             str          w19,  [fp, i_s]                         // Store i into the stack

test:        cmp          w19,  size                              // Compare if i is less than 50

             b.lt         top                                     // If i is less than 50 keep the loop running and go to the top


             mov          w19,  1                                 // Move 1 into w19 register
             str          w19,  [fp, i_s]                         // Store it into the stack as i
             
             b            outerloop_test                          // Branch to outer loop test which is the test for i being less than the size
             
firstloop:                                                        // First for loop

             ldr          w19,  [fp, i_s]                         // Load i into w19
             add          x23,  fp, array_s                       // Calculate array base address
             ldr          w24,  [x23, w19, SXTW 2]                // Load v[i] into w24 
             str          w24,  [fp, t_s]                         // Store value of v[i] in temp

             ldr          w19,  [fp, i_s]                         // Load value of i into w19
             str          w19,  [fp, j_s]                         // Store value of i into j into the stack


b inner_looptest                                                  // Branch to the inner for loop test

inner_loop:                                                       // inner loop body


             ldr          w20,  [fp, j_s]                         // Load j into w20
             sub          w26,  w20,              1               // Subtract j-1
             add          x23,  fp,               array_s         // Calculate array base address
             ldr          w25,  [x23, w26, SXTW 2]                // Load value of v[j-1]
             add          w26,  w26,              1               // Add 1 to j-1
             str          w25,  [x23, w26, SXTW 2]                // Store value of v[j-1]

             ldr          w20,  [fp, j_s]                         // Load j into w20
             sub          w20,  w20,              1               // Decrement j by 1 at the end of the loop
             str          w20,  [fp, j_s]                         // Store j into the stack



inner_looptest:                                                   // Inner loop test 

             ldr          w20,  [fp, j_s]                         // Load j into w20
             cmp          w20,  0                                 // Compare j and 0

             b.le         outer_loop                              // If j <= 0, exit inner loop


             sub          w26,  w20,              1               // Calculate j-1
             add          x23,  fp,               array_s         // Calculate array base address
             ldr          w25,  [x23, w26, SXTW 2]                // Load value of v[j-1]

             ldr          w24,  [fp, t_s]                         // Load value of temp
             cmp          w24,  w25                               // Compare  v[j-1] and temp

             b.ge         outer_loop                              // If temp >= v[j-1], exit inner loop
             b            inner_loop                              // If you pass both checks go back to the top of the inner loop



outer_loop:                                                       //Outer loop body to calculate v[j] = temp



             ldr          w21,  [fp, t_s]                         // Load temp to w21

             ldr          w20,   [fp, j_s]                        // Load j to w20
             add          x23,   fp,               array_s        // Calculate array base address
             str          w21,   [x23, w20, SXTW 2]               // Store value of temp into v[j] and put it in the stack


             ldr          w19,   [fp, i_s]                        // Load value of i into w19
             add          w19,   w19,              1              // increment i by 1
             str          w19,   [fp, i_s]                        // Store i back into the stack


outerloop_test:                                                   // Outer loop test to check if i is bigger than the size
             ldr          w19,   [fp, i_s]                        // Load i to w19
             cmp          w19,   size                             // Compare i with 50
             b.lt         firstloop                               // If i is less than 50 keep the loop going



             adrp         x0,    fmt1                             // Address of the string
             add          x0,    x0,              :lo12:fmt1      // Address of the string
             bl           printf                                  // Call print f function to print "Sorted array"


             mov          w19,   0                                // Move 0 to w19
             str          w19,   [fp, i_s]                        // Store i as 0 in stack


             b            test2                                   // Branch to test 2 
top1:                                                             // Top of final for loop

             ldr          w19,   [fp, i_s]                        // Load i into w19 register

             adrp         x0,    fmt                              // Address of the string
             add          x0,    x0,               :lo12:fmt      // Address of the string
             ldr          w1,    [fp, i_s]                        // First argument i
             add          x23,   fp,               array_s        // Calculate array base address
             ldr          w2,    [x23, w19, SXTW 2]               // Second argument v[i]
             bl           printf                                  // Call print f function


             add          w19,   w19,              1              // Increment i by 1
             str          w19,   [fp, i_s]                        // Store i back into the stack

test2:                                                            // Test for the for loop
             cmp          w19,   size                             // Check if i is less than size of array

             b.lt         top1                                    // If i is less than array keep loop going and go to the top of the loop

             ldp          fp,    lr,              [sp], dealloc   // Deallocate memory
             ret                                                  // Restore state of program
