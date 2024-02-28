.section .data
    bienvenida: .string "Bienvenid@ al registro\n"
    lenB=.-bienvenida
    inform: .string "Esto es lo que hay en el registro por ahora:\n---\n"
    lenI=.-inform
    cierreLectura: .string "--Fin del registro--\n"
    lenCL=.-cierreLectura
    pregunta: .string "Opciones:\nAñadir una línea (a)\nBorrar una línea (r)\nCambiar la posición de 2 líneas (c)\nBuscar líneas por nombre o edad (b)\nSalir (s/q)\n¿Qué quieres hacer?: "
    lenP=.-pregunta
    salida: .string "Adiós :)\n"
    lenS=.-salida
    nombrePreg: .string "Introduce el nombre (max 20 letras):\n"
    lenNP=.-nombrePreg
    edadPreg: .string "Introduce la edad (max 3 cifras):\n"
    lenEP=.-edadPreg
    cabecera: .ascii "Nombre\tEdad\n"
    lenC=.-cabecera
    fileName: .string "personal.txt"
    saltoLinea: .ascii "\n"
    opInvalida: .string "Opción no válida\n\n"
    lenOI=.-opInvalida
    tab: .ascii "\t"
    msgBorrar: .string "¿Qué línea quieres borrar?: "
    lenMB=.-msgBorrar
    msgEC: .string "Línea inválida\n"
    lenMEC=.-msgEC
    fileNameProv: .string "registroProv.txt"
    warningBuffer: .string "Tu respuesta ha sido demasiado larga, puede que haya ocurrido algo raro\n"
    lenWB=.-warningBuffer
    msgCL1: .string "Dime la primera línea que quieres cambiar: "
    lenCL1=.-msgCL1
    msgCL2: .string "Dime la segunda línea que quieres cambiar: "
    lenCL2=.-msgCL2
    msgPregBuscar: .string "¿Quieres buscar por nombre (n) o por edad (e)?: "
    lenMPB=.-msgPregBuscar
    msgPregNombre: .string "Introduce el nombre que quieres buscar: "
    lenMPN= . - msgPregNombre
    msgPregEdad: .string "Introduce la edad que quieres buscar: "
    lenMPE=.-msgPregEdad
    msgNoCoinc: .string "No se ha encontrado ninguna coincidencia\n"
    lenMNC=.-msgNoCoinc
    msg1Coinc: .string "Se ha encontrado 1 coincidencia\n"
    len1C=.-msg1Coinc
    msgNCoinc: .string "Se han encontrado "
    lenNC=.-msgNCoinc
    msgNCoinc2: .string " coincidencias\n"
    lenNC2=.-msgNCoinc2
    msgResultSearch: .string "Resultado de la búsqueda:\n---\n"
    lenRS=.-msgResultSearch
    msgConfirm: .string "Pulsa [ENTER] para continuar "
    lenMCF=.-msgConfirm
.section .bss
    .lcomm lineas, 4
    maxN=20
    .lcomm nombre, maxN+1
    maxE=3
    .lcomm edad, maxE+1
    .lcomm basura,1
    .lcomm buffer, 1
    .lcomm respuesta,2
    .lcomm lenEdad,4
    .lcomm lenNombre,4
    .lcomm entradaInt,10
    .lcomm lineaABorrar,4
    .lcomm lenEI,4
    .lcomm guardaDescriptor,4
    .lcomm numLineaActual,4
    .lcomm numLineaACambiar1,4
    .lcomm numLineaACambiar2,4
    .lcomm lineaACambiar1, maxN+maxE+2
    .lcomm lineaACambiar2, maxN+maxE+2
    .lcomm lenLineaACambiar1,4
    .lcomm lenLineaACambiar2,4
    .lcomm lenLineaACambiarActual,4
    .lcomm lineasEscaneadas,4
    .lcomm stringResultado,10
    .lcomm lenSR,4
    .lcomm nombreBuscado, maxN
    .lcomm edadBuscada, maxE
    .lcomm posEnLinea,4
    .lcomm posDeTab,4
    .lcomm descriptorOg,4
    .lcomm estoyBuscando,1
    .lcomm lineasEncontradas,4
