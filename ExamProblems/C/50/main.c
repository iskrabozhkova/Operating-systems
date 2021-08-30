#include <unistd.h>
#include <err.h>
  #include <sys/types.h>
       #include <sys/stat.h>
       #include <fcntl.h>
#include <string.h>



int main(int argc, char* argv[]){
    for(int i = 1; i < argc; i++){
        if(strcmp(argv[i], "-") == 0){
            char c;
            while(read(1, &c, sizeof(c)) > 0){
                write(1, &c, sizeof(c));
            }
        }else{
            int fd = open(argv[i], O_RDONLY);
            if(fd == -1){
                err(1, "Cannot open the file");
            }
            char c;
            while(read(fd, &c, sizeof(c)) > 0){
                write(1, &c, sizeof(c));
            }
            close(fd);
        }
    }

}