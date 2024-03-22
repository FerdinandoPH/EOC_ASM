#!/bin/bash
    
    #Esta función recibe los siguientes argumentos necesarios:
    # Nombre del archivo fuente. A no ser que la flag -e esté presente, se asume que el archivo fuente es un archivo .asm
    
    #También puede recibir los siguientes argumentos opcionales:
    # Nombre del archivo de salida, precedido de la flag -o. Si no está presente, se asume que el archivo de salida se llamará igual que el archivo fuente, pero sin la extensión .asm

    #Flag -g, que indica que se deben generar símbolos de depuración. Si no está presente, no se generarán, y se añadirá -s en ld
    #Flag -e, que indica que el nombre del archivo fuente no tiene extensión .asm

    #Librerías, seguidas de la flag -l. Si no está presente, no se añadirán librerías. Pueden ser varias, separadas por una coma. Ejemplo: -l printf,scanf

    #La función debe funcionar independientemente del orden en el que se pasen los argumentos (excepto por que la salida debe estar inmediatamente después de -o, y las librerías inmediatamente después de -l). Si alguno de los argumentos no es válido, se debe mostrar un mensaje de error y salir del script

    #El funcionamiento del programa es el siguiente: el programa debe llamar a as y ld siguiendo el procedimiento indicado de los argumentos. as siempre llevará la flag --32, y ld siempre llevará la flag -m elf_i386. Si se ha pasado la flag -g, as llevará la flag -g. Si se han pasado librerías, ld las añadirá. Si no se ha pasado la flag -g, ld llevará la flag -s
function errorArgumentos(){
    echo "Error en los argumentos"
}

    es_debug=false
    librerias=()
    leyendo_librerias=false
    librerias_leidas=false
    leyendo_output=false
    output_leido=false
    es_explicito=false
    fuente_leida=false
    nombre_output=""
    nombre_fuente=""
    while [ "$#" -gt 0 ]; do
        case "$1" in
            -g)
                if [ $es_debug = false ] && [ $leyendo_librerias = false ] && [ $leyendo_output = false ]; then
                    es_debug=true
                else
                    errorArgumentos
                    return 1
                fi
                ;;
            -l)
                if [ $leyendo_librerias = false ] || [ $leyendo_output = true ] || [ $librerias_leidas = true ]; then
                    errorArgumentos
                    return 1
                else
                    leyendo_librerias=true
                fi
                ;;
            -o)
                if [ $leyendo_output = true ] || [ $leyendo_librerias = true ] || [ $output_leido = true ]; then
                    errorArgumentos
                    return 1
                else
                    leyendo_output=true
                fi
                ;;
            -e)
                if [ $es_explicito = false ] && [ $leyendo_librerias = false ] && [ $leyendo_output = false ]; then
                    es_explicito=true
                else
                    errorArgumentos
                    return 1
                fi
                ;;
            *)
                if $leyendo_librerias; then
                    IFS=',' read -ra librerias <<< "$1"
                    librerias_leidas=true
                    leyendo_librerias=false
                elif $leyendo_output; then
                    nombre_output="$1"
                    output_leido=true
                    leyendo_output=false
                else
                    if [ $fuente_leida = false ]; then
                        nombre_fuente="$1"
                        fuente_leida=true
                    else
                        errorArgumentos
                        return 1
                    fi
                fi
                ;;
        esac
        shift
    done
    if [ $fuente_leida = false ]; then
        errorArgumentos
        return 1
    fi
    if [ $output_leido = false ]; then
        nombre_output="${nombre_fuente%.*}"
    fi
    if [ $es_explicito = false ]; then
        nombre_fuente="$nombre_fuente.asm"
    fi
    if [ $es_debug = true ]; then
        as --32 -g -o "$nombre_output.o" "$nombre_fuente"
    else
        as --32 -o "$nombre_output.o" "$nombre_fuente"
    fi
    if [ ${#librerias[@]} -gt 0 ]; then
        if [ $es_debug = true ]; then
            ld -m elf_i386 -o "$nombre_output" "${librerias[@]/#/-l}" "$nombre_output.o"
        else
            ld -m elf_i386 -s -o "$nombre_output" "${librerias[@]/#/-l}" "$nombre_output.o"
        fi
    else
        if [ $es_debug = true ]; then
            ld -m elf_i386 -o "$nombre_output" "$nombre_output.o"
        else
            ld -m elf_i386 -s -o "$nombre_output" "$nombre_output.o"
        fi
    fi



