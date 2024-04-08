

/*
Ali Akbari 
UCID: 30171539
Assignment 5
Lecture 01
Leonard Manzara
Tutorial 02


 */



 // Format Strings

                .text
fmt:            .string "%s %d%s is %s\n"
fmt1:           .string "usage: a5b mm dd\n"

jan:            .string "January"
feb:            .string "February"
mar:            .string "March"
apr:            .string "April"
may:            .string "May"
jun:            .string "June"
jul:            .string "July"
aug:            .string "August"
sep:            .string "September"
oct:            .string "October"
nov:            .string "November"
dec:            .string "December"

spr:            .string "Spring"
sum:            .string "Summer"
fal:            .string "Fall"
win:            .string "Winter" 


st:             .string "st"
nd:             .string "nd"
rd:             .string "rd"
th:             .string "th"

                .data                                                                           // Data Section
                .balign 8
month_m:        .dword jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
season_m:       .dword spr, sum, fal, win
suffix_m:       .dword st, nd, rd, th





// Macros
define(i_r, w19)
define(argc_r, w20)
define(argv_r, x21)
define(month_r, w22)
define(day_r, w23)
define(suffix_r, w26)
define(season_r, w28)


                .text                                                                           // Text Section
                .balign 4                                                                       // Align Machine Instructions
                .global main                                                                    // Make main global
main:                                                                                           // Main function
    stp         x29,            x30, [sp, -16]!                                                 // Allocate memory
    mov         x29,            sp                                                              // Save the state

    mov         argc_r,         w0                                                              // Move number of arguments to argc_r
    mov         argv_r,         x1                                                              // Move x1 to argv_r
    mov         i_r,            1                                                               // Set i to 1 

    cmp         argc_r,         3                                                               // Compare number of arguments with 3
    b.ne        error                                                                           // If the number of arguments is not 3 branch to error 

    ldr         x0,             [argv_r, i_r, SXTW 3]                                           // Load into x0 first argument
    bl          atoi                                                                            // Change to Integer
    mov         month_r,        w0                                                              // Move it into month_r

    mov         i_r,            2                                                               //  Set i to 2
    ldr         x0,             [argv_r, i_r, SXTW 3]                                           // Load into x0 second argument
    bl          atoi                                                                            // Change to integer
    mov         day_r,          w0                                                              // Put it into day_r


    // Month and day Range error checking
    cmp         month_r,        1                                                               // Compare the month and 1
    b.lt        error                                                                           // If month is less than 1 branch to error
    cmp         month_r,        12                                                              // Compare month and 12
    b.gt        error                                                                           // If month is greater than 12 branch to error

    cmp         day_r,          1                                                               // Comapre day and 1
    b.lt        error                                                                           // If the day is less than 1 branch to error
    cmp         day_r,          31                                                              // Compare day and 31 
    b.gt        error                                                                           // If the day is greater than 31 Branch to error


    cmp         month_r,        1                                                               // Compare month and 1
    b.gt        notJan                                                                          // If it is greater than 1 branch to notJan

    b           winter                                                                          // If it is January branch to winter

notJan:                                                                                         // notJan branch
    cmp         month_r,        2                                                               // Check if it february
    b.gt        notFeb                                                                          // If it is greater than 2 branch to notFeb

    b           winter                                                                          // If it is february then branch to winter


notFeb:                                                                                         // notFeb branch
    cmp         month_r,        3                                                               // Check if it is March
    b.gt        notMar                                                                          // If its not March branch to notMar

    cmp         day_r,          20                                                              // If it is march check the day to see what season to branch to
    b.le        winter                                                                          // If it is less than 20 branch to winter
    b           spring                                                                          // If it is greater than 20 branch to spring



notMar:                                                                                         // notMar branch
    cmp         month_r,        4                                                               // Check if it is April
    b.gt        notApr                                                                          // If its not april branch to notApr

    b           spring                                                                          // If it is April branch to spring 

notApr:                                                                                         // notApr branch
    cmp         month_r,        5                                                               // Check if its may
    b.gt        notMay                                                                          // If its not may branch to notMay

    b           spring                                                                          // If it is may branch to spring


notMay:                                                                                         // notMay branch
    cmp         month_r,        6                                                               // Check if its June
    b.gt        notJune                                                                         // If it is not June branch to notJune

    cmp         day_r,          20                                                              // If it is June check what day it is to see what season to branch to
    b.le        spring                                                                          // If it is less than or equal to 20 branch to spring
    b           summer                                                                          // If it is greater than 20 branch to summer

notJune:                                                                                        // notJune branch
    cmp         month_r,        7                                                               // Check if its July
    b.gt        notJuly                                                                         // If it is not July branch to notJuly
    
    b           summer                                                                          // Branch to summer if it is July



notJuly:                                                                                        // notJuly branch
    cmp         month_r,        8                                                               // Check if its August
    b.gt        notAugust                                                                       // If it is not August branch to notAugust

    b           summer                                                                          // If it is August branch to summer


