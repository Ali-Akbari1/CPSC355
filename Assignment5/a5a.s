


/*
Ali Akbari 
UCID: 30171539
Assignment 5
Lecture 01
Leonard Manzara
Tutorial 02


 */




QUEUESIZE =         8                                                                           // Size of the queue                         
MODMASK =           0x7                                                                         // Modmask
FALSE =             0                                                                           // Set false to 0
TRUE =              1                                                                           // Set true to 1

                    .data                                                                       // Data section

                    .global queue                                                               // Set queue to a global variable
                    .global head                                                                // Set head to a global variable
                    .global tail                                                                // Set tail to a global variable

head:               .word -1                                                                    // Initialize head to -1
tail:               .word -1                                                                    // Initialize tail to -1
queue:              .skip QUEUESIZE*4                                                           // Make the queue with the size of QUEUESIZE

                                                                            // Macro for value
                                                                                // Macro for i
                                                                                // Macro for j
                                                                            // Macro for count
     


                    .text                                                                       // Text section

fmt:                .string "\nQueue overflow! Cannot enqueue into a full queue.\n"             // Queue overflow format string
fmt1:               .string "\nQueue underflow! Cannot dequeue from an empty queue.\n"          // Queue underflow format string
fmt2:               .string "\nEmpty queue\n"                                                   // Empty queue format string
fmt3:               .string "\nCurrent queue contents:\n"                                       // Current queue contents format string
fmt4:               .string " %d"                                                               // String to print queue contents
fmt5:               .string " <-- head of queue"                                                // String to show head of the queue
fmt6:               .string " <-- tail of queue"                                                // String to show tail of the queue
fmt7:               .string "\n"                                                                // Line break string



enqueueAlloc =      -(16 + QUEUESIZE*4) & -16                                                   // Memory allocation for enqueue
enqueueDealloc =    -enqueueAlloc                                                               // Deallocation of memory


                    .text                                                                       // Text section
                    .balign     4                                                               // Align Machine Instructions
                    .global     enqueue                                                         // Set enqueue global
enqueue:                                                                                        // enqueue function
    stp             x29,        x30,            [sp, enqueueAlloc]!                             // Memory allocation
    mov             x29,        sp                                                              // Saves the state

    mov             w22,    w0                                                              // Get value passed into enqueue and put it into value register



    bl              queueFull                                                                   // Call queuefull function

    cmp             w0,         TRUE                                                            // If queue is full
    b.eq            Overflow                                                                    // Branch to overflow

    bl              queueEmpty                                                                  // Call queueEmpty
    cmp             w0,         TRUE                                                            // Compare if queue is empty
    b.ne            elseEnqueue                                                                 // If it is not empty go to the else branch


    adrp            x19,        head                                                            // Address of head variable
    add             x19,        x19,            :lo12:head                                      // Base address of head
    ldr             w20,        [x19]                                                           // load base address to register w20                         
    mov             w20,        0                                                               // Move 0 into w20
    str             w20,        [x19]                                                           // Store w20 back into x19

    adrp            x19,        tail                                                            // Address of tail variable
    add             x19,        x19,            :lo12:tail                                      // Base address of tail
    ldr             w21,        [x19]                                                           // Load base address of tail to w21
    mov             w21,        0                                                               // Set w21 to 0
    str             w21,        [x19]                                                           // Store 0 back to x19
    b               endEnqueue                                                                  // Branch to endEnqueue


elseEnqueue:                                                                                    // elseEnqueue branch

    adrp            x19,        tail                                                            // Address of tail variable
    add             x19,        x19,            :lo12:tail                                      // Base address of tail
    ldr             w21,        [x19]                                                           // Load tail into w21

    add             w21,        w21,            1                                               // Add 1 to tail

    and             w21,        w21,            MODMASK                                         // AND tail with MODMASK
    str             w21,        [x19]                                                           // Store tail back into x19
    b               endEnqueue                                                                  // Branch to endEnqueue


endEnqueue:                                                                                     // endEnqueue branch

    adrp            x19,        tail                                                            // Address of tail variable
    add             x19,        x19,            :lo12:tail                                      // Base address of tail
    ldr             w21,        [x19]                                                           // Load tail into w21

    adrp            x28,        queue                                                           // Address of queue
    add             x28,        x28,            :lo12:queue                                     // Base address of queue

    str             w22,    [x28, w21, SXTW 2]                                              // Store value into the queue


    ldp             x29,        x30,            [sp],       enqueueDealloc                      // Deallocate memory
    ret                                                                                         // Return


