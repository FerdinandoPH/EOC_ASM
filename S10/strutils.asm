.data

.text


.globl _start

_start:
    movl $1, %eax
    movl $0, %ebx
    int $0x80


.globl strlen
.type strlen, @function
strlen:
    enter $0,$0
    pushl %esi
    xorl %eax, %eax
    movl 8(%ebp), %esi
    bucle_longitud:
        cmpb $0, (%esi,%eax,1)
        je fin_longitud
        incl %eax
        jmp bucle_longitud
    fin_longitud:
    popl %esi
    leave
    ret $4

.globl limpiar_entrada
.type limpiar_entrada, @function
limpiar_entrada:
    enter $4,$0
    pushl %eax
    pushl %esi
    pushl %edi
    movl 8(%ebp), %esi
    leal -4(%ebp), %edi
    pushl %esi
    call strlen
    cmpl $10,-1(%esi,%eax,1)
    je quitar_salto_linea
    cmpl $0,-1(%esi,%eax,1)
    je quitar_salto_linea
    purgar:
        movl $3, %eax
        movl $0, %ebx
        movl %edi, %ecx
        movl $1, %edx
        int $0x80
        cmpb $10, (%edi)
        je fin_limpieza
        jmp purgar
    quitar_salto_linea:
        decl %eax
        js fin_limpieza
        cmpb $10, (%edi,%eax,1)
        jne quitar_salto_linea
        movb $0, (%edi,%eax,1)
    fin_limpieza:
    popl %edi
    popl %esi
    popl %eax
    leave
    ret $4