notAugust:                                                                                      // notAugust branch
    cmp         month_r,        9                                                               // Check if its September
    b.gt        notSeptember                                                                    // If it is not September branch to notSeptember

    cmp         day_r,          20                                                              // If it is September Check what day it is to see what season to branch to
    b.le        summer                                                                          // If it is less than or equal to 20 branch to summer 
    b           fall                                                                            // If it is greater than 20 branch to fall

notSeptember:                                                                                   // notSeptember branch
    cmp         month_r,        10                                                              // Check if its October
    b.gt        notOctober                                                                      // If it is not October branch to notOctober
    b           fall                                                                            // If it is october branch to fall


notOctober:                                                                                     // notOctober branch
    cmp         month_r,        11                                                              // Check if its november
    b.gt        isDecember                                                                      // If it is not november branch to isDecember

    b           fall                                                                            // If it is november branch to fall


isDecember:                                                                                     // It is december
    cmp         day_r,          20                                                              // Check what day it is in December
    b.le        fall                                                                            // If it is less than or equal to 20 branch to fall
    b           winter                                                                          // Otherwise branch to winter


winter:                                                                                         // Winter branch

    mov         season_r,       3                                                               // Move season_r to 3 because winter is index 3
    b           suffix                                                                          // Branch to suffix


spring:                                                                                         // Spring branch

    mov         season_r,       0                                                               // Move season_r to 0 because spring is index 0
    b           suffix                                                                          // Branch to suffix


summer:                                                                                         // Summer branch

    mov         season_r,       1                                                               // Move season_r to 1 because summer is index 1
    b           suffix                                                                          // Branch to suffix


fall:                                                                                           // Fall branch

    mov         season_r,       2                                                               // Move season_r to 2 because fall is index 2
    b           suffix                                                                          // Branch to suffix


suffix:                                                                                         // Suffix branch
    cmp         day_r,          1                                                               // Check if it is day 1  
    b.eq        firstSuff                                                                       // If it is branch to firstSuff "st"
    cmp         day_r,          2                                                               // Check if it is day 2
    b.eq        secondSuff                                                                      // If it is branch to SecondSuff "nd"
    cmp         day_r,          3                                                               // Check if it is day 3       
    b.eq        thirdSuff                                                                       // If it is branch to thirdSuff "rd"
    cmp         day_r,          21                                                              // Check if it is day 21
    b.eq        firstSuff                                                                       // If it is branch to firstSuff "st"
    cmp         day_r,          22                                                              // Check if it is day 22
    b.eq        secondSuff                                                                      // If it is branch to SecondSuff "nd"
    cmp         day_r,          23                                                              // Check if it is day 23
    b.eq        thirdSuff                                                                       // If it is branch to thirdSuff "rd"
    cmp         day_r,          31                                                              // Check if it is day 31
    b.eq        firstSuff                                                                       // If it is branch to firstSuff "st"
    b           fourthSuff                                                                      // Otherwise branch to fourth Suffix "th"

firstSuff:                                                                                      // firstSuff branch "st"

    mov         suffix_r,       0                                                               // Move suffix_r to 0 because st is in index 0
    b           output                                                                          // Branch to output


secondSuff:                                                                                     // SecondSuff branch "nd"

    mov         suffix_r,       1                                                               // Move suffix_r to 1 because st is in index 1
    b           output                                                                          // Branch to output

thirdSuff:                                                                                      // ThirdSuff branch "rd"

    mov         suffix_r,       2                                                               // Move suffix_r to 2 because st is in index 2
    b           output                                                                          // Branch to output

fourthSuff:                                                                                     // FourthSuff branch "th"

    mov         suffix_r,       3                                                               // Move suffix_r to 3 because st is in index 3

    b           output                                                                          // Branch to output

output:                                                                                         // Output branch to print everything

    adrp        x0,             fmt                                                             // Address of string
    add         x0,             x0,         :lo12:fmt                                           // Address of string


    adrp        x24,            month_m                                                         // Address of month
    add         x24,            x24,        :lo12:month_m                                       // Base address of month
    sub         month_r,        month_r,    1                                                   // Subtract 1 from month
    ldr         x1,             [x24, month_r, SXTW 3]                                          // First argument as month

    mov         w2,             day_r                                                           // Load second argument as day

    adrp        x25,            suffix_m                                                        // Address of suffix
    add         x25,            x25,        :lo12:suffix_m                                      // Base address of suffix

    ldr         x3,             [x25, suffix_r, SXTW 3]                                         // Third argument as suffix

    adrp        x27,            season_m                                                        // Address of season
    add         x27,            x27,        :lo12:season_m                                      // Base address of season

    ldr         x4,             [x27, season_r, SXTW 3]                                         // fourth argument as season
    bl          printf                                                                          // Call printf


    b           done                                                                            // Branch to done

error:                                                                                          // Error branch
    adrp        x0,             fmt1                                                            // Address of string
    add         x0,             x0,         :lo12:fmt1                                          // Address of string
    bl          printf                                                                          // Call printf
    
    b           done                                                                            // Branch to done

done:                                                                                           // Done branch

    ldp         x29,            x30,        [sp],           16                                  // Deallocate memory
    ret                                                                                         // Return
