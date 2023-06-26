#include <stdio.h>
#include "disk_abstraction.h"
/*
int main() {
   // printf() displays the string inside quotation
   printf("Hello, World 1!\n");
   return 0;
}
*/

int allocate_memory (int num_blocks) {
    //printf ("disksize = %d\n", num_blocks * BLOCK_SIZE);
    disk = malloc (num_blocks * BLOCK_SIZE);
    return 0;
}

struct block* block_read (int block_num) {
    struct block* read_buf = malloc (BLOCK_SIZE);
    memcpy( read_buf->buffer, &disk[block_num * BLOCK_SIZE], BLOCK_SIZE); 
    return read_buf;
}

int block_write (int block_num, struct block* write_buffer){
    //printf ("block_num * BLOCK_SIZE = %d\n", block_num * BLOCK_SIZE);

    memcpy( &disk[block_num * BLOCK_SIZE], write_buffer->buffer, BLOCK_SIZE); 
    return 0;
} // returns 0 if success, returns 1 if failure