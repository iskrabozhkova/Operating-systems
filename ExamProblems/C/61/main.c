#include <sys/types.h>                    
#include<string.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <err.h>
#include <errno.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
   #include <sys/wait.h>

int main(){
    char buffer[1024];
    ssize_t count = read(0, buffer,sizeof(buffer));
    if(count < 0){
        err(1, "Error while reading");
    }
    buffer[count-1] = '\0';

    pid_t pid = fork();
    if(pid == -1){
        err(2, "Error with fork");
    }
    if(pid == 0){
        //execute the command
        if(execlp(buffer, "cmd", (char*)NULL) == -1){
            err(3, "Error while execute the command");
        }
    }
    int status;
    if(wait(&status) == -1){
        err(4, "Error while waiting");
    }

    exit(0);
    }
