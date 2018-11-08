	.file	"test.c"
	.globl	global_val
	.data
	.align 4
	.type	global_val, @object
	.size	global_val, 4
global_val:
	.long	4
	.globl	t00
	.data
	.align 4
	.type	t00, @object
	.size	t00, 4
t00:
	.long	4
	.section	.rodata
.LC0:
	.string	"\n"
.LC1:
	.string	"There was "
.LC2:
	.string	" pass.\n"
.LC3:
	.string	"There were "
.LC4:
	.string	" passes.\n"
	.text	
	movl	$4, %eax
	movl 	%eax, 0(%rbp)
	movl	0(%rbp), %eax
	movl 	%eax, 0(%rbp)
	.globl	sample_void_function
	.type	sample_void_function, @function
sample_void_function: 
.LFB0:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$24, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movl 	-20(%rbp), %eax
	movq 	-20(%rbp), %rdi
	call	printInt
	movl	%eax, -28(%rbp)
	movq 	$.LC0, -36(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
	call	printStr
	movl	%eax, -40(%rbp)
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	sample_void_function, .-sample_void_function
	.globl	sample_int_function
	.type	sample_int_function, @function
sample_int_function: 
.LFB1:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$28, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -12(%rbp)
	movl	$0, %eax
	movl 	%eax, -32(%rbp)
	movl	-32(%rbp), %eax
	movl 	%eax, -28(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jge .L4
	jmp .L5
	jmp .L5
.L4: 
	movl	-28(%rbp), %eax
	movl 	%eax, -36(%rbp)
	addl 	$1, -28(%rbp)
	jmp .L5
.L5: 
	movl	-28(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	sample_int_function, .-sample_int_function
	.globl	main
	.type	main, @function
main: 
.LFB2:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$140, %rsp

	movl	$10, %eax
	movl 	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	$6, %eax
	movl 	%eax, -60(%rbp)
	movl	$5, %eax
	movl 	%eax, -68(%rbp)
	movl	-68(%rbp), %eax
	movl 	%eax, -64(%rbp)
	movl	$10, %eax
	movl 	%eax, -80(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
movl 	-80(%rbp), %eax
	movq 	-80(%rbp), %rsi
	call	sample_void_function
	movl	%eax, -84(%rbp)
	movl	$10, %eax
	movl 	%eax, -92(%rbp)
	movl	$2, %eax
	movl 	%eax, -96(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
movl 	-92(%rbp), %eax
	movq 	-92(%rbp), %rsi
movl 	-96(%rbp), %eax
	movq 	-96(%rbp), %rdx
	call	sample_int_function
	movl	%eax, -100(%rbp)
	movl	-100(%rbp), %eax
	movl 	%eax, -32(%rbp)
	movl	$1, %eax
	movl 	%eax, -108(%rbp)
	movl	-32(%rbp), %eax
	cmpl	-108(%rbp), %eax
	je .L8
	jmp .L9
	jmp .L10
.L8: 
	movq 	$.LC1, -116(%rbp)
	movl 	-116(%rbp), %eax
	movq 	-116(%rbp), %rdi
	call	printStr
	movl	%eax, -120(%rbp)
	movl 	-32(%rbp), %eax
	movq 	-32(%rbp), %rdi
	call	printInt
	movl	%eax, -128(%rbp)
	movq 	$.LC2, -132(%rbp)
	movl 	-132(%rbp), %eax
	movq 	-132(%rbp), %rdi
	call	printStr
	movl	%eax, -136(%rbp)
	jmp .L10
.L9: 
	movq 	$.LC3, -140(%rbp)
	movl 	-140(%rbp), %eax
	movq 	-140(%rbp), %rdi
	call	printStr
	movl	%eax, -144(%rbp)
	movl 	-32(%rbp), %eax
	movq 	-32(%rbp), %rdi
	call	printInt
	movl	%eax, -148(%rbp)
	movq 	$.LC4, -152(%rbp)
	movl 	-152(%rbp), %eax
	movq 	-152(%rbp), %rdi
	call	printStr
	movl	%eax, -156(%rbp)
.L10: 
	movl	$0, %eax
	movl 	%eax, -160(%rbp)
	movl	-160(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.ident		"Compiled by 16CS30030"
	.section	.note.GNU-stack,"",@progbits
