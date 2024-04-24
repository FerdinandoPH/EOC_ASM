.global len_str
.global str_to_ul
.global print_str

# Devuelve el numero de caracteres de una cadena de texto ASCII.
# Argumentos:
#    1. cadena de texto acabada en 0 (NULL).
# Devuelve:
#    Devuelve en numero de caracteres (bytes) de la cadena (sin contar NULL).
len_str:
    # Nuevo marco de pila, sin variables locales
    enter $0, $0
    # Salvaguardar registros que modificamos
    pushl %ecx
    pushl %ebx

    movl 8(%ebp), %ebx # Cadena de texto (1er parametro)
    xorl %eax, %eax    # Valor de retorno en eax
 countchar:
    movb (%ebx, %eax), %cl
    incl %eax
    cmpb $0, %cl
    jne countchar
    decl %eax  # Descontar caracter NULL

    # Recuperar registros
    popl %ebx
    popl %ecx
    # Recuperar marco de pila
    leave
    # Retornar
    ret $4


# Devuelve un entero sin signo a partir de una cadena de texto.
# Argumentos:
#    1. cadena de texto ASCII acabada en NULL.
# Devuelve:
#    Devuelve el decimal sin signo de la cadena 
#    o 0xFFFF si hay desbordamiento o la cadena no es valida.
str_to_ul:
    # Nuevo marco de pila, sin variables locales
    enter $0, $0
    # Salvaguardar registros que modificamos
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi

    movl 8(%ebp), %ebx # Cadena de texto (1er parametro)
    pushl %ebx
    call len_str       # Longitud de la cadena
    movl %eax, %ecx
    xorl %eax, %eax
    xorl %edx, %edx
    xorl %esi, %esi
    movl $10, %edi
  nextdigit:
    mull %edi  # mul edx|eax=edi*eax
    jc overror
    movb (%ebx, %esi), %dl
	cmpb $'0', %dl
    jb overror
    cmpb $'9', %dl
    ja overror
    andb $0x0F, %dl  # subb $'0',%dl
    addl %edx, %eax
    jc overror
    incl %esi
    cmpl %ecx, %esi
    jne nextdigit
    # No hay desbordamiento
    jmp endstrul
 overror:
    movl $0xFFFF, %eax

 endstrul:
    # Recuperar registros
    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    # Recuperar marco de pila
    leave
    # Retornar
    ret $4


# Mostrar una cadena de texto por pantalla.
# Argumentos:
#    1. cadena de texto a mostrar.
# Devuelve:
#    Devuelve en numero de bytes mostrados.
print_str:
    # Nuevo marco de pila, sin variables locales
    push %ebp
    movl %esp, %ebp
    # Salvaguardar registros que modificamos
    pushl %edx
    pushl %ecx
    pushl %ebx

    # Mostrar por pantalla
    movl 8(%ebp), %ecx # Cadena de texto (1er parametro)
    push %ecx
    call len_str       # Longitud de la cadena
    movl %eax, %edx
    movl $4, %eax      # Escribir
    movl $1, %ebx      # por pantalla (stdout)
    int $0x80

    # Recuperar registros
    popl %ebx
    popl %ecx
    popl %edx
    # Recuperar marco de pila
    movl %ebp, %esp
    popl %ebp
    # Retornar, eax proporcionado por interrupcion
    ret $4
