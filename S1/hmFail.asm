.data
msg:
.ascii "¡Hola, mundo!\n"
len = . - msg

.text
.global _start
_start:
movl $len, %edx
movl $msg, %ecx
movl $1, %ebx
movl $4, %eax
int $0x80