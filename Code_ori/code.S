.org 0
# Provide program starting address to linker

.data
    data_0: .word 0b00000000000000000000000000000001
    data_1: .word 0b00000000000000000000000010000001
    data_2: .word 0b00000000000000001000000000000000
    data_3: .word 0b00000000100000000001010000000100
    data_4: .word 0b11111111111111111111111111111111
    nextline: .ascii "\n"
    .set str_size, .-nextline
    buffer: .byte 0
.text
.global main

main:
    jal ra, get_cycles
    mv t1, a0

    addi sp, sp, -20

    # push four pointers of test data onto the stack
    lw t0, data_0
    sw t0, 0(sp)
    lw t0, data_1
    sw t0, 4(sp)
    lw t0, data_2
    sw t0, 8(sp)
    lw t0, data_3
    sw t0, 12(sp)
    lw t0, data_4
    sw t0, 16(sp)
   
    addi s0, x0, 5    # s0 is the iteration times(5 test case)
    addi s1, x0, 0    # s1 is counter
    addi s2, sp, 0    # s2 initial at (0)sp
    
    li a5, 0x55555555
    li a6, 0x33333333
    li t1, 0x0f0f0f0f
loop:
    lw a0, 0(s2)        #load data into a0
    addi s2, s2, 4      # s2 move to next data
    addi s1, s1, 1      # counter++

clz:
    # OR the input value with itself shifted to the right by 1, 2, 4, 8, 16, and 16 bits (total 32).
    srli a1, a0, 1
    or a0, a0, a1

    srli a1, a0, 2
    or a0, a0, a1

    srli a1, a0, 4
    or a0, a0, a1

    srli a1, a0, 8
    or a0, a0, a1

    srli a1, a0, 16
    or a0, a0, a1

    srli a1, a0, 16
    srli a2, a1, 16
    or a0, a0, a2

    # Count ones (population count).
    srli a1, a0, 1 #rl
    and a4, a1, a5 #r
    sub a0, a0, a4 #l

    and a1, a0, a6 #rr
    srli a2, a0, 2 #ml
    and a3, a6, a2 #m
    add a0, a3, a1 #l

    srli a1, a0, 4 #rl
    add a0, a1, a0 #rl
    and a0, a0, t1 #l

    srli a1, a0, 8
    add a0,a1,a0

    srli a1, a0, 16
    add a0, a1, a0

    srli a1, a0, 16
    srli a2, a1, 16
    add a0, a0, a2

    # Return the number of zeros and count the priority
    andi a0, a0, 0x7f # andi a0, a0, 0x7f
    addi a1, x0, 1
    sub a0, a0, a1
det:
    addi a3, x0, 10
    addi a4, x0 , 0
    blt a0, a3, print
    jal ra, stp
# a0: number(0<=x<10)
print:
    addi a0, a0, 48  # convert to ascii
    la t0, buffer    
    sb a0, 0(t0)      

    li a0, 1
    la a1, buffer
    li a2, 1
    li a7, 64
    ecall

    la a2, str_size
    lw a2, 0(a2) 
    addi a0, x0, 1
    la a1, nextline
    li a7, 64
    ecall

    addi a3, x0, 0
    bne s1, s0, loop
    beq s1, s0, end
stp:
    addi a0, a0, -10
    addi a4, a4, 1
    bge a0, a3, stp

printn:
    # input & output
    # a0: divided
    # a4: quotient
    addi a4, a4, 48
    addi sp, sp, -4
    la t0, buffer    # 
    sb a4, 0(t0)     # save quotientto buffer  
    sw a0, 0(sp)     # divided save in stack
    addi a0, x0, 1
    la a1, buffer
    addi a2, x0, 1
    li a7, 64
    ecall
    lw a0, 0(sp)     # lw divided in stack
    addi sp, sp, 4
    addi a4, x0, 0   # reset quotient  
    ret

thstp:
    addi a0, a0, -1000
    addi a4, a4, 1
    bge a0, a3, thstp
    jal ra, printn    # a0 < 1000
    jal ra, h
hstp:
    addi a0, a0, -100
    addi a4, a4, 1
    bge a0, a3, hstp
    jal ra, printn
    jal ra, t
tstp:
    addi a0, a0, -10
    addi a4, a4, 1
    bge a0, a3, tstp
    jal ra, printn
    jal ra, o
end:
    jal ra, get_cycles
    sub a0, a0, t2

th:
    # a0: cycle num divided
    addi a3, x0, 1000  # a3 = divisor
    addi a4, x0, 0     # a4 = quotient
    bge a0, a3, thstp  # a0 >= 1000
    jal ra, printn
h:
    addi a3, x0, 100
    bge a0, a3, hstp
    jal ra, printn 
t:
    addi a3, x0, 10
    bge a0, a3, tstp
    jal ra, printn
o:  
    addi a0, a0, 48
    la t0, buffer
    sb a0, 0(t0)
    li a0, 1
    la a1, buffer
    addi a2, x0, 1
    li a7, 64
    ecall  
        

    li a7, 93    # Exit system call
    ecall
get_cycles:
    csrr a1, cycleh
    csrr a0, cycle
    csrr a2, cycleh
    bne a1, a2, get_cycles
    ret
