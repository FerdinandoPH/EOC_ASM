.data
    saltoLinea: .string "\n"
    command_string: .asciz "/bin/bash"
    argument0: .asciz "bash"
    argument1: .asciz "-c"
    argument2: .asciz "play ./Recursos/pr.wav -q -t alsa >> /dev/null 2>&1"
    argument3: .asciz "play --volume 0.2 ./Recursos/gb.wav -t alsa"
    argument4: .asciz "fuser -k /dev/snd/*"
    argumentsPr: .long argument0, argument1, argument2, 0
    mensajeParar: .asciz "Pulsa Enter para parar la reproduccion"
    lenMP= .-mensajeParar
.bss
    .lcomm estado,4
    .lcomm basura,1
.text
.global _start
_start:
    mov $2,%eax
    int $0x80
    testl %eax,%eax
    jnz padre
        movl $11,%eax
        movl $command_string,%ebx
        movl $argumentsPr,%ecx
        movl $0,%edx
        int $0x80
    padre:
        movl %eax,%ebx
        movl $7,%eax
        movl $estado,%ecx
        movl $0,%edx
        int $0x80
        movl estado,%eax
        shrl $8,%eax
        pushl $10
        pushl %eax
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
    movl $4,%eax
    movl $1,%ebx
    movl $mensajeParar,%ecx
    movl $lenMP,%edx
    int $0x80
    movl $3,%eax
    movl $0,%ebx
    leal basura,%ecx
    movl $1,%edx
    int $0x80
        movl $1,%eax
        movl $0,%ebx
        int $0x80


