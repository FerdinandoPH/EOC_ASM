.section .data
    msgEnter: .string "Introduce el caracter: "
    lenME = . - msgEnter
    msgDetectado: .string "Escapando a UTF-8\n"
    lenMD = . - msgDetectado
.section bss
    .lcomm buffer,4
    .lcomm basura,1
.section .text
    .globl _start
    _start:
        mov $4,%eax
        mov $1,%ebx
        mov $msgEnter,%ecx
        mov $lenME,%edx
        int $0x80
        mov $3,%eax
        mov $0,%ebx
        mov $buffer,%ecx
        mov $4,%edx
        int $0x80
        movb 4(%ecx),%bl
        cmpb $10,%bl
        je sigue
        cmpb $0,%bl 
        je sigue
            call purgar_buffer
        sigue:
        movl $buffer,%ecx
        movb (%ecx),%al
        cmpb $0xC3,%al
        jne noUTF8
            movl $4,%eax
            movl $1,%ebx
            movl $msgDetectado,%ecx
            movl $lenMD,%edx
            int $0x80
        noUTF8:
        movl $4,%eax
        movl $1,%ebx
        movl $buffer,%ecx
        movl $4,%edx
        int $0x80

        mov $1,%eax
        mov $0,%ebx
        int $0x80

.type purgar_buffer, @function
purgar_buffer:
    # movl $4, %eax
    # movl $1, %ebx
    #movl $warningBuffer, %ecx
    # movl $lenWB, %edx
    # int $0x80

    movl $3, %eax
    movl $0, %ebx
    movl $basura, %ecx
    movl $1, %edx
    int $0x80
    lea basura,%esi
    cmpb $10, (%esi)
    jne purgar_buffer
    ret
