

/*
Ali Akbari 
UCID: 30171539
Assignment 4
Lecture 01
Leonard Manzara
Tutorial 02
 */



fmt:          .string "Initial cuboid values:\n"                                                                        // Creating format string and assigning its output
fmt1:         .string "Cuboid %s origin = (%d, %d)\n"                                                                   // Creating format string and assigning its output
fmt2:         .string "\tBase width = %d Base length = %d\n"                                                            // Creating format string and assigning its output
fmt3:         .string "\tHeight = %d\n"                                                                                 // Creating format string and assigning its output
fmt4:         .string "\tVolume = %d\n\n"                                                                               // Creating format string and assigning its output
fmt5:         .string "first"                                                                                           // Creating format string and assigning its output
fmt6:         .string "second"                                                                                          // Creating format string and assigning its output
fmt7:         .string "\nChanged cuboid values:\n"                                                                      // Creating format string and assigning its output





define(c_base_r, x19)                                                                                                   // Macro for base of struct c
define(result_r, w20)                                                                                                   // Macro for result

TRUE =                  1                                                                                               // Assign 1 to TRUE
FALSE =                 0                                                                                               // Assign 0 to FALSE


point_x =               0                                                                                               // Offset for point_x
point_y =               4                                                                                               // Offset for point_y
point_size =            8                                                                                               // Size of point which is two integers

dimension_width =       0                                                                                               // Offset for width
dimension_length =      4                                                                                               // Offset for length
dimension_size =        8                                                                                               // Size of dimension which is two integers


cuboid_origin =         0                                                                                               // Offset for origin
cuboid_base =           8                                                                                               // Offset for base
cuboid_height =         16                                                                                              // Offset for height
cuboid_volume =         20                                                                                              // Offset for volume

cuboid_size =           24                                                                                              // Size of struct cuboid

totalOffset =           cuboid_size*2                                                                                   // Total offset required for firstCuboid and secondCuboid


firstCuboid_s =         cuboid_size   + cuboid_size                                                                     // firstCuboid offset
secondCuboid_s =        firstCuboid_s + cuboid_size                                                                     // secondCuboid offset




alloc =                 -(16 + totalOffset) & -16                                                                       // Allocate memory
dealloc =               -alloc                                                                                          // Deallocate memory

fp                      .req x29                                                                                        // Register equates to rename fp
lr                      .req x30                                                                                        // Register equates to rename lr




        .balign 4                                                                                                       // Align machine instructions
        .global main                                                                                                    // Declare main function 
main:   stp             fp,             lr,             [sp, alloc]!                                                    // Allocate memory for main
        mov             fp,             sp                                                                              // Save the state
      

        add             x8,             fp,             firstCuboid_s                                                   // Base address for firstCuboid
        bl              newCuboid                                                                                       // Call subroutine newCuboid

        add             x8,             fp,             secondCuboid_s                                                  // Base address for secondCuboid
        bl              newCuboid                                                                                       // Call subroutine newCuboid

        adrp            x0,             fmt                                                                             // Address of the string
        add             x0,             x0,             :lo12:fmt                                                       // Address of the string
        bl              printf                                                                                          // Call printf function
        



        adrp            x0,             fmt5                                                                            // Address of the string
        add             x0,             x0,             :lo12:fmt5                                                      // Address of the string
        add             x8,             fp,             firstCuboid_s                                                   // Base address for firstCuboid
        bl              printCuboid                                                                                     // Call printCuboid


        adrp            x0,             fmt6                                                                            // Address of the string
        add             x0,             x0,             :lo12:fmt6                                                      // Address of the string
        add             x8,             fp,             secondCuboid_s                                                  // Base address for secondCuboid
        bl              printCuboid                                                                                     // Call printCuboid

        add             x0,             fp,             firstCuboid_s                                                   // Assign x0 to firstCuboid
        add             x1,             fp,             secondCuboid_s                                                  // Assign x1 to secondCuboid       
        bl              equalSize

        cmp             w0,             TRUE                                                                            // Compare if w0 register is equal to true
        b.ne            else                                                                                            // If they are not equal go to the else branch

        add             x8,             fp,             firstCuboid_s                                                   // Assign x8 to base address of firstCuboid          
        mov             w1,             3                                                                               // Assign w1 to 3
        mov             w2,             -6                                                                              // Assign w2 to -6
        bl              move                                                                                            // Call function move

        add             x7,             fp,             secondCuboid_s                                                  // Assign x7 to base address of secondCuboid
        mov             w1,             4                                                                               // Assign w1 to 4
        bl              scale                                                                                           // Call function scale


