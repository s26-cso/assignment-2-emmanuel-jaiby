.globl make_node
.globl insert
.globl get
.globl getAtMost



make_node:
                                    # Make space on stack
    addi sp, sp, -24
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)

                                    # Move val to s0, in preparation for malloc
    mv s0, a0

                                    # Call malloc
    addi a0, zero, 1
    addi a1, zero, 24
    call calloc
    mv s1, a0                       # Pointer to struct

                                    # Struct assignments
    sw s0, 0(s1)                    # newNode->val = val
    sw zero, 4(s1)                  # padding
    sd zero, 8(s1)                  # newNode->left = NULL;
    sd zero, 16(s1)                 # newNode->left = NULL;

                                    # Deallocate stack space
    ld s1, 16(sp)
    ld s0, 8(sp)
    ld ra, 0(sp)
    addi sp, sp, 24
    ret

insert:
                                    # Make space on stack
    addi sp, sp, -56
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)
    sd s2, 24(sp)
    sd s3, 32(sp)
    sd s4, 40(sp)
    sd s5, 48(sp)

    mv s0, a0                       # Now holds root
    mv s1, a1                       # Now holds val
    mv s2, s0                       # Now holds newRoot (we will iterate over this)
    beqz s2, insert_root_is_null
    lw s3, 0(s2)                    # newRoot->val
    ld s4, 8(s2)                    # newRoot->left
    ld s5, 16(s2)                   # newRoot->right


insert_while:                       # an infinite while loop

    slt t0, s1, s3                  # sets t0 to 1 if val < newRoot->val
    sub t1, s1, s3                  
    seqz t1, t1                     # sets t1 to 1 if val == newRoot->val
    or t0, t0, t1                   # sets t0 to 1 if val <= newRoot->val

    seqz t1, s4                     # sets t1 to 1 if newRoot->left == NULL
    and t2, t1, t0                  # t2 = val <= newRoot->val && newRoot->left == NULL
    bnez t2, insert_left    

    snez t1, s4                     # sets t1 to 1 if newRoot->left != NULL
    and t2, t1, t0                  # t2 = val <= newRoot->val && newRoot->left != NULL
    beqz t2, insert_not_left        # if t2 == 0 here, then val </= newRoot->val

    mv s2, s4                       # Updates newRoot = newRoot->left
    lw s3, 0(s2)
    ld s4, 8(s2)                
    ld s5, 16(s2)

    j insert_while

insert_root_is_null:
    mv a0, s1
    call make_node
    ld ra, 0(sp)    
    ld s0, 8(sp)    
    ld s1, 16(sp)   
    ld s2, 24(sp)   
    ld s3, 32(sp)   
    ld s4, 40(sp)   
    ld s5, 48(sp)   
    addi sp, sp, 56 
    ret 
insert_not_left:
    beqz s5, insert_right           # moves to insert_right if newRoot->right == NULL

    mv s2, s5                       # Updates newRoot = newRoot->right
    lw s3, 0(s2)    
    ld s4, 8(s2)                    
    ld s5, 16(s2)   

    beq zero, zero, insert_while    


insert_left:    
    mv a0, s1                       # set up val for make_node
    call make_node                  # make_node(val)
    sd a0, 8(s2)                    # newRoot->left = make_node(val)

    ld ra, 0(sp)    

    mv a0, s0                       # set up root for return value

    ld s0, 8(sp)    
    ld s1, 16(sp)   
    ld s2, 24(sp)   
    ld s3, 32(sp)   
    ld s4, 40(sp)   
    ld s5, 48(sp)   
    addi sp, sp, 56 

    ret 

insert_right:   
    mv a0, s1                       # set up val for make_node
    call make_node                  # make_node(val)
    sd a0, 16(s2)                   # newRoot->right = make_node(val)

    ld ra, 0(sp)    

    mv a0, s0                       # set up root for return value

    ld s0, 8(sp)    
    ld s1, 16(sp)   
    ld s2, 24(sp)   
    ld s3, 32(sp)   
    ld s4, 40(sp)   
    ld s5, 48(sp)   
    addi sp, sp, 56 
    ret 

get:    
                                    # Make space on stack
    addi sp, sp, -56    
    sd ra, 0(sp)    
    sd s0, 8(sp)    
    sd s1, 16(sp)   
    sd s2, 24(sp)   
    sd s3, 32(sp)   
    sd s4, 40(sp)   
    sd s5, 48(sp)   

    mv s0, a0                       # Now holds root
    mv s1, a1                       # Now holds val
    mv s2, s0                       # Now holds newRoot (we will iterate over this)
    beqz s2, get_root_is_null
    lw s3, 0(s2)                    # newRoot->val
    ld s4, 8(s2)                    # newRoot->left
    ld s5, 16(s2)                   # newRoot->right


