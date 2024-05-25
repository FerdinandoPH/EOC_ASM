.data
    tiempoEspera: .long 0, 1000000000000
    cadena: .asciz "Hola Mundo\n"
    lenCadena= . - cadena
    saltoLinea: .asciz "\n"
.text
.global _start
_start:
    xorl %esi, %esi
    bucle:
    incl %esi
    pushl $10
    pushl %esi
    call inttostr_wrapper
    mov $4, %eax
    mov $1, %ebx
    mov $stringResultado, %ecx
    mov lenSR, %edx
    int $0x80
    movl $4, %eax
    movl $1, %ebx
    movl $saltoLinea, %ecx
    movl $1, %edx
    int $0x80
    movl $162, %eax
    movl $tiempoEspera, %ebx
    movl $0, %ecx
    int $0x80
    jmp bucle