.section .text
.globl _start
_start:

    movl $4, %eax
    movl $1, %ebx
    movl $bienvenida, %ecx
    movl $lenB, %edx
    int $0x80


bucle_main:
    movl $0,numLineaActual
    movl $0,lineas
    #abrimos archivo
    movl $5, %eax
    movl $fileName, %ebx
    movl $0x0442, %ecx
    movl $0666, %edx
    int $0x80
    movl %eax, %edi    
    movl $4, %eax
    movl $1, %ebx
    movl $inform, %ecx
    movl $lenI, %edx
    int $0x80
    movl $4, %eax
    movl $1, %ebx
    movl $tab, %ecx
    movl $1, %edx
    int $0x80
    obtener_longitud:
    movl $19, %eax
    movl %edi, %ebx
    movl $0, %ecx
    movl $2, %edx
    int $0x80

    movl %eax, %esi

    movl $19, %eax
    movl %edi, %ebx
    movl $0, %ecx
    movl $0, %edx
    int $0x80
    #escribimos la cabecera
    cmpl %eax, %esi
    jne read_loop

    movl $4, %eax
    movl %edi, %ebx
    movl $cabecera, %ecx
    movl $lenC, %edx
    int $0x80
    jmp obtener_longitud
    read_loop:
        movl $3, %eax 
        movl %edi, %ebx 
        movl $buffer, %ecx 
        movl $1, %edx 
        int $0x80
        

        movl $4, %eax 
        movl $1, %ebx 
        movl $buffer, %ecx 
        int $0x80

        lea buffer, %ebx
        cmpb $10, (%ebx)
        jne no_sumar_linea
        cmpl $1, %esi
        je no_sumar_linea
            lea lineas, %ebx
            incl (%ebx)
            pushl lineas
            call int_a_string
            addl $4, %esp
            movl $4, %eax
            movl $1, %ebx
            movl $stringResultado, %ecx
            movl lenSR, %edx
            int $0x80
            movl $4, %eax
            movl $1, %ebx
            movl $tab, %ecx
            movl $1, %edx
            int $0x80
        no_sumar_linea:


        subl $1, %esi


        cmpl $0, %esi
        jg read_loop

        movl $4, %eax
        movl $1, %ebx
        movl $cierreLectura, %ecx
        movl $lenCL, %edx
        int $0x80
    fin_read_loop:
preguntas:
    movl $4, %eax
    movl $1, %ebx
    movl $pregunta, %ecx
    movl $lenP, %edx
    int $0x80

    movl $3, %eax
    movl $0, %ebx
    movl $respuesta, %ecx
    movl $2, %edx
    int $0x80

    lea respuesta, %esi
    cmpb $10,1(%esi)
    je salto_purga_1
    cmpb $0,1(%esi)
    je salto_purga_1
    call purgar_buffer
    jmp op_invalida
    salto_purga_1:
    movb respuesta, %al
    orb $0x20, %al
    cmpb $97,%al
    je nuevo_registro
    cmpb $115,%al
    je fin_bucle_main
    cmpb $113,%al
    je fin_bucle_main
    cmpb $98,%al
    je buscar_lineas
    cmpb $99,%al
    je cambiar_lineas
    cmpb $114,%al
    je borrar_linea
    op_invalida:
    movl $4, %eax
    movl $1, %ebx
    movl $opInvalida, %ecx
    movl $lenOI, %edx
    int $0x80
    jmp fin_read_loop
