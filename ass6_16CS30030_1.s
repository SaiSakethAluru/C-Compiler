	.file	"test.c"
	.section	.rodata
.LC0:
	.string	"Passing pointers to function f!\n"
.LC1:
	.string	"Value passed to function: "
.LC2:
	.string	"\n"
.LC3:
	.string	"Value returned from function s is: "
.LC4:
	.string	"\n"
.LC5:
	.string	"Read an integer!!"
.LC6:
	.string	"\n"
.LC7:
	.string	"The integer that was read is:"
.LC8:
	.string	"\n"
	.text	
	.globl	f
	.type	f, @function
f: 
.LFB0:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$20, %rsp
	movq	%rdi, -20(%rbp)
	movl	-20(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	$2, %eax
	movl 	%eax, -28(%rbp)
	movl 	-24(%rbp), %eax
	movl 	-28(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -32(%rbp)
	movl	-32(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	-24(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	f, .-f
	.globl	main
	.type	main, @function
main: 
.LFB1:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$148, %rsp

	movl	$3, %eax
	movl 	%eax, -36(%rbp)
	movl	-36(%rbp), %eax
	movl 	%eax, -28(%rbp)
	movq 	$.LC0, -52(%rbp)
	movl 	-52(%rbp), %eax
	movq 	-52(%rbp), %rdi
	call	printStr
	movl	%eax, -56(%rbp)
	movq 	$.LC1, -60(%rbp)
	movl 	-60(%rbp), %eax
	movq 	-60(%rbp), %rdi
	call	printStr
	movl	%eax, -64(%rbp)
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdi
	call	printInt
	movl	%eax, -72(%rbp)
	movq 	$.LC2, -76(%rbp)
	movl 	-76(%rbp), %eax
	movq 	-76(%rbp), %rdi
	call	printStr
	movl	%eax, -80(%rbp)
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdi
	call	f
	movl	%eax, -88(%rbp)
	movl	-88(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movq 	$.LC3, -96(%rbp)
	movl 	-96(%rbp), %eax
	movq 	-96(%rbp), %rdi
	call	printStr
	movl	%eax, -100(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
	call	printInt
	movl	%eax, -104(%rbp)
	movq 	$.LC4, -108(%rbp)
	movl 	-108(%rbp), %eax
	movq 	-108(%rbp), %rdi
	call	printStr
	movl	%eax, -112(%rbp)
	movq 	$.LC5, -116(%rbp)
	movl 	-116(%rbp), %eax
	movq 	-116(%rbp), %rdi
	call	printStr
	movl	%eax, -120(%rbp)
	movq 	$.LC6, -124(%rbp)
	movl 	-124(%rbp), %eax
	movq 	-124(%rbp), %rdi
	call	printStr
	movl	%eax, -128(%rbp)
	leaq	-44(%rbp), %rax
	movq 	%rax, -136(%rbp)
	movl 	-136(%rbp), %eax
	movq 	-136(%rbp), %rdi
	call	readInt
	movl	%eax, -140(%rbp)
	movl	-140(%rbp), %eax
	movl 	%eax, -28(%rbp)
	movq 	$.LC7, -148(%rbp)
	movl 	-148(%rbp), %eax
	movq 	-148(%rbp), %rdi
	call	printStr
	movl	%eax, -152(%rbp)
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdi
	call	printInt
	movl	%eax, -156(%rbp)
	movq 	$.LC8, -160(%rbp)
	movl 	-160(%rbp), %eax
	movq 	-160(%rbp), %rdi
	call	printStr
	movl	%eax, -164(%rbp)
	movl	$0, %eax
	movl 	%eax, -168(%rbp)
	movl	-168(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident		"Compiled by 16CS30030"
	.section	.note.GNU-stack,"",@progbits
