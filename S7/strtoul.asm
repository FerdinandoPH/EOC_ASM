.section .data
    numPrueba: .string "2147483648"
.section .text
.global _start
_start:
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
    pushl %edx
    pushl %esi
    pushl %edi
    movl 8(%ebp), %esi
    movl $0,%ecx
    obtener_longitud_local:
        movb (%esi,%ecx,1), %al
        cmpb $0,%al
        je fin_obtener_longitud_local
        incl %ecx
        jmp obtener_longitud_local
    fin_obtener_longitud_local:
    movl $0,%eax
    movl $0,%ebx
    movb $10,%bl
    bucle_colocar_cifras:
        movl $0,%edx
        movb (%esi),%dl
        cmpb $48,%dl
        jl error_argumento
        addl $48,%ebx
        cmpb %bl,%dl
        jg error_argumento
        subb $48,%dl
        subb $48,%bl
        addl %edx,%eax
        jo error_argumento
        jc error_argumento
        decl %ecx
        cmpl $0,%ecx
        jle fin_colocar_cifras
        mull %ebx
        jo error_argumento
        jc error_argumento
        incl %esi
        jmp bucle_colocar_cifras
    fin_colocar_cifras:
    popl %edi
    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    leave
    ret $4
    error_argumento:
        movl $-1,%eax
        jmp fin_colocar_cifras

