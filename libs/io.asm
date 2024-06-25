.data
    saltoLinea: .ascii "\n"
    msgErrorIntToStr: .string "Error al convertir de entero a cadena\n"
    lenMEITS = . - msgErrorIntToStr
    numPrueba: .string "-1FFF"
    stringBase: .string "16"
    msgErrorStringToInt: .string "Error en la conversión de cadena a entero\n"
    lenMESTI =  .-msgErrorStringToInt
.bss
    .globl stringResultado
    .lcomm stringResultado,34
    .globl lenSR
    .lcomm lenSR,4
.text
    # .globl _start
    # _start:
    #     pushl $10
    #     pushl $-2147483648
    #     call inttostr

    #     movl $4, %eax
    #     movl $1, %ebx
    #     movl $stringResultado, %ecx
    #     movl lenSR, %edx
    #     int $0x80

    #     movl $4, %eax
    #     movl $1, %ebx
    #     movl $saltoLinea, %ecx
    #     movl $1, %edx
    #     int $0x80

    #     movl $1, %eax
    #     movl $0, %ebx
    #     int $0x80
.globl inttostr_baseString_wrapper
.type inttostr_baseString_wrapper, @function
inttostr_baseString_wrapper:
    enter $0,$0
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi
    pushl %edi
    pushl 12(%ebp)
    pushl 8(%ebp)
    call inttostr_baseString
    cmpl $0,lenSR
    jg finalizar_inttostr_baseString_wrapper
        movl $4, %eax
        movl $1, %ebx
        movl $msgErrorIntToStr, %ecx
        movl $lenMEITS, %edx
        int $0x80

        movl $1, %eax
        movl $1, %ebx
        int $0x80
    finalizar_inttostr_baseString_wrapper:
    popl %edi
    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax
    leave
    ret $8
.globl inttostr_baseString
.type inttostr_baseString, @function
inttostr_baseString:
    enter $0,$0
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi
    pushl %edi

    pushl $10
    pushl 12(%ebp)
    call strtoint

    pushl %eax
    pushl 8(%ebp)
    call inttostr

    popl %edi
    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax
    leave
    ret $8
.globl inttostr_wrapper
.type inttostr_wrapper, @function
inttostr_wrapper:
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
        movl $msgErrorIntToStr, %ecx
        movl $lenMEITS, %edx
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
    movl $34, %ecx
    movl $stringResultado, %edi
    rep stosb

    movl 8(%ebp),%eax
    movl 12(%ebp), %ecx
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

        movl 12(%ebp), %ebx
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
        cmpl $'9', %edx
        jle esta_en_base_10
            addl $7, %edx
        esta_en_base_10:
        movb %dl, -1(%esi,%ecx,1)
        xorl %edx, %edx
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
        # movl $msgErrorIntToStr, %ecx
        # movl $lenMEITS, %edx
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
#.section .text
# .global _start
# _start:
#     pushl $stringBase
#     pushl $numPrueba
#     call strtoint_baseString
#     movl $1, %eax
#     movl $0, %ebx
#     int $
.globl strtoint_baseString_wrapper
.type strtoint_baseString_wrapper, @function
strtoint_baseString_wrapper:
    enter $0,$0
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi
    pushl %edi

    pushl 12(%ebp)
    pushl 8(%ebp)
    call strtoint_baseString
    
    cmpl $-1,%edx
    jle finalizar_strtoint_baseString_wrapper
        movl $4, %eax
        movl $1, %ebx
        movl $msgErrorStringToInt, %ecx
        movl $lenMESTI, %edx
        int $0x80

        movl $1, %eax
        movl $1, %ebx
        int $0x80
    finalizar_strtoint_baseString_wrapper:
    popl %edi 
    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    leave
    ret $8
.globl strtoint_baseString
.type strtoint_baseString, @function
strtoint_baseString:
    enter $0,$0
    pushl %ebx
    pushl %ecx
    #pushl %edx
    pushl %esi
    pushl %edi

    pushl $10
    pushl 12(%ebp)
    call strtoint

    pushl %eax
    pushl 8(%ebp)
    call strtoint

    popl %edi 
    popl %esi
    #popl %edx
    popl %ecx
    popl %ebx
    leave
    ret $8
.globl strtoint_wrapper
.type strtoint_wrapper, @function
strtoint_wrapper:
    enter $0,$0
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi
    pushl %edi

    pushl 12(%ebp)
    pushl 8(%ebp)
    call strtoint
    
    cmpl $-1,%edx
    jle finalizar_strtoint_wrapper
        movl $4, %eax
        movl $1, %ebx
        movl $msgErrorStringToInt, %ecx
        movl $lenMESTI, %edx
        int $0x80

        movl $1, %eax
        movl $1, %ebx
        int $0x80
    finalizar_strtoint_wrapper:
    popl %edi 
    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    leave
    ret $8
.globl strtoint
.type strtoint, @function
strtoint:
    enter $0,$0
    pushl %ebx
    pushl %ecx
    #pushl %edx
    pushl %esi
    pushl %edi
    movl $1,%edi
    movl 8(%ebp), %esi
    movl $0,%ecx
    obtener_longitud_strtoint:
        movb (%esi,%ecx,1), %al
        cmpb $0,%al
        je fin_obtener_longitud_strtoint
        cmpb $10,%al
        je fin_obtener_longitud_strtoint
        incl %ecx
        jmp obtener_longitud_strtoint
    fin_obtener_longitud_strtoint:
    movl $0,%eax
    movl $0,%ebx
    movb 12(%ebp),%bl
    cmpb $16,%bl
    jg error_arg_strtoint
    cmpb $2,%bl
    jl error_arg_strtoint
    cmpb $'-',(%esi)
    jne bucle_colocar_cifras
        movl $-1,%edi
        incl %esi
        decl %ecx
    bucle_colocar_cifras:
        movl $0,%edx
        movb (%esi),%dl
        subb $'0',%dl
        js error_arg_strtoint
        cmpb $10,%dl
        jl fin_reajuste
            cmpb $16,%dl
            jle error_arg_strtoint
            cmpb $42,%dl
            jg error_arg_strtoint
            # jg quizas_minus
                subb $7,%dl
                jmp fin_reajuste
            # quizas_minus:
            #     cmpb $49,%dl
            #     jl error_arg_strtoint
            #     cmpb $'z',%dl
            #     jg error_arg_strtoint
            #     subb $39,%dl
        fin_reajuste:
        cmpb %bl,%dl
        jge error_arg_strtoint
        addl %edx,%eax
        jo error_arg_strtoint
        decl %ecx
        jz fin_colocar_cifras
        mull %ebx
        jo error_arg_strtoint
        incl %esi
        jmp bucle_colocar_cifras
    fin_colocar_cifras:
    movl $0,%edx
    imull %edi,%eax
    fin_colocar_cifras_con_error:
    popl %edi
    popl %esi
    popl %ecx
    popl %ebx
    leave
    ret $8
    error_arg_strtoint:
        movl $-1,%edx
        movl $-1,%eax
        jmp fin_colocar_cifras_con_error

