#include <err.h>
 #include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <stdint.h>
#include <stdlib.h>
  #include <unistd.h>

int main(int argc, char* argv[]){
    if(argc != 3){
        err(1, "Wrong number of parameters");
    }
    int fd1 = open(argv[1], O_RDONLY);
    if(fd1 == -1){
        err(2, "Cannot open the file");
    }
    int fd2 = open(argv[2], O_RDONLY);
    if(fd2 == -1){
        int errno_cpy = errno;
        close(fd1);
        errno_cpy = errno;
        err(2, "Cannot open the file");
    }
    int fd3 = open("f3", O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR);
    if(fd3 == -1){
        int errno_cpy = errno;
        close(fd1);
        close(fd2);
        errno_cpy = errno;
        err(3, "Cannot open the file");
    }
    
    uint32_t x[2];
    while(read(fd1, x, sizeof(x)) == sizeof(x)){
        
    }
    exit(0);
}