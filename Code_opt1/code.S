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
    li a5, 0
loop:
    lw a1, 0(s2)        #load data into a0

    addi a2, x0, 2
    addi a0, x0, 0

    addi s2, s2, 4      # s2 move to next data
    addi s1, s1, 1      # counter++
    blt a1, a5, ulimitcase
    blt a1, a2, print

clz:
    srli a1, a1, 1
    addi a0, a0, 1
    bge a1, a2, clz
    jal det
ulimitcase:
    li a0, 31
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
    sub a0, a0, t1

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
