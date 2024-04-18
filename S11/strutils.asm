.data
testString: .string "Fernando"
saltoLinea: .ascii "\n"
mensajeEntrada: .string "Introduce una cadena (max 20 caracteres) y te doy la longitud: "
lenMenEntrada = . - mensajeEntrada
cadena1: .string "Copiame guapi :)"
cadcat1: .string "Hola"
cadcat2: .string " Mundo"
cadenaBusca: .string "Murcielago"
msgBusca1: .string "La letra "
lenMB1 = . - msgBusca1
msgBusca2: .string " se encuentra en la posicion "
lenMB2 = . - msgBusca2
letraBuscada: .byte 'o'
mensajeLongitud: .string "La longitud de la cadena es: "
lenMenLongitud = . - mensajeLongitud
cadenaComp1: .string "Pedritoritrririta"
cadenaComp2: .string "Pedritoritrririto"
subCadena: .string "rit"
msgComp: .string "El resultado de la comparación es: "
lenMsgComp = . - msgComp
msgBus: .string "La subcadena se encuentra en la dirección: "
lenMsgBus = . - msgBus
.bss
    .lcomm entrada,21
    .lcomm cadena2, 17
    .lcomm todoJunto, 11
.text


.globl _start

_start:

    movl $4, %eax
    movl $1, %ebx
    movl $mensajeEntrada, %ecx
    movl $lenMenEntrada, %edx
    int $0x80

    movl $3, %eax
    movl $0, %ebx
    movl $entrada, %ecx
    movl $20, %edx
    int $0x80

    pushl $0
    pushl $entrada
    call limpiar_entrada
    
    pushl $entrada
    call strlen
    pushl $10
    pushl %eax
    call inttostr
    movl $4, %eax
    movl $1, %ebx
    movl $mensajeLongitud, %ecx
    movl $lenMenLongitud, %edx
    int $0x80
    movl $4, %eax
    movl $1, %ebx
    movl $stringResultado, %ecx
    movl $lenSR, %edx
    int $0x80
    movl $4, %eax
    movl $1, %ebx
    movl $saltoLinea, %ecx
    movl $1, %edx
    int $0x80

    pushl $cadena1
    pushl $cadena2
    
    call strcpy

    movl $4, %eax
    movl $1, %ebx
    movl $cadena2, %ecx
    movl $17, %edx
    int $0x80

    movl $4, %eax
    movl $1, %ebx
    movl $saltoLinea, %ecx
    movl $1, %edx
    int $0x80

    
    pushl $cadcat1
    pushl $todoJunto
    call strcpy

    pushl $cadcat2
    pushl $todoJunto
    call strcat

    movl $4, %eax
    movl $1, %ebx
    movl $todoJunto, %ecx
    movl $11, %edx
    int $0x80

    movl $4, %eax
    movl $1, %ebx
    movl $saltoLinea, %ecx
    movl $1, %edx
    int $0x80

    pushl letraBuscada
    pushl $cadenaBusca
    call charIndex
    pushl $10
    pushl %eax
    call inttostr
    movl $4, %eax
    movl $1, %ebx
    movl $msgBusca1, %ecx
    movl $lenMB1, %edx
    int $0x80
    movl $4, %eax
    movl $1, %ebx
    movl $letraBuscada, %ecx
    movl $1, %edx
    int $0x80
    movl $4, %eax
    movl $1, %ebx
    movl $msgBusca2, %ecx
    movl $lenMB2, %edx
    int $0x80
    movl $4, %eax
    movl $1, %ebx
    movl $stringResultado, %ecx
    movl $lenSR, %edx
    int $0x80
    movl $4, %eax
    movl $1, %ebx
    movl $saltoLinea, %ecx
    movl $1, %edx
    int $0x80

    pushl $cadenaComp1
    pushl $cadenaComp2
    call strcmp
    pushl $10
    pushl %eax
    call inttostr
    movl $4, %eax
    movl $1, %ebx
    movl $msgComp, %ecx
    movl $lenMsgComp, %edx
    int $0x80
    movl $4, %eax
    movl $1, %ebx
    movl $stringResultado, %ecx
    movl $lenSR, %edx
    int $0x80
    movl $4, %eax
    movl $1, %ebx
    movl $saltoLinea, %ecx
    movl $1, %edx
    int $0x80

    pushl $subCadena
    pushl $cadenaComp1
    call strstr
    pushl $10
    pushl %eax
    call inttostr
    movl $4, %eax
    movl $1, %ebx
    movl $msgBus, %ecx
    movl $lenMsgBus, %edx
    int $0x80
    movl $4, %eax
    movl $1, %ebx
    movl $stringResultado, %ecx
    movl $lenSR, %edx
    int $0x80
    movl $4, %eax
    movl $1, %ebx
    movl $saltoLinea, %ecx
    movl $1, %edx
    int $0x80

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
    ya_tenemos_longitud:
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
        cmpb $'\n', (%esi,%eax,1)
        jne quitar_salto_linea
        cmpl $'\n', 12(%ebp)
        je fin_limpieza
        movb $0, (%esi,%eax,1)
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
        movl $0, %eax
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
        movl $0, %eax
        jmp fin_strncat

