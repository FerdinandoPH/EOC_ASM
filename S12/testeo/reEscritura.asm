.data
    incioMensaje: .string "Estoy contando: "
    lenIM=.-incioMensaje
    saltoLinea: .asciz "\n"
    retrocesoLinea: .asciz "\r"
    subeLinea: .asciz "\033[A"
    tiempo: .long 0,100000000
.text
.global _start
_start:
    movl $1, %eax
    bucle:
    pushl $10
    pushl %eax
    call inttostr
    pushl %eax
    movl $4, %eax
    movl $1, %ebx
    movl $incioMensaje, %ecx
    movl $lenIM, %edx
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
    movl $4, %eax
    movl $1, %ebx
    movl $saltoLinea, %ecx
    movl $1, %edx
    int $0x80
    movl $162, %eax
    movl $tiempo, %ebx
    movl $0, %ecx
    int $0x80
    popl %eax
    cmpl $101, %eax
    jge fin
        pushl %eax
        movl $4, %eax
        movl $1, %ebx
        movl $retrocesoLinea, %ecx
        movl $1, %edx
        int $0x80
        movl $4, %eax
        movl $1, %ebx
        movl $subeLinea, %ecx
        movl $3, %edx
        int $0x80
        movl $4, %eax
        movl $1, %ebx
        movl $subeLinea, %ecx
        movl $3, %edx
        int $0x80
        popl %eax
        incl %eax
        jmp bucle
# .data
#     incioMensaje: .string "Estoy contando: "
#     lenIM=.-incioMensaje
#     saltoLinea: .asciz "\n"
#     retrocesoLinea: .asciz "\r\033[K"  # Mover al inicio de la línea y borrarla
#     subeLinea: .asciz "\033[A"
#     tiempo: .long 0,500000000
# .text
# .global _start
# _start:
#     movl $1, %eax
#     bucle:
#     pushl $10
#     pushl %eax
#     call inttostr
#     pushl %eax
#     movl $4, %eax
#     movl $1, %ebx
#     movl $incioMensaje, %ecx
#     movl $lenIM, %edx
#     int $0x80
#     movl $4, %eax
#     movl $1, %ebx
#     movl $stringResultado, %ecx
#     movl $lenSR, %edx
#     int $0x80
#     movl $4, %eax
#     movl $1, %ebx
#     movl $saltoLinea, %ecx
#     movl $1, %edx
#     int $0x80
#     movl $4, %eax
#     movl $1, %ebx
#     movl $saltoLinea, %ecx
#     movl $1, %edx
#     int $0x80
#     movl $162, %eax
#     movl $tiempo, %ebx
#     movl $0, %ecx
#     int $0x80
#     cmpl $101, %eax
#     jge fin
#         movl $4, %eax
#         movl $1, %ebx
#         movl $retrocesoLinea, %ecx
#         movl $3, %edx  # La longitud de la secuencia de escape es 3
#         int $0x80
#         movl $4, %eax
#         movl $1, %ebx
#         movl $subeLinea, %ecx
#         movl $3, %edx  # La longitud de la secuencia de escape es 3
#         int $0x80
#         movl $4, %eax
#         movl $1, %ebx
#         movl $subeLinea, %ecx
#         movl $3, %edx  # La longitud de la secuencia de escape es 3
#         int $0x80
#         popl %eax
#         incl %eax
#         jmp bucle
    fin:
    #popl %eax
    movl $1, %eax
    movl $0, %ebx
    int $0x80
