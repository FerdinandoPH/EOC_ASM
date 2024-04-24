.data
    msg1: .string "Soy el hijo\n"
    l1= .-msg1
    msg2: .string "Soy el padre\n"
    l2= .-msg2
    tiempoEspera:.long 1,0
    idHijo:.long 0
    saltoLinea: .string "\n"
.text
.globl _start
_start:
    movl $2,%eax
    int $0x80
    testl %eax,%eax
    jnz padre
    hijo:


        movl $4,%eax
        movl $1,%ebx
        movl $msg1,%ecx
        movl $l1,%edx
        int $0x80
        movl $1,%eax
        movl $1,%ebx
        int $0x80
    padre:
    movl %eax,idHijo
            movl $162,%eax
    movl $tiempoEspera,%ebx
    movl $0,%ecx
    int $0x80
    movl $4,%eax
    movl $1,%ebx
    movl $msg2,%ecx
    movl $l2,%edx
    int $0x80
    movl $37,%eax
    movl idHijo,%ebx
    movl $15,%ecx
    int $0x80
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
    movl $1,%eax
    movl $0,%ebx
    int $0x80
