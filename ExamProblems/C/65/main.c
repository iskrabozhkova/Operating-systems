#include <err.h>
#include <unistd.h>
      #include <sys/types.h>
       #include <sys/stat.h>
       #include <fcntl.h>
#include <time.h>
#include <errno.h>
#include <sys/wait.h>
#include <string.h>

int strToInt(char* str){
    for(size_t i = 0; i < strlen(str); i++){
        if(str[i] >= '0' && str[i] <= '9'){
            return str[i] - '0';
        }
    }
    return -1;
}

int main(int argc, char* argv[]){
    if(argc < 2){
        err(1, "Wrong number of parametes");
    }
    int fd = open("run.log", O_CREAT | O_TRUNC | O_RDWR, 0666);
    if(fd == -1){
        err(2, "Cannot open the file");
    }
    struct timer{
        time_t start;
        time_t end;
        int code;
    };
    int counter =0;
    while(1){
        struct timer t;

        int pid = fork();
        if(pid == 0){
            t.start =time(NULL);

            if(execlp(argv[1], argv[1], (char*)NULL) == -1){
                int old = errno;
                close(fd);
                errno=old;
                err(2, "Error with execlp");
            }
        }
        int status;

        if(wait(&status) == -1){
            int old = errno;
            close(fd);
            errno = old;
            err(3, "Error with wait");
        }
        t.code=status;
        t.end = time(NULL);

        if(counter == 2 && (t.end - t.start) < strToInt(argv[1])  && t.code != 0){
            break;
        }else{
            if(write(fd, &t, sizeof(t)) != sizeof(t)){
                int old=errno;
                close(fd);
                errno=old;
                err(4,"Error with writhing in log file");
            };
            break;
        }
        counter++;
    }
}   