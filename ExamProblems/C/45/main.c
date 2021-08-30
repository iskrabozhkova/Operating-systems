  #include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdint.h>
#include <err.h>
 #include <stdlib.h>
    #include <fcntl.h>

int cmp(const void* a, const void* b){
    return *((uint32_t*)a) - *((uint32_t*)b);
}
int main(int argc, char* argv[]){
    if(argc != 2) {
        err(2, "Wrong num of parameters");
    }
    struct stat st;
    stat(argv[1],&st);

    if(st.st_size % sizeof(uint32_t) != 0){
        err(1, "Wrong size");
    }

    //left
    uint32_t half = (st.st_size/sizeof(uint32_t))/2;
    uint32_t* left = malloc(half * sizeof(uint32_t));

    int fd = open(argv[1], O_RDONLY);
    if(fd == -1){
        err(2, "Cannot open the file");
    }

    int file = open("file", O_CREAT | O_TRUNC | O_RDWR, 0666);

    if(read(fd, &half, sizeof(half) * sizeof(uint32_t)) != sizeof(half) * sizeof(uint32_t) ){
        err(3, "Error reading file");
    }
    qsort(left, half, sizeof(uint32_t), cmp);
    write(file, &half, sizeof(uint32_t) * half );

    //right

    uint32_t* right = malloc(half * sizeof(uint32_t));
    int file2 = open("file2", O_CREAT | O_TRUNC | O_RDWR, 0666);

    if(read(fd, &half, sizeof(half) * sizeof(uint32_t)) != sizeof(half) * sizeof(uint32_t) ){
        err(3, "Error reading file");
    }
    qsort(right, half, sizeof(uint32_t), cmp);
    write(file2, &half, sizeof(uint32_t) * half );

    lseek(file, 0, SEEK_SET);
    lseek(file2, 0, SEEK_SET);

    int sorted = open("sorted", O_CREAT | O_TRUNC | O_RDWR, 0666);

    uint32_t i=0;
    uint32_t j=0;
    uint32_t c1;
    uint32_t c2;

    while (read(file, &c1, sizeof(c1)) > 0 && read(file2, &c2, sizeof(c1)) > 0 ){
        if(c1 <= c2){
            write(sorted, &c1, sizeof(c1));
            lseek(file2, -1 * sizeof(c1), SEEK_CUR);
            i++;
        }else{
            write(sorted, &c2, sizeof(c2));
            lseek(file, -1 * sizeof(c1), SEEK_CUR);
            j++;
        }
    }

    while(i < half){
         if(read(file, &c1, sizeof(c1)) > 0){
             write(sorted, &c1, sizeof(c1));
             i++;
         }
    }
    while (j < half){
         if(read(file2, &c2, sizeof(c2)) > 0){
             write(sorted, &c2, sizeof(c2));
             j++;
         }
    }
    close(file);
    close(file2);
 }