Overflow:                                                                                       // Overflow branch

    adrp            x0,         fmt                                                             // Address of the string
    add             x0,         x0,             :lo12:fmt                                       // Address of the string
    bl              printf                                                                      // Call printf

    ldp             x29,        x30,            [sp],       enqueueDealloc                      // Deallocate memory
    ret                                                                                         // Return




UnderFlow:                                                                                      // Underflow Branch

    adrp            x0,         fmt1                                                            // Address of the string
    add             x0,         x0,             :lo12:fmt1                                      // Address of the string
    bl              printf                                                                      // Call printf
    mov	            w0,         -1				                                                // return -1


    ldp             x29,        x30,            [sp],       dealloc                             // Deallocate memory
    ret                                                                                         // Return



                    .balign     4                                                               // Align machine instructions
                    .global     dequeue                                                         // Set dequeue function global

value_size =        4                                                                           // Size of value
alloc =             -(16 + value_size) & -16                                                    // Allocate memory
dealloc =           -alloc                                                                      // Deallocate memory

dequeue:                                                                                        // Dequeue function

    stp             x29,        x30,            [sp, alloc]!                                    // Allocate memory
    mov             x29,        sp                                                              // Saves the state


    bl              queueEmpty                                                                  // Call queueEmpty
    cmp             w0,         TRUE                                                            // If queueEmpty is true

    b.eq            UnderFlow                                                                   // If queue is empty go to underflow branch

    adrp            x19,        head                                                            // Address of head variable
    add             x19,        x19,            :lo12:head                                      // Base address of head
    ldr             w20,        [x19]                                                           // Load head into w20

    adrp            x28,        queue                                                           // Address of queue
    add             x28,        x28,            :lo12:queue                                     // Base address of queue

    ldr	            w22,    [x28, w20, SXTW 2]                                              // value = queue[head]

    adrp            x19,        tail                                                            // Address of tail variable
    add             x19,        x19,            :lo12:tail                                      // Base address of tail
    ldr             w21,        [x19]                                                           // Load tail into w21

    cmp             w20,        w21                                                             // Compare head and tail

    b.ne            elseDequeue                                                                 // If they are not equal go to else branch
    mov             w20,        -1                                                              // Set head to -1
    adrp            x19,        head                                                            // Address of head variable
    add             x19,        x19,            :lo12:head                                      // Base address of head
    str             w20,        [x19]                                                           // Store -1 as head

    mov             w21,        -1                                                              // Set tail to -1
    adrp            x19,        tail                                                            // Address of tail variable
    add             x19,        x19,            :lo12:tail                                      // Base address of tail
    str             w21,        [x19]                                                           // Store -1 as tail
    b               endDequeue                                                                  // Branch to endDequeue


elseDequeue:                                                                                    // elseDequeue branch
    add             w20,        w20,            1                                               // Add 1 to head
    and             w20,        w20,            MODMASK                                         // AND head with MODMASK
    adrp            x19,        head                                                            // Address of head variable
    add             x19,        x19,            :lo12:head                                      // Base address of head
    str             w20,        [x19]                                                           // Store head into x19
    b               endDequeue                                                                  // Branch to endDequeue

endDequeue:                                                                                     // endDequeue branch
    mov             w0,         w22                                                         // Return value
    ldp             x29,        x30,            [sp],       dealloc                             // Deallocate memory
    ret                                                                                         // Return



                    .balign     4                                                               // Align Machine Instructions
queueFull:                                                                                      // queueFull function

    stp             x29,        x30,            [sp, -16]!                                      // Allocate memory
    mov             x29,        sp                                                              // Saves the state

    adrp            x19,        head                                                            // Address of head variable
    add             x19,        x19,            :lo12:head                                      // Base address of head
    ldr             w20,        [x19]                                                           // Load head into w20

    adrp            x19,        tail                                                            // Address of tail variable
    add             x19,        x19,            :lo12:tail                                      // Base address of tail
    ldr             w21,        [x19]                                                           // Load tail into w21

    add             w21,        w21,            1                                               // Add 1 to tail

    and             w21,        w21,            MODMASK                                         // AND tail with MODMASK

    cmp             w20,        w21                                                             // Compare tail and head

    b.ne            else                                                                        // If they are not equal branch to else
    mov             w0,         TRUE                                                            // If they are equal return TRUE 

    ldp             x29,        x30,            [sp],       16                                  // Deallocate memory
    ret                                                                                         // return


else:                                                                                           // Else branch

    mov             w0,         FALSE                                                           // Return FALSE

    ldp             x29,        x30,            [sp],       16                                  // Deallocate memory
    ret                                                                                         // Return

                    .balign     4                                                               // Align machine instructions
