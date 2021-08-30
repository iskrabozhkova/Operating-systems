#include <err.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(int argc, char* argv[]){

    //find argv[1] -type -printf "%f %T@\n" | sort -nrk2 | head -n 1 | cut -d " " -f 1
    if(argc != 2){
        err(1, "Wrong num of parameters");
    }
    int a[2];

    if(pipe(a) == -1){
        err(2, "Error with pipe");
    }
    int pid = fork();
    if(pid == -1){
        err(3, "Error with fork");
    }
    if(pid == 0){
        close(a[0]);
        dup2(a[1], 1);
        close(a[1]);

        if(execlp("find", "find", argv[1], "-type", "f", "-printf", "%f %T\n", (char*)NULL) == -1){
            err(4, "Error with find");
        }
    }
    int status;
    if(wait(&status) == -1){
        err(5, "Error with wait");
    }
    if(!WIFEXITED(status) || WEXITSTATUS(status) != 0){
        err(5, "Error executing child");
    }
    close(a[1]);

    int b[2];
    if(pipe(b) == -1){
        err(6, "Error with pipe b");
    }
    int pid2 = fork();

    if(pid2 == -1){
        err(7, "Error with fork2");
    }

    if(pid2 == 0){
        //take input from find
        dup2(a[0], 0);
        close(b[0]);
        dup2(b[1], 1);
        if(execlp("sort","sort","-n","-r","-k2",(char*)NULL) == -1){
            err(8, "Error sort");
        }
    }
      int status;
    if(wait(&status) == -1){
        err(5, "Error with wait");
    }
    if(!WIFEXITED(status) || WEXITSTATUS(status) != 0){
        err(5, "Error executing child");
    }
    close(b[1]);
}