.globl strchr
.type strchr, @function
strchr:
    enter $0,$0
    pushl %esi
    pushl %edi
    pushl %ecx
    pushl %edx
    xorl %edx, %edx
    movl 8(%ebp), %esi
    movl 12(%ebp), %edx

    pushl %esi
    call strlen
    movl %eax, %ecx
    bucle_buscar_strchr:
        cmpb %dl, (%esi)
        je encontrado_strchr
        incl %esi
        loop bucle_buscar_strchr
    movl $-1, %eax
    jmp fin_strchr
    encontrado_strchr:
        movl %esi, %eax
    fin_strchr:
    popl %edx
    popl %ecx
    popl %edi
    popl %esi
    leave
    ret $8
.globl charIndex
.type charIndex, @function
charIndex:
    enter $0,$0
    pushl 12(%ebp)
    pushl 8(%ebp)
    call strchr
    subl 8(%ebp), %eax
    cmpl $-1, %eax
    jge fin_charIndex
    movl $-1, %eax
    fin_charIndex:
    leave
    ret $8
.globl strcmp
.type strcmp, @function
strcmp:
    enter $0,$0
    pushl %esi
    pushl %edi

    movl 8(%ebp), %esi
    movl 12(%ebp), %edi
    xorl %eax, %eax
    bucle_comparar_strcmp:
        movb (%esi), %al
        subb (%edi), %al
        jnz fin_strcmp
        cmpb $0, (%esi)
        je fin_strcmp
        incl %esi
        incl %edi
        jmp bucle_comparar_strcmp
    fin_strcmp:
    popl %edi
    popl %esi
    leave
    ret $8
.globl strstr
.type strstr, @function
strstr:
    enter $0,$0
    pushl %esi
    pushl %edi
    pushl %ecx
    pushl %edx

    movl 8(%ebp), %esi
    movl 12(%ebp), %edi
    
    pushl %esi
    call strlen
    movl %eax, %ecx
    pushl %edi
    call strlen
    movl %eax, %edx
    cmpl %ecx, %eax
    jg no_encontrado_strstr

    xorl %ecx, %ecx
    xorl %eax, %eax
    bucle_buscar_strstr:
        movb (%esi), %al
        testb %al, %al
        jz no_encontrado_strstr
        cmpb %al, (%edi,%ecx,1)
        je seguir_buscando_strstr
            testl %ecx, %ecx
            jz sumar_indice_strstr
                xorl %ecx, %ecx
                jmp bucle_buscar_strstr
            sumar_indice_strstr:
            incl %esi
            jmp bucle_buscar_strstr
        seguir_buscando_strstr:
            incl %ecx
            incl %esi
            cmpl %edx, %ecx
            je encontrado_strstr
            jmp bucle_buscar_strstr
    encontrado_strstr:
        movl %esi, %eax
        subl %ecx, %eax
    fin_strstr:
    popl %edx
    popl %ecx
    popl %edi
    popl %esi
    leave
    ret $8
    no_encontrado_strstr:
        movl $0, %eax
        jmp fin_strstr