else:                                                                                                                   // Else branch
        adrp            x0,             fmt7                                                                            // Address of the string
        add             x0,             x0,             :lo12:fmt7                                                      // Address of the string
        bl              printf                                                                                          // Call printf function

        adrp            x0,             fmt5                                                                            // Address of the string
        add             x0,             x0,             :lo12:fmt5                                                      // Address of the string
        add             x8,             fp,             firstCuboid_s                                                   // Assign x8 to base address of firstCuboid  
        bl              printCuboid                                                                                     // Call function printCuboid


        adrp            x0,             fmt6                                                                            // Address of the string
        add             x0,             x0,             :lo12:fmt6                                                      // Address of the string
        add             x8,             fp,             secondCuboid_s                                                  // Assign x8 to base address of firstCuboid 
        bl              printCuboid                                                                                     // Call function printCuboid



        ldp             fp,             lr,             [sp],                   dealloc                                 // Deallocate memory
        ret                                                                                                             // Restore state of program

newCuboid:                                                                                                              // newCuboid function 
        stp             fp,             lr,             [sp, -(16 + cuboid_size)& -16]!                                 // Allocate Memory
        mov             fp,             sp                                                                              // Save the state

        mov             c_base_r,       x8                                                                              // Move x8 to macro c_base_r for readability

        mov             w20,            0                                                                               // Assign w20 to 0
        str             w20,            [c_base_r,      cuboid_origin +         point_x]                                // Store 0 to c.origin.x

        mov             w20,            0                                                                               // Assign w20 to 0
        str             w20,            [c_base_r,      cuboid_origin +         point_y]                                // Store 0 to c.origin.y

        mov             w21,            2                                                                               // Assign w21 to 2
        str             w21,            [c_base_r,      cuboid_base +           dimension_width]                        // Store 2 to c.base.width

        mov             w22,            2                                                                               // Assign w22 to 2
        str             w22,            [c_base_r,      cuboid_base +           dimension_length]                       // Store 2 to c.base.length

        mov             w28,            3                                                                               // Assign w28 to 3
        str             w28,            [c_base_r,      cuboid_height]                                                  // Store 3 to c.height

        ldr             w21,            [c_base_r,      cuboid_base +           dimension_width]                        // Load c.base.width to register w21
        ldr             w22,            [c_base_r,      cuboid_base +           dimension_length]                       // Load c.base.length to register w22
        ldr             w28,            [c_base_r,      cuboid_height]                                                  // Load c.height to register w28
        
        mov             w20,            0                                                                               // Assign 0 to w20
        mul             w20,            w21,            w22                                                             // Do width*length = w20
        mul             w20,            w28,            w20                                                             // Do w20 = width*length*height
        str             w20,            [c_base_r,      cuboid_volume]                                                  // Store the volume into c.volume

    

 
        ldp             fp,             lr,             [sp],                   -(-(16 + cuboid_size)& -16)             // Deallocate memory
        ret                                                                                                             // Return



move:                                                                                                                   // Move function
        stp             fp,             lr,             [sp, -16]!                                                      // Allocate memory
        mov             fp,             sp                                                                              // Saves the state

        ldr             w26,            [x8,            cuboid_origin +         point_x]                                // Load c.origin.x to register w26
        add             w26,            w26,            w1                                                              // Add w1 which is 3 to w26 
        str             w26,            [x8,            cuboid_origin +         point_x]                                // Store w26 to c.origin.x

        ldr             w26,            [x8,            cuboid_origin +         point_y]                                // Load c.origin.y to register w26
        add             w26,            w26,            w2                                                              // Add w2 which is -6 to w26 
        str             w26,            [x8,            cuboid_origin +         point_y]                                // Store w26 to c.origin.y

 

        ldp             fp,             lr,             [sp],                   16                                      // Deallocate memory
        ret                                                                                                             // Return



