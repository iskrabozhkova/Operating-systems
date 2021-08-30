#include <sys/types.h>                    
#include<string.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <err.h>
#include <errno.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
   #include <sys/wait.h>

int main(int argc, char* argv[]){
    if(argc != 2){
        err(1, "Wrong num of arg");
    }
    pid_t pid = fork();
    if(pid == -1){
        err(1, "Failed to fork");
    }

    //child
    if(pid == 0){
        int a[2];
        if(pipe(a) == -1){
            err(2, "Failed to pipe");
        }
        int pid2 = fork();
         if(pid2 == -1){
            err(1, "Failed to fork");
        }
        if(pid2 == 0){
            //cat file

            close(a[0]);
            dup2(a[1], 1);
            close(a[1]);
        }
         if ( execlp("cat",argv[1], (char*)NULL) == -1 ) {
			     err(4,"Failed to execute cat");
	  	}

        int status;
	    if( wait(&status) == -1 ) {
		    err(5,"Failed to wait for child(cat)");
        }
        close(a[1]);
        dup2(a[0],0);
        close(a[0]);

        if( !WIFEXITED(status) ||  WEXITSTATUS(status) != 0 ) {
		    err(3,"Cannot cat");
        }

	     if( execlp("sort", argv[1],(char*)NULL) == -1 ) {
		     err(4,"Cannot sort");
 	     }
    }
      exit(0);

  
}