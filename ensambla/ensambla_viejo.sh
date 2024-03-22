# shellcheck disable=SC2148
function ensambla(){
	arg1=$1
	aSE=${arg1%%.*}
	case "$#" in
	1)
		as "$1" -o "$aSE".o --32
		ld -m elf_i386 -s "$aSE".o -o "$aSE"
		;;
	2)
		if [ "$2" = "-g" ]
			then
			echo "Ensamblando en modo debug"
			as -g "$1" -o "$aSE".o --32
			ld -m elf_i386 "$aSE".o -o "$aSE"
		else
		as "$1" -o "$2".o --32			
		ld -m elf_i386 -s "$2".o -o "$2"
		fi
		;;
	3)
		if [ "$3" = "-g" ]
			then
			echo "Ensamblando en modo debug"
			as -g "$1" -o "$2".o --32
			ld -m elf_i386 "$2".o -o "$2"
		else
			echo "3er arg inválido"
		fi
		;;
	*)
		echo "args inválidos\nUso correcto: ensambla <nombre_del_archivo> <nombre_del_ejecutable (opcional)> <-g opcional para gdb>"
		;;
	esac	
}
export -f ensambla