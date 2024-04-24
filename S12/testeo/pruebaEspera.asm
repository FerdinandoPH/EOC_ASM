.data
    tiempoEspera: .long 2, 500000000
    inicio: .string "Esperamos...\n"
    lenInicio= .-inicio
    mensaje: .string "Hola mundo\n"
    lenMensaje= .-mensaje
.text
.global _start
_start:
    movl $4, %eax
    movl $1, %ebx
    movl $inicio, %ecx
    movl $lenInicio, %edx
    int $0x80
    movl $162, %eax
    movl $tiempoEspera, %ebx
    movl $0, %ecx
    int $0x80
    movl $4, %eax
    movl $1, %ebx
    movl $mensaje, %ecx
    movl $lenMensaje, %edx
    int $0x80
    movl $1, %eax
    movl $0, %ebx
    int $0x80
