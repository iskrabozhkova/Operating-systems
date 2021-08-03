#include <err.h>
 #include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <stdint.h>
#include <stdlib.h>
  #include <unistd.h>

int main(int argc, char* argv[]){
    if(argc != 2){
        err(1, "Wrong number of parameters");
    }
    int fd = open(argv[1], O_RDWR);
    if(fd == -1){
        err(2, "Cannot open the file");
    }
    uint8_t buffer[4096];
    int count[256] = {0};
    int rs;

    while((rs = read(fd, &buffer, sizeof(buffer))) != 0){
        if(rs == -1){
            int errno_cpy = errno;
            close(fd);
            errno = errno_cpy;
            err(3, "Error while reading file");
        }
        for(int i = 0; i < rs; i++){
            count[buffer[i]]++;
        }
    }
    if(lseek(fd, 0, SEEK_SET) == -1){
         int errno_cpy = errno;
            close(fd);
            errno = errno_cpy;
            err(3, "Error lseeking");
    }
    for(int i = 0; i < 256; i++){
        uint8_t c = i;
        while(count[i] > 0){
            if(write(fd, &c, 1) != 1){
                int errno_cpy = errno;
                close(fd);
                errno = errno_cpy;
                err(3, "Error while writing in file");
            }
            count[i]--;
        }
    }
    close(fd);
    exit(0);
}