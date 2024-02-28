.section .data
    msgBorrar: .string "¿Qué línea quieres borrar?: "
    lenMB=.-msgBorrar
    msgEC: .string "Línea inválida\n"
    lenMEC=.-msgEC
.section .bss
    .lcomm entradaLB, 10
    .lcomm lineaABorrar,4
    .lcomm lenEB,4
    .lcomm basura,1
.section .text
    .globl _start
_start:
    borrar_linea:
        movl $4, %eax
        movl $1, %ebx
        movl $msgBorrar, %ecx
        movl $lenMB, %edx
        int $0x80

        movl $3, %eax
        movl $0, %ebx
        movl $entradaLB, %ecx
        movl $10, %edx
        int $0x80

        lea lenEB, %esi
        movl %eax, (%esi)
        lea entradaLB, %esi
        addl %eax, %esi
        decl %esi
        cmpl $10,(%esi)
        je convertir_a_entero
        lea lenEB, %esi
        incl (%esi)
        call purgar_buffer
        convertir_a_entero:
            
            movl $lenEB,%ecx
            movl (%ecx),%ecx
            decl %ecx
            lea entradaLB, %esi
            lea lineaABorrar, %ebx
            proceso_conversion:
                movb (%esi),%al
                cmpb $48,%al
                jl error_conversion
                cmpb $57,%al
                jg error_conversion
                subl $48,%eax
                movl %ecx,%edx
                decl %ecx
                basificacion:
                    cmpl $0,%ecx
                    je fin_basificacion
                    imull $10,%eax
                    decl %ecx
                    jmp basificacion
                fin_basificacion:
                movl %edx,%ecx
                incl %esi
                addl %eax,(%ebx)
                loop proceso_conversion
                cmpb $0,(%ebx)
                jle error_conversion
            jmp fin_conversion_entero
            error_conversion:
                movl $4, %eax
                movl $1, %ebx
                movl $msgEC, %ecx
                movl $lenMEC, %edx
                int $0x80
                movl $0, %eax
                movl %edi,%esi
                lea entradaLB,%edi
                movl $10,%ecx
                rep stosb
                movl %esi,%edi
                jmp borrar_linea
            fin_conversion_entero:
            movl $1, %eax
            movl $0, %ebx
            int $0x80

    purgar_buffer:
        movl $3, %eax
        movl $0, %ebx
        movl $basura, %ecx
        movl $1, %edx
        int $0x80
        lea basura,%esi
        cmpb $10, (%esi)
        jne purgar_buffer
        ret
