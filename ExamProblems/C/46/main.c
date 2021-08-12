//give error
#include<stdlib.h>
#include<stdint.h>
#include<err.h>
#include<errno.h>
#include<unistd.h>
#include<stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>


int main(int argc, char* argv[])
{
	if ( argc != 5 ) {
		err(1,"Invalid arguments");
	}
    int fd1 = open(argv[1], O_RDONLY);
    if(fd1 == -1){
        err(2, "Cannot open f1.dat");
    }
      int fd2 = open(argv[2], O_RDONLY);
    if(fd1 == -1){
        close(fd1);
        err(2, "Cannot open f2.idx");
    }
    int fd3 = open(argv[3], O_WRONLY | O_TRUNC | O_CREAT, 0666);
    if(fd3 == -1){
        close(fd1);
        close(fd2);
          err(3, "Cannot open f2.dat");
    }
        int fd4 = open(argv[4], O_WRONLY | O_TRUNC | O_CREAT, 0666);
    if(fd3 == -1){
        close(fd1);
        close(fd2);
        close(fd3);
          err(4, "Cannot open f2.idx");
    }

    uint16_t offset;
    uint8_t length;
    uint8_t nothing;

    int read_size;
    while((read_size = read(fd2, &offset, sizeof(offset)) == sizeof(offset))){
        if(read(fd2, &length, sizeof(length)) != sizeof(length)){
            err(5, "Error while reading the file");
        }
         if(read(fd2, &nothing, sizeof(nothing)) != sizeof(nothing)){
            err(5, "Error while reading the file");
        }
        char* symbols = malloc(length);
        if(lseek(fd1, offset, SEEK_SET) == -1){
            close(fd1);
            close(fd2);
            close(fd3);
            close(fd4);
            err(6, "Error while lseek");
        }
        if(read(fd1, &symbols, length) != length){
             close(fd1);
            close(fd2);
            close(fd3);
            close(fd4);
            err(6, "Error while reading");
        }
        if(length > 0 && (symbols[0] >= 'A' && symbols[0] <= 'Z')){
            if(write(fd3, &symbols, length)){
                 close(fd1);
                close(fd2);
                close(fd3);
                close(fd4);
                err(7, "Error while writing");
            }
            uint16_t curPos = -((uint16_t) length);
            if(lseek(fd3, curPos, SEEK_CUR) == -1){
                close(fd1);
                close(fd2);
                close(fd3);
                close(fd4);
                err(8, "Error while lseek");
            }
            if(write(fd4, &offset, sizeof(offset)) != sizeof(offset)){
                close(fd1);
                close(fd2);
                close(fd3);
                close(fd4);
                err(9, "Error while write");
            }
            if(write(fd4, &length, sizeof(length)) != sizeof(length)){
                close(fd1);
                close(fd2);
                close(fd3);
                close(fd4);
                err(9, "Error while write");
            }
            if(write(fd4, &nothing, sizeof(nothing)) != sizeof(nothing)){
                close(fd1);
                close(fd2);
                close(fd3);
                close(fd4);
                err(9, "Error while write");
            }
        }

    }
    if(read_size != 0){
        close(fd1);
        close(fd2);
        close(fd3);
        close(fd4);
        err(10,"Error while reading");
    }
    close(fd1);
    close(fd2);
    close(fd3);
    close(fd4);
    exit(0);
}