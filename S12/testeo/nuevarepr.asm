.data

    comando: .string "/usr/bin/play"

    argloc: .string "/usr/bin/play"
    argsonido: .string "./Recursos/t2.wav"
    argsSilencio: .string "-q"
    argv: .long argloc, argsonido, argsSilencio, 0
    mError: .string "Error al ejecutar el comando\n"
    lenMError = . - mError
    #args
        argc: .long 0
        argv_ori: .long 0
        envp: .long 0
.text

.global _start

_start:

    colecta_args:
        movl (%esp), %ecx
        movl %ecx, argc
        movl %esp, %ebx
        addl $4, %ebx
        movl %ebx, argv_ori
        llegar_a_envp:
            addl $4, %ebx
            loop llegar_a_envp
        addl $4, %ebx
        movl %ebx, envp

    movl $comando, %ebx
    movl $argv, %ecx
    movl envp, %edx
    movl $11, %eax
    leal 12(%esp), %esi
    int $0x80

    movl $4, %eax
    movl $1, %ebx
    movl $mError, %ecx
    movl $lenMError, %edx
    int $0x80

    movl $1, %eax
    movl $1, %ebx
    int $0x80
