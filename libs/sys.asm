.text
.global salir
salir:
    movl $1, %eax
    movl $0, %ebx
    int $0x80