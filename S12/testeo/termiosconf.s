	.file	"termiosconf.c"
	.text
	.section	.rodata
.LC0:
	.string	"tcgetattr"
	.text
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	leal	4(%esp), %ecx
	.cfi_def_cfa 1, 0
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	movl	%esp, %ebp
	.cfi_escape 0x10,0x5,0x2,0x75,0
	pushl	%ebx
	pushl	%ecx
	.cfi_escape 0xf,0x3,0x75,0x78,0x6
	.cfi_escape 0x10,0x3,0x2,0x75,0x7c
	addl	$-128, %esp
	call	__x86.get_pc_thunk.bx
	addl	$_GLOBAL_OFFSET_TABLE_, %ebx
	movl	%gs:20, %eax
	movl	%eax, -12(%ebp)
	xorl	%eax, %eax
	subl	$8, %esp
	leal	-132(%ebp), %eax
	pushl	%eax
	pushl	$0
	call	tcgetattr@PLT
	addl	$16, %esp
	testl	%eax, %eax
	jns	.L2
	subl	$12, %esp
	leal	.LC0@GOTOFF(%ebx), %eax
	pushl	%eax
	call	perror@PLT
	addl	$16, %esp
	subl	$12, %esp
	pushl	$1
	call	exit@PLT
.L2:
	movl	-132(%ebp), %eax
	movl	%eax, -72(%ebp)
	movl	-128(%ebp), %eax
	movl	%eax, -68(%ebp)
	movl	-124(%ebp), %eax
	movl	%eax, -64(%ebp)
	movl	-120(%ebp), %eax
	movl	%eax, -60(%ebp)
	movl	-116(%ebp), %eax
	movl	%eax, -56(%ebp)
	movl	-112(%ebp), %eax
	movl	%eax, -52(%ebp)
	movl	-108(%ebp), %eax
	movl	%eax, -48(%ebp)
	movl	-104(%ebp), %eax
	movl	%eax, -44(%ebp)
	movl	-100(%ebp), %eax
	movl	%eax, -40(%ebp)
	movl	-96(%ebp), %eax
	movl	%eax, -36(%ebp)
	movl	-92(%ebp), %eax
	movl	%eax, -32(%ebp)
	movl	-88(%ebp), %eax
	movl	%eax, -28(%ebp)
	movl	-84(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	-80(%ebp), %eax
	movl	%eax, -20(%ebp)
	movl	-76(%ebp), %eax
	movl	%eax, -16(%ebp)
	subl	$12, %esp
	leal	-72(%ebp), %eax
	pushl	%eax
	call	cfmakeraw@PLT
	addl	$16, %esp
	movb	$1, -49(%ebp)
	movb	$0, -50(%ebp)
	movl	-60(%ebp), %eax
	orl	$1, %eax
	movl	%eax, -60(%ebp)
	movl	$0, %eax
	movl	-12(%ebp), %edx
	subl	%gs:20, %edx
	je	.L4
	call	__stack_chk_fail_local
.L4:
	leal	-8(%ebp), %esp
	popl	%ecx
	.cfi_restore 1
	.cfi_def_cfa 1, 0
	popl	%ebx
	.cfi_restore 3
	popl	%ebp
	.cfi_restore 5
	leal	-4(%ecx), %esp
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.section	.text.__x86.get_pc_thunk.bx,"axG",@progbits,__x86.get_pc_thunk.bx,comdat
	.globl	__x86.get_pc_thunk.bx
	.hidden	__x86.get_pc_thunk.bx
	.type	__x86.get_pc_thunk.bx, @function
__x86.get_pc_thunk.bx:
.LFB7:
	.cfi_startproc
	movl	(%esp), %ebx
	ret
	.cfi_endproc
.LFE7:
	.hidden	__stack_chk_fail_local
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
