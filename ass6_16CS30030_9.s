	.file	"test.c"
	.section	.rodata
.LC0:
	.string	""
.LC1:
	.string	"----------Here we test GCD :---------"
.LC2:
	.string	"Enter 2 numbers for finding their gcd recursively"
.LC3:
	.string	"Entered num = "
.LC4:
	.string	"Entered num = "
.LC5:
	.string	"The gcd of the 2 numbers you entered is :"
.LC6:
	.string	""
	.text	
	.globl	gcd
	.type	gcd, @function
gcd: 
.LFB0:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$68, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-16(%rbp), %eax
	je .L2
	jmp .L3
	jmp .L7
.L2: 
	movl	-20(%rbp), %eax
	movl 	%eax, -36(%rbp)
	jmp .L7
.L3: 
	movl	-20(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jg .L4
	jmp .L5
	jmp .L6
.L4: 
	movl 	-20(%rbp), %eax
	movl 	-16(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -44(%rbp)
	movl	-44(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	-16(%rbp), %eax
	movl 	%eax, -28(%rbp)
	jmp .L6
.L5: 
	movl 	-16(%rbp), %eax
	movl 	-20(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -56(%rbp)
	movl	-56(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	-20(%rbp), %eax
	movl 	%eax, -28(%rbp)
.L6: 
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rsi
	call	gcd
	movl	%eax, -72(%rbp)
	movl	-72(%rbp), %eax
	movl 	%eax, -32(%rbp)
	movl	-32(%rbp), %eax
	movl 	%eax, -36(%rbp)
.L7: 
	movl	-36(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	gcd, .-gcd
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
	subq	$136, %rsp

	movq 	$.LC0, -48(%rbp)
	movl 	-48(%rbp), %eax
	movq 	-48(%rbp), %rdi
	call	printStr
	movl	%eax, -52(%rbp)
	movq 	$.LC1, -56(%rbp)
	movl 	-56(%rbp), %eax
	movq 	-56(%rbp), %rdi
	call	printStr
	movl	%eax, -60(%rbp)
	movq 	$.LC2, -64(%rbp)
	movl 	-64(%rbp), %eax
	movq 	-64(%rbp), %rdi
	call	printStr
	movl	%eax, -68(%rbp)
	leaq	-32(%rbp), %rax
	movq 	%rax, -76(%rbp)
	movl 	-76(%rbp), %eax
	movq 	-76(%rbp), %rdi
	call	readInt
	movl	%eax, -80(%rbp)
	movl	-80(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movq 	$.LC3, -88(%rbp)
	movl 	-88(%rbp), %eax
	movq 	-88(%rbp), %rdi
	call	printStr
	movl	%eax, -92(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
	call	printInt
	movl	%eax, -100(%rbp)
	leaq	-32(%rbp), %rax
	movq 	%rax, -104(%rbp)
	movl 	-104(%rbp), %eax
	movq 	-104(%rbp), %rdi
	call	readInt
	movl	%eax, -108(%rbp)
	movl	-108(%rbp), %eax
	movl 	%eax, -28(%rbp)
	movq 	$.LC4, -116(%rbp)
	movl 	-116(%rbp), %eax
	movq 	-116(%rbp), %rdi
	call	printStr
	movl	%eax, -120(%rbp)
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdi
	call	printInt
	movl	%eax, -124(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rsi
	call	gcd
	movl	%eax, -132(%rbp)
	movl	-132(%rbp), %eax
	movl 	%eax, -36(%rbp)
	movq 	$.LC5, -140(%rbp)
	movl 	-140(%rbp), %eax
	movq 	-140(%rbp), %rdi
	call	printStr
	movl	%eax, -144(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
	call	printInt
	movl	%eax, -148(%rbp)
	movq 	$.LC6, -152(%rbp)
	movl 	-152(%rbp), %eax
	movq 	-152(%rbp), %rdi
	call	printStr
	movl	%eax, -156(%rbp)
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident		"Compiled by 16CS30030"
	.section	.note.GNU-stack,"",@progbits
