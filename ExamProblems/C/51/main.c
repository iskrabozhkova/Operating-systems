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

int contains(char c, char* set) {
	int len=strlen(set);
	for(int i=0;i<len;i++) {
		if( c==set[i]) {
			return 1;
		}
	}
	
	return 0;
}

int main(int argc, char* argv[]){
    if(argc == 1){
        err(1,"No arguments");
    }
    if(strcmp(argv[1], "-d") == 0){
        char c;
        while(read(0, &c, sizeof(c)) > 0){
            //strchr -> searches for the first occurrence of the character 
            char* searched = strchr(argv[2], c);
            if(!searched){
                write(1,&c,sizeof(c));
            }
        }
    }else if(strcmp(argv[1], "-s") == 0){
        char c;
           int flag=0;
        while(read(0, &c, sizeof(c)) > 0){
            if(contains(c, argv[2])){
                if(flag == 0){
                     write(1,&c,sizeof(c));
                }
                flag=1;
            }else{
                     write(1,&c,sizeof(c));
                     flag=0;
                
            }
        }
    }
}