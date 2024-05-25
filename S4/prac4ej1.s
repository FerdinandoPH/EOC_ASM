.data
buf: .zero 10
buf2: .zero 10
nombre: .ascii "Inserte nombre "
edad: .ascii "Inserte edad "
repetir: .ascii "Desea continuar"
buf3: .zero 2
descriptor: int $0
personal: .string "personal.txt"
tabular: .ascii "\t"
lineanueva: .ascii "\n"
.text
.globl _start
_start:

movl $5, %eax
movl $personal, %ebx
movl $(01|02000|0100), %ecx
movl $0666, %edx
int $0x80

movl %eax, descriptor




bucle:

movl $4, %eax
movl $1, %ebx
movl $nombre, %ecx
movl $15, %edx
int $0x80

movl $3, %eax
movl $0, %ebx
movl $buf, %ecx
movl $10, %edx
int $0x80

movl %eax,%edx
movl $9,-1(%eax,%ecx)
movl $4, %eax
movl descriptor, %ebx
movl $buf, %ecx
int $0x80

#movl $4, %eax
#movl descriptor, %ebx
#movl $tabular, %ecx
#movl $1, %edx
#int $0x80

movl $4, %eax
movl $1, %ebx
movl $edad, %ecx
movl $13, %edx
int $0x80

movl $3, %eax
movl $0, %ebx
movl $buf2, %ecx
movl $10, %edx
int $0x80

movl %eax,%edx
movl $4, %eax
movl descriptor, %ebx
movl $buf2, %ecx
int $0x80

movl $4, %eax
movl descriptor, %ebx
movl $lineanueva, %ecx
movl $1, %edx
int $0x80

movl $4, %eax
movl $1, %ebx
movl $repetir, %ecx
movl $15, %edx
int $0x80

movl $3, %eax
movl $0, %ebx
movl $buf3, %ecx
movl $2, %edx
int $0x80

cmpb $'s', buf3
jne bucle




movl $6, %eax
movl descriptor, %ebx
int $0x80

movl $1, %eax
movl $0, %ebx
int $0x80
