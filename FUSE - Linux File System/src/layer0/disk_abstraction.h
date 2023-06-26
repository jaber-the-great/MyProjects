
#define BLOCK_SIZE 4096
// TODO: public final variable block size = 4096

// variable to store malloc'd allocate memory
char* disk;

struct block {
    char buffer[BLOCK_SIZE];
};


int allocate_memory (int num_blocks); // returns 0 if success, returns 1 if failure

struct block* block_read (int block_num); // how do we return a block?

int block_write (int block_num, struct block* write_buffer); // returns 0 if success, returns 1 if failure