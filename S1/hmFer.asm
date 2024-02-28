.data
msg:
.ascii "\n¡Hola, mundo!\n"
len = . - msg
fer:
.ascii "\nMe llamo Fernando :) \n"
len2= . - fer

.text
.global _start
_start:
movl $len, %edx
movl $msg, %ecx
movl $1, %ebx
movl $4, %eax
int $0x80

movl $len2, %edx
movl $fer, %ecx
movl $1, %ebx
movl $4, %eax
int $0x80

movl $0, %ebx
movl $1, %eax
int $0x80