nuevo_registro:
        movl $4, %eax
        movl $1, %ebx
        movl $nombrePreg, %ecx
        movl $lenNP, %edx
        int $0x80

        movl $3, %eax
        movl $0, %ebx
        movl $nombre, %ecx
        movl $maxN, %edx
        int $0x80

        lea nombre, %esi
        addl %eax, %esi
        decl %esi
        cmpb $10,(%esi)
        je set_longitud_nombre

        lea lenNombre, %esi
        movl $maxN, (%esi)
        call purgar_buffer
        jmp fin_lectura_nombre
        set_longitud_nombre:
        lea lenNombre, %esi
        decl %eax
        movl %eax, (%esi)
        fin_lectura_nombre:
        movl $4, %eax
        movl $1, %ebx
        movl $edadPreg, %ecx
        movl $lenEP, %edx
        int $0x80
        movl $3, %eax
        movl $0, %ebx
        movl $edad, %ecx
        movl $maxE, %edx
        int $0x80

        lea edad, %esi
        addl %eax, %esi
        decl %esi
        cmpb $10,(%esi)
        je set_longitud_edad
        lea lenEdad, %esi
        movl $maxE, (%esi)
        call purgar_buffer
        jmp fin_lectura_edad
        set_longitud_edad:
        lea lenEdad, %esi
        decl %eax
        movl %eax, (%esi)
        fin_lectura_edad:
        movl $19, %eax
        movl %edi, %ebx
        movl $0, %ecx
        movl $2, %edx
        int $0x80
        lea lenNombre, %esi
        movl $4, %eax
        movl %edi, %ebx
        movl $nombre, %ecx
        movl (%esi), %edx
        int $0x80
        movl $4, %eax
        movl $tab, %ecx
        movl $1, %edx
        int $0x80
        lea lenEdad, %esi
        movl $4, %eax
        movl $edad, %ecx
        movl (%esi), %edx
        int $0x80
        movl $4, %eax
        movl $saltoLinea, %ecx
        movl $1, %edx
        int $0x80

        #Borramos y repetimos
        movl %edi,%edx
        lea nombre, %edi
        movl $maxN, %ecx
        xorl %eax, %eax
        rep stosb
        lea edad, %edi
        movl $maxE, %ecx
        xorl %eax, %eax
        rep stosb
        movl %edx, %edi
        jmp bucle_main

borrar_linea:
    movl $0, lineaABorrar
    pushl $lineaABorrar
    pushl $msgBorrar
    pushl $lenMB
    call convertir_a_entero
    addl $12, %esp
    #Comienza la creación del archivo provisional
    movl $5, %eax
    movl $fileNameProv, %ebx
    movl $0x0442, %ecx
    movl $0666, %edx
    int $0x80
    movl %eax, (guardaDescriptor)

    movl $0, numLineaActual
    #leemos el archivo original y determinamos la longitud
    movl $19, %eax
    movl %edi, %ebx
    movl $0, %ecx
    movl $2, %edx
    int $0x80

    movl %eax, %esi

    movl $19, %eax
    movl %edi, %ebx
    movl $0, %ecx
    movl $0, %edx
    int $0x80

    read_loop_borrar:

        movl $3, %eax 
        movl %edi, %ebx 
        movl $buffer, %ecx 
        movl $1, %edx 
        int $0x80
        

        movl %eax, %edx

        lea buffer, %ebx
        cmpb $10, (%ebx)
        jne skip_sumar_linea
        lea numLineaActual, %ebx
        incl (%ebx)
        skip_sumar_linea:
        movl numLineaActual, %eax
        movl lineaABorrar, %ebx
        cmpl %eax, %ebx
        je skip_escribir_en_nuevo
     
        movl guardaDescriptor,%ebx
        movl $4, %eax 
        movl $buffer, %ecx 
        int $0x80
        skip_escribir_en_nuevo:
      
        subl %edx, %esi

       
        cmpl $0, %esi
        jg read_loop_borrar
    fin_read_loop_borrar:
        call borrar_y_renombrar
        jmp bucle_main
