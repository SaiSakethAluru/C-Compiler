	.file	"test.c"
	.section	.rodata
.LC0:
	.string	""
.LC1:
	.string	"--------------BUBBLE SORT TEST FILE---------------"
.LC2:
	.string	"Here we sort an array of elements"
.LC3:
	.string	"using ITERATIVE approach:"
.LC4:
	.string	"Enter 5 integers of the array :"
.LC5:
	.string	"got "
.LC6:
	.string	"\n"
.LC7:
	.string	"The array fed is :"
.LC8:
	.string	""
.LC9:
	.string	"The array after sorting is :"
.LC10:
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
	subq	$348, %rsp

	movl	$5, %eax
	movl 	%eax, -48(%rbp)
	movq 	$.LC0, -76(%rbp)
	movl 	-76(%rbp), %eax
	movq 	-76(%rbp), %rdi
	call	printStr
	movl	%eax, -80(%rbp)
	movq 	$.LC1, -84(%rbp)
	movl 	-84(%rbp), %eax
	movq 	-84(%rbp), %rdi
	call	printStr
	movl	%eax, -88(%rbp)
	movq 	$.LC2, -92(%rbp)
	movl 	-92(%rbp), %eax
	movq 	-92(%rbp), %rdi
	call	printStr
	movl	%eax, -96(%rbp)
	movq 	$.LC3, -100(%rbp)
	movl 	-100(%rbp), %eax
	movq 	-100(%rbp), %rdi
	call	printStr
	movl	%eax, -104(%rbp)
	movq 	$.LC4, -108(%rbp)
	movl 	-108(%rbp), %eax
	movq 	-108(%rbp), %rdi
	call	printStr
	movl	%eax, -112(%rbp)
	movl	$0, %eax
	movl 	%eax, -116(%rbp)
	movl	-116(%rbp), %eax
	movl 	%eax, -52(%rbp)
.L2: 
	movl	$5, %eax
	movl 	%eax, -124(%rbp)
	movl	-52(%rbp), %eax
	cmpl	-124(%rbp), %eax
	jl .L4
	jmp .L5
.L3: 
	movl	-52(%rbp), %eax
	movl 	%eax, -128(%rbp)
	addl 	$1, -52(%rbp)
	jmp .L2
