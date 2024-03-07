.section .data
    msgRes: .string "El resultado es: "
    lenMsgRes = . - msgRes
    saltoLinea: .ascii "\n"
    esPositivo: .string " (positivo)"
    esNegativo: .string " (negativo)"
    lenPN = 12
    msgError: .string "Error: desbordamiento\n"
    lenMsgError = . - msgError
.section .bss
    .lcomm stringResultado, 11
    .lcomm lenSR, 4


.section .text
.global _start
_start:
pushl %eax # salvo %eax puesto que se va a devolver un valor en ´el

pushl $32 # 2º argumento (tamaño 4 bytes)
pushl $-33 # 1er argumento (tamaño 4 bytes)

call suma # llamo a la subrutina suma
movl %eax, %ebx # salvo el valor devuelto en %ebx

addl $(2*4), %esp # limpio los argumentos

popl %eax # recupero %eax
cmpl $-1,%ebx
je error
pushl %ebx
call int_a_string
addl $4, %esp
pushl %ebx
movl $4, %eax
movl $1, %ebx
movl $msgRes, %ecx
movl $lenMsgRes, %edx
int $0x80
movl $4, %eax
movl $1, %ebx
movl $stringResultado, %ecx
movl lenSR, %edx
int $0x80
movl $4, %eax
movl $1, %ebx
popl %esi
cmpl $0,%esi
jge positivo
movl $esNegativo, %ecx
jmp seguirImpresion
positivo:
movl $esPositivo, %ecx
seguirImpresion:
movl $lenPN, %edx
int $0x80
movl $4, %eax
movl $1, %ebx
movl $saltoLinea, %ecx
movl $1, %edx
int $0x80
movl $0, %ebx
movl $1, %eax
int $0x80
error:
movl $4, %eax
movl $1, %ebx
movl $msgError, %ecx
movl $lenMsgError, %edx
int $0x80
movl $1, %eax
movl $0, %ebx
int $0x80
#-------------------------------------------------------------------
# int suma(int, int)
# Devuelve en un int la suma de 2 argumentos de tipo int
# o -1 en caso de desbordamiento
#-------------------------------------------------------------------
.type suma, @function # define el símbolo 'suma' como función (opcional)
.global suma # declara 'suma' como global (opcional)
suma:
pushl %ebp # salvo el marco de pila del llamador
movl %esp, %ebp # nuevo marco de pila

pushl %ebx # salvo %ebx puesto que se usa en la subrutina

movl 8(%ebp), %eax # copio el 1er argumento en %eax
movl 12(%ebp), %ebx # copio el 2º argumento en %ebx
addl %ebx, %eax # sumo ambos y lo salvo en %eax
jno salir
movl $-1, %eax # si hay desbordamiento cargo -1

salir:
popl %ebx # recupero %ebx

movl %ebp, %esp # soslayo variables locales (aunque no hay)
popl %ebp # recupero el marco de pila del llamador
ret # devuelvo el control al llamador
int_a_string:
            enter $0,$0
            pushl %esi
            pushl %eax
            pushl %ebx
            pushl %ecx
            pushl %edx
            pushl %edi
            movl %edi, %esi
            movl $0,lenSR
            movl $stringResultado, %edi
            movl $10, %ecx
            xorl %eax, %eax
            rep stosb
            movl %esi,%edi
            movl $stringResultado, %esi
            movl $10, %ecx
            movl 8(%ebp), %eax
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
                    movl 8(%ebp), %eax
                    jmp obtener_num_cifras
                    peligro_overflow:
                    movl $10, %ecx
                    jmp obtener_num_cifras 
            fin_obtener_num_cifras:
                addl $1, lenSR
                movl lenSR, %ecx
                movl 8(%ebp), %eax
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
            popl %edi
            popl %edx
            popl %ecx
            popl %ebx
            popl %eax
            popl %esi
            leave
            ret $4
