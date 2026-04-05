.section .rodata
input_fmt: .string "%d%c"

.globl main

.section .text
main: 


input_parser:

                                                # Saving entirely too much stuff
    addi sp, sp, -112           
    sd ra, 0(sp)            
    sd s0, 8(sp)            
    sd s1, 16(sp)           
    sd s2, 24(sp)           
    sd s3, 32(sp)           
    sd s4, 40(sp)           
    sd s5, 48(sp)           
    sd s6, 56(sp)           
    sd s7, 64(sp)           
    sd s8, 72(sp)           
    sd s9, 80(sp)           
    sd s10, 88(sp)          
    sd s11, 96(sp)          


    mv s0, a0                                   
    addi s0, s0, -1                             # s0 = argc-1 
    beqz s0, exit           
    mv s1, a1                                   # s1 = argv

    mv a0, s0           
    li a1, 4                                    # sizeof(int) == 4 (assumed)
    call calloc         
    mv s2, a0                                   # inputArray

    mv a0, s0           
    li a1, 4            
    call calloc         
    mv s3, a0                                   # resultArray

    mv a0, s0           
    li a1, 4            
    call calloc         
    mv s4, a0                                   # stack.stack

    mv s5, zero                                 # stack.size (denotes where the stack's next element will be inserted)

    mv s6, zero                                 # i = 0

    


initialisation_loop:            

    mv t0, s6                                   # t0 = i
    slli t0, t0, 2                              
    add t0, t0, s3                              # t0 = resultArray + i
    addi t1, zero, -1                           # t1 = -1
    sw t1, 0(t0)                                # resultArray[i] = -1

    mv s7, s6                                   # s7 = i
    slli s7, s7, 2          
    add s7, s7, s2                              # s7 = inputArray + i

    mv a0, s6                                   # a0 = i
    addi a0, a0, 1                              # a0 = i+1
    slli a0, a0, 3                              
    add a0, a0, s1                              # a0 = argv+i+i
    ld a0, 0(a0)                                # a0 = argv[i+1]

    

    call atoi           

    sw a0, 0(s7)                                # inputArray[i] = atoi(argv[i+1])

monotonic_while:

    beqz s5, pushStack                          # if stack.size == 0, directly pushStack

    mv t0, s5                                   # t0 = stack.size
    addi t0, t0, -1                             # t0 = stack.size - 1
    slli t0, t0, 2          
    add t0, t0, s4                              # t0 = stack.stack + stack.size - 1
    lw t0, 0(t0)                                # t0 = stack.stack[stack.size-1] := stack.top

    slli t1, t0, 2                              
    add t1, t1, s2                              # t1 = inputArray + stack.top
    lw t1, 0(t1)                                # t1 = inputArray[stack.top]

    mv t2, s6                                   # t2 = i
    slli t2, t2, 2          
    add t2, t2, s2                              # t2 = inputArray + i
    lw t2, 0(t2)                                # t2 = inputArray[i]

    bge t1, t2, pushStack                       # if stack.size != 0 but inputArray[stack.top] < inputArray[i] directly pushStack
    
    mv t3, t0                                   # t3 = stack.top
    slli t3, t3, 2          
    add t3, t3, s3                              # t3 = resultArray + stack.top
    sw s6, 0(t3)                                # resultArray[stack.top] = i

    addi s5, s5, -1                             # stack.size--

    j monotonic_while           

pushStack:          
    mv t0, s5                                   # t0 = stack.stack
    slli t0, t0, 2          
    add t0, t0, s4                              # t0 = stack.stack + stack.size
    sw s6, 0(t0)                                # stack.stack[stack.size] = i
    addi s5, s5, 1                              # stack.size++;

    addi s6, s6, 1                              # i++
    blt s6, s0, initialisation_loop             # return to loop if i < argc-1
    mv s6, zero                                 # set i = 0 for result printing (since loop breakout will have happened here)

result_printing:            
    la a0, input_fmt          # "%d%c"
    
    slli t0, s6, 2          
    add t0, t0, s3          
    lw a1, 0(t0)              # resultArray[i]
    
    addi t1, s6, 1            # t1 = i + 1
    li a2, 10                 # (Newline)
    beq t1, s0, do_printf     # If i + 1 == s0, jump to printf with '\n'
    li a2, 32                 # Else overwrite with space ' '

do_printf:
    call printf         
    
    addi s6, s6, 1            # i++
    blt s6, s0, result_printing
    mv a0, zero
    call fflush

pre_exit:
    mv a0, s4
    call free
    mv a0, s3
    call free
    mv a0, s2
    call free
    mv a0, zero

exit:
    ld ra, 0(sp)
    ld s0, 8(sp)
    ld s1, 16(sp)
    ld s2, 24(sp)
    ld s3, 32(sp)
    ld s4, 40(sp)
    ld s5, 48(sp)
    ld s6, 56(sp)
    ld s7, 64(sp)
    ld s8, 72(sp)
    ld s9, 80(sp)
    ld s10, 88(sp)
    ld s11, 96(sp)
    addi sp, sp, 112
    ret