.L4: 
	leaq	-56(%rbp), %rax
	movq 	%rax, -136(%rbp)
	movl 	-136(%rbp), %eax
	movq 	-136(%rbp), %rdi
	call	readInt
	movl	%eax, -140(%rbp)
	movl	-140(%rbp), %eax
	movl 	%eax, -64(%rbp)
	movq 	$.LC5, -148(%rbp)
	movl 	-148(%rbp), %eax
	movq 	-148(%rbp), %rdi
	call	printStr
	movl	%eax, -152(%rbp)
	movl 	-64(%rbp), %eax
	movq 	-64(%rbp), %rdi
	call	printInt
	movl	%eax, -160(%rbp)
	movq 	$.LC6, -164(%rbp)
	movl 	-164(%rbp), %eax
	movq 	-164(%rbp), %rdi
	call	printStr
	movl	%eax, -168(%rbp)
	movl 	-52(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -172(%rbp)
	movq	-172(%rbp), %rax
	movq	%rdx, -28(%rbp)
	jmp .L3
.L5: 
	movq 	$.LC7, -180(%rbp)
	movl 	-180(%rbp), %eax
	movq 	-180(%rbp), %rdi
	call	printStr
	movl	%eax, -184(%rbp)
	movl	$0, %eax
	movl 	%eax, -188(%rbp)
	movl	-188(%rbp), %eax
	movl 	%eax, -52(%rbp)
.L6: 
	movl	$5, %eax
	movl 	%eax, -196(%rbp)
	movl	-52(%rbp), %eax
	cmpl	-196(%rbp), %eax
	jl .L8
	jmp .L9
.L7: 
	movl	-52(%rbp), %eax
	movl 	%eax, -200(%rbp)
	addl 	$1, -52(%rbp)
	jmp .L6
.L8: 
	movl 	-52(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -204(%rbp)
	movq	-204(%rbp), %rax
	movq 	%rax, -208(%rbp)
	movl	-208(%rbp), %eax
	movl 	%eax, -64(%rbp)
	movl 	-64(%rbp), %eax
	movq 	-64(%rbp), %rdi
	call	printInt
	movl	%eax, -216(%rbp)
	movq 	$.LC8, -220(%rbp)
	movl 	-220(%rbp), %eax
	movq 	-220(%rbp), %rdi
	call	printStr
	movl	%eax, -224(%rbp)
	jmp .L7
.L9: 
	movl	$0, %eax
	movl 	%eax, -228(%rbp)
	movl	-228(%rbp), %eax
	movl 	%eax, -52(%rbp)
.L10: 
	movl	$5, %eax
	movl 	%eax, -236(%rbp)
	movl	-52(%rbp), %eax
	cmpl	-236(%rbp), %eax
	jl .L12
	jmp .L18
.L11: 
	movl	-52(%rbp), %eax
	movl 	%eax, -240(%rbp)
	addl 	$1, -52(%rbp)
	jmp .L10
.L12: 
	movl	$0, %eax
	movl 	%eax, -244(%rbp)
	movl	-244(%rbp), %eax
	movl 	%eax, -60(%rbp)
.L13: 
	movl	$4, %eax
	movl 	%eax, -252(%rbp)
	movl 	-252(%rbp), %eax
	movl 	-52(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -256(%rbp)
	movl	-60(%rbp), %eax
	cmpl	-256(%rbp), %eax
	jl .L15
	jmp .L11
.L14: 
	movl	-60(%rbp), %eax
	movl 	%eax, -260(%rbp)
	addl 	$1, -60(%rbp)
	jmp .L13
.L15: 
	movl 	-60(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -264(%rbp)
	movq	-264(%rbp), %rax
	movq 	%rax, -268(%rbp)
	movl	-268(%rbp), %eax
	movl 	%eax, -64(%rbp)
	movl	$1, %eax
	movl 	%eax, -276(%rbp)
	movl 	-60(%rbp), %eax
	movl 	-276(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -280(%rbp)
	movl 	-280(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -284(%rbp)
	movq	-284(%rbp), %rax
	movq 	%rax, -288(%rbp)
	movl	-288(%rbp), %eax
	movl 	%eax, -68(%rbp)
	movl	-64(%rbp), %eax
	cmpl	-68(%rbp), %eax
	jg .L16
	jmp .L14
	jmp .L17
.L16: 
	movl 	-60(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -296(%rbp)
	movq	-296(%rbp), %rax
	movq	%rdx, -28(%rbp)
	movl	$1, %eax
	movl 	%eax, -304(%rbp)
	movl 	-60(%rbp), %eax
	movl 	-304(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -308(%rbp)
	movl 	-308(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -312(%rbp)
	movq	-312(%rbp), %rax
	movq	%rdx, -28(%rbp)
	jmp .L14
.L17: 
	jmp .L14
	jmp .L11
.L18: 
	movq 	$.LC9, -320(%rbp)
	movl 	-320(%rbp), %eax
	movq 	-320(%rbp), %rdi
	call	printStr
	movl	%eax, -324(%rbp)
	movl	$0, %eax
	movl 	%eax, -328(%rbp)
	movl	-328(%rbp), %eax
	movl 	%eax, -52(%rbp)
.L19: 
	movl	$5, %eax
	movl 	%eax, -336(%rbp)
	movl	-52(%rbp), %eax
	cmpl	-336(%rbp), %eax
	jl .L21
	jmp .L22
.L20: 
	movl	-52(%rbp), %eax
	movl 	%eax, -340(%rbp)
	addl 	$1, -52(%rbp)
	jmp .L19
.L21: 
	movl 	-52(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -344(%rbp)
	movq	-344(%rbp), %rax
	movq 	%rax, -348(%rbp)
	movl	-348(%rbp), %eax
	movl 	%eax, -64(%rbp)
	movl 	-64(%rbp), %eax
	movq 	-64(%rbp), %rdi
	call	printInt
	movl	%eax, -356(%rbp)
	movq 	$.LC10, -360(%rbp)
	movl 	-360(%rbp), %eax
	movq 	-360(%rbp), %rdi
	call	printStr
	movl	%eax, -364(%rbp)
	jmp .L20
.L22: 
	movl	$0, %eax
	movl 	%eax, -368(%rbp)
	movl	-368(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident		"Compiled by 16CS30030"
	.section	.note.GNU-stack,"",@progbits
