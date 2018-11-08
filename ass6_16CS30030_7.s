	.file	"test.c"
	.section	.rodata
.LC0:
	.string	"------------SUM TEST FILE-------------"
.LC1:
	.string	"Here we find the sum of numbers upto a number"
.LC2:
	.string	"using ITERATIVE approach thus "
.LC3:
	.string	"testing different loops:"
.LC4:
	.string	"Enter the number :"
.LC5:
	.string	""
.LC6:
	.string	"Sum calculated using FOR LOOP :"
.LC7:
	.string	""
.LC8:
	.string	"Sum calculated using WHILE LOOP :"
.LC9:
	.string	""
.LC10:
	.string	"Sum calculated using DO-WHILE LOOP :"
.LC11:
	.string	""
	.text	
	.globl	main
	.type	main, @function
main: 
.LFB0:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$236, %rsp

	movq 	$.LC0, -40(%rbp)
	movl 	-40(%rbp), %eax
	movq 	-40(%rbp), %rdi
	call	printStr
	movl	%eax, -44(%rbp)
	movq 	$.LC1, -48(%rbp)
	movl 	-48(%rbp), %eax
	movq 	-48(%rbp), %rdi
	call	printStr
	movl	%eax, -52(%rbp)
	movq 	$.LC2, -56(%rbp)
	movl 	-56(%rbp), %eax
	movq 	-56(%rbp), %rdi
	call	printStr
	movl	%eax, -60(%rbp)
	movq 	$.LC3, -64(%rbp)
	movl 	-64(%rbp), %eax
	movq 	-64(%rbp), %rdi
	call	printStr
	movl	%eax, -68(%rbp)
	movq 	$.LC4, -72(%rbp)
	movl 	-72(%rbp), %eax
	movq 	-72(%rbp), %rdi
	call	printStr
	movl	%eax, -76(%rbp)
	leaq	-28(%rbp), %rax
	movq 	%rax, -84(%rbp)
	movl 	-84(%rbp), %eax
	movq 	-84(%rbp), %rdi
	call	readInt
	movl	%eax, -88(%rbp)
	movl	-88(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	$0, %eax
	movl 	%eax, -100(%rbp)
	movl	-100(%rbp), %eax
	movl 	%eax, -96(%rbp)
	movl	$0, %eax
	movl 	%eax, -108(%rbp)
	movl	-108(%rbp), %eax
	movl 	%eax, -104(%rbp)
	movl	$1, %eax
	movl 	%eax, -112(%rbp)
	movl	-112(%rbp), %eax
	movl 	%eax, -96(%rbp)
.L2: 
	movl	-96(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jle .L4
	jmp .L5
.L3: 
	movl	-96(%rbp), %eax
	movl 	%eax, -120(%rbp)
	addl 	$1, -96(%rbp)
	jmp .L2
.L4: 
	movl 	-104(%rbp), %eax
	movl 	-96(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -124(%rbp)
	movl	-124(%rbp), %eax
	movl 	%eax, -104(%rbp)
	jmp .L3
.L5: 
	movq 	$.LC5, -132(%rbp)
	movl 	-132(%rbp), %eax
	movq 	-132(%rbp), %rdi
	call	printStr
	movl	%eax, -136(%rbp)
	movq 	$.LC6, -140(%rbp)
	movl 	-140(%rbp), %eax
	movq 	-140(%rbp), %rdi
	call	printStr
	movl	%eax, -144(%rbp)
	movl 	-104(%rbp), %eax
	movq 	-104(%rbp), %rdi
	call	printInt
	movl	%eax, -152(%rbp)
	movl	$0, %eax
	movl 	%eax, -156(%rbp)
	movl	-156(%rbp), %eax
	movl 	%eax, -104(%rbp)
	movl	$1, %eax
	movl 	%eax, -164(%rbp)
	movl	-164(%rbp), %eax
	movl 	%eax, -96(%rbp)
	movq 	$.LC7, -172(%rbp)
	movl 	-172(%rbp), %eax
	movq 	-172(%rbp), %rdi
	call	printStr
	movl	%eax, -176(%rbp)
	movq 	$.LC8, -180(%rbp)
	movl 	-180(%rbp), %eax
	movq 	-180(%rbp), %rdi
	call	printStr
	movl	%eax, -184(%rbp)
.L6: 
	movl	-96(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jle .L7
	jmp .L8
.L7: 
	movl 	-104(%rbp), %eax
	movl 	-96(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -188(%rbp)
	movl	-188(%rbp), %eax
	movl 	%eax, -104(%rbp)
	movl	-96(%rbp), %eax
	movl 	%eax, -196(%rbp)
	addl 	$1, -96(%rbp)
	jmp .L6
.L8: 
	movl 	-104(%rbp), %eax
	movq 	-104(%rbp), %rdi
	call	printInt
	movl	%eax, -200(%rbp)
	movl	$0, %eax
	movl 	%eax, -204(%rbp)
	movl	-204(%rbp), %eax
	movl 	%eax, -104(%rbp)
	movl	$1, %eax
	movl 	%eax, -212(%rbp)
	movl	-212(%rbp), %eax
	movl 	%eax, -96(%rbp)
	movq 	$.LC9, -220(%rbp)
	movl 	-220(%rbp), %eax
	movq 	-220(%rbp), %rdi
	call	printStr
	movl	%eax, -224(%rbp)
	movq 	$.LC10, -228(%rbp)
	movl 	-228(%rbp), %eax
	movq 	-228(%rbp), %rdi
	call	printStr
	movl	%eax, -232(%rbp)
.L9: 
	movl 	-104(%rbp), %eax
	movl 	-96(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -236(%rbp)
	movl	-236(%rbp), %eax
	movl 	%eax, -104(%rbp)
	movl	-96(%rbp), %eax
	movl 	%eax, -244(%rbp)
	addl 	$1, -96(%rbp)
	movl	-96(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jle .L9
	jmp .L10
.L10: 
	movl 	-104(%rbp), %eax
	movq 	-104(%rbp), %rdi
	call	printInt
	movl	%eax, -248(%rbp)
	movq 	$.LC11, -252(%rbp)
	movl 	-252(%rbp), %eax
	movq 	-252(%rbp), %rdi
	call	printStr
	movl	%eax, -256(%rbp)
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident		"Compiled by 16CS30030"
	.section	.note.GNU-stack,"",@progbits
