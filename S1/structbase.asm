.data

    a: .byte 1
    b: .long 0xFF // = 0x000000FF
    c: .word 0377 // = 0x00FF

    miMensaje: .ascii "¡Hola, mundo!\n"
    miCadena: .string "¡Hola, mundo!\n" //o .asciz, es igual
    len = . - miCadena // Posicion actual - inicio de miCadena = longitud de la cadena
    //Etiqueta != variable

.text

.global _start
_start:
    movl $4, %eax