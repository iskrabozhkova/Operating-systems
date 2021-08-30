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

//-c3 --> return the number
int searchNumber(char* str){
    int len = strlen(str);
    for(int i = 0; i < len ; i++){
        if (str[i] >= '0' && str[i] <= '9')
			return str[i] - '0';
    }
    return -1;
}
int main(int argc, char* argv[]){
    if(strcmp(argv[1], "-c") == 0){
        if(argc == 5){
            int begin = searchNumber(argv[2]);
            int end = searchNumber(argv[4]);
            int length = end - begin;

            for(int i = 0; i < length;i++){
                 char c;
                while (read(0, &c, sizeof(c)) > 0){
                    write(1,&c, sizeof(c));
                }
            }
        }else{
            int num = searchNumber(argv[2]);
            char* buffer = (char*) malloc (sizeof(char) * num);
            read(0, buffer, sizeof(char)*num);
                
            char c;
            while (read(0, &c, sizeof(c)) > 0){
                write(1,&c, sizeof(c));
            }
        }
    }else if(strcmp(argv[1], "-d") == 0){
        if(argc == 7){
            int first = searchNumber(argv[4]);
            int second = searchNumber(argv[6]);
            int end = second - first;

            int c;
            char delimiter = argv[2][0];
            int counter = 1;
            while(read(0, &c, sizeof(c)) > 0){
                if(c == delimiter){
                    counter++;
                }
                if(counter >= first && counter <=end){
                    write(1, &c, sizeof(c));
                }
            }
        }else{
            char delimiter = argv[2][0];
            int num = searchNumber(argv[4]);
            int counter = 1;
            char c;
            while(read(0, &c, sizeof(c)) > 0){
                if(c == delimiter){
                    counter++;
                }
                if(counter == num){
                    if(c != delimiter){
                        write(1, &c, sizeof(c));
                    }
                }
            }
        }
    }
}