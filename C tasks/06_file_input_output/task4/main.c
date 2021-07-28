//cat with multiple arguments

#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <err.h>
#include <stdlib.h>

int main(int argc, char* argv[]){
    for(int i = 0; i < argc; i++){
        int fd = open(argv[i], O_RDONLY);
        char c;
        ssize_t read_size;

        while((read_size = read(fd, &c, sizeof(c))) >0){
            write(1,&c,sizeof(c));
        }
        close(fd);
    }
    exit(0);
}