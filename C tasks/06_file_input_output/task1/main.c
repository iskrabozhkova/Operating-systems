//copy from file1 to file2
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <err.h>
#include <unistd.h>
 #include <stdlib.h>

int main(){
    int fd1 = open("file1.txt", O_RDONLY);
    int fd2 = open("file2.txt" , O_CREAT| O_WRONLY);
    char c;

    if(fd1 == -1){
        err(1, "Cannot open file.txt");
        close(fd1);
        exit(1);
    }
       if(fd2 == -1){
        err(2, "Cannot open file2");
        close(fd2);
        exit(2);
    }
    while(read(fd1, &c, 1)){
        write(fd2, &c, 1);
    }

 close(fd1);
 close(fd2);
 exit(0);
}