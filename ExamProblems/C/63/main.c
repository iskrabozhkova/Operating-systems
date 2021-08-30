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

int main(int argc, char* argv[]){
    //flag for echo 
    int flag = 1;

    if(argc == 2){
    //check command length
        if(strlen(argv[1]) > 4){
            flag=0;
            errx(1, "Length of command has to be max 4 symbols");
        }
    }
    //make buffer for stdin
    char* buffer = malloc(sizeof(char) * 8);
    uint8_t rd_size = read(0, buffer, sizeof(buffer));
    if(rd_size > sizeof(char) *8){
        int old = errno;
        free(buffer);
        errno = old;
        err(2, "Failed to read commands");
    }

    int len = strlen(buffer);
    int j = 0;
    while(1){
        char* first = malloc(sizeof(char) * 5);
        char* second = malloc(sizeof(char) * 5);
        first[0]='\0';
        second[0]='\0';

        for(int i = 0; i < len; i++){
            if(buffer[i] == '\n' || buffer[i] == 0x20){
                first[i] = '\0';
                j++;
                break;
            }
            first[i] = buffer[j];
            j++;
        }
        for(int i = 0; i < len; i++){
            if(buffer[i] == '\n' || buffer[i] == 0x20){
                second[i] = '\0';
                j++;
                break;
            }
            second[i] = buffer[j];
            j++;
        }
        if(first[0] == '\0'){
            break;
        }

        int pid = fork();
        if(pid == -1){
            int old = errno;
            free(buffer);
            errno=old;
            err(3, "Error with fork");
        }

        if(pid == 0){
            if(flag == 1){
                //execute command echo 
                //if there is second parameter
                if(second[0] != '\0'){
                    if(execlp("echo", "echo", first,second, (char*)NULL) == -1){
                        int old = errno;
                        free(buffer);
                        errno=old;
                        err(4, "Error with echo");
                    }
                }else{
                    if(execlp("echo", "echo", first, (char*)NULL) == -1){
                        int old = errno;
                        free(buffer);
                        errno=old;
                        err(4, "Error with echo");
                    }
                }
            }else{
                if(second[0] != '\0'){
                    if(execlp("echo", "echo", argv[1],argv[1], (char*)NULL) == -1){
                        int old = errno;
                        free(buffer);
                        errno=old;
                        err(4, "Error with echo");
                    }
                }else{
                    if(execlp("echo", "echo",  argv[1], (char*)NULL) == -1){
                        int old = errno;
                        free(buffer);
                        errno=old;
                        err(4, "Error with echo");
                    }
                }
            }
        }
        //In parent
        int status;
        if(wait(&status) == -1){
            int old=errno;
            free(buffer);
            errno=old;
            err(5, "Error with wait");
        }
        if(!WIFEXITED(status) || WEXITSTATUS(status) != 0){
             int old=errno;
            free(buffer);
            errno=old;
            err(5, "Error with child execution");
        }
        if(j == len - 1){
            break;
        }
    }
}