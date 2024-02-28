.section .data
filename: .string "registro.txt"
buffer: .space 1024
stat: .space 88 # espacio para la estructura stat
saltoLinea: .ascii "\n"
.section .text
.globl _start

_start:
    # Abrir el archivo
    movl $5, %eax # sys_open
    movl $filename, %ebx # nombre del archivo
    movl $0, %ecx # O_RDONLY
    int $0x80

    # Guardar el descriptor del archivo
    movl %eax, %edi

    # Obtener la información del archivo
    movl $19, %eax
    movl %edi, %ebx
    movl $0, %ecx
    movl $2, %edx
    int $0x80

    movl %eax, %esi

    movl $19, %eax
    movl %edi, %ebx
    movl $0, %ecx
    movl $0, %edx
    int $0x80

read_loop:
    # Leer el contenido del archivo
    movl $3, %eax # sys_read
    movl %edi, %ebx # descriptor del archivo
    movl $buffer, %ecx # buffer
    movl $2, %edx # tamaño del buffer
    int $0x80

    # Guardar el número de bytes leídos
    movl %eax, %edx

    # Escribir el contenido del buffer en la salida estándar
    movl $4, %eax # sys_write
    movl $1, %ebx # descriptor de la salida estándar
    movl $buffer, %ecx # buffer
    int $0x80

    # Restar el número de bytes leídos del tamaño total
    subl %edx, %esi

    # Si aún quedan bytes por leer, volver al inicio del bucle
    cmpl $0, %esi
    jg read_loop

    # Cerrar el archivo
    movl $6, %eax # sys_close
    movl %edi, %ebx # descriptor del archivo
    int $0x80

    movl $4, %eax
    movl $1, %ebx
    movl $saltoLinea, %ecx
    movl $1, %edx
    int $0x80

    # Salir del programa
    movl $1, %eax # sys_exit
    xorl %ebx, %ebx # código de salida
    int $0x80
