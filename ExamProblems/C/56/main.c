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
    if(argc != 4){
        err(1, "Wrong number of parameters");
    }
    //header
    struct header{
        uint32_t magic; 
        uint8_t header_version;
        uint8_t data_version;
        uint16_t count;    
        uint32_t reserved1;
        uint32_t reserved2;
    };

    struct header head;
    struct stat st;
    if(stat(argv[1],&st) == -1){
        err(2, "Error with stat");
    }
    //data 0x00
    struct data0{
        uint16_t offset;
		uint8_t original_byte;
		uint8_t new_byte;
    };
    //data 0x01
    struct data1{
        uint32_t offset;
        uint16_t original_word;
        uint16_t new_word;
    };
    //open f1 file
    int f1 = open(argv[2], O_RDONLY);
    if(f1 == -1){
        err(3, "Error while opening the file");
    }
    //open f2 file
    int f2 = open(argv[3], O_RDWR);
    if(f2 == -1){
        int old = errno;
        close(f1);
        errno=old;
        err(4, "Error while opening f2");
    }
    //copy f1 to f2
    uint8_t c;
    while(read(f1, &c, sizeof(c)) > 0){
        if(write(f2, &c,sizeof(c)) != sizeof(c)){
            int old=errno;
            close(f1);
            close(f2);
            errno=old;
            err(5, "Error while writing in the file");
        }
    }
    //lseek na dvata faila
    if( lseek(f1,0,SEEK_SET) == -1 ) {
		int old=errno;
		close(f1);
		close(f2);
		errno=old;
		err(6,"Failed to lseek f1");
	}
	
	if( lseek(f2,0,SEEK_SET) == -1 ) {
        int old=errno;
        close(f1);
        close(f2);
        errno=old;
        err(7,"Failed to lseek f2");
    }
    //open patch
    int patch = open(argv[1], O_RDONLY);
    if(patch == -1){
        int old=errno;
		close(f1);
		close(f2);
		errno=old;
		err(6,"Failed to patch");
    }
    if(head.header_version == 0x00){
        struct data0 d;
        while (read(patch, &d, sizeof(d))> 0){
            lseek(f2, d.offset, SEEK_SET);

            uint8_t b;
            read(f2, &b, sizeof(b));
            lseek(f2, -1*sizeof(uint8_t), SEEK_CUR);
            write(f2, &d.new_byte, sizeof(d.new_byte))

        }
    }
}