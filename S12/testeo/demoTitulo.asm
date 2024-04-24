.section .data
    #titulo
        titulo1:  .asciz " ####### #          #          #    ######  ####### ######  ### #     # ####### ####### \n"
        lenLineaTitulo=.-titulo1
        titulo2:  .asciz " #       #          #         # #   #     # #       #     #  #  ##    #    #    #     # \n"
        titulo3:  .asciz " #       #          #        #   #  #     # #       #     #  #  # #   #    #    #     # \n"
        titulo4:  .asciz " #####   #          #       #     # ######  #####   ######   #  #  #  #    #    #     # \n"
        titulo5:  .asciz " #       #          #       ####### #     # #       #   #    #  #   # #    #    #     # \n"
        titulo6:  .asciz " #       #          #       #     # #     # #       #    #   #  #    ##    #    #     # \n"
        titulo7:  .asciz " ####### #######    ####### #     # ######  ####### #     # ### #     #    #    ####### \n"
        titulo8:  .asciz "                             Por Fernando Perez Holguin                                 \n"
        lt8=.-titulo8
        LFtitulo: .asciz "                                                                                        \n"
        LinAbajo: .asciz "                                                                                        \n"
        continuar:.asciz "                         Pulsa una tecla para continuar                                 \n"
        titulo: .long titulo1, titulo2, titulo3, titulo4, titulo5, titulo6, titulo7,titulo8
        lenTitulo: .long 8
        filasCentraTitulo:.long 0
        intervaloContinuar: .long 5
        espaciacionPuntos: .long 4
        mostrarContinuar: .long 1
        asterisco: .asciz "*"
        espacio: .asciz " "
    #argumentos_sonido
        command_string: .asciz "/bin/bash"
        argument0: .asciz "bash"
        argument1: .asciz "-c"
        argument2: .asciz "play ./Recursos/t2.wav -q -t alsa > /dev/null 2>&1"
        argument3: .asciz "play ./Recursos/t1.wav -q -t alsa > /dev/null 2>&1"
        argument4: .asciz "play ./Recursos/s.wav -q -t alsa > /dev/null 2>&1"
        argument5: .asciz "which play > /dev/null 2>&1"
        argumentShh: .asciz "> /dev/null 2>&1"
        argumentsT2: .long argument0, argument1, argument2, 0
        argumentsT1: .long argument0, argument1, argument3, 0
        argumentsInit: .long argument0, argument1, argument4, 0
        argumentsSox: .long argument0, argument1, argument5, 0
        musID: .long 0
        noaudio:.string "--noaudio"
    #mensajes
        mensajeComenzado: .string "El juego comienza\n"
        lenMenCom=.-mensajeComenzado
        errorSox: .string "\n\nError en la ejecucion de sox. Reinicia el programa y probablemente se pasará. Si no, pon --noaudio al ejecutar el programa\n"
        lenErrorSox=.-errorSox
        nohaySox: .string "\n\nNo se ha encontrado el programa sox.\nInstálalo con sudo apt install sox o pon --noaudio al ejecutar el programa\n"
        lenNoHaySox=.-nohaySox
        noHayAudio: .string "\n\nNo sen han encontrado los archivos de audio.\nColócalos en la carpeta recursos o pon --noaudio al ejecutar el programa\n"
        lenNoHayAudio=.-noHayAudio
        pantallaPeque: .string "La pantalla es demasiado pequeña para jugar. El mínimo es 90 columnas y 24 filas\n"
        lenPantallaPeque=.-pantallaPeque
        mensajeSinAudio: .string "El programa se ejecutará sin audio\n"
        
    #delays
        delaySinAudio: .long 2,0
        delayLetrasTitulo: .long 0,030000000
        delayLFtitulo: .long 0,2071000000
        delayIdling: .long 0,100000000
        
    #archivos de musica
        archivomus1: .asciz "./Recursos/t1.wav"
        archivomus2: .asciz "./Recursos/t2.wav"
        archivomus3: .asciz "./Recursos/s.wav"
        archivosMusica: .long archivomus1, archivomus2, archivomus3
        lenArchivosMusica: .long 3
    #profe_builtin
        termiosnew: .space 18
        termiosold: .space 18
        saltoLinea: .asciz "\n"
        clear:    .asciz "\033[2J"
        retrocesoLinea: .asciz "\r\033[K"
        subeLinea: .asciz "\033[A"
        bajaLinea: .asciz "\033[B"
        guardarPos: .asciz "\033[s"
        restaurarPos: .asciz "\033[u"
        lenClear=.-clear
    #tamaño_pantalla
        winsize:.skip 8
        columnas: .long 0
        filas: .long 0
