.section .data
    # Comando a ejecutar
    mensaje: .string "El id del hijo musical es: "
    mensaje_len = . - mensaje
    mensajeFx: .string "El id del hijo de efectos es: "
    mensajeFx_len = . - mensajeFx
    saltoLinea: .string "\n"
    command_string: .asciz "/bin/bash"
    argument0: .asciz "bash"
    argument1: .asciz "-c"
    argument2: .asciz "play ./Recursos/gr.wav -q -t alsa repeat 999999999"
    argument3: .asciz "play --volume 0.2 ./Recursos/gb.wav -q -t alsa"
    argument4: .asciz "play ./Recursos/s.wav -q -t alsa"
    argumentsGr: .long argument0, argument1, argument2, 0
    argumentsGb: .long argument0, argument1, argument3, 0
    argumentsS: .long argument0, argument1, argument4, 0
    musID: .long 0
    fxID: .long 0
    initID: .long 0
    purgaEntradaID: .long 0
    mensajeParar: .string "Pulsa ENTER para parar: "
    mensajeParar_len = . - mensajeParar
    tiempoEspera: .long 2, 500000000
    tiempoPurga: .long 0, 100000000
    errorAudio: .string "\n\nError raro de audio de sox. Reabre el programa y se pasa\n"
    errorAudio_len = . - errorAudio
.bss
    .lcomm basura,1
    .lcomm estado,4
.section .text
.globl _start

_start:
    movl $2, %eax               # syscall number for fork
    int $0x80                   # realiza la llamada al sistema
    testl %eax, %eax            # comprueba si fork ha fallado
    jnz padre0
    movl $11, %eax              # syscall number for execve
    movl $command_string, %ebx  # path: Ruta del ejecutable de Bash
    movl $argumentsS, %ecx       # argv: Argumentos a pasar
    movl $0, %edx               # envp: Variables de entorno (NULL si no se necesitan)
    int $0x80                   # realiza la llamada al sistema
    padre0:
    movl %eax, initID
    movl initID, %ebx
    movl $7,%eax
    leal estado,%ecx
    movl $0,%edx
    int $0x80
    movl estado,%eax
    shrl $8,%eax
    testl %eax,%eax
    jz absorbe_enters
    movl $4,%eax
    movl $1,%ebx
    movl $errorAudio,%ecx
    movl $errorAudio_len,%edx
    int $0x80
    movl $1,%eax
    movl $1,%ebx
    int $0x80
    absorbe_enters:
    # pushl $10
    # pushl %eax
    # call inttostr
    # movl $4,%eax
    # movl $1,%ebx
    # movl $stringResultado,%ecx
    # movl $lenSR,%edx
    # int $0x80
    # movl $4,%eax
    # movl $1,%ebx
    # movl $saltoLinea,%ecx
    # movl $1,%edx
    # int $0x80
                movl $55, %eax               # syscall number for fcntl
    movl $0, %ebx                # file descriptor (stdin)
    movl $4, %ecx                # command (set flags)
    movl $2048, %edx             # flags (O_NONBLOCK)
    int $0x80                    # realiza la llamada al sistema
    purgar:
    # Leer de stdin
    movl $3, %eax                # syscall number for read
    movl $0, %ebx                # file descriptor (stdin)
    leal basura, %ecx            # buffer to read into
    movl $1, %edx                # number of bytes to read
    int $0x80  
    cmpl $-1, %eax
    jg purgar
        movl $55, %eax               # syscall number for fcntl
    movl $0, %ebx                # file descriptor (stdin)
    movl $4, %ecx                # command (set flags)
    movl $0, %edx                # flags (O_NONBLOCK removed)
    int $0x80 
    movl $2, %eax               # syscall number for fork
    int $0x80                   # realiza la llamada al sistema
    testl %eax, %eax            # comprueba si fork ha fallado
    jnz padre
    # Preparar la llamada al sistema execve
    movl $11, %eax              # syscall number for execve
    movl $command_string, %ebx  # path: Ruta del ejecutable de Bash
    movl $argumentsGr, %ecx       # argv: Argumentos a pasar
    movl $0, %edx               # envp: Variables de entorno (NULL si no se necesitan)

    int $0x80                   # realiza la llamada al sistema
    padre:
    movl %eax, musID
    movl $4,%eax
    movl $1,%ebx
    movl $mensaje,%ecx
    movl $mensaje_len,%edx
    int $0x80
    pushl $10
    pushl musID
    call inttostr
    movl $4,%eax
    movl $1,%ebx
    movl $stringResultado,%ecx
    movl $lenSR,%edx
    int $0x80
    movl $4,%eax
    movl $1,%ebx
    movl $saltoLinea,%ecx
    movl $1,%edx
    int $0x80
    movl $2,%eax
    int $0x80
    testl %eax, %eax
    jnz padre2
    movl $162, %eax
    movl $tiempoEspera, %ebx
    movl $0, %ecx
    int $0x80
    movl $11, %eax              # syscall number for execve
    movl $command_string, %ebx  # path: Ruta del ejecutable de Bash
    movl $argumentsGb, %ecx       # argv: Argumentos a pasar
    movl $0, %edx               # envp: Variables de entorno (NULL si no se necesitan)
    int $0x80                   # realiza la llamada al sistema
    padre2:
    movl %eax, fxID
    movl $4,%eax
    movl $1,%ebx
    movl $mensajeFx,%ecx
    movl $mensajeFx_len,%edx
    int $0x80
    pushl $10
    pushl fxID
    call inttostr
    movl $4,%eax
    movl $1,%ebx
    movl $stringResultado,%ecx
    movl $lenSR,%edx
    int $0x80
    movl $4,%eax
    movl $1,%ebx
    movl $saltoLinea,%ecx
    movl $1,%edx
    int $0x80
    movl $4,%eax
    movl $1,%ebx
    movl $mensajeParar,%ecx
    movl $mensajeParar_len,%edx
    int $0x80
    # movl $2,%eax
    # int $0x80
    # testl %eax, %eax
    # jnz padre3
    # bucle_limpia:
    #     movl $3,%eax
    #     movl $0,%ebx
    #     movl $basura,%ecx
    #     movl $1,%edx
    #     int $0x80
    #     jmp bucle_limpia
    # padre3:
    # movl %eax, purgaEntradaID
    # movl $162, %eax
    # movl $tiempoPurga, %ebx
    # movl $0, %ecx
    # int $0x80
    # movl $37,%eax
    # movl purgaEntradaID,%ebx
    # movl $9,%ecx
    # int $0x80

    movl $3,%eax
    movl $0,%ebx
    movl $basura,%ecx
    movl $1,%edx
    int $0x80

    pushl $10
    pushl basura
    call inttostr
    movl $4,%eax
    movl $1,%ebx
    movl $stringResultado,%ecx
    movl $lenSR,%edx
    int $0x80
    movl $4,%eax
    movl $1,%ebx
    movl $saltoLinea,%ecx
    movl $1,%edx
    int $0x80
    movl $37,%eax
    movl musID,%ebx
    movl $15,%ecx
    int $0x80
    movl $37,%eax
    movl fxID,%ebx
    movl $15,%ecx
    int $0x80
    # Si execve falla, terminar el programa
    movl $1, %eax               # syscall number for exit
    xorl %ebx, %ebx             # status 0 para la salida
    int $0x80                   # realiza la llamada al sistema
