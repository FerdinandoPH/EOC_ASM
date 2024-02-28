.section .data
    bienvenida: .string "Bienvenid@ al registro\n"
    lenB=.-bienvenida
    inform: .string "Esto es lo que hay en el registro por ahora:\n---\n"
    lenI=.-inform
    cierreLectura: .string "--Fin del registro--\n"
    lenCL=.-cierreLectura
    pregunta: .string "¿Quieres añadir una línea (a), borrar una línea (b) o salir (s)\n"
    lenP=.-pregunta
    salida: .string "Adiós :)\n"
    lenS=.-salida
    nombrePreg: .string "Introduce el nombre (max 20 letras):\n"
    lenNP=.-nombrePreg
    edadPreg: .string "Introduce la edad (max 3 cifras):\n"
    lenEP=.-edadPreg
    cabecera: .ascii "Nombre\tEdad\n"
    lenC=.-cabecera
    fileName: .string "registro.txt"
    saltoLinea: .ascii "\n"
    opInvalida: .string "Opción no válida\n"
    lenOI=.-opInvalida
    tab: .ascii "\t"
    msgBorrar: .string "¿Qué línea quieres borrar?: "
    lenMB=.-msgBorrar
    msgEC: .string "Línea inválida\n"
    lenMEC=.-msgEC
    fileNameProv: .string "registroProv.txt"
    warningBuffer: .string "Tu respuesta ha sido demasiado larga, puede que haya ocurrido algo raro\n"
    lenWB=.-warningBuffer
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
    .lcomm entradaLB,10
    .lcomm lineaABorrar,4
    .lcomm lenEB,4
    .lcomm guardaDescriptor,4
    .lcomm lineaActual,4
.section .text
.globl _start
_start:

    movl $4, %eax
    movl $1, %ebx
    movl $bienvenida, %ecx
    movl $lenB, %edx
    int $0x80


bucle_main:
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
        # Leer el contenido del archivo
        movl $3, %eax # sys_read
        movl %edi, %ebx # descriptor del archivo
        movl $buffer, %ecx # buffer
        movl $1, %edx # tamaño del buffer
        int $0x80
        
        # Guardar el número de bytes leídos
        movl %eax, %edx

        lea buffer, %ebx
        cmpb $10, (%ebx)
        jne no_sumar_linea
        lea lineas, %ebx
        incl (%ebx)
        no_sumar_linea:
        # Escribir el contenido del buffer en la salida estándar
        movl $4, %eax # sys_write
        movl $1, %ebx # descriptor de la salida estándar
        movl $buffer, %ecx # buffer
        int $0x80

        # Restar el número de bytes leídos del tamaño total
        subl %edx, %esi

        # Si aún quedan bytes por leer, volver al inicio del bucle
        cmpl $0, %esi
        jg read_loop

        movl $4, %eax
        movl $1, %ebx
        movl $cierreLectura, %ecx
        movl $lenCL, %edx
        int $0x80
    fin_read_loop:
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
    call purgar_buffer
    jmp op_invalida
    salto_purga_1:
    movb respuesta, %al
    orb $0x20, %al
    cmpb $97,%al
    je nuevo_registro
    cmpb $115,%al
    je fin_bucle_main
    cmpb $98,%al
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
convertir_a_entero:
    movl $4, %eax
    movl $1, %ebx
    movl $msgBorrar, %ecx
    movl $lenMB, %edx
    int $0x80

    movl $3, %eax
    movl $0, %ebx
    movl $entradaLB, %ecx
    movl $10, %edx
    int $0x80

    lea lenEB, %esi
    movl %eax, (%esi)
    lea entradaLB, %esi
    addl %eax, %esi
    decl %esi
    cmpl $10,(%esi)
    je saltarse_purga
    lea lenEB, %esi
    incl (%esi)
    call purgar_buffer
    saltarse_purga:
    movl $lenEB,%ecx
    movl (%ecx),%ecx
    decl %ecx
    lea entradaLB, %esi
    lea lineaABorrar, %ebx
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
    lea lineas,%esi
    movl (%esi),%esi
    decl %esi
    cmpl %esi,(%ebx)
    jg error_conversion
    ret
    error_conversion:
        movl $4, %eax
        movl $1, %ebx
        movl $msgEC, %ecx
        movl $lenMEC, %edx
        int $0x80
        xorl %eax,%eax
        movl %edi,%esi
        lea entradaLB,%edi
        movl $10,%ecx
        rep stosb
        lea lineaABorrar,%edi
        movl $4,%ecx
        rep stosb
        movl %esi,%edi
        jmp convertir_a_entero
    movl $5, %eax
    movl $fileNameProv, %ebx
    movl $0x0442, %ecx
    movl $0666, %edx
    int $0x80
    movl %eax, (guardaDescriptor)
    #empezamos en la línea 0
    movl $0, lineaActual
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
        # Leer el contenido del archivo
        movl $3, %eax # sys_read
        movl %edi, %ebx # descriptor del archivo
        movl $buffer, %ecx # buffer
        movl $1, %edx # tamaño del buffer
        int $0x80
        
        # Guardar el número de bytes leídos
        movl %eax, %edx

        lea buffer, %ebx
        cmpb $10, (%ebx)
        jne skip_sumar_linea
        lea lineaActual, %ebx
        incl (%ebx)
        skip_sumar_linea:
        movl lineaActual, %eax
        movl lineaABorrar, %ebx
        cmpl %eax, %ebx
        je skip_escribir_en_nuevo
        # Escribir el contenido del buffer en la salida estándar
        movl guardaDescriptor,%ebx
        movl $4, %eax # sys_write
        movl $buffer, %ecx # buffer
        int $0x80
        skip_escribir_en_nuevo:
        # Restar el número de bytes leídos del tamaño total
        subl %edx, %esi

        # Si aún quedan bytes por leer, volver al inicio del bucle
        cmpl $0, %esi
        jg read_loop_borrar
    fin_read_loop_borrar:
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
    movl $4, %eax
    movl $1, %ebx
    movl $warningBuffer, %ecx
    movl $lenWB, %edx
    int $0x80

    movl $3, %eax
    movl $0, %ebx
    movl $basura, %ecx
    movl $1, %edx
    int $0x80
    lea basura,%esi
    cmpb $10, (%esi)
    jne purgar_buffer
    ret


