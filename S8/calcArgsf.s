.section .data
    igual: .ascii " = "
    saltoLinea: .ascii "\n"
    espacio: .ascii " "
    msgEC: .string "Error en los argumentos\n"
    lenMEC=.-msgEC
    restoMsg1: .string " (R = "
    lenR1=.-restoMsg1
    restoMsg2: .string ")"
    lenR2=.-restoMsg2
    ayuda: .string "Uso: calcArgs <base (opcional, 2-16, por defecto 10)> <numero1> <operacion> <numero2>\n\nLos números deben ser enteros\nLas operaciones soportadas son:\nSuma(+)\nResta(-)\nMultiplicacion(\\* o x)\nDivision(/, con cociente y resto)\nPotencia(^, con exponentes positivos)\n\n"
    lenAy=.-ayuda
    ovError: .string "Error: Número demasiado grande o división entre cero\n"
    lenOE=.-ovError
    msgBase: .string "Interpretando argumentos en base "
    lenMB=.-msgBase
    msgBDiez: .string " (en base 10: "
    lenBD=.-msgBDiez
.section .bss
    .lcomm num1,4
    .lcomm l1S,4
    .lcomm num2,4
    .lcomm opCode,1
    .lcomm lenEI,4
    .lcomm solucion,4
    .lcomm resto,4
    .lcomm base,4
    .lcomm parentesisFinal,1

