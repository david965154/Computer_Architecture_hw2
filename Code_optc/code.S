	.file	"code.c"
	.option nopic
	.attribute arch, "rv32i2p1_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	count_leading_zeros
	.type	count_leading_zeros, @function
count_leading_zeros:
	beq	a1,zero,.L10
.L6:
	li	a5,0
	li	a3,1
.L7:
	slli	a4,a1,31
	srli	a0,a0,1
	or	a0,a4,a0
	srli	a1,a1,1
	addi	a5,a5,1
	bne	a0,a3,.L7
	bne	a1,zero,.L7
	li	a0,64
	sub	a0,a0,a5
	slli	a0,a0,16
	srli	a0,a0,16
	ret
.L10:
	li	a5,1
	bgtu	a0,a5,.L6
	xori	a0,a0,1
	seqz	a5,a0
	li	a0,64
	sub	a0,a0,a5
	slli	a0,a0,16
	srli	a0,a0,16
	ret
	.size	count_leading_zeros, .-count_leading_zeros
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.string	"%d\n"
	.align	2
.LC1:
	.string	"%lld\n"
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	sw	s1,4(sp)
	sw	s2,0(sp)
	lui	s1,%hi(.LC0)
	call	get_cycles
	mv	s0,a0
	mv	s2,a1
	addi	a0,s1,%lo(.LC0)
	li	a1,2
	call	printf
	li	a1,3
	addi	a0,s1,%lo(.LC0)
	call	printf
	li	a1,4
	addi	a0,s1,%lo(.LC0)
	call	printf
	li	a1,5
	addi	a0,s1,%lo(.LC0)
	call	printf
	call	get_cycles
	sub	a2,a0,s0
	sgtu	a0,a2,a0
	sub	a3,a1,s2
	sub	a3,a3,a0
	lui	a0,%hi(.LC1)
	addi	a0,a0,%lo(.LC1)
	call	printf
	lw	ra,12(sp)
	lw	s0,8(sp)
	lw	s1,4(sp)
	lw	s2,0(sp)
	li	a0,0
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.ident	"GCC: (xPack GNU RISC-V Embedded GCC arm64) 13.2.0"