.bss
    .lcomm basura, 4
    .lcomm estado,4
    .lcomm audio,4
.text

.macro bajar_cursor num
    pushl %edi
    movl \num, %edi
    bucle_bajar_cursor_\@:
        print_str $bajaLinea
        decl %edi
        jnz bucle_bajar_cursor_\@
    popl %edi
    .endm
.macro clr
    movl $4, %eax
    movl $1, %ebx
    movl $clear, %ecx
    movl $lenClear, %edx
    int $0x80
    .endm
.macro desbloquear_stdin
    movl $55, %eax               # syscall number for fcntl
    movl $0, %ebx                # file descriptor (stdin)
    movl $4, %ecx                # command (set flags)
    movl $2048, %edx             # flags (O_NONBLOCK)
    int $0x80                    # realiza la llamada al sistema
    .endm
.macro esperar tiempo
    movl $162,%eax
    movl \tiempo,%ebx
    movl $0,%ecx
    int $0x80
    .endm
.macro print_str string
    pushl \string
    call strlen
    movl %eax, %edx
    movl $4, %eax
    movl $1, %ebx
    movl \string, %ecx
    int $0x80
    .endm
.macro parar_musica
    movl $7, %eax
    movl musID, %ebx
    movl $estado, %ecx
    movl $1, %edx
    int $0x80
    testl %eax , %eax
    jnz fin_parada_musica_\@
        movl $37, %eax
        movl musID, %ebx
        incl %ebx
        movl $15, %ecx
        int $0x80
    fin_parada_musica_\@:
    .endm
.macro purgar_buffer
    bucle_purga_buffer_\@:
    movl $3, %eax
    movl $0, %ebx
    leal basura, %ecx
    movl $1, %edx
    int $0x80
    cmpl $-1,%eax
    jg bucle_purga_buffer_\@
    .endm
.macro salir valor
    movl $1, %eax
    movl \valor, %ebx
    int $0x80
    .endm

.macro subir_cursor num
    pushl %edi
    movl \num, %edi
    bucle_subir_cursor_\@:
        print_str $subeLinea
        decl %edi
        jnz bucle_subir_cursor_\@
    popl %edi
    .endm
