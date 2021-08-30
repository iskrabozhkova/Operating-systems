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



int main(int argc, char* argv[]){
    if(argc != 2){
        err(1, "Wrong number of arguments");
    }
    struct user{
        uint32_t id;
		uint16_t reserved1;
		uint16_t reserved2;
		uint32_t start;
		uint32_t end;
    };
    struct user u;
    struct stat st;
    if(stat(argv[1], &st) == -1){
        err(2, "Error with stat");
    }
    //open file
    int fd = open(argv[1], O_RDWR);
    if(fd == -1){
        err(2, "Error with open");
    }
    
    uint32_t num_users=st.st_size / sizeof(u);
    uint32_t sum = 0;

    while(read(fd, &u, sizeof(u)) == sizeof(u)){
        sum = sum + (u.end - u.start);
    }
    if( lseek(fd,0,SEEK_SET) == -1 ) {
		int old=errno;
		close(fd);
		errno=old;
		err(4,"Failed to lseek file");
	}
    uint32_t avg = sum / num_users;
    uint32_t disp = 0;
    while(read(fd, &u, sizeof(u)) == sizeof(u)){
        disp = disp + (u.end - u.start - avg)*(u.end - u.start - avg);
    }
    disp = disp / num_users;

    if( lseek(fd,0,SEEK_SET) == -1 ) {
		int old=errno;
		close(fd);
		errno=old;
		err(4,"Failed to lseek file");
	}
    while(read(fd, &u, sizeof(u)) == sizeof(u)){
        uint32_t power = (u.end - u.start)*(u.end - u.start);

        if(power > disp){
            uint32_t id = u.id;
            if( write(1,&id,sizeof(id)) != sizeof(id)) {
				int old=errno;
				close(fd);
				errno=old;
				err(-3,"Failed to write user id");
			}
        }
    }
}