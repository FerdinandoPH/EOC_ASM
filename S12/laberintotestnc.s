.data
   key:    .byte 0   # Ultima pulsacion de teclado
   pos:    .byte 2,2 # Fila, Columna actual
   goal:   .byte 1,2 # Fila, Columna de salida
   # Graficos
   wall:   .asciz "#" # Pared
   nowall: .asciz " " # Espacio libre
   player: .asciz "@" # Jugador
   meta: .asciz "X"   # Salida
   # Codigos ANSI
   position: .asciz "\033[02;02H" # Fila;Columna
   origen:   .asciz "\033[1;1H"   # Fila;Columna arriba-izquierda
   clear:    .asciz "\033[2J"     # Limpiar la terminal
   hidecur:  .asciz "\033[?25l"   # Ocultar el cursor
   showcur:  .asciz "\033[?25h"   # Mostrar el cursor
   nextline: .asciz "\033[1E"     # Pasar a siguiente linea
   # Textos
   victory: .asciz "Has conseguido llegar a la salida.\n"
   surrend: .asciz "Te has rendido.\n"
   # Datos del mapa
   mapfile: .long 0 # Archivo del mapa
   size: .long 5,4  # Tamaño del mapa en filas,columnas
   mapDefecto: .asciz "10111100011000111111"
   map: .asciz "10111100011000111111"
   FREE = '0' # Caracter que representa espacio libre
   baseTimer: .long 0,10000000
   deltaTime: .long 0
   thresholdMeta: .long 5
   dibujarX: .byte 1
   mensajePasos: .asciz "Pasos dados: "
   pasosDados: .long 0
   # No TOCAR 
   termiosnew: .space 18 # Configuracion de la terminal
   termiosold: .space 18
   # NO TOCAR
   descriptor: .long 0
   longitudArchivo: .long 0
   mensajeErrorTam: .asciz "El tamaño del mapa no es un cuadrado"
   mensajeErrorJug: .asciz "La posición del jugador no es válida"
   mensajeErrorMet: .asciz "La posición de la meta no es válida"
   buffer: .space 1
.text
.macro esperar tiempo
   movl $162,%eax
   movl \tiempo,%ebx
   movl $0,%ecx
   int $0x80
.endm
.macro salir num
   movl $1,%eax
   movl \num,%ebx
   int $0x80
.endm
.global _start
# ARGUMENTOS:
# 1º Nombre del programa
# 2º Archivo de mapa
# 3º Fila inicio
# 4º Columna inicio
# 5º Fila final
# 6º Columna final
_start:
   # TODO PROCESAR ARGUMENTOS
   popl %ecx
   cmpl $6, %ecx
   jne cargar_defecto

   # TODO LEER MAPA DESDE ARCHIVO
   popl %ebx
   popl %ebx
   movl $5, %eax
   movl $0,%ecx
   int $0x80
   movl %eax, descriptor
   movl $19, %eax
   movl descriptor, %ebx
   movl $0, %ecx
   movl $2, %edx
   int $0x80
   movl %eax, longitudArchivo
   movl $19, %eax
   movl descriptor, %ebx
   movl $0, %ecx
   movl $0, %edx
   int $0x80
   movl $map, %edi
   movl longitudArchivo,%esi
   cmpl $9801,%esi
   jle bucle_copia_mapa
      pushl $mensajeErrorTam
      call print_str
      salir $1

   bucle_copia_mapa:
      movl $3, %eax
      movl descriptor, %ebx
      movl $buffer, %ecx
      movl $1, %edx
      int $0x80
      cmpb $'\n', buffer
      je nueva_fila
         movb buffer, %dl
         movb %dl, (%edi)
         incl %edi
         incl (size+4)
         jmp iterar_copia_mapa
      nueva_fila:
         incl size
      iterar_copia_mapa:
      decl %esi
      jnz bucle_copia_mapa
   movl $6, %eax
   movl descriptor, %ebx
   int $0x80
   xorl %edx, %edx
   movl (size+4),%eax
   movl size,%ecx
   divl %ecx
   movl %eax, (size+4)

   popl %ebx
   pushl $10
   pushl %ebx
   call strtoint
   movl %eax, %ebx
   testl %ebx, %ebx
   jz error_pos_jugador
   cmpl size, %ebx
   jg error_pos_jugador
   movb %bl, (pos)
   orb $0x30, %bl
   movb %bl, (position+3)
   popl %ebx
   pushl $10
   pushl %ebx
   call strtoint
   movl %eax, %ebx
   testl %ebx, %ebx
   jz error_pos_jugador
   cmpl size, %ebx
   jg error_pos_jugador
   movb %bl, (pos+1)
   orb $0x30, %bl
   movb %bl, (position+6)
   jmp jugador_colocado_inicial
   error_pos_jugador:
      pushl $mensajeErrorJug
      call print_str
      salir $1
   jugador_colocado_inicial:
   popl %ebx
   pushl $10
   pushl %ebx
   call strtoint
   movl %eax, %ebx
   testl %ebx, %ebx
   jz error_pos_meta
   cmpl size, %ebx
   jg error_pos_meta
   movb %bl, (goal)
   decb %bl

   popl %ecx
   pushl $10
   pushl %ecx
   call strtoint
   movl %eax, %ecx
   testl %ecx, %ecx
   jz error_pos_meta
   cmpl size, %ecx
   jg error_pos_meta
   movb %cl, (goal+1)
   imull size,%ebx
   addl %ecx,%ebx
   decl %ebx
   addl $map, %ebx
   cmpb $'0', (%ebx)
   jne error_pos_meta
   jmp inicio
   error_pos_meta:
      pushl $mensajeErrorMet
      call print_str
      salir $1
   


   cargar_defecto:
   
   inicio:
   # Recuperar configuracion terminal
   movl $54, %eax
   movl $0, %ebx
   movl $0x5401, %ecx
   movl $termiosold, %edx
   int $0x80
   # Establecer nueva configuracion terminal
   movl $54, %eax
   movl $0, %ebx
   movl $0x5403, %ecx
   movl $termiosnew, %edx
   int $0x80
   # Limpiar terminal
   push $clear
   call print_str
   # Ocultar cursor
   push $hidecur
   call print_str


