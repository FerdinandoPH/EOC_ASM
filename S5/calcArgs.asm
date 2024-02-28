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
    ayuda: .string "Uso: calcArgs <numero1> <operacion> <numero2>\n\nLos números deben ser enteros\nLas operaciones soportadas son:\nSuma(+)\nResta(-)\nMultiplicacion(\\* o x)\nDivision(/, con cociente y resto)\nPotencia(^, con exponentes positivos)\n\n"
    lenAy=.-ayuda
    ovError: .string "Error: Número demasiado grande o división entre cero\n"
    lenOE=.-ovError
.section .bss
    .lcomm stringResultado, 11
    .lcomm lenSR, 4
    .lcomm num1,4
    .lcomm l1S,4
    .lcomm num2,4
    .lcomm opCode,1
    .lcomm lenEI,4
    .lcomm basura,1
    .lcomm solucion,4
    .lcomm resto,4

.section .text
.globl _start
_start:
    popl %ecx
    cmpl $4,%ecx
    je obtener_args
        jmp errorArg
    obtener_args:
    popl %ebx #Descartamos el nombre del programa
    #arg 1
    popl %ebx

    pushl %ebx
    call obtener_longitud
    addl $4,%esp

    pushl $num1
    pushl %edx
    pushl %ebx
    call string_a_int
    addl $12,%esp

    #operando
    popl %ebx
    movb (%ebx),%al
    movb %al,opCode
    #arg 2
    popl %ebx
    pushl %ebx
    call obtener_longitud
    addl $4,%esp

    pushl $num2
    pushl %edx
    pushl %ebx
    call string_a_int
    addl $12,%esp
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
        pushl num1
        call int_a_string
        addl $4,%esp
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

        pushl num2
        call int_a_string
        addl $4,%esp
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

        pushl solucion
        call int_a_string
        addl $4,%esp
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
            pushl resto
            call int_a_string
            addl $4,%esp
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
    movl $4,%eax
    movl $1,%ebx
    movl $saltoLinea,%ecx
    movl $1,%edx
    int $0x80

    movl $1,%eax
    movl $0,%ebx
    int $0x80
.type int_a_string, @function
int_a_string:
            pushl %esi
            pushl %eax
            pushl %ebx
            pushl %ecx
            pushl %edx
            pushl %edi
            pushl %ebp
            movl %esp, %ebp
            movl %edi, %esi
            movl $0,lenSR
            movl $stringResultado, %edi
            movl $10, %ecx
            xorl %eax, %eax
            rep stosb
            movl %esi,%edi
            movl $stringResultado, %esi
            movl $10, %ecx
            movl 32(%ebp), %eax
            obtener_num_cifras:
                movl $0, %edx
                cmpl $0, %eax
                setl %dl
                imull $-1, %edx
                idivl %ecx
                cmpl $0, %eax
                je fin_obtener_num_cifras
                    addl $1, lenSR
                    cmpl $1000000000,%ecx
                    jge peligro_overflow
                    imull $10, %ecx
                    movl 32(%ebp), %eax
                    jmp obtener_num_cifras
                    peligro_overflow:
                    movl $10, %ecx
                    jmp obtener_num_cifras 
            fin_obtener_num_cifras:
                addl $1, lenSR
                movl lenSR, %ecx
                movl 32(%ebp), %eax
                cmpl $0, %eax
                jge colocar_cifras
                    movb $45, (%esi)
                    negl %eax
                    incl lenSR
                    incl %esi
            colocar_cifras:
                movl $10, %ebx
                movl $0, %edx
                divl %ebx
                addl $48, %edx
                movb %dl, -1(%esi, %ecx)
                loop colocar_cifras
            movl %ebp, %esp
            popl %ebp
            popl %edi
            popl %edx
            popl %ecx
            popl %ebx
            popl %eax
            popl %esi
            ret
.type string_a_int, @function
string_a_int:
    
    pushl %esi
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %edi
    pushl %ebp
    movl %esp, %ebp


    movl 36(%ebp),%eax
    movl %eax,lenEI

    xorl %eax,%eax

    
    movl $lenEI,%ecx
    movl (%ecx),%ecx
    movl 32(%ebp), %esi
    movl 40(%esp), %ebx
    comparar_signo:
        movb (%esi),%al
        cmpb $45,%al
        jne proceso_conversion
            incl %esi
            decl lenEI
            decl %ecx
    proceso_conversion:
        movl $0,%eax
        movb (%esi),%al
        cmpb $48,%al
        jl errorArg
        cmpb $57,%al
        jg errorArg
        subl $48,%eax
        movl %ecx,%edx
        decl %ecx
        basificacion:
            cmpl $0,%ecx
            je fin_basificacion
            imull $10,%eax
            jo errorNum
            decl %ecx
            jmp basificacion
        fin_basificacion:
        movl %edx,%ecx
        incl %esi
        addl %eax,(%ebx)
        loop proceso_conversion
    movl 32(%ebp),%eax
    movb (%eax),%al
    cmpb $45,%al
    jne fin_string_a_int
        negl (%ebx)
    fin_string_a_int:
    movl %ebp, %esp
    popl %ebp
    popl %edi
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax
    popl %esi
    ret
.type purgar_buffer, @function
purgar_buffer:
    # movl $4, %eax
    # movl $1, %ebx
    #movl $warningBuffer, %ecx
    # movl $lenWB, %edx
    # int $0x80
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi
    pushl %ebp
    movl %esp, %ebp
    movl $3, %eax
    movl $0, %ebx
    movl $basura, %ecx
    movl $1, %edx
    int $0x80
    lea basura,%esi
    cmpb $10, (%esi)
    jne purgar_buffer
    movl %ebp, %esp
    popl %ebp
    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax
    ret
.type obtener_longitud, @function
obtener_longitud:
    pushl %esi
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edi
    pushl %ebp
    movl %esp, %ebp

    movl 28(%ebp), %esi
    movl $0, %edx
    longitud:
        movb (%esi), %al
        cmpb $0, %al
        je fin_longitud
        incl %edx
        incl %esi
        jmp longitud
    fin_longitud:
    movl %ebp, %esp
    popl %ebp
    popl %edi
    popl %ecx
    popl %ebx
    popl %eax
    popl %esi
    ret
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