.global _start
_start:
    #tamaño_pantalla
        movl $54, %eax
        movl $0, %ebx
        movl $0x5413, %ecx
        leal winsize, %edx
        int $0x80
        movl winsize, %eax
        shll $16, %eax
        shrl $16, %eax
        movl %eax, filas
        movl winsize, %eax
        shrl $16, %eax
        movl %eax, columnas
        cmpl $90,%eax
        jl pantalla_insuficiente
        movl filas, %eax
        cmpl $24,%eax
        jl pantalla_insuficiente
        jmp pantalla_suficiente
            pantalla_insuficiente:
            print_str $pantallaPeque
            salir $1
        pantalla_suficiente:
    #configuracion_terminal
        # movl $54, %eax
        # movl $0, %ebx
        # movl $0x5401, %ecx
        # movl $termiosold, %edx
        # int $0x80
        # movl $54, %eax
        # movl $0, %ebx
        # movl $0x5403, %ecx
        # movl $termiosnew, %edx
        # movl $1,12(%edx)
        # int $0x80
        desbloquear_stdin
    #comprobar_audio
        #comprobar --noaudio
            popl %ecx
            cmpl $2,%ecx
            jne fin_noaudio
                popl %ebx
                popl %ebx
                pushl %ebx
                pushl $noaudio
                call strcmp
                testl %eax, %eax
                jnz fin_noaudio
                    movl $-1,audio
                    print_str $mensajeSinAudio
                    esperar $delaySinAudio
                    jmp init_audio_exitoso
            fin_noaudio:
        #comprobar_sox
            movl $2, %eax
            int $0x80
            testl %eax, %eax
            jnz padre_comprobar_sox
                movl $11, %eax
                movl $command_string, %ebx
                movl $argumentsSox, %ecx
                movl $0, %edx
                int $0x80
            padre_comprobar_sox:
            movl %eax, %ebx
            movl $7, %eax
            movl $estado, %ecx
            movl $0, %edx
            int $0x80
            movl estado, %eax
            shrl $8, %eax
            testl %eax, %eax
            jz sox_encontrado
                movl $4, %eax
                movl $1, %ebx
                movl $nohaySox, %ecx
                movl $lenNoHaySox, %edx
                int $0x80
                salir $1
            sox_encontrado:
        #comprobar_archivos
            movl lenArchivosMusica, %ecx
            movl $archivosMusica, %esi
            bucle_busqueda_archivosMusica:
                pushl %ecx
                movl $33, %eax
                movl (%esi), %ebx
                movl $0, %ecx
                int $0x80
                testl %eax, %eax
                jnz archivo_no_encontrado
                addl $4, %esi
                popl %ecx
                loop bucle_busqueda_archivosMusica
            jmp limpieza_inicial_sox
            archivo_no_encontrado:
                movl $4, %eax
                movl $1, %ebx
                movl $noHayAudio, %ecx
                movl $lenNoHayAudio, %edx
                int $0x80
                salir $1
        #comprobar sox II
            limpieza_inicial_sox:
                movl $2, %eax
                int $0x80
                testl %eax, %eax
                jnz padre_limpieza_sox
                    movl $11, %eax
                    movl $command_string, %ebx
                    movl $argumentsInit, %ecx
                    movl $0, %edx
                    int $0x80
                padre_limpieza_sox:
                    movl %eax,musID
                    movl $7, %eax
                    movl musID, %ebx
                    movl $estado, %ecx
                    movl $0,%edx
                    int $0x80
                    movl estado, %eax
                    shrl $8, %eax
                    testl %eax, %eax
                    jz sox_ok
                        movl $4, %eax
                        movl $1, %ebx
                        movl $errorSox, %ecx
                        movl $lenErrorSox, %edx
                        int $0x80
                        salir $1
                sox_ok:
                
        init_audio_exitoso:
    #titulo
        #mostrar_titulo
            purgar_buffer
            clr
            pushl $argumentsT1
            call poner_musica
            print_str $LFtitulo
            movl lenTitulo,%ecx
            movl $titulo,%esi
            bucle_lineas_titulo:
                pushl %ecx
                pushl %esi
                movl (%esi), %esi
                movl $lenLineaTitulo, %ecx
                bucle_caracteres_titulo:
                    pushl %ecx
                    movl $4, %eax
                    movl $1, %ebx
                    movl %esi, %ecx
                    movl $1, %edx
                    int $0x80
                    esperar $delayLetrasTitulo
                    incl %esi
                    popl %ecx
                    loop bucle_caracteres_titulo
                popl %esi
                addl $4, %esi
                popl %ecx
                loop bucle_lineas_titulo
            #centraje
                movl $0,%edx
                movl filas, %eax
                subl $3, %eax
                movl $2, %ebx
                divl %ebx
                testl %edx, %edx
                jz no_sumar_uno_centraje
                    incl %eax
                no_sumar_uno_centraje:
                movl %eax, filasCentraTitulo
                movl %eax, %ecx
                xorl %edx, %edx
                movl delayLFtitulo+4, %eax
                divl %ecx
                movl %eax, delayLFtitulo+4
                bucle_centrar_titulo:
                    pushl %ecx
                    print_str $LFtitulo
                    esperar $delayLFtitulo
                    popl %ecx
                    loop bucle_centrar_titulo
            desbloquear_stdin
            purgar_buffer
        #bucle_titulo
            movl $0,%edi
            movl $0,%esi
            esperar_tecla:
                movl $3, %eax
                movl $0, %ebx
                leal basura, %ecx
                movl $1, %edx
                int $0x80
                cmpl $-1,%eax
                jg fin
                esperar $delayIdling
                testl %edi, %edi
                jz fin_anim_titulo
                    print_str $guardarPos
                    movl %esi,%eax
                    xorl %edx,%edx
                    movl intervaloContinuar,%ebx
                    divl %ebx
                    testl %edx,%edx
                    jnz fin_actualizar_continuar
                        movl filasCentraTitulo,%ecx
                        subl $2,%ecx
                        bucle_subir_a_continuar:
                            pushl %ecx
                            print_str $subeLinea
                            popl %ecx
                            loop bucle_subir_a_continuar
                        print_str $retrocesoLinea
                        movl mostrarContinuar,%eax
                        negl %eax
                        movl %eax,mostrarContinuar
                        testl %eax,%eax
                        jns mostrar_continuar
                            print_str $saltoLinea
                            jmp fin_actualizar_continuar
                        mostrar_continuar:
                            print_str $continuar
                        fin_actualizar_continuar:
                        print_str $restaurarPos
                    #animacion_puntos
                        movl %esi,%eax
                        xorl %edx,%edx
                        pushl %edi
                        movl espaciacionPuntos,%ebx
                        divl %ebx
                        movl %edx,%edi
                        incl %edi
                        movl filasCentraTitulo,%ecx
                        addl lenTitulo,%ecx
                        incl %ecx
                        subir_cursor %ecx
                        print_str $retrocesoLinea
                        movl $lenLineaTitulo,%ecx
                        subl $2,%ecx
                        bucle_linea_arriba:
                            pushl %ecx
                            cmpl $1,%edi
                            jne espacio_LA_puntos
                                print_str $asterisco
                                #xorl %edi,%edi
                                jmp fin_caracter_puntos
                            espacio_LA_puntos:
                                print_str $espacio
                            fin_caracter_puntos:
                            decl %edi
                            testl %edi,%edi
                            jnz no_max_puntos_LA
                                movl $4,%edi
                                no_max_puntos_LA:
                            popl %ecx
                            loop bucle_linea_arriba
                        print_str $bajaLinea
                        movl lenTitulo,%ecx
                        pushl %esi
                        bucle_linea_derecha:
                            pushl %ecx
                            movl lenTitulo,%edx
                            subl %ecx,%edx
                            imull $4,%edx
                            movl $titulo,%esi
                            addl %edx,%esi
                            movl (%esi),%esi
                            addl $lenLineaTitulo,%esi
                            subl $3,%esi
                            cmpl $1,%edi
                            jne espacio_LD_puntos
                                movb $'*',(%esi)
                                jmp fin_caracter_puntos_LD
                            espacio_LD_puntos:
                                movb $' ',(%esi)
                            fin_caracter_puntos_LD:
                            decl %edi
                            testl %edi,%edi
                            jnz no_max_puntos_LD
                                movl $4,%edi
                                no_max_puntos_LD:
                            #debug solo
                                
                                movl $4,%eax
                                movl $1,%ebx
                                movl $retrocesoLinea,%ecx
                                movl $5,%edx
                                int $0x80
                                subl $lenLineaTitulo,%esi
                                addl $3,%esi
                                movl %esi,%ecx
                                movl $4,%eax
                                movl $1,%ebx
                                movl $lenLineaTitulo,%edx
                                int $0x80
                            popl %ecx
                            loop bucle_linea_derecha
                            popl %esi
                        print_str $retrocesoLinea
                        movl $lenLineaTitulo,%ecx
                        subl $3,%ecx
                        pushl %esi
                        movl $LFtitulo,%esi
                        bucle_linea_abajo:
                            pushl %ecx
                            cmpl $1,%edi
                            jne espacio_LA_puntos_abajo
                                movb $'*',(%esi,%ecx,1)
                                #xorl %edi,%edi
                                jmp fin_caracter_puntos_abajo
                            espacio_LA_puntos_abajo:
                                movb $' ',(%esi,%ecx,1)
                            fin_caracter_puntos_abajo:
                            decl %edi
                            testl %edi,%edi
                            jnz no_max_puntos_LA_abajo
                                movl $4,%edi
                                no_max_puntos_LA_abajo:
                            popl %ecx
                            decl %ecx
                            jns bucle_linea_abajo
                        popl %esi
                        print_str $LFtitulo
                        subir_cursor $2

                        movl lenTitulo,%ecx
                        decl %ecx
                        pushl %esi
                        bucle_linea_izquierda:
                            pushl %ecx
                            imull $4,%ecx
                            movl $titulo,%esi
                            addl %ecx,%esi
                            movl (%esi),%esi
                            incl %esi
                            print_str $retrocesoLinea
                            cmpl $1,%edi
                            jne espacio_LI_puntos
                                print_str $asterisco
                                jmp fin_caracter_puntos_LI
                            espacio_LI_puntos:
                                print_str $espacio
                            fin_caracter_puntos_LI:
                            decl %edi
                            testl %edi,%edi
                            jnz no_max_puntos_LI
                                movl $4,%edi
                                no_max_puntos_LI:
                            movl $4,%eax
                            movl $1,%ebx
                            movl %esi,%ecx
                            movl $lenLineaTitulo-1,%edx
                            int $0x80
                            subir_cursor $2
                            popl %ecx
                            decl %ecx
                            jns bucle_linea_izquierda
                        popl %esi

                        popl %edi
                    #evitar_desbordamiento
                        incl %esi
                        cmpl $2147483647,%esi
                        jne no_max_anim_titulo
                            movl $7,%esi
                            no_max_anim_titulo:
                    print_str $restaurarPos
                fin_anim_titulo:
                movl $7, %eax
                movl musID, %ebx
                movl $estado, %ecx
                movl $1, %edx
                int $0x80
                testl %eax , %eax
                jz esperar_tecla
                    movl $1,%edi
                    pushl $argumentsT2
                    call poner_musica
                    jmp esperar_tecla
    fin:
        parar_musica
        purgar_buffer
        clr
        movl $4, %eax
        movl $1, %ebx
        leal mensajeComenzado, %ecx
        movl $lenMenCom, %edx
        int $0x80
        movl $1, %eax
        movl $0, %ebx
        int $0x80
.type poner_musica, @function
    poner_musica:
        enter $0, $0
        pushl %ebx
        pushl %ecx
        pushl %edx

        movl audio, %eax
        testl %eax, %eax
        jnz fin_poner_musica

        #matar musica anterior
            movl $7, %eax
            movl musID, %ebx
            movl $estado, %ecx
            movl $1, %edx
            int $0x80
            testl %eax , %eax
            jnz poner_nueva_musica
                movl $37, %eax
                movl musID, %ebx
                incl %ebx
                movl $15, %ecx
                int $0x80
        poner_nueva_musica:
            movl $2, %eax
            int $0x80
            testl %eax, %eax
            jnz padre_poner_musica
                movl $11, %eax
                movl $command_string, %ebx
                movl 8(%ebp), %ecx
                movl $0, %edx
                int $0x80
                movl $1, %eax
                movl $0, %ebx
                int $0x80
        padre_poner_musica:
            movl %eax, musID
            xorl %eax, %eax
        fin_poner_musica:
        popl %edx
        popl %ecx
        popl %ebx
        leave
        ret $4
