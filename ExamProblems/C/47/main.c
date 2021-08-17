#include<stdlib.h>
#include<stdint.h>
#include<unistd.h>
#include<err.h>
#include<errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

//TO DO: test it

int main( int argc, char* argv[] )
{
	if ( argc != 4 ) {
		err(1,"Invalid arguments");
	}

    int fd1 = open(argv[2],O_RDONLY);
   if( fd1 == -1 ) {
		err(2,"Coudn't open file fd1 ");
	}

	int fd2 = open(argv[2],O_RDONLY);
	if( fd2 == -1 ) {
		err(3,"Coudn't open file fd2");
	}

	int patch=open(argv[3],O_RDWR);
	if( patch == -1 ) {
		err(4,"Coudn't open patch file");
	}

    struct elements{
        uint16_t offset;
		uint8_t f1_original;
		uint8_t f2_new;
    };

    struct elements e;
    uint8_t c1;
    uint8_t c2;

    while (read(fd1, &c1, sizeof(c1)) && read(fd2, &c2, sizeof(c2))){
        if(c1 != c2){
            //determine the current offset
            e.offset=lseek(fd1, 0, SEEK_CUR)-1;
            if(e.offset  == (uint16_t)-1 ) {
				int old=errno;
				close(fd1);
				close(fd2);
				close(patch);
				errno=old;
				err(-4,"Coudn't lseek() file");
			}
            e.f1_original=c1;
            e.f2_new=c2;

            if(write(patch, &e,sizeof(e)) != sizeof(e)){
                int old=errno;
                 close(fd1);
                 close(fd2);
                 close(patch);
                 errno=old;
                 err(-4,"Coudn't write in patch");
            }
        }
    }
}