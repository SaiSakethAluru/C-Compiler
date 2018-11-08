	.file	"test.c"
	.comm	lo,4,4
	.comm	hi,4,4
	.comm	r,4,4
	.comm	i,4,4
	.comm	j,4,4
	.comm	t,4,4
	.comm	x,4,4
	.comm	h,4,4
	.comm	t00,4,4
	.comm	t01,4,4
	.comm	t02,4,4
	.text	
	.globl	quickSort
	.type	quickSort, @function
quickSort: 
.LFB0:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$40, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -20(%rbp)
	movq	%rdx, -16(%rbp)
	movl	-20(%rbp), %eax
	movl 	%eax, -28(%rbp)
	movl	-16(%rbp), %eax
	movl 	%eax, -32(%rbp)
	movl 	-20(%rbp), %eax
	movl 	-16(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -48(%rbp)
	movl	-48(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	-24(%rbp), %eax
	movl 	%eax, -24(%rbp)
	.ident		"Compiled by 16CS30030"
	.section	.note.GNU-stack,"",@progbits
