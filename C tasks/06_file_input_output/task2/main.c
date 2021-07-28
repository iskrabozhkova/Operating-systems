#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <err.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char* argv[]){
    if(argc != 2){
        errx(2,"Wrong number of parameters");
        exit(1);
    }
    int fd1 = open(argv[1], O_RDONLY);
    if(fd1 == -1){
        err(1, "Cannot open the file");
        exit(2);
    }
    char c;
    int i = 0;
    while(read(fd1, &c, 1)){
        if(c == '\n'){
            i++;
        }
        write(1, &c, 1);
        if(i == 10){
            break;
        }
    }

    exit(0);
}