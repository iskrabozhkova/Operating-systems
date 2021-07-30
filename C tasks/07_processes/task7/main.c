//don't work
#include <stdio.h>
#include <err.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>


int main(int argc, char* argv[]){
    if(argc != 4){
        err(1, "Wrong number of parameters");
    }
    for(int i = 0; i < argc; i++){
        int pid = fork();
        if(pid == 0){
            if(execlp(argv[1], argv[1], (char*)NULL) == -1){
                err(2, "Couldn't exec the program");
            }
        }else if(pid > 0){
            int status;
            wait(&status);
            if(WIFEXITED(status)){
                printf("Pid: %d\nStatus: %d\n", pid, WEXITSTATUS(status));
            }
        }else{
            err(3, "Fork failed");
        }
    }
    exit(0);
}