.section .text
.extern inttostr
.extern strtoint
.globl _start
_start:
    popl %ecx
    cmpl $5,%ecx
    je obtener_args
    cmpl $4,%ecx
    jne errorArg
        popl %ebx
        movl $10,base
        jmp obtener_args_sin_base
    obtener_args:
    popl %ebx #Descartamos el nombre del programa
    #base
    popl %ebx

    pushl %edx
    pushl %eax
    pushl $10
    pushl %ebx
    call strtoint
    cmpl $-1,%edx
    je errorArg
    movl %eax,base
    popl %eax
    popl %edx

    movl $4,%eax
    movl $1,%ebx
    movl $msgBase,%ecx
    movl $lenMB,%edx
    int $0x80

    movl $4,%eax
    movl $1,%ebx
    pushl $10
    pushl base
    call inttostr_wrapper
    movl $stringResultado,%ecx
    movl lenSR,%edx
    int $0x80

    movl $4,%eax
    movl $1,%ebx
    movl $saltoLinea,%ecx
    movl $1,%edx
    int $0x80

    obtener_args_sin_base:
    #arg 1
    popl %ebx
    pushl %edx
    pushl %eax
    pushl base
    pushl %ebx
    call strtoint
    cmpl $-1,%edx
    je errorArg
    movl %eax,num1
    popl %eax
    popl %edx
    #operando
    popl %ebx
    pushl %ebx
    call obtener_longitud
    cmpl $1,%edx
    jne errorArg
    movb (%ebx),%al
    movb %al,opCode
    #arg 2
    popl %ebx

    pushl %edx
    pushl %eax
    pushl base
    pushl %ebx
    call strtoint
    cmpl $-1,%edx
    je errorArg
    movl %eax,num2
    popl %eax
    popl %edx
    determinar_operacion:
        movl $0,%edi
        movb opCode,%al
        cmpb $43,%al
        je suma
        cmpb $45,%al
        je resta
        cmpb $42,%al
        je multiplicacion
        cmpb $120,%al
        je multiplicacion
        cmpb $88,%al
        je multiplicacion
        cmpb $47,%al
        je division
        cmpb $94,%al
        je potencia
        jmp errorArg
    suma:
        movl num1,%eax
        addl num2,%eax
        jo errorNum
        movl %eax,solucion
        jmp imprimir_resultado
    resta:
        movl num1,%eax
        subl num2,%eax
        jo errorNum
        movl %eax,solucion
        jmp imprimir_resultado
    multiplicacion:
        movl num1,%eax
        imull num2,%eax
        jo errorNum
        movl %eax,solucion
        jmp imprimir_resultado
    division:
        movl $1,%edi
        movl num1,%eax
        movl num2,%ecx
        cmpl $0,%ecx
        je errorNum
        movl $0,%edx
        cmpl $0,%eax
        setl %dl
        imull $-1,%edx
        idivl %ecx
        jo errorNum
        movl %eax,solucion
        cmpl $0,%edx
        jge ya_es_positivo
            negl %edx
        ya_es_positivo:
        movl %edx,resto
        jmp imprimir_resultado
    potencia:
        cmpl $0,num2
        jl errorArg
        movl num2,%ecx
        movl $1,%eax
        calculo_potencia:
            imull num1,%eax
            jo errorNum
            loop calculo_potencia
        movl %eax,solucion
        jmp imprimir_resultado
    imprimir_resultado:
        pushl base
        pushl num1
        call inttostr
        cmpl $0,lenSR
        je errorArg
        movl $4,%eax
        movl $1,%ebx
        movl $stringResultado,%ecx
        movl lenSR,%edx
        int $0x80

        movl $4,%eax
        movl $1,%ebx
        movl $espacio,%ecx
        movl $1,%edx
        int $0x80

        movl $4,%eax
        movl $1,%ebx
        movl $opCode,%ecx
        movl $1,%edx
        int $0x80

        movl $4,%eax
        movl $1,%ebx
        movl $espacio,%ecx
        movl $1,%edx
        int $0x80
        pushl base
        pushl num2
        call inttostr
        cmpl $0,lenSR
        je errorArg
        movl $4,%eax
        movl $1,%ebx
        movl $stringResultado,%ecx
        movl lenSR,%edx
        int $0x80

        movl $4,%eax
        movl $1,%ebx
        movl $igual,%ecx
        movl $3,%edx
        int $0x80

        pushl base
        pushl solucion
        call inttostr
        cmpl $0,lenSR
        je errorArg
        movl $4,%eax
        movl $1,%ebx
        movl $stringResultado,%ecx
        movl lenSR,%edx
        int $0x80

        cmpl $1,%edi
        jne finalizar
            movl $4,%eax
            movl $1,%ebx
            movl $restoMsg1,%ecx
            movl $lenR1,%edx
            int $0x80
            pushl base
            pushl resto
            call inttostr
            cmpl $0,lenSR
            je errorArg
            movl $4,%eax
            movl $1,%ebx
            movl $stringResultado,%ecx
            movl lenSR,%edx
            int $0x80
            movl $4,%eax
            movl $1,%ebx
            movl $restoMsg2,%ecx
            movl $lenR2,%edx
            int $0x80
    finalizar:
    cmpl $10,base
    je verdadero_fin
        movl $4,%eax
        movl $1,%ebx
        movl $msgBDiez,%ecx
        movl $lenBD,%edx
        int $0x80
        movb $1,parentesisFinal
        movl $10, base
        jmp imprimir_resultado
    verdadero_fin:
    xorl %eax,%eax
    movb parentesisFinal,%al
    testb %al,%al
    jz no_cerrar_parentesis
        movl $4,%eax
        movl $1,%ebx
        movl $restoMsg2,%ecx
        movl $lenR2,%edx
        int $0x80
    no_cerrar_parentesis:
    movl $4,%eax
    movl $1,%ebx
    movl $saltoLinea,%ecx
    movl $1,%edx
    int $0x80

    movl $1,%eax
    movl $0,%ebx
    int $0x80
.type obtener_longitud, @function
obtener_longitud:
    enter $0,$0
    pushl %esi
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edi

    movl 8(%ebp), %esi
    movl $0, %edx
    longitud:
        movb (%esi), %al
        cmpb $0, %al
        je fin_longitud
        incl %edx
        incl %esi
        jmp longitud
    fin_longitud:
    popl %edi
    popl %ecx
    popl %ebx
    popl %eax
    popl %esi
    leave
    ret $4
errorArg:
    movl $4, %eax
    movl $1, %ebx
    movl $msgEC, %ecx
    movl $lenMEC, %edx
    int $0x80

    movl $4, %eax
    movl $1, %ebx
    movl $ayuda, %ecx
    movl $lenAy, %edx
    int $0x80

    movl $1, %eax
    movl $1, %ebx
    int $0x80
errorNum:
    movl $4, %eax
    movl $1, %ebx
    movl $ovError, %ecx
    movl $lenOE, %edx
    int $0x80
    movl $1, %eax
    movl $1, %ebx
    int $0x80
