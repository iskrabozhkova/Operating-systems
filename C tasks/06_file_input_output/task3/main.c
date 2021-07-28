#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <err.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char* argv[]){
     char c;
    int lines = 0;
    int words = 0;
    int chars = 0;
    if(argc != 2){
         err(2, "Wrong number of parameters");
    }
    int fd1=open(argv[1], O_RDONLY);
    if(fd1 == -1){
        err(1, "Cannot open the file");
    }
   

    while(read(fd1, &c, 1) > 0){
        if(c =='\n'){
            lines++;
            words++;
        }
        if(c ==' '){
            words++;
        }
        chars++;
    }
    printf("File has %d lines, %d words, %d chars\n", lines, words, chars);
    close(fd1);
}