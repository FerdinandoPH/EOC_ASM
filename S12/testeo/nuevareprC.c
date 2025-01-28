

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
int main(int argc, char *argv[], char *envp[]){
    //Ejecuta /usr/bin/aplay de forma que reproduzca el archivo ./Recursos/t1.wav. Usa execve
    char *argv_n[] = {"/usr/bin/aplay", "./Recursos/t1.wav", "-q", NULL};
    // char *envp[] = {NULL};
    execve(argv_n[0], argv_n, envp);
    //system("aplay ./Recursos/t1.wav");
}