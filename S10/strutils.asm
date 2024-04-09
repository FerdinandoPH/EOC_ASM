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
.globl limpiar_cadena
.type limpiar_cadena, @function
limpiar_cadena:
    enter $0,$0
    pushl %edi
    pushl %ecx
    movl 8(%ebp), %edi
    movl 12(%ebp), %ecx
    testl %ecx, %ecx
    jns ya_tenemos_longitud
        pushl %edi
        call strlen
        movl %eax, %ecx
    xorl %eax, %eax
    rep stosb
    movl 8(%ebp), %eax
    popl %ecx
    popl %edi
    leave
    ret $8
.globl limpiar_entrada
.type limpiar_entrada, @function
limpiar_entrada:
    enter $4,$0
    pushl %esi
    pushl %edi
    movl 8(%ebp), %esi
    leal -4(%ebp), %edi
    pushl %esi
    call strlen
    cmpl $'\n',-1(%esi,%eax,1)
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
        cmpb $'\n', (%edi,%eax,1)
        jne quitar_salto_linea
        cmpl $'\n', 12(%ebp)
        je fin_limpieza
        movb $0, (%edi,%eax,1)
    fin_limpieza:
    movl 8(%ebp), %eax
    popl %edi
    popl %esi
    leave
    ret $8
.globl strcpy
.type strcpy, @function
strcpy:
    enter $0,$0
    pushl %esi
    pushl %edi

    movl 12(%ebp), %esi
    movl 8(%ebp), %edi
    movl %edi, %eax

    bucle_copiar_strcpy:
        movb (%esi), %al
        movb %al, (%edi)
        incl %esi
        incl %edi
        cmpb $0, %al
        jne bucle_copiar_strcpy
    
    popl %edi
    popl %esi
    leave
    ret $8

.globl strncpy
.type strncpy, @function
strncpy:
    enter $0,$0
    pushl %esi
    pushl %edi
    pushl %ecx

    movl 12(%ebp), %esi
    movl 8(%ebp), %edi
    movl 16(%ebp), %ecx
    
    pushl %esi
    call strlen
    cmpl %ecx, %eax
    jl error_strncpy
    bucle_copiar_strncpy:
        movb (%esi), %al
        movb %al, (%edi)
        incl %esi
        incl %edi
        loop bucle_copiar_strncpy
    incl %edi
    movb $0, (%edi)
    movl 8(%ebp), %eax
    fin_strncpy:
    popl %ecx
    popl %edi
    popl %esi
    leave
    ret $12
    error_strncpy:
        movl -1, %eax
        jmp fin_strncpy
.globl strcat
.type strcat, @function
strcat:
    enter $0,$0
    pushl %esi
    pushl %edi

    movl 8(%ebp), %esi
    movl 12(%ebp), %edi

    pushl %esi
    call strlen

    addl %eax,%esi
    bucle_copiar_strcat:
        movb (%edi), %al
        movb %al, (%esi)
        incl %edi
        incl %esi
        testb %al, %al
        jnz bucle_copiar_strcat
    
    movl 8(%ebp), %eax
    popl %edi
    popl %esi
    leave
    ret $8

.globl strncat
.type strncat, @function
strncat:
    enter $0,$0
    pushl %esi
    pushl %edi
    pushl %ecx

    movl 8(%ebp), %esi
    movl 12(%ebp), %edi
    movl 16(%ebp), %ecx

    pushl %esi
    call strlen

    addl %eax,%esi
    pushl %edi
    call strlen
    cmpl %ecx, %eax
    jl error_strncat
    bucle_copiar_strncat:
        movb (%edi), %al
        movb %al, (%esi)
        incl %edi
        incl %esi
        loop bucle_copiar_strncat
    movl 8(%ebp), %eax
    fin_strncat:
    popl %ecx
    popl %edi
    popl %esi
    leave
    ret $12
    error_strncat:
        movl -1, %eax
        jmp fin_strncat

.globl strchr
.type strchr, @function
strchr:
    enter $0,$0
    pushl %esi
    pushl %edi
    pushl %ecx

    movl 12(%ebp), %esi
    movl 8(%ebp), %edi

    pushl %esi
    call strlen
    movl %eax, %ecx
    bucle_buscar_strchr:
        cmpb %edi, (%esi)
        je encontrado_strchr
        incl %esi
        loop bucle_buscar_strchr
    movl $-1, %eax
    jmp fin_strchr
    encontrado_strchr:
        movl %esi, %eax
    fin_strchr:
    popl %ecx
    popl %edi
    popl %esi
    leave
    ret $8

