.section .data
    numPrueba: .string "-123456789"
.section .text
.global _start
_start:
    pushl $10
    pushl $numPrueba
    call strtoul
    movl $1, %eax
    movl $0, %ebx
    int $0x80


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
    movl $1, %edi
    obtener_longitud_local:
        movb (%esi,%ecx,1), %al
        cmpb $0,%al
        je fin_obtener_longitud_local
        incl %ecx
        jmp obtener_longitud_local
    fin_obtener_longitud_local:
    cmpb $'-',(%esi)
    jne no_es_negativo
        movl $-1,%edi
        incl %esi
        decl %ecx
    no_es_negativo:
    movl $0,%eax
    movl $0,%ebx
    movb 12(%ebp),%bl
    bucle_colocar_cifras:
        movl $0,%edx
        movb (%esi),%dl
        cmpb $'0',%dl
        jl error_argumento
        addl $'0',%ebx
        cmpb %bl,%dl
        jg error_argumento
        subb $'0',%dl
        subb $'0',%bl
        addl %edx,%eax
        jo error_argumento
        #jc error_argumento
        decl %ecx
        jz fin_colocar_cifras
        imull %ebx
        jo error_argumento
        #jc error_argumento
        incl %esi
        jmp bucle_colocar_cifras
    fin_colocar_cifras:
    imull %edi,%eax
    popl %edi
    popl %esi
    #popl %edx
    popl %ecx
    popl %ebx
    leave
    ret $8
    error_argumento:
        movl $-1,%edx
        jmp fin_colocar_cifras

