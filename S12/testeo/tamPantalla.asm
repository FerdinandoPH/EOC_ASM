.section .data
winsize:
    .skip 8

.section .text
.globl _start
_start:
    movl $54, %eax
    movl $0, %ebx
    movl $0x5413, %ecx
    movl $winsize, %edx
    int $0x80  
        # Now, the winsize struct is filled with the size of the terminal.
    # The number of columns is in the first two bytes, and the number of rows is in the next two bytes.
    movl winsize,%eax
    shrl $16,%eax
    pushl $10
    pushl %eax
    call inttostr
    movl $4, %eax        # The syscall number for write is 4
    movl $1, %ebx        # File descriptor 1 is stdout
    movl $stringResultado,%ecx
    movl $lenSR,%edx
    int $0x80
    
    movl $1, %eax        # The syscall number for exit is 1
    xorl %ebx, %ebx      # Return 0
    int $0x80
    