.text
.global _start
_start:
    movl $-1, %edx
    movl $-2147483648, %eax
    movl $2, %ebx
    #divl %ebx
    movl $-1, %edx
    movl $-2147483648, %eax
    movl $2, %ebx
    idivl %ebx
    movl $-1, %edx
    movl $-128, %eax
    movl $2, %ebx
    divl %ebx
    movl $-1, %edx
    movl $-128, %eax
    movl $2, %ebx
    idivl %ebx

    movl $1, %eax
    movl $0, %ebx
    int $0x80
