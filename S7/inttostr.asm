.data
    saltoLinea: .asciz "\n"
.bss
    .globl stringResultado
    .lcomm stringResultado,12
    .globl lenSR
    .lcomm lenSR,4
.text
    .globl _start
    _start:
        pushl $-123456789
        call inttostr

        movl $4, %eax
        movl $1, %ebx
        movl $stringResultado, %ecx
        movl lenSR, %edx
        int $0x80

        movl $4, %eax
        movl $1, %ebx
        movl $saltoLinea, %ecx
        movl $1, %edx
        int $0x80

        movl $1, %eax
        movl $0, %ebx
        int $0x80
.type inttostr, @function
inttostr:
    enter $0,$0
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi
    pushl %edi

    movl $0, lenSR
    xorl %eax, %eax
    movl $12, %ecx
    movl $stringResultado, %edi
    rep stosb

    movl 8(%ebp),%eax
    movl $10, %ecx
    obtener_num_cifras:
        xorl %edx, %edx
        testl %eax, %eax
        sets %dl
        negl %edx
        idivl %ecx
        testl %eax, %eax
        jz fin_obtener_num_cifras
            addl $1, lenSR
            jmp obtener_num_cifras
    fin_obtener_num_cifras:
        addl $1, lenSR
        movl $stringResultado, %esi
        movl lenSR, %ecx

        movl $10, %ebx
        movl $0,%edx

        movl 8(%ebp), %eax
        testl %eax, %eax
        jns colocar_cifras
            movb $'-',(%esi)
            negl %eax
            incl %esi
            incl lenSR
    colocar_cifras:
        divl %ebx
        addl $'0', %edx
        movb %dl, -1(%esi,%ecx,1)
        xorl %edx, %edx
        loop colocar_cifras
    popl %edi
    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax
    leave
    ret $4