queueEmpty:                                                                                     // queueEmpty function

    stp             x29,        x30,            [sp, -16]!                                      // Allocate memory
    mov             x29,        sp                                                              // Saves the state

    adrp            x19,         head                                                           // Address of head variable
    add             x19,        x19,            :lo12:head                                      // Base address of head
    ldr             w20,        [x19]                                                           // Load head into w20

    cmp             w20,        -1                                                              // Compare head with -1

    b.ne            else                                                                        // If they are not equal branch to else

    mov             w0,         TRUE                                                            // Return TRUE

    ldp             x29,        x30,            [sp],       16                                  // Deallocate memory
    ret                                                                                         // Return

                    .balign     4                                                               // Align Machine Instructions
                    .global     display                                                         // Make display function global
display:                                                                                        // Display function
 
    stp             x29,        x30,            [sp, enqueueAlloc]!                             // Allocate memory
    mov             x29,        sp                                                              // Saves the state

    adrp            x19,        tail                                                            // Address of tail variable
    add             x19,        x19,            :lo12:tail                                      // Base address of tail
    ldr             w21,        [x19]                                                           // Load tail into w21

    adrp            x19,        head                                                            // Address of head variable
    add             x19,        x19,            :lo12:head                                      // Base address of head
    ldr             w20,        [x19]                                                           // Load head into w20


    bl              queueEmpty                                                                  // Call queueEmpty function

    cmp             w0,         TRUE                                                            // If queueEmpty is TRUE
    b.eq            displayEmptyQueue                                                           // Branch to displayEmptyQueue 



    sub             w26,    w21,            w20                                             // count = tail - head
    add             w26,    w26,        1                                               // count += 1
    cmp             w26,    0                                                               // Compare count with 0

    b.gt            next                                                                        // If it greater than 0 branch to next

    add             w26,    w26,        QUEUESIZE                                       // Add count and QUEUESIZE


next:                                                                                           // Next branch
    adrp            x0,         fmt3                                                            // Address of the string
    add             x0,         x0,             :lo12:fmt3                                      // Address of the string
    bl              printf                                                                      // Call printf


    adrp            x19,        head                                                            // Address of head variable
    add             x19,        x19,            :lo12:head                                      // Base address of head
    ldr             w20,        [x19]                                                           // Load head into w20

    mov             w25,        w20                                                             // i = head
    mov             w27,        0                                                               // j = 0



    b               test                                                                        // Branch to loop test

top:                                                                                            // Top of the loop



    adrp            x28,        queue                                                           // Address of queue
    add             x28,        x28,            :lo12:queue                                     // Base address of queue

    adrp            x0,         fmt4                                                            // Address of the string
    add             x0,         x0,             :lo12:fmt4                                      // Address of the string

    ldr             w1,         [x28, w25, SXTW 2]                                              // Print queue
    bl              printf                                                                      // Call printf 

    cmp             w25,        w20                                                             // Compare i with head
    b.ne            continue                                                                    // If they are not equal branch to continue

    adrp            x0,         fmt5                                                            // Address of the string
    add             x0,         x0,             :lo12:fmt5                                      // Address of the string
    bl              printf                                                                      // Call printf




continue:                                                                                       // Continue branch
    cmp             w25,        w21                                                             // Compare i and tail
    b.ne            after                                                                       // If they are not equal branch to after

    adrp            x0,         fmt6                                                            // Address of the string
    add             x0,         x0,             :lo12:fmt6                                      // Address of the string
    bl              printf                                                                      // Call printf

after:                                                                                          // After branch
    adrp            x0,         fmt7                                                            // Address of the string
    add             x0,         x0,             :lo12:fmt7                                      // Address of the string
    bl              printf                                                                      // Call printf

    add             w25,        w25,            1                                               // i+=1
    and             w25,        w25,            MODMASK                                         // AND i with MODMASK

    add             w27,        w27,            1                                               // Increment j by 1

test:                                                                                           // Loop test
    cmp             w27,        w26                                                         // Compare j and count

    b.lt            top                                                                         // if j < count go to the top of the loop


    ldp             x29,        x30,            [sp],       enqueueDealloc                      // Deallocate memory
    ret                                                                                         // Return



displayEmptyQueue:                                                                              // Display the empty queue

    adrp            x0,         fmt2                                                            // Address of the string
    add             x0,         x0,             :lo12:fmt2                                      // Address of the string
    bl              printf                                                                      // Call printf

    ldp             x29,        x30,            [sp],       enqueueDealloc                      // Deallocate memory
    ret                                                                                         // Return