cambiar_lineas:
    #reinicializar todas las variables implicadas
        movl $0, lineasEscaneadas
        movl $0, numLineaActual
        movl $0, numLineaACambiar1
        movl $0, numLineaACambiar2
        movl $0, lenLineaACambiarActual
        movl $0, lenLineaACambiar1
        movl $0, lenLineaACambiar2
        movl %edi,%esi
        lea lineaACambiar1,%edi
        xorl %eax,%eax
        movl $maxN+maxE+2,%ecx
        rep stosb
        lea lineaACambiar2,%edi
        xorl %eax,%eax
        movl $maxN+maxE+2,%ecx
        rep stosb
        movl %esi,%edi
    pushl $numLineaACambiar1
    pushl $msgCL1
    pushl $lenCL1
    call convertir_a_entero
    addl $12, %esp
    pushl $numLineaACambiar2
    pushl $msgCL2
    pushl $lenCL2
    call convertir_a_entero
    addl $12, %esp
    movl numLineaACambiar1, %eax
    cmpl numLineaACambiar2, %eax
    je bucle_main
    movl $19, %eax
    movl %edi, %ebx
    movl $0, %ecx
    movl $0, %edx
    int $0x80
    #Leemos el archivo original y copiamos las lineas y su longitud a las variables correspondientes
    movl $0, numLineaActual
    movl $0,%esi
    movl $0, lineasEscaneadas
    bucle_leer_lineas_necesarias:
        
        movl $3, %eax 
        movl %edi, %ebx 
        movl $buffer, %ecx 
        movl $1, %edx 
        int $0x80
        
        movl %eax, %edx
        test %esi,%esi
        jz no_escribir_linea
            movb buffer,%bl
            movb %bl,(%esi)
            incl %esi
            movl lenLineaACambiarActual, %ebx
            incl (%ebx)
        no_escribir_linea:
        lea buffer, %ebx
        cmpb $10, (%ebx)
        jne bucle_leer_lineas_necesarias
            lea numLineaActual, %ebx
            incl (%ebx)


            movl numLineaActual, %eax
            cmpl numLineaACambiar1, %eax
            jne no_guardar_linea_1
                lea lineasEscaneadas, %eax
                incl (%eax)

                lea lineaACambiar1,%esi
                lea lenLineaACambiar1,%edx
                movl %edx, lenLineaACambiarActual
                jmp bucle_leer_lineas_necesarias
            no_guardar_linea_1:
            cmpl numLineaACambiar2, %eax
            jne no_guardar_linea_2
                lea lineasEscaneadas, %eax
                incl (%eax)

                lea lineaACambiar2,%esi
                lea lenLineaACambiar2,%edx
                movl %edx, lenLineaACambiarActual
                jmp bucle_leer_lineas_necesarias
            no_guardar_linea_2:
            testl %esi,%esi
            jz bucle_leer_lineas_necesarias
                movl $0, %esi
                lea lineasEscaneadas, %eax
                cmpl $2, (%eax)
                jl bucle_leer_lineas_necesarias
    fin_bucle_leer_lineas_necesarias:
    #Comienza la creación del archivo provisional
    preparativos_read_loop_cambiar:
        movl $5, %eax
        movl $fileNameProv, %ebx
        movl $0x0442, %ecx
        movl $0666, %edx
        int $0x80
        movl %eax, (guardaDescriptor)
        #empezamos en la línea 0
        movl $0, numLineaActual
        #leemos el archivo original y determinamos la longitud
        movl $19, %eax
        movl %edi, %ebx
        movl $0, %ecx
        movl $2, %edx
        int $0x80
        movl %eax, %esi
        movl $19, %eax
        movl %edi, %ebx
        movl $0, %ecx
        movl $0, %edx
        int $0x80
    read_loop_cambiar:
        
        movl $3, %eax 
        movl %edi, %ebx 
        movl $buffer, %ecx 
        movl $1, %edx 
        int $0x80
        movl numLineaActual, %ebx
        cmpl numLineaACambiar1, %ebx
        je no_escribir
        cmpl numLineaACambiar2, %ebx
        je no_escribir
            movl guardaDescriptor,%ebx
            movl $4, %eax 
            movl $buffer, %ecx 
            movl $1, %edx 
            int $0x80
        no_escribir:
        lea buffer, %ebx
        cmpb $10, (%ebx)
        jne skip_sumar_linea_c
            lea numLineaActual, %ebx
            incl (%ebx)
            movl (%ebx), %ebx
            cmpl numLineaACambiar1, %ebx
            jne no_escribir_l1
                movl $4, %eax
                movl guardaDescriptor, %ebx
                movl $lineaACambiar2, %ecx
                movl lenLineaACambiar2, %edx
                int $0x80
                jmp skip_sumar_linea_c
            no_escribir_l1:
            cmpl numLineaACambiar2, %ebx
            jne skip_sumar_linea_c
                movl $4, %eax
                movl guardaDescriptor, %ebx
                movl $lineaACambiar1, %ecx
                movl lenLineaACambiar1, %edx
                int $0x80            
        skip_sumar_linea_c:
        
        subl $1, %esi

        
        cmpl $0, %esi
        jg read_loop_cambiar
    fin_read_loop_cambiar:
        call borrar_y_renombrar
        jmp bucle_main
