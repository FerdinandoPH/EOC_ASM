#include <termios.h>
#include <unistd.h>
#include <stdlib.h>
int main(){
    struct termios orig_termios;

// Guardar la configuración actual para restaurarla más tarde
if (tcgetattr(STDIN_FILENO, &orig_termios) < 0) {
    exit(EXIT_FAILURE);
}

struct termios new_termios = orig_termios;
cfmakeraw(&new_termios);

// Restablecer la capacidad de recibir señales de interrupción
new_termios.c_cc[VMIN] = 1;  // Set the minimum number of bytes
new_termios.c_cc[VTIME] = 0; // No timeout
new_termios.c_lflag |= ISIG; // Habilitar ISIG para permitir señales de INTR, QUIT, SUSP
return 0;
}