// code goes here
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>   
#include <stdlib.h>
#include <stdint.h>
#include <err.h>
#include <errno.h>
#include <sys/stat.h>

int main(int argc, char* argv[]){
    if(argc != 2){
        err(2, "Wrong number arguments");
    }
    //open file
    int fd = open(argv[1], O_RDONLY);
    if(fd == -1){
        err(1, "Cannot open program");
    }
   	struct stat st;
	if( stat(argv[1],&st) == -1 ) {
		err(1,"Failed to stat");
	}

    //skip magic word ORC
    if(lseek(fd, 3, SEEK_SET) == -1){
        int old=errno;
        close(fd);
        errno=old;
        err(5, "Error with lseek when trying to skip magic word ORC.");
    };

    uint32_t c;
    uint32_t ram_size = 0;

    //make struct for instructions
    struct Instruction{
        uint8_t opcode;
        int64_t firstOperand;
        int64_t secondOperand;
        int64_t thirdOperand;
    }__attribute__((packed));
    struct Instruction instructions;

    //check ram_size
    if(read(fd,&c, sizeof(c)) == sizeof(c)){
         ram_size = c;
    }

    //allocate memory
    uint64_t* ram = (uint64_t*) calloc(ram_size, sizeof(uint32_t));

    //read from file and do the instructions
    while(read(fd, &instructions, sizeof(instructions)) == sizeof(instructions)){
         //set
         if(instructions.opcode == 0x95){
           int64_t tar = instructions.firstOperand;
           int64_t val = instructions.secondOperand;
           ram[tar] = val;   
         }else if(instructions.opcode == 0xc1){
              int64_t v = instructions.firstOperand;
            if(write(1, &ram[v], sizeof(v)) != sizeof(ram[v])){
                err(3, "Error with write");
            }
         }else if(instructions.opcode == 0x5d){
              int64_t to = instructions.firstOperand;
              int64_t from_ptr = instructions.secondOperand;
              ram[to] = ram[from_ptr];
         }else if(instructions.opcode == 0x63){
              int64_t from_ptr = instructions.firstOperand;
              int64_t to = instructions.secondOperand;
              ram[to] = ram[from_ptr];
         }
         //add
         else if(instructions.opcode == 0xAD){
             int64_t res = instructions.firstOperand;
             int64_t v1 = instructions.secondOperand;
             int64_t v2 = instructions.thirdOperand;
             ram[res] = ram[v1] + ram[v2];
         }
         //multiply
          else if(instructions.opcode == 0x33){
             int64_t res = instructions.firstOperand;
             int64_t v1 = instructions.secondOperand;
             int64_t v2 = instructions.thirdOperand;
             ram[res] = ram[v1] * ram[v2];
         }
         //div
         else if(instructions.opcode == 0x04){
             int64_t res = instructions.firstOperand;
             int64_t v1 = instructions.secondOperand;
             int64_t v2 = instructions.thirdOperand;
             if(v2 == 0){
                 err(2, "You cannot divide by zero.");
             }else{
                ram[res] = ram[v1] / ram[v2];
             }
         }
         //mod
        else if(instructions.opcode == 0x04){
             int64_t res = instructions.firstOperand;
             int64_t v1 = instructions.secondOperand;
             int64_t v2 = instructions.thirdOperand;
             ram[res] = ram[v1] % ram[v2];
         }
         //nothing
         else if(instructions.opcode == 0x00){
             if(lseek(fd, 24, SEEK_CUR) == -1){
                int old=errno;
                close(fd);
                errno=old;
                err(5, "Error with lseek in nor instruction");
             };
         }
        //sgz
         //}
         else if(instructions.opcode == 0x25){
             int v = instructions.firstOperand;
             if(ram[v] > 0){
                if(lseek(fd, 49, SEEK_CUR) == -1){
                int old=errno;
                close(fd);
                errno=old;
                err(5, "Error with lseek in sgz instruction");
             };
             }
  
         }
         //sleep
         else if(instructions.opcode == 0xBF){
             int64_t v = instructions.firstOperand;
             sleep(ram[v] / 1000);
         }
         //jmp
         else if(instructions.opcode == 0x91){
             int64_t idx = instructions.firstOperand;
            int64_t idx_value = ram[idx];
            lseek(fd, 7 + (25*idx_value), SEEK_SET);
         }
     }
     close(fd);
     free(ram);
}
