.section .data
    numPrueba: .string "FF"
    stringBase: .string "16"
.section .text
# .global _start
# _start:
#     pushl $stringBase
#     pushl $numPrueba
#     call strtoul_baseString
#     movl $1, %eax
#     movl $0, %ebx
#     int $0x80
.globl strtoul_baseString
.type strtoul_baseString, @function
strtoul_baseString:
    enter $0,$0
    pushl %ebx
    pushl %ecx
    #pushl %edx
    pushl %esi
    pushl %edi

    pushl $10
    pushl 12(%ebp)
    call strtoul

    pushl %eax
    pushl 8(%ebp)
    call strtoul

    popl %edi 
    popl %esi
    #popl %edx
    popl %ecx
    popl %ebx
    leave
    ret $8
.globl strtoul
.type strtoul, @function
strtoul:
    enter $0,$0
    pushl %ebx
    pushl %ecx
    #pushl %edx
    pushl %esi
    pushl %edi
    movl 8(%ebp), %esi
    movl $0,%ecx
    obtener_longitud_strtoul:
        movb (%esi,%ecx,1), %al
        cmpb $0,%al
        je fin_obtener_longitud_strtoul
        cmpb $10,%al
        je fin_obtener_longitud_strtoul
        incl %ecx
        jmp obtener_longitud_strtoul
    fin_obtener_longitud_strtoul:
    movl $0,%eax
    movl $0,%ebx
    movb 12(%ebp),%bl
    cmpb $16,%bl
    jg error_arg_strtoul
    cmpb $2,%bl
    jl error_arg_strtoul
    bucle_colocar_cifras:
        movl $0,%edx
        movb (%esi),%dl
        subb $'0',%dl
        js error_arg_strtoul
        cmpb $10,%dl
        jl fin_reajuste
            cmpb $16,%dl
            jle error_arg_strtoul
            cmpb $42,%dl
            jg quizas_minus
                subb $7,%dl
                jmp fin_reajuste
            quizas_minus:
                cmpb $49,%dl
                jl error_arg_strtoul
                subb $39,%dl
        fin_reajuste:
        cmpb %bl,%dl
        jge error_arg_strtoul
        addl %edx,%eax
        jo error_arg_strtoul
        #jc error_arg_strtoul
        decl %ecx
        jz fin_colocar_cifras
        mull %ebx
        jo error_arg_strtoul
        #jc error_arg_strtoul
        incl %esi
        jmp bucle_colocar_cifras
    fin_colocar_cifras:
    movl $0,%edx
    fin_colocar_cifras_con_error:
    popl %edi
    popl %esi
    #popl %edx
    popl %ecx
    popl %ebx
    leave
    ret $8
    error_arg_strtoul:
        movl $-1,%edx
        movl $-1,%eax
        jmp fin_colocar_cifras_con_error

