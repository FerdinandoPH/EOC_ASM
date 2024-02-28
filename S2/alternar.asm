.section .data
    prompt: .string "Escribe una cadena: "
    len1 = . - prompt
    msg: .string "Alternando mayúsculas y minúsculas, es: "
    len2 = . - msg
    warning: .string "Te has pasado de la longitud máxima (20 letras)\nAcortando a: "
    len3 = . - warning
    warning2: .string "Y dejando fuera: "
    len4 = . - warning2
.section .bss
    lenEntrada=21
    .lcomm entrada, lenEntrada
    .lcomm basura, 1
.section .text
    .globl _start

_start:
    # Print prompt
    movl $4, %eax
    movl $1, %ebx
    leal prompt, %ecx
    movl $len1, %edx
    int $0x80

    # Read input
    movl $3, %eax
    movl $0, %ebx
    leal entrada, %ecx
    movl $21, %edx
    int $0x80
    //Comprueba si queda algo en el buffer
    lea entrada, %eax
    addl $lenEntrada,%eax
    decl %eax
    cmpb $10, (%eax)
    je fin_purga
    cmpb $0, (%eax)
    je fin_purga
    //Si queda algo en el buffer, lo purga

    movl $4 , %eax
    movl $1, %ebx
    lea warning, %ecx
    movl $len3, %edx
    int $0x80
    //Cambia el último caracter a \n
    lea entrada, %eax
    addl $lenEntrada-1, %eax
    movb $10, (%eax)
    
    movl $4, %eax
    movl $1, %ebx
    lea entrada, %ecx
    movl $21, %edx
    int $0x80

    movl $4, %eax
    movl $1, %ebx
    lea warning2, %ecx
    movl $len4, %edx
    int $0x80

    purgar_buffer:
        movl $3, %eax
        movl $0, %ebx
        lea basura, %ecx
        movl $1, %edx
        int $0x80
        
        movl $4, %eax
        movl $1, %ebx
        lea basura, %ecx
        movl $1, %edx
        int $0x80

        cmpb $10,basura
        jne purgar_buffer

    fin_purga:
    # Print msg
    movl $4, %eax
    movl $1, %ebx
    leal msg, %ecx
    movl $len2, %edx
    int $0x80

    leal entrada,%ecx
    movl $0, %edi
    movl %ecx, %esi
longitud_y_alternar:
    cmpb $0, (%esi)
    je fin_longitud_y_alternar
    cmpb $65, (%esi)
    jl post_alternar
    cmpb $122, (%esi)
    jg post_alternar
    cmpb $90, (%esi)
    jg es_minuscula
    addb $32, (%esi)
    jmp post_alternar
es_minuscula:
    subb $32, (%esi)
    jmp post_alternar
post_alternar:
    incl %edi
    incl %esi
    jmp longitud_y_alternar
fin_longitud_y_alternar:

    # Print entrada
    movl $4, %eax
    movl $1, %ebx
    leal entrada, %ecx
    movl %edi, %edx
    int $0x80

    # Exit
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
