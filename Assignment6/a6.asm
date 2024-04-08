
/*

Ali Akbari 
UCID: 30171539
Assignment 6
Lecture 01
Leonard Manzara
Tutorial 02

 */
                .data                                       // Data Section

limit:          .double 0r1.0e-10                           // Limit of the series

                .text                                       // Text section
pn:             .string "input.bin"                         // Path name of the file
fmt1:           .string "Can't open file. Aborting\n"       // String for not being able to open the file
output:         .string "%13.10f\t%16.10f\t%13.10f\n"       // Format of the output
header:         .string "Input:\t\t\te^x:\t\t\te^-x:\n"     // Header of output columns

fd_r            .req    w19                                 // Register equates for file descriptor
bytes_read_r    .req    x21                                 // Register equates for amount of bytes read


alloc =         -(16 + 8) & -16                             // Allocation of memory
dealloc =       -alloc                                      // Deallocation
buf_s =         16                                          // Buffer size

define(buf_base_r, x22)                                     // Macro for buffer base address



    .balign                 4                               // Align Machine Instructions
    .global                 main                            // Set main global
main:                                                       // Main function
    stp     x29,            x30,    [sp, alloc]!            // Allocate memory
    mov     x29,            sp                              // Save the state

    adrp    x0,             header                          // Address of header
    add     x0,             x0,     :lo12:header            // Base address of header
    bl      printf                                          // Call printf

    mov     w0,             -100                            // Use current working directory
    ldr     x1,             =pn                             // Load register x1 with the path name
    mov     w2,             0                               // Open file in read mode
    mov     w3,             0                               // 4th arg is not used 


    mov     x8,             56                              // Use system call to open file
    svc     0                                               // Call system

    mov     fd_r,           w0                              // Save the file descriptor

    cmp     fd_r,           -1                              // Error check for opening file
    b.gt    openok                                          // branch to openok if we could open the file

    ldr     x0,             =fmt1                           // Load x0 with fmt1 string
    bl      printf                                          // Call printf
    mov     w0,             -1                              // return -1
    b       exitmain                                        // Exit 

openok:                                                     // Openok branch
    add     buf_base_r,     x29,    buf_s                   // Get base address of buffer

readfile:                                                   // Read file branch
    
    mov     w0,             fd_r                            // File descriptor of opened file
    mov     x1,             buf_base_r                      // 2nd argument is buffer
    mov     w2,             8                               // We want to read 8 bytes
    mov     x8,             63                              // Use svc to READ from file
    svc     0                                               // Call system

    mov     bytes_read_r,   x0                              // Return value is number of bytes read
    
    cmp     bytes_read_r,   8                               // Compare number of bytes read with 8 
    b.ne    closefile                                       // If they are not equal branch to closefile

    ldr     d0,             [buf_base_r]                    // First argument for e^x
    bl      calc                                            // Call calculate function
    fmov    d1,             d0                              // Get the value returned
    
    ldr     d0,             [buf_base_r]                    // First argument for e^-x
    fneg    d0,             d0                              // Negate x value
    bl      calc                                            // Call calculate function
    fmov    d2,             d0                              // Get return value in d2

    adrp    x0,             output                          // Page address of output
    add     x0,             x0,     :lo12:output            // Base address of output
    ldr     d0,             [buf_base_r]                    // Load d0 with buffer
    bl      printf                                          // Call printf function

    b       readfile                                        // Branch to the top



closefile:                                                  // Close file branch
    mov     w0,             fd_r                            // File descriptor of opened file
    mov     x8,             57                              // Use svc to CLOSE file
    svc     0                                               // Call system

    mov     w0,             0                               // Return 0
    b       exitmain                                        // Exit


    .balign 4                                               // Align Machine instructions
calc:                                                       // Calculate function
    stp     x29,            x30,    [sp, -16]!              // Allocate memory
    mov     x29,            sp                              // Save the state

    fmov    d23,            d0                              // Numerator
    fmov    d24,            1.0                             // First power = 1
    fmov    d19,            d24                             // Factor
    fmov    d27,            1.0                             // Increment
    fmov    d22,            1.0                             // Accumulator start with one to add one



    fdiv    d28,            d23,    d19                     // Numerator / Denominator
    fadd    d22,            d22,    d28                     // Add accumulator

top:                                                        // Top of the loop

    fmul    d23,            d23,    d0                      // Numerator*x
    fadd    d24,            d24,    d27                     // Add 1 to the power

    fmul    d19,            d19,    d24                     // Factor = factor*power

    fdiv    d28,            d23,    d19                     // Numerator / Factor

    fadd    d22,            d22,    d28                     // Add to the accumulator

    fabs    d28,            d28                             // Get the absolute value of the accumulator

    adrp    x25,            limit                           // Page address of the limit
    add     x25,            x25,    :lo12:limit             // Base address of the limit
    ldr     d3,             [x25]                           // Load it into d3
    fcmp    d28,            d3                              // Compare limit with the value from the loop
    b.ge    top                                             // If it is greater than or equal to branch to the top

    fmov    d0,             d22                             // Return the accumulator

    ldp     x29,            x30,    [sp], 16                // Deallocate memory
    ret                                                     // Return


exitmain:                                                   // Exit main branch
    ldp     x29,            x30,    [sp], dealloc           // Deallocate memory
    ret                                                     // Return
 
