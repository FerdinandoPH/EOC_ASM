.section .data
    prompt: .string "Escribe una cadena: "
    len1 = . - prompt
    msgMin: .string "En minúsculas, es: "
    lenMin = . - msgMin
    msgMay: .string "En mayúsculas, es: "
    lenMay = . - msgMay
    msgAlt: .string "Alternando, es: "
    lenAlt = . - msgAlt
    warning: .string "Te has pasado de la longitud máxima (20 letras)\nAcortando a: "
    len3 = . - warning
    warning2: .string "Y dejando fuera: "
    len4 = . - warning2
.section .bss
    lenEntrada=21
    .lcomm entrada, lenEntrada
    .lcomm minus, lenEntrada
    .lcomm mayus, lenEntrada
    .lcomm alt, lenEntrada
    .lcomm basura, 1
.section .text
    .globl _start

_start:
    movl $4, %eax
    movl $1, %ebx
    leal prompt, %ecx
    movl $len1, %edx
    int $0x80

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

    
    movl $4, %eax
    movl $1, %ebx
    lea entrada, %ecx
    movl $lenEntrada-1, %edx
    int $0x80

    movl $4, %eax
    movl $1, %ebx
    lea warning2, %ecx
    movl $len4, %edx
    int $0x80

    lea entrada, %ecx
    addl $lenEntrada-1, %ecx
    movl $4, %eax
    movl $1, %ebx
    movl $1, %edx
    int $0x80
        //Cambia el último caracter a \n
    // lea entrada, %eax
    // addl $lenEntrada-1, %eax
    movb $10, (%ecx)

    purgar_buffer:
        movl $3, %eax
        movl $0, %ebx
        lea basura, %ecx
        movl $1, %edx
        int $0x80
        
        movl $4, %eax
        movl $1, %ebx
        leal basura, %ecx
        movl $1, %edx
        int $0x80

        cmpb $10,basura
        jne purgar_buffer

    fin_purga:     
    movl $0, %edi
    cambio4en4:
        // movl %esi,%edx
        // subl %edi, %edx
        // addl $3, %edx
        cmpl $lenEntrada-4, %edi
        jge pasitos
        leal entrada, %esi
        addl %edi, %esi
        movl (%esi), %eax
        movl %eax, %ebx
        shrl $24, %ebx
        cmpb $0, %bl
        je pasitos
        cmpb $10, %bl
        je pasitos
        //minus
        movl %eax,%edx
        orl $0x20202020, %edx
        lea minus, %esi
        addl %edi, %esi
        movl %edx, (%esi)
        //mayus
        movl %eax,%edx
        andl $0xDFDFDFDF, %edx
        lea mayus, %esi
        addl %edi, %esi
        movl %edx, (%esi)
        //alt
        movl %eax,%edx
        xorl $0x20202020, %edx
        lea alt, %esi
        addl %edi, %esi
        movl %edx, (%esi)
        /--
        addl $4, %edi 
        jmp cambio4en4 
    pasitos:
        leal entrada, %esi
        addl %edi, %esi
        movb (%esi), %al
        cmpb $10, %al
        je fin_cambio4en4
        //minus
        movb %al, %ah
        orb $0x20, %ah
        leal minus, %esi
        addl %edi, %esi
        movb %ah, (%esi)
        //mayus
        movb %al, %ah
        andb $0xDF, %ah
        leal mayus, %esi
        addl %edi, %esi
        movb %ah, (%esi)
        //alt
        movb %al, %ah
        xorb $0x20, %ah
        leal alt, %esi
        addl %edi, %esi
        movb %ah, (%esi)
        /--
        incl %edi
        jmp pasitos
    fin_cambio4en4:
    //metemos salto de línea al final
    leal minus, %esi
    addl %edi, %esi
    movb $10, (%esi)
    leal mayus, %esi
    addl %edi, %esi
    movb $10, (%esi)
    leal alt, %esi
    addl %edi, %esi
    movb $10, (%esi)
    //imprimimos
    
    //minus
    movl $4, %eax
    movl $1, %ebx
    leal msgMin, %ecx
    movl $lenMin, %edx
    int $0x80

    movl $4, %eax
    movl $1, %ebx
    leal minus, %ecx
    movl $lenEntrada, %edx
    int $0x80
    //mayus
    movl $4, %eax
    movl $1, %ebx
    leal msgMay, %ecx
    movl $lenMay, %edx
    int $0x80

    movl $4, %eax
    movl $1, %ebx
    leal mayus, %ecx
    movl $lenEntrada, %edx
    int $0x80
    //alt
    movl $4, %eax
    movl $1, %ebx
    leal msgAlt, %ecx
    movl $lenAlt, %edx
    int $0x80

    movl $4, %eax
    movl $1, %ebx
    leal alt, %ecx
    movl $lenEntrada, %edx
    int $0x80




    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
