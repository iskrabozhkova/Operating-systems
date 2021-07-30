#include <stdio.h>
#include <err.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>


int main(int argc, char* argv[]){
    if(argc != 2){
        err(1, "Wrong number of parameters");
    }
    int pid = fork();
    if(pid == 0){
        if(execlp(argv[1], argv[1], (char*)NULL) == -1){
            err(2, "Couldn't exec the program");
        }
    }else if(pid > 0){
        int status;
        wait(&status);
        if(WIFEXITED(status)){
            printf("Command %s is executed\n", argv[1]);
        }
    }else{
        err(3, "Fork failed");
    }
    exit(0);
}