function ensambla(){
	case "$#" in
	1)
		as "$1".asm -o "$1".o --32
		ld -m elf_i386 -s "$1".o -o "$1"
		;;
	2)
		if [ "$2" = "-d" ]
			then
			echo "Ensamblando en modo debug"
			as -g "$1".asm -o "$1".o --32
			ld -m elf_i386 "$1".o -o "$1"
		else
		as "$1".asm -o "$2".o --32			
		ld -m elf_i386 -s "$2".o -o "$2"
		fi
		;;
	3)
		if [ "$3" = "-d" ]
			then
			echo "Ensamblando en modo debug"
			as -g "$1".asm -o "$2".o --32
			ld -m elf_i386 "$2".o -o "$2"
		else
			echo "3er arg inválido"
		fi
		;;
	*)
		echo "args inválidos\nUso correcto: ensambla <nombre_del_archivo> <nombre_del_ejecutable (opcional)> <-d opcional para gdb>\n"
		;;
	esac	
}
export -f ensambla