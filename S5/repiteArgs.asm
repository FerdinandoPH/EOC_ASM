.section .data
    msg1p: .string "Se ha(n) pasado "
    lenM =. - msg1p
    msg2p: .string " argumentos\n"
    lenM2 =. - msg2p
    msgRec: .string "(se tendrán en cuenta solo los primeros 9 argumentos)\n"
    lenM3 =. - msgRec
    msgPres: .string "Los argumentos son:\n"
    lenM4 =. - msgPres
    saltoLinea: .ascii "\n"
.section .bss
    .lcomm stringResultado,10
    .lcomm lenSR,4
.section .text
.globl _start
_start:
    movl $4, %eax
    movl $1, %ebx
    movl $msg1p, %ecx
    movl $lenM, %edx
    int $0x80
    popl %ecx
    movl %ecx, %edi
    movl %ebx,%esi
    pushl %ecx
    call int_a_string
    addl $4, %esp
    movl $4, %eax
    movl $1, %ebx
    movl $stringResultado, %ecx
    movl lenSR, %edx
    int $0x80
    movl $4, %eax
    movl $1, %ebx
    movl $msg2p, %ecx
    movl $lenM2, %edx
    int $0x80
    cmpl $9,%edi
    jle no_limitar
        movl $9,%edi
        movl $4,%eax
        movl $1,%ebx
        movl $msgRec,%ecx
        movl $lenM3,%edx
        int $0x80
    no_limitar:
    movl $4, %eax
    movl $1, %ebx
    movl $msgPres, %ecx
    movl $lenM4, %edx
    int $0x80
    movl %edi,%ecx
    movl %esi,%ebx
    loop_display_args:
        movl %ecx,%esi
        popl %ebx
        movl %ebx,%ecx
        movl $0,%edx
        determinar_longitud:
            cmpb $0,(%ecx)
            je fin_determinar_longitud
                incl %edx
                incl %ecx
                jmp determinar_longitud
        fin_determinar_longitud:
        subl %edx,%ecx
        movl $4,%eax
        movl $1,%ebx
        int $0x80
        movl $4,%eax
        movl $1,%ebx
        movl $saltoLinea,%ecx
        movl $1,%edx
        int $0x80
        movl %esi,%ecx
        loop loop_display_args


    movl $1, %eax
    movl $0, %ebx
    int $0x80
.type int_a_string, @function
int_a_string:
            pushl %esi
            pushl %eax
            pushl %ebx
            pushl %ecx
            pushl %edx
            pushl %edi
            pushl %ebp
            movl %esp, %ebp
            movl %edi, %esi
            movl $0,lenSR
            movl $stringResultado, %edi
            movl $10, %ecx
            xorl %eax, %eax
            rep stosb
            movl %esi,%edi
            movl $stringResultado, %esi
            movl $10, %ecx
            obtener_num_cifras:
                movl 32(%ebp), %eax
                movl $0, %edx
                divl %ecx
                cmpl $0, %eax
                je fin_obtener_num_cifras
                    addl $1, lenSR
                    imull $10, %ecx
                    jmp obtener_num_cifras
            fin_obtener_num_cifras:
                addl $1, lenSR
                movl lenSR, %ecx
                movl 32(%ebp), %eax
            colocar_cifras:
                movl $10, %ebx
                movl $0, %edx
                divl %ebx
                addl $48, %edx
                movb %dl, -1(%esi, %ecx)
                loop colocar_cifras
            movl %ebp, %esp
            popl %ebp
            popl %edi
            popl %edx
            popl %ecx
            popl %ebx
            popl %eax
            popl %esi
            ret
