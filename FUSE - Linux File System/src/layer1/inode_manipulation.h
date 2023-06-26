
#include <disk_abstraction.h>



// TODO: Change later
#define INODES_PER_BLOCK 4
#define INODE_LIST_SIZE 99
#define NUM_BUFFER_BLOCKS 900
#define INDIRECTIONS_PER_BLOCK 2
#define NUM_DIRECT_BLOCKS 1
// block 0: superblock
// block 1-99: inodes
// block 100-999: buffer


// 4 inodes in one block
struct inode {
    int direct_blocks [NUM_DIRECT_BLOCKS];
    int single_indirect_block;
    int double_indirect_block;
    int triple_indirect_block;
    int filelength; // in bytes
    int permissions;
    int accesstime;
    int owner;
    //int next_free_inode;
    int other_data[249 - NUM_DIRECT_BLOCKS]; // change later
};

struct free_inode {
    int next_free_inode;
    int was_allocated;
    int other_data[254];
};

struct inode_block {
    struct inode inode_arr[INODES_PER_BLOCK];
};


struct free_data_block {
    int next_free_block;
    int was_allocated;
    int other_data[1022];
};

struct superblock {
    int next_free_inode_num;
    int next_free_data_block;
    int inodes_allocated; // how many inodes already allocated
    int max_inodes; // how many inodes can the filesystem store
    int inodes_per_block; // how many inodes per block
    int indirections_per_block; // INDIRECTIONS_PER_BLOCK
    int buffer_allocated; // how many blocks of buffer have already been allocated
    int max_buffer_blocks; // how many blocks of buffer can the filesystem store
    int other_data [1017];
};

struct indirect_block {
    int block_nums [1024];
};
int print_superblock ();

int makefs (); 
// first allocate space
// then handle superblock and free lists

int inode_allocate(); // returns the inode number for the newly allocated inode
// change superblock free list

int inode_free (int inode_num); // Do we need to return an inode pointer for the read? -- I don't think so
// call buffer_free for all blocks to be deallocated

struct inode* inode_read(int inode_num); // returns an inode pointer for the inode_num

int inode_write (int inode_num, struct inode* inode_data); // returns 0 if write successful

int buffer_allocate (int inode_num, int size); // returns the block number for the recently allocated block disk space
// change superblock free list

int buffer_free (int block_num); // frees the block, returns 0 if successful
// ??? for the parameter
// change superblock free list

int buffer_read (int inode_num, const int seek, int length, char** buffer); 
// read from the inode
// start from the int seek and read until the length,
// returns a buffer (pass by reference) for what is read until the end of the file or end of length
// returns a int for the length of read (which could be less than length if file is shorter)

int buffer_write (int inode_num, int seek, char* string, int length); 
// returns an int for the length of the write
// automatically calls buffer_allocate if necessary