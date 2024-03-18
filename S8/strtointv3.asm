.section .data
    numPrueba: .string "-1FFF"
    stringBase: .string "16"
.section .text
.global _start
_start:
    pushl $stringBase
    pushl $numPrueba
    call strtoint_baseString
    movl $1, %eax
    movl $0, %ebx
    int $0x80

.type strtoint_baseString, @function
strtoint_baseString:
    enter $0,$0
    pushl %ebx
    pushl %ecx
    #pushl %edx
    pushl %esi
    pushl %edi

    pushl $10
    pushl $stringBase
    call strtoint

    pushl %eax
    pushl $numPrueba
    call strtoint

    popl %edi 
    popl %esi
    #popl %edx
    popl %ecx
    popl %ebx
    leave
    ret $8
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
    jne no_es_negativo
        movl $-1,%edi
        incl %esi
        decl %ecx
    no_es_negativo:
    bucle_colocar_cifras:
        movl $0,%edx
        movb (%esi),%dl
        cmpb $'0',%dl
        jl error_arg_strtoint
        addb $47,%bl
        cmpb $'9',%bl
        jle fin_reajuste_comparacion_mas_de_base_10
            addb $7,%bl
        fin_reajuste_comparacion_mas_de_base_10:
        cmpb %bl,%dl
        jg error_arg_strtoint
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
        jo error_arg_strtoint
        #jc error_arg_strtoint
        decl %ecx
        jz fin_colocar_cifras
        mull %ebx
        jo error_arg_strtoint
        #jc error_arg_strtoint
        incl %esi
        jmp bucle_colocar_cifras
    fin_colocar_cifras:
    movl $0,%edx
    imull %edi,%eax
    fin_colocar_cifras_con_error:
    popl %edi
    popl %esi
    #popl %edx
    popl %ecx
    popl %ebx
    leave
    ret $8
    error_arg_strtoint:
        movl $-1,%edx
        movl $-1,%eax
        jmp fin_colocar_cifras_con_error