# BUCLE PRINCIPAL
mainLoop:
   # Limpiar pulsacion previa
   movb $0, (key)

   # Posicion 0,0 para mostrar mapa
   push $origen
   call print_str
   movl $162, %eax
   movl $baseTimer, %ebx
   movl $0, %ecx
   int $0x80
   movl deltaTime, %eax
   incl %eax
   movl %eax, deltaTime
   xorl %edx, %edx
   divl thresholdMeta
   testl %edx, %edx
   jnz fin_reloj_anim
      movl $0, deltaTime
   fin_reloj_anim:
      negb dibujarX
   # Mostrar mapa
   xorl %edi, %edi
nextRow:
   xorl %esi, %esi
nextCol:
   cmpb $1, dibujarX
   jne no_es_meta_render
      movl $meta, %ecx
      movl %edi, %eax
      incl %eax
      cmpb (goal), %al
      jne no_es_meta_render
      movl %esi, %eax
      incl %eax
      cmpb (goal+1), %al
      je displayPos
   no_es_meta_render:
   # Por defecto espacio libre    
   movl $nowall, %ecx
   movl %edi, %eax
   mull (size)
   cmpb $FREE, map(%esi,%eax)
   je displayPos
   movl $wall, %ecx

 displayPos:
   # Mostrar pared o libre
   movl $4, %eax
   movl $1, %ebx
   movl $1, %edx
   int $0x80
   # Avanzar por array
   incl %esi
   cmpl (size), %esi
   jne nextCol
   # Mover cursor abajo
   movl $4, %eax
   movl $1, %ebx
   movl $nextline, %ecx
   movl $4, %edx
   int $0x80
   # Mas filas
   incl %edi
   cmp (size+4), %edi
   jne nextRow
   
   push $mensajePasos
   call print_str
   pushl $10
   pushl pasosDados
   call inttostr
   pushl $stringResultado
   call print_str
   # Fijar posicion jugador
   
   push $position
   call print_str
   # Mostrar jugador
   push $player
   call print_str

   # Lectura teclado
   movl $3, %eax
   movl $0, %ebx
   movl $key, %ecx
   movl $1, %edx
   int $0x80

   # Comprobar pulsacion
   # MOVIMIENTO
   cmpb $'w', (key)
   je mov_up
   cmpb $'a', (key)
   je mov_left
   cmpb $'s', (key)
   je mov_down
   cmpb $'d', (key)
   je mov_right
   # SALIR
   cmpb $'q', (key)
   je fail
   
   # Comprobar meta
   movw (goal), %ax
   cmpw (pos), %ax
   je win
   
   # Sigue jugando
   jmp mainLoop
   
fail:
   push $surrend
   jmp end
   
win:
   push $victory

