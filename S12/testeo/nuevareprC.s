	.file	"nuevareprC.c"
	.text
	.section	.rodata
.LC0:
	.string	"/usr/bin/aplay"
.LC1:
	.string	"./Recursos/t1.wav"
.LC2:
	.string	"-q"
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
	subl	$48, %esp
	call	__x86.get_pc_thunk.ax
	addl	$_GLOBAL_OFFSET_TABLE_, %eax
	movl	%ecx, %edx
	movl	4(%edx), %ecx
	movl	%ecx, -44(%ebp)
	movl	8(%edx), %edx
	movl	%edx, -48(%ebp)
	movl	%gs:20, %edx
	movl	%edx, -12(%ebp)
	xorl	%edx, %edx
	leal	.LC0@GOTOFF(%eax), %edx
	movl	%edx, -28(%ebp)
	leal	.LC1@GOTOFF(%eax), %edx
	movl	%edx, -24(%ebp)
	leal	.LC2@GOTOFF(%eax), %edx
	movl	%edx, -20(%ebp)
	movl	$0, -16(%ebp)
	movl	-28(%ebp), %edx
	subl	$4, %esp
	pushl	-48(%ebp)
	leal	-28(%ebp), %ecx
	pushl	%ecx
	pushl	%edx
	movl	%eax, %ebx
	call	execve@PLT
	addl	$16, %esp
	movl	$0, %eax
	movl	-12(%ebp), %edx
	subl	%gs:20, %edx
	je	.L3
	call	__stack_chk_fail_local
.L3:
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
	.section	.text.__x86.get_pc_thunk.ax,"axG",@progbits,__x86.get_pc_thunk.ax,comdat
	.globl	__x86.get_pc_thunk.ax
	.hidden	__x86.get_pc_thunk.ax
	.type	__x86.get_pc_thunk.ax, @function
__x86.get_pc_thunk.ax:
.LFB7:
	.cfi_startproc
	movl	(%esp), %eax
	ret
	.cfi_endproc
.LFE7:
	.hidden	__stack_chk_fail_local
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