buscar_lineas:
    preguntar_tipo:
        movl $0,lineasEncontradas
        movl $4, %eax
        movl $1, %ebx
        movl $msgPregBuscar, %ecx
        movl $lenMPB, %edx
        int $0x80

        movl $3, %eax
        movl $0, %ebx
        movl $respuesta, %ecx
        movl $2, %edx
        int $0x80
        lea respuesta, %esi
        cmpb $10,1(%esi)
        je salto_purga_buscar
        call purgar_buffer
        salto_purga_buscar:
        movb respuesta, %al
        orb $0x20, %al
        cmpb $110,%al
        je buscar_por_nombre
        cmpb $101,%al
        je buscar_por_edad
        movl $4, %eax
        movl $1, %ebx
        movl $opInvalida, %ecx
        movl $lenOI, %edx
        int $0x80
        jmp preguntar_tipo
        buscar_por_nombre:
            movb $0xFF, estoyBuscando
            movl $4, %eax
            movl $1, %ebx
            movl $msgPregNombre, %ecx
            movl $lenMPN, %edx
            int $0x80

            movl $3, %eax
            movl $0, %ebx
            movl $nombreBuscado, %ecx
            movl $maxN, %edx
            int $0x80

            lea nombreBuscado, %esi
            addl %eax, %esi
            decl %esi
            cmpb $10,(%esi)
            je no_llamar_purga_bn
                call purgar_buffer
            no_llamar_purga_bn:
            jmp fin_preguntas_buscar
        buscar_por_edad:
            movb $1, estoyBuscando
            movl $4, %eax
            movl $1, %ebx
            movl $msgPregEdad, %ecx
            movl $lenMPE, %edx
            int $0x80

            movl $3, %eax
            movl $0, %ebx
            movl $edadBuscada, %ecx
            movl $maxE, %edx
            int $0x80

            lea edadBuscada, %esi
            addl %eax, %esi
            decl %esi
            cmpb $10,(%esi)
            je no_llamar_purga_be
                call purgar_buffer
            no_llamar_purga_be:
            jmp fin_preguntas_buscar
        fin_preguntas_buscar:
            movl $4, %eax
            movl $1, %ebx
            movl $msgResultSearch, %ecx
            movl $lenRS, %edx
            int $0x80
            movl $19, %eax
            movl %edi, %ebx
            movl $0, %ecx
            movl $2, %edx
            int $0x80
            
            movl %eax, %esi

            movl $19, %eax
            movl %edi, %ebx
            movl $12, %ecx
            movl $0, %edx
            int $0x80
            subl $12, %esi
            movl $1,numLineaActual
            movl $0,posEnLinea
            movl $0, posDeTab
            movl %edi,descriptorOg
            read_loop_buscar:
                movl $3, %eax 
                movl descriptorOg, %ebx 
                movl $buffer, %ecx 
                movl $1, %edx 
                int $0x80
                lea buffer, %ebx
                cmpb $9, (%ebx)
                jne no_es_tab
                    movl posEnLinea, %eax
                    movl %eax, posDeTab
                    cmpb $110,respuesta
                    sete %al
                    cmpb $0xFF,estoyBuscando
                    sete %ah
                    andb %ah,%al
                    cmpb $1, %al
                    jne no_hay_match_nombre
                        cmpb $0,lineasEncontradas
                        jne no_meter_cabecera
                            movl $4, %eax
                            movl $1, %ebx
                            movl $tab, %ecx
                            movl $1, %edx
                            int $0x80
                            movl $4, %eax
                            movl $1, %ebx
                            movl $cabecera, %ecx
                            movl $lenC, %edx
                            int $0x80
                        no_meter_cabecera:
                        incl lineasEncontradas

                        pushl numLineaActual
                        call int_a_string
                        addl $4, %esp

                        movl $4, %eax
                        movl $1, %ebx
                        movl $stringResultado, %ecx
                        movl lenSR, %edx
                        int $0x80
                        movl $4, %eax
                        movl $1, %ebx
                        movl $tab, %ecx
                        movl $1, %edx
                        int $0x80
                        addl posEnLinea,%esi
                        pushl posEnLinea
                        pushl descriptorOg
                        call imprimir_linea
                        addl $8, %esp
                        movl $4, %eax
                        movl $1, %ebx
                        movl $saltoLinea, %ecx
                        movl $1, %edx
                        int $0x80
                    no_hay_match_nombre:
                    negb estoyBuscando
                    jmp fin_comparaciones
                no_es_tab:
                                lea buffer, %ebx
                cmpb $10, (%ebx)
                jne no_sumar_linea_buscar
                    movl $0, posDeTab
                    cmpb $0xFF, estoyBuscando
                    sete %al
                    cmpb $101,respuesta
                    sete %ah
                    andb %ah,%al
                    cmpb $1, %al
                    jne no_hay_match_edad
                        cmpb $0,lineasEncontradas
                        jne no_meter_cabecera_edad
                            movl $4, %eax
                            movl $1, %ebx
                            movl $tab, %ecx
                            movl $1, %edx
                            int $0x80
                            movl $4, %eax
                            movl $1, %ebx
                            movl $cabecera, %ecx
                            movl $lenC, %edx
                            int $0x80
                        no_meter_cabecera_edad:
                        incl lineasEncontradas

                        pushl numLineaActual
                        call int_a_string
                        addl $4, %esp

                        movl $4, %eax
                        movl $1, %ebx
                        movl $stringResultado, %ecx
                        movl lenSR, %edx
                        int $0x80
                        
                        movl $4, %eax
                        movl $1, %ebx
                        movl $tab, %ecx
                        movl $1, %edx
                        int $0x80
                        addl posEnLinea,%esi
                        incl %esi
                        pushl posEnLinea
                        pushl descriptorOg
                        call imprimir_linea
                        addl $8, %esp
                        movl $4, %eax
                        movl $1, %ebx
                        movl $saltoLinea, %ecx
                        movl $1, %edx
                        int $0x80
                    no_hay_match_edad:
                    lea numLineaActual, %ebx
                    incl (%ebx)
                    movl $0,posEnLinea
                    negb estoyBuscando
                    jmp fin_comparaciones_sin_add
                no_sumar_linea_buscar:
                comparaciones:
                    cmpb $0xFF, estoyBuscando
                    jne fin_comparaciones
                    cmpb $110,respuesta
                    jne buscamos_por_edad
                        #buscamos_por_nombre
                        movb (%ebx),%cl
                        lea nombreBuscado,%edi
                        addl posEnLinea,%edi
                        cmpb %cl,(%edi)
                        je fin_comparaciones
                            movl $1, estoyBuscando
                        jmp fin_comparaciones
                    buscamos_por_edad:
                        cmpb $101,respuesta
                        jne fin_comparaciones
                            movb (%ebx),%cl
                            #buscamos_por_edad
                            lea edadBuscada,%edi
                            addl posEnLinea,%edi
                            subl posDeTab,%edi
                            decl %edi
                            cmpb %cl,(%edi)
                            je fin_comparaciones
                                movl $1, estoyBuscando
                fin_comparaciones:
                

                incl posEnLinea
                fin_comparaciones_sin_add:

                subl $1, %esi

                cmpl $0, %esi
                jg read_loop_buscar
            mensaje_resultados:

            cmpl $0,lineasEncontradas
            je cero_lineas
            
            movl $4, %eax
            movl $1, %ebx
            movl $cierreLectura, %ecx
            movl $lenCL, %edx
            int $0x80

            cmpl $1,lineasEncontradas
            je una_linea
                movl $4, %eax
                movl $1, %ebx
                movl $msgNCoinc, %ecx
                movl $lenNC, %edx
                int $0x80
                pushl lineasEncontradas
                call int_a_string
                addl $4, %esp

                movl $4, %eax
                movl $1, %ebx
                movl $stringResultado, %ecx
                movl lenSR, %edx
                int $0x80
                movl $4, %eax
                movl $1, %ebx
                movl $msgNCoinc2, %ecx
                movl $lenNC2, %edx
                int $0x80
                jmp cierre_final_buscar
            una_linea:
                movl $4,%eax
                movl $1,%ebx
                movl $msg1Coinc, %ecx
                movl $len1C, %edx
                int $0x80
                jmp cierre_final_buscar
            cero_lineas:
                movl $4, %eax
                movl $1, %ebx
                movl $msgNoCoinc, %ecx
                movl $lenMNC, %edx
                int $0x80
                jmp cierre_final_buscar
            cierre_final_buscar:
            movl $4, %eax
            movl $1, %ebx
            movl $msgConfirm, %ecx
            movl $lenMCF, %edx
            int $0x80
            movl $3, %eax
            movl $0, %ebx
            movl $basura, %ecx
            movl $1, %edx
            int $0x80
            cmpb $10, (%ecx)
            je no_purga_busqueda_final
                call purgar_buffer
            no_purga_busqueda_final:
            movl descriptorOg, %edi
            jmp bucle_main
