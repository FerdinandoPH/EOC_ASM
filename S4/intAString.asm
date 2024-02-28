.section .data
    num: .long 0x0000007B
    saltoLinea: .byte 0x0A
.section .bss
    .lcomm stringResultado,10
    .lcomm lenSR,4
.section .text
    .globl _start
    _start:
        pushl num
        call int_a_string
        addl $4, %esp
        movl $4, %eax
        movl $1, %ebx
        movl $stringResultado, %ecx
        movl $10, %edx
        int $0x80
        movl $4, %eax
        movl $1, %ebx
        movl $saltoLinea, %ecx
        movl $1, %edx
        int $0x80
        movl $1, %eax
        movl $0, %ebx
        int $0x80
.type int_a_string, @function
        int_a_string:
            pushl %ebp
            movl %esp, %ebp
            movl $stringResultado, %esi
            movl $10, %ecx
            obtener_num_cifras:
                movl 8(%ebp), %eax
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
                movl 8(%ebp), %eax
            colocar_cifras:
                movl $10, %ebx
                movl $0, %edx
                divl %ebx
                addl $48, %edx
                movb %dl, -1(%esi, %ecx)
                loop colocar_cifras
            movl %ebp, %esp
            popl %ebp
            ret
