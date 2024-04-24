.data
    saltoLinea: .asciz "\n"
    command_string: .asciz "/bin/bash"
    argument0: .asciz "bash"
    argument1: .asciz "-c"
    argument2: .asciz "which play > /dev/null 2>&1"
    arguments: .long argument0, argument1, argument2, 0
.bss
    .lcomm status,4
.text
.global _start
_start:
    # Crear un proceso hijo
    movl $2, %eax               # syscall number for fork
    int $0x80                   # realiza la llamada al sistema

    # Comprobar si estamos en el proceso hijo
    test %eax, %eax             # Compara el valor de retorno con 0
    jz child_process            # Si es igual a 0, salta a child_process

parent_process:
    # Aquí, %eax contiene el ID del proceso hijo
    movl %eax, %ebx
    # Esperar a que el proceso hijo termine
    movl $7, %eax               # syscall number for waitpid
                 # PID del proceso hijo
    movl $status, %ecx               # status: Puntero a la variable de estado (NULL si no se necesita)
    movl $0, %edx               # options: Opciones para waitpid (0 para ninguna opción)
    int $0x80                   # realiza la llamada al sistema
    movl status, %eax
    shrl $8, %eax
    pushl $10
    pushl %eax
    call inttostr
    movl $4, %eax               # syscall number for write
    movl $1, %ebx               # file descriptor for stdout
    movl $stringResultado, %ecx # buffer: Puntero al búfer de datos
    movl $lenSR, %edx               # count: Número de bytes a escribir
    int $0x80                   # realiza la llamada al sistema
    movl $4, %eax               # syscall number for write
    movl $1, %ebx               # file descriptor for stdout
    movl $saltoLinea, %ecx      # buffer: Puntero al búfer de datos
    movl $1, %edx               # count: Número de bytes a escribir
    int $0x80                   # realiza la llamada al sistema
    # Aquí, %eax contiene el valor de retorno de execve en el proceso hijo
    # Si es distinto de cero, significa que el comando falló y play no está instalado

    # Terminar el proceso padre
    movl $1, %eax               # syscall number for exit
    xorl %ebx, %ebx             # status 0 para la salida
    int $0x80                   # realiza la llamada al sistema

child_process:
    # Preparar la llamada al sistema execve
    movl $11, %eax              # syscall number for execve
    movl $command_string, %ebx  # path: Ruta del ejecutable de Bash
    movl $arguments, %ecx       # argv: Argumentos a pasar
    movl $0, %edx               # envp: Variables de entorno (NULL si no se necesitan)

    int $0x80 
