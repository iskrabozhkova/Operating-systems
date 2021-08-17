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

int flag=0;
int new_line_flag=1;
uint8_t counter=1;

int main(int argc, char* argv[]){
   if(strcmp(argv[1], "-n") == 0){
       flag=1;
   }

    for(int i = 2; i < argc; i++){
        if(strcmp(argv[i],"-") == 0){
            char c;
            while(read(0,&c,sizeof(c)) > 0){
                if(new_line_flag == 1){
                    setbuf(stdout, NULL);
                    fprintf(stdout, "%d ",counter);
                    new_line_flag=0;
                }
                write(1,&c,sizeof(c));
                if(c == '\n'){
                    new_line_flag=1;
                    counter++;
                }
            }
        }else{
            int fd=open(argv[2], O_RDONLY);
            char c;
            while(read(fd,&c,sizeof(c)) > 0){
                if(new_line_flag == 1){
                    setbuf(stdout, NULL);
                    fprintf(stdout, "%d ",counter);
                    new_line_flag=0;
                }
                write(1,&c,sizeof(c));
                if(c == '\n'){
                    new_line_flag=1;
                    counter++;
                }
            }
            close(fd);
        }
        }
}