fin_bucle_main:
    movl $6, %eax
    movl %edi, %ebx
    int $0x80

    movl $4, %eax
    movl $1, %ebx
    movl $salida, %ecx
    movl $lenS, %edx
    int $0x80

    movl $1, %eax
    movl $0, %ebx
    int $0x80
.type purgar_buffer, @function
purgar_buffer:
    # movl $4, %eax
    # movl $1, %ebx
    #movl $warningBuffer, %ecx
    # movl $lenWB, %edx
    # int $0x80

    movl $3, %eax
    movl $0, %ebx
    movl $basura, %ecx
    movl $1, %edx
    int $0x80
    lea basura,%esi
    cmpb $10, (%esi)
    jne purgar_buffer
    ret
.type convertir_a_entero, @function
convertir_a_entero:
    
    pushl %ebp 
    movl %esp, %ebp

    xorl %eax,%eax
    movl %edi,%esi
    lea entradaInt,%edi
    movl $10,%ecx
    rep stosb
    movl 16(%esp),%edi
    movl $4,%ecx
    rep stosb
    movl %esi,%edi
    
    movl $4, %eax
    movl $1, %ebx
    movl 12(%esp), %ecx
    movl 8(%esp), %edx
    int $0x80

    movl $3, %eax
    movl $0, %ebx
    movl $entradaInt, %ecx
    movl $10, %edx
    int $0x80

    lea lenEI, %esi
    movl %eax, (%esi)
    lea entradaInt, %esi
    addl %eax, %esi
    decl %esi
    cmpl $10,(%esi)
    je saltarse_purga
    lea lenEI, %esi
    incl (%esi)
    call purgar_buffer
    saltarse_purga:
    movl $lenEI,%ecx
    movl (%ecx),%ecx
    decl %ecx
    lea entradaInt, %esi
    movl 16(%esp), %ebx
    proceso_conversion:
        movl $0,%eax
        movb (%esi),%al
        cmpb $48,%al
        jl error_conversion
        cmpb $57,%al
        jg error_conversion
        subl $48,%eax
        movl %ecx,%edx
        decl %ecx
        basificacion:
            cmpl $0,%ecx
            je fin_basificacion
            imull $10,%eax
            decl %ecx
            jmp basificacion
        fin_basificacion:
        movl %edx,%ecx
        incl %esi
        addl %eax,(%ebx)
        loop proceso_conversion
    cmpl $0,(%ebx)
    jle error_conversion
    movl lineas, %esi
    cmpl %esi,(%ebx)
    jg error_conversion
    movl %ebp, %esp
    popl %ebp
    ret
    error_conversion:
        movl $4, %eax
        movl $1, %ebx
        movl $msgEC, %ecx
        movl $lenMEC, %edx
        int $0x80
        xorl %eax,%eax
        movl %edi,%esi
        lea entradaInt,%edi
        movl $10,%ecx
        rep stosb
        movl 16(%esp),%edi
        movl $4,%ecx
        rep stosb
        movl %esi,%edi
        jmp convertir_a_entero
