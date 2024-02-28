.data
msg: .ascii "Hola mundo\n"
lenM= .-msg
ruta: .string "hola.txt\0"
lenR= .-ruta
.section .text
.globl _start
_start:
    movl $5, %eax
    movl $ruta, %ebx
    movl $0x41, %ecx
    movl $0666,%edx
    int $0x80
    
    movl %eax, %ebx
    movl $4, %eax
    lea msg, %ecx
    movl $lenM, %edx
    int $0x80

    movl $6 , %eax
    
    int $0x80

    movl $1, %eax
    movl $0, %ebx
    int $0x80

