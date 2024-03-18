.section .data
    numPrueba: .string "1100100"
    stringBase: .string "2"
.section .text
.global _start
_start:
    pushl $stringBase
    pushl $numPrueba
    call strtoul_baseString
    movl $1, %eax
    movl $0, %ebx
    int $0x80

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
        cmpb $'0',%dl
        jl error_arg_strtoul
        addb $47,%bl
        cmpb $'9',%bl
        jle fin_reajuste_comparacion_mas_de_base_10
            addb $7,%bl
        fin_reajuste_comparacion_mas_de_base_10:
        cmpb %bl,%dl
        jg error_arg_strtoul
        subb $'0',%dl
        subb $47,%bl
        cmpb $10, %bl
        jle fin_reajuste_mapeo_mas_de_base_10
            subb $7,%bl
            cmpb $10,%dl
            jl fin_reajuste_mapeo_mas_de_base_10
                subb $7,%dl
        fin_reajuste_mapeo_mas_de_base_10:
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