end:
   # Limpiar terminal
   push $clear
   call print_str
   # Cursor esquina izquierda-arriba
   push $origen
   call print_str
   # Recuperar estado terminal
   movl $54, %eax
   movl $0, %ebx
   movl $0x5403, %ecx
   movl $termiosold, %edx
   int $0x80
   # Mostrar el mensaje en pila
   call print_str
   # Mostrar cursor
   pushl $showcur
   call print_str
   # Retornar al SO
   movl $1, %eax
   movl $0, %ebx
   int $0x80


# TODO LOGICA DE CONTROL DEL JUGADOR
# TODO setCursorPos SERA SUBRUTINA, PROCESAR SALIDA
mov_up:
   decb (pos)
   call setCursorPos
   incl pasosDados
   testl %eax, %eax
   jnz fin_mov
      incb (pos)
      decl pasosDados
      jmp fin_mov

mov_down:
   incb (pos)
   call setCursorPos
   incl pasosDados
   testl %eax, %eax
   jnz fin_mov
      decb (pos)
      decl pasosDados
      jmp fin_mov

mov_right:
   incb (pos+1)
   call setCursorPos
   incl pasosDados
   testl %eax, %eax
   jnz fin_mov
      decb (pos+1)
      decl pasosDados
      jmp fin_mov

mov_left:
   decb (pos+1)
   call setCursorPos
   incl pasosDados
   testl %eax, %eax
   jnz fin_mov
      incb (pos+1)
      decl pasosDados
      jmp fin_mov
fin_mov:
movw (pos), %ax
cmpw (goal), %ax
je win
jmp mainLoop
    
# Establece la posicion del cursor con el codigo ANSI.
# Primero comprueba si es posible actualizar la posicion.
# Argumentos:
#    1. La posicion de la cadena de texto con el codigo ANSI \033[FILA;COLH.
#    2. Las coordenadas de la nueva posicion.
# Devuelve:
#    1 si la posicion es valida y se ha actualizado el codigo ANSI.
#    0 si la posicion no es alcanzable y no se ha actualizado el codigo ANSI.
.type setCursorPos, @function
setCursorPos:
   enter $0, $0
   pushl %ebx
   pushl %ecx
   # AH=fila, AL=columna
   movw (pos), %ax
   #Comprobar que no se salga
   cmpb (size), %al
   
   jg error_fuera_mapa
   cmpb (size+4), %ah
   jg error_fuera_mapa
   cmpb $0, %al
   jle error_fuera_mapa
   cmpb $0, %ah
   jle error_fuera_mapa
   jmp comprobar_paredes
   error_fuera_mapa:
      movl $0, %eax
      jmp fin_scp
   # TODO AMPLIAR A DOS CARACTERES CADA POSICION
   #Comprobar colisiones
   comprobar_paredes:
   xorl %ebx,%ebx
   movb %al, %bl
   decb %bl
   imull size,%ebx
   xorl %ecx,%ecx
   movb %ah, %cl
   addl %ecx, %ebx
   decl %ebx
   addl $map, %ebx
   cmpb $'1', (%ebx)
   jne ok_scp
       movl $0, %eax
       jmp fin_scp
   ok_scp:
   # Convertir a ASCII
   orb $0x30, %al
   orb $0x30, %ah
   # Actualizar codigo ANSI
   movb %al, (position+3)
   movb %ah, (position+6)
   movl $1,%eax
   # TODO VALOR DE RETORNO
   fin_scp:
   popl %ecx
   popl %ebx
   leave
   ret
# .type es_cuadrado_perfecto, @function
# es_cuadrado_perfecto:
#     enter $0, $0
#     flds 8(%ebp)         # Carga el número en la pila de punto flotante
#     fsqrt               # Calcula la raíz cuadrada
#     frndint             # Redondea al entero más cercano
#     subl $8, %esp
#     fistpl (%esp)       # Almacena el número entero en la pila
#     movl (%esp), %eax   # Mueve el número entero al registro eax
#     fld %st(0)          # Duplica el valor en la parte superior de la pila
#     fmul %st(0), %st(1) # Eleva al cuadrado el número entero
#     fcomip %st(1), %st(0) # Compara el resultado con el número original
#     fstp %st(0)         # Descarta el valor en la parte superior de la pila
#     jz fin_es_cuadrado_perfecto # Si el resultado es cero (los números son iguales), salta a es_cuadrado_perfecto
#     movl $0, %eax
#     jmp fin_es_cuadrado_perfecto
#     fin_es_cuadrado_perfecto:
#     addl $8, %esp
#     leave
#     ret $4
