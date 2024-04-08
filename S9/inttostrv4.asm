.data
    saltoLinea: .ascii "\n"
    msgError: .string "Error al convertir de entero a cadena\n"
    lenME = . - msgError
.bss
    .globl stringResultado
    .lcomm stringResultado,34
    .globl lenSR
    .lcomm lenSR,4
.text
    .globl _start
    _start:
        pushl $10
        pushl $-123
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
.globl inttostr_cadenaCustom
.type inttostr_cadenaCustom, @function
inttostr_cadenaCustom:
    enter $0,$0
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi
    pushl %edi
    pushl 12(%ebp)
    pushl 8(%ebp)
    call inttostr
    finalizar_inttostr_cadenaCustom:
    movl $stringResultado, %esi
    movl 16(%ebp), %edi
    bucle_copia:
        movb (%esi), %al
        testb %al, %al
        jz finalizar_copia
            movb %al, (%edi)
            incl %edi
            incl %esi
        incl %esi
        jmp bucle_copia
    finalizar_copia:
    popl %edi
    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax
    leave
    ret $12
# .globl inttostr_baseString_wrapper
# .type inttostr_baseString_wrapper, @function
# inttostr_baseString_wrapper:
#     enter $0,$0
#     pushl %eax
#     pushl %ebx
#     pushl %ecx
#     pushl %edx
#     pushl %esi
#     pushl %edi
#     pushl 12(%ebp)
#     pushl 8(%ebp)
#     call inttostr_baseString
#     cmpl $0,lenSR
#     jg finalizar_inttostr_baseString_wrapper
#         movl $4, %eax
#         movl $1, %ebx
#         movl $msgError, %ecx
#         movl $lenME, %edx
#         int $0x80

#         movl $1, %eax
#         movl $1, %ebx
#         int $0x80
#     finalizar_inttostr_baseString_wrapper:
#     popl %edi
#     popl %esi
#     popl %edx
#     popl %ecx
#     popl %ebx
#     popl %eax
#     leave
#     ret $8
# .globl inttostr_baseString
# .type inttostr_baseString, @function
# inttostr_baseString:
#     enter $0,$0
#     pushl %eax
#     pushl %ebx
#     pushl %ecx
#     pushl %edx
#     pushl %esi
#     pushl %edi

#     pushl $10
#     pushl 12(%ebp)
#     call strtoint

#     pushl %eax
#     pushl 8(%ebp)
#     call inttostr

#     popl %edi
#     popl %esi
#     popl %edx
#     popl %ecx
#     popl %ebx
#     popl %eax
#     leave
#     ret $8
.globl inttostr_wrapper
.type inttostr_wrapper, @function
    enter $0,$0
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi
    pushl %edi
    pushl 12(%ebp)
    pushl 8(%ebp)
    call inttostr
    cmpl $0,lenSR
    jg finalizar_inttostr_wrapper
        movl $4, %eax
        movl $1, %ebx
        movl $msgError, %ecx
        movl $lenME, %edx
        int $0x80

        movl $1, %eax
        movl $1, %ebx
        int $0x80
    finalizar_inttostr_wrapper:
    popl %edi
    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax
    leave
    ret $8
.globl inttostr
.type inttostr, @function
inttostr:
    enter $0,$0
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi
    pushl %edi
    cmpl $16,12(%ebp)
    jg error_arg_inttostr
    cmpl $1,12(%ebp)
    jle error_arg_inttostr
    movl $0, lenSR
    xorl %eax, %eax
    movl $32, %ecx
    movl $stringResultado, %edi
    rep stosb
    movl $0,%edi
    movl 8(%ebp),%eax
    movl 12(%ebp), %ecx
    movl $stringResultado, %esi
    testl %eax, %eax
    jns obtener_num_cifras
        movb $'-',(%esi)
        incl %esi
        cmpl $-2147483648, %eax
        jne se_puede_negar
            movl $-1,%edx
            idivl %ecx
            negl %edx
            pushl %edx
            incl lenSR
        se_puede_negar:
        negl %eax
        incl lenSR
        incl %edi
    obtener_num_cifras:
        xorl %edx, %edx
        testl %eax, %eax
        sets %dl
        negl %edx
        divl %ecx
        pushl %edx
        incl lenSR
        testl %eax, %eax
        jnz obtener_num_cifras
    fin_obtener_num_cifras:
        movl lenSR, %ecx
        subl %edi, %ecx
        movl 12(%ebp), %ebx
        movl $0,%edx
        movl 8(%ebp), %eax
    colocar_cifras:
        popl %edx
        addl $'0', %edx
        cmpl $'9', %edx
        jle esta_en_base_10
            addl $7, %edx
        esta_en_base_10:
        movb %dl, (%esi)
        incl %esi
        loop colocar_cifras
    finalizar_inttostr:
    popl %edi
    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax
    leave
    ret $8
    error_arg_inttostr:
        # movl $4, %eax
        # movl $1, %ebx
        # movl $msgError, %ecx
        # movl $lenME, %edx
        # int $0x80
        # movl $1, %eax
        # movl $1, %ebx
        # int $0x80
        movl $0, lenSR
        xorl %eax, %eax
        movl $32, %ecx
        movl $stringResultado, %edi
        rep stosb
        jmp finalizar_inttostr