.type borrar_y_renombrar @function
borrar_y_renombrar:
    #Cerramos el archivo original
    movl $6, %eax
    movl %edi, %ebx
    int $0x80
    #y lo borramos
    movl $11, %eax
    movl $fileName, %ebx
    int $0x80
    #Cerramos el archivo provisional
    movl $6, %eax
    movl guardaDescriptor, %ebx
    int $0x80
    #y lo renombramos
    movl $38, %eax
    movl $fileNameProv, %ebx
    movl $fileName, %ecx
    int $0x80
    ret
.type int_a_string, @function
int_a_string:
            pushl %ebp
            pushl %esi
            movl %esp, %ebp
            movl %edi, %esi
            movl $0,lenSR
            movl $stringResultado, %edi
            movl $10, %ecx
            xorl %eax, %eax
            rep stosb
            movl %esi,%edi
            movl $stringResultado, %esi
            movl $10, %ecx
            obtener_num_cifras:
                movl 12(%esp), %eax
                movl $0, %edx
                divl %ecx
                cmpl $0, %eax
                je fin_obtener_num_cifras
                    addl $1, lenSR
                    imull $10, %ecx
                    jmp obtener_num_cifras
            fin_obtener_num_cifras:
                addl $1, lenSR
                movl lenSR, %ecx
                movl 12(%esp), %eax
            colocar_cifras:
                movl $10, %ebx
                movl $0, %edx
                divl %ebx
                addl $48, %edx
                movb %dl, -1(%esi, %ecx)
                loop colocar_cifras
            movl %ebp, %esp
            popl %esi
            popl %ebp
            ret
.type imprimir_linea, @function
imprimir_linea:
    pushl %ebp
    movl %esp, %ebp
    movl $19, %eax
    movl 8(%ebp), %ebx
    movl $0, %ecx
    subl 12(%ebp), %ecx
    decl %ecx
    movl $1, %edx
    int $0x80
    read_and_print_loop:
        movl $3, %eax
        movl 8(%ebp), %ebx
        movl $buffer, %ecx
        movl $1, %edx
        int $0x80
        movb buffer, %al
        cmpb $10, %al
        je fin_read_and_print_loop
            movl $4, %eax
            movl $1, %ebx
            movl $buffer, %ecx
            int $0x80
            decl %esi
        jmp read_and_print_loop
    fin_read_and_print_loop:
    movl $19, %eax
    movl 8(%ebp), %ebx
    movl $-1, %ecx
    movl $1, %edx
    int $0x80
    movl %ebp, %esp
    popl %ebp
    ret