get_while:                          # An infinite while loop
    sub t0, s1, s3                  # sets t0 to 1 if val == newRoot->val
    beqz t0, get_found                  

    slt t0, s1, s3                  # sets t0 to 1 if val < newRoot->val
    seqz t1, s4                     # sets t1 to 1 if newRoot->left == NULL
    and t1, t0, t1                  # sets t1 to 1 if val < newRoot->val && newRoot->left == NULL
    bnez t1, get_not_found          # if (val < newRoot->val && newRoot->left == NULL) return NULL;
    beqz t0, get_not_left           # if (val > newRoot->val)

    mv s2, s4                       # newRoot = newRoot->left
    lw s3, 0(s2)    
    ld s4, 8(s2)    
    ld s5, 16(s2)   

    j get_while    

get_root_is_null:
    mv a0, zero
    ld ra, 0(sp)    
    ld s0, 8(sp)    
    ld s1, 16(sp)   
    ld s2, 24(sp)   
    ld s3, 32(sp)   
    ld s4, 40(sp)   
    ld s5, 48(sp)   
    addi sp, sp, 56 
    ret 


get_not_left:   
    beqz s5, get_not_found  

    mv s2, s5   
    lw s3, 0(s2)    
    ld s4, 8(s2)    
    ld s5, 16(s2)   

    j get_while    

get_found:  
    mv a0, s2                       # setting up newRoot for return value
    ld ra, 0(sp)    
    ld s0, 8(sp)    
    ld s1, 16(sp)   
    ld s2, 24(sp)   
    ld s3, 32(sp)   
    ld s4, 40(sp)   
    ld s5, 48(sp)   
    addi sp, sp, 56 
    ret 


get_not_found:  
    ld ra, 0(sp)    
    ld s0, 8(sp)    
    ld s1, 16(sp)   
    ld s2, 24(sp)   
    ld s3, 32(sp)   
    ld s4, 40(sp)   
    ld s5, 48(sp)   
    addi sp, sp, 56 
    mv a0, zero                     # setting up NULL for return value
    ret 

getAtMost:  
                                    # Make space on stack
    addi sp, sp, -64    
    sd ra, 0(sp)    
    sd s0, 8(sp)    
    sd s1, 16(sp)   
    sd s2, 24(sp)   
    sd s3, 32(sp)   
    sd s4, 40(sp)   
    sd s5, 48(sp)   
    sd s6, 56(sp)   

    mv s0, a1                       # Now holds root
    mv s1, a0                       # Now holds val
    mv s2, s0                       # Now holds newRoot (we will iterate over this)
    beqz s2, getAtMost_root_is_null
    lw s3, 0(s2)                    # newRoot->val
    ld s4, 8(s2)                    # newRoot->left
    ld s5, 16(s2)                   # newRoot->right
    mv s6, zero 
    addi s6, s6, -1                 # bestSoFar = -1


getAtMost_while:
    beqz s2, getAtMost_not_found
    beq s1, s3, getAtMost_found     # if val == newRoot->val return val;
    blt s1, s3, getAtMost_greater   # if val < newRoot->val move left
    
    mv s6, s3                       # if val > newRoot->val bestSoFar = newRoot->val

    mv s2, s5                       # newRoot = newRoot->right
    beqz s2, getAtMost_not_found
    lw s3, 0(s2)
    ld s4, 8(s2)
    ld s5, 16(s2)

    j getAtMost_while

getAtMost_root_is_null:
    li a0, -1
    ld ra, 0(sp)
    ld s0, 8(sp)
    ld s1, 16(sp)
    ld s2, 24(sp)
    ld s3, 32(sp)
    ld s4, 40(sp)
    ld s5, 48(sp)
    ld s6, 56(sp)
    addi sp, sp, 64
    ret

getAtMost_not_found:
    mv a0, s6
    ld ra, 0(sp)
    ld s0, 8(sp)
    ld s1, 16(sp)
    ld s2, 24(sp)
    ld s3, 32(sp)
    ld s4, 40(sp)
    ld s5, 48(sp)
    ld s6, 56(sp)
    addi sp, sp, 64
    ret

getAtMost_found:
    mv a0, s1
    ld ra, 0(sp)
    ld s0, 8(sp)
    ld s1, 16(sp)
    ld s2, 24(sp)
    ld s3, 32(sp)
    ld s4, 40(sp)
    ld s5, 48(sp)
    ld s6, 56(sp)
    addi sp, sp, 64
    ret

getAtMost_greater:
    mv s2, s4
    beqz s2, getAtMost_not_found
    lw s3, 0(s2)
    ld s4, 8(s2)
    ld s5, 16(s2)
    j getAtMost_while