scale:                                                                                                                  // Scale function


        stp             fp,             lr,             [sp, -16]!                                                      // Allocate memory
        mov             fp,             sp                                                                              // Save the state

        ldr             w27,            [x7,            cuboid_base +           dimension_width]                        // Load c.base.width to register w27
        mul             w27,            w27,            w1                                                              // Multiply w1 which is 4 to w27
        str             w27,            [x7,            cuboid_base +           dimension_width]                        // Store w27 to c.base.width

        ldr             w25,            [x7,            cuboid_base +           dimension_length]                       // Load c.base.length to register w25
        mul             w25,            w25,            w1                                                              // Multiply w1 which is 4 to w25
        str             w25,            [x7,            cuboid_base +           dimension_length]                       // Store w25 to c.base.length

        ldr             w24,            [x7,            cuboid_height]                                                  // Load c.height to register w24
        mul             w24,            w24,            w1                                                              // Multiply w1 which is 4 to w24
        str             w24,            [x7,            cuboid_height]                                                  // Store w24 to c.height

        ldr             w23,            [x7,            cuboid_volume]                                                  // Load c.volume to register w23
        mul             w23,            w27,            w25                                                             // c.volume = c.base.width*c.base.length
        mul             w23,            w23,            w24                                                             // c.volume = c.base.width*c.base.length*c.height
        str             w23,            [x7,            cuboid_volume]                                                  // Store w23 to c.volume



        ldp             fp,             lr,             [sp],                   16                                      // Deallocate memory
        ret                                                                                                             // Return



printCuboid:                                                                                                            // printCuboid function
        stp             fp,             lr,             [sp, -16]!                                                      // Allocate Memory
        mov             fp,             sp                                                                              // Save the state
        
        mov             x19,            x8                                                                              // Move x8 to x19

        mov             x1,             x0                                                                              // Move x0, to x1
        adrp            x0,             fmt1                                                                            // Address of the string
        add             x0,             x0,             :lo12:fmt1                                                      // Address of the string
        ldr             w2,             [x19,           cuboid_origin +         point_x]                                // Load into w2 c.origin.x
        ldr             w3,             [x19,           cuboid_origin +         point_y]                                // Load into w3 c.origin.y
        bl              printf                                                                                          // Call printf function

        adrp            x0,             fmt2                                                                            // Address of the string
        add             x0,             x0,             :lo12:fmt2                                                      // Address of the string
        ldr             w1,             [x19,           cuboid_base +           dimension_width]                        // Load into w1 c.base.width
        ldr             w2,             [x19,           cuboid_base +           dimension_length]                       // Load into w2 c.base.length
        bl              printf                                                                                          // Call printf function

        adrp            x0,             fmt3                                                                            // Address of the string
        add             x0,             x0,             :lo12:fmt3                                                      // Address of the string
        ldr             w1,             [x19,           cuboid_height]                                                  // Load into w1 c.height
        bl              printf                                                                                          // Call printf function

        adrp            x0,             fmt4                                                                            // Address of the string
        add             x0,             x0,             :lo12:fmt4                                                      // Address of the string
        ldr             w1,             [x19,           cuboid_volume]                                                  // Load into w1 c.volume
        bl              printf                                                                                          // Call printf function



        ldp             fp,             lr,             [sp],                   16                                      // Deallocate memory
        ret                                                                                                             // Return


equalSize:                                                                                                              // equalSize function
        stp             fp,             lr,             [sp, -16]!
        mov             fp,             sp                                                                              // Saves the state

        mov             result_r,       FALSE                                                                           // Move FALSE into result_r macro 


        ldr             w10,            [x0,            cuboid_base +           dimension_width]                        // Load into w10 firstCuboid width
        ldr             w11,            [x1,            cuboid_base +           dimension_width]                        // Load into w11 secondCuboid width
        cmp             w10,            w11                                                                             // Compare firstCuboid and secondCuboid widths

        b.ne            next                                                                                            // If they are not equal branch to next

        ldr             w10,            [x0,            cuboid_base +           dimension_length]                       // Load into w10 firstCuboid length
        ldr             w11,            [x1,            cuboid_base +           dimension_length]                       // Load into w11 secondCuboid length
        cmp             w10,            w11                                                                             // Compare firstCuboid and secondCuboid lengths

        b.ne            next                                                                                            // If they are not equal branch to next

        ldr             w10,            [x0,            cuboid_height]                                                  // Load into w10 firstCuboid height
        ldr             w11,            [x1,            cuboid_height]                                                  // Load into w11 secondCuboid height

        cmp             w10,            w11                                                                             // Compare firstCuboid and secondCuboid heights
        b.ne            next                                                                                            // If they are not equal branch to next

        mov             result_r,       TRUE                                                                            // If the cuboids are not equal to each other move TRUE into result_r
        mov             w0,             result_r                                                                        // Move the value of result_r into w0


next:                                                                                                                   // Branch next
        mov             w0,             result_r                                                                        // Move the value of result_r into w0

        ldp             fp,             lr,             [sp],                   16                                      // Deallocate memory
        ret                                                                                                             // Return
