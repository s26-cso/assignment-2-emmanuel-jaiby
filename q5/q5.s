.section .rodata
    filename: .string "input.txt"
    is_palindrome: .string "Yes\n"
    not_palindrome: .string "No\n"

.section .text
.globl main

main:

startup:

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

    li a0, -100                             # AT_FDCWD (current working directory)
    la a1, filename
    li a2, 0                                # O_RDONLY (open read only)
    li a7, 56                               # sys_openat (syscall 56)
    ecall
    mv s0, a0                               # holds file descriptor

    li a1, 0                                # offset
    li a2, 2                                # SEEK_END
    li a7, 62                               # sys_lseek (syscall 62)
    ecall
    mv s1, a1                               # holds total length

    li s2, 0                                # left
    addi s3, s1, -1                         # right

    addi sp, sp, -16

palindrome_loop:
    bge s2, s3, yes_exit

    mv a0, s0                               # fd
    mv a1, s2                               # left
    li a2, 0                                # SEEK_SET
    li a7, 62                               # sys_lseek
    ecall

    mv a0, s0                               # fd
    mv a1, sp                               # memory location to read to
    li a2, 1                                # 1 byte
    li a7, 63                               # sys_read
    ecall
    lbu s4, 0(sp)

    mv a0, s0                               # fd
    mv a1, s3                               # right
    li a2, 0                                # SEEK_SET
    li a7, 62                               # sys_lseek
    ecall

    mv a0, s0                               # fd
    mv a1, sp                               # memory location to read to
    li a2, 1                                # 1 byte
    li a7, 63                               # sys_read
    ecall
    lbu s5, 0(sp)
    
    bne s4, s5, no_exit

    addi s2, s2, 1
    addi s3, s3, -1
    j palindrome_loop

yes_exit:
    la a1, is_palindrome
    li a2, 3                                # number of characters 
    j print_exit

no_exit:
    la a1, not_palindrome
    li a2, 4                                # number of characters
    j print_exit

print_exit:
    li a0, 1                                # stdout
    li a7, 64                               # sys_write
    ecall

    add sp, sp, 16

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
    
    li a0, 0
    li a7, 93
    ecall
