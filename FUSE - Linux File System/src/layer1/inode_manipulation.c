

#include "inode_manipulation.h"
#include <stdio.h>

int print_superblock () {
    struct superblock* sb = (struct superblock*)block_read (0);
    printf( "--------- print_superblock() -----------\n");
    printf ("int next_free_inode_num = %d\n", sb->next_free_inode_num );
    printf ("int next_free_data_block = %d\n", sb->next_free_data_block);
    printf ("int inodes_allocated = %d\n", sb->inodes_allocated);
    printf ("int max_inodes = %d\n", sb->max_inodes); // how many inodes can the filesystem store
    printf ("int inodes_per_block = %d\n", sb->inodes_per_block); // how many inodes per block
    printf ("int indirections_per_block = %d\n", sb->indirections_per_block); // INDIRECTIONS_PER_BLOCK
    printf ("int buffer_allocated = %d\n", sb->buffer_allocated ); // how many blocks of buffer have already been allocated
    printf ("int max_buffer_blocks = %d\n", sb->max_buffer_blocks); // how many blocks of buffer can the filesystem store)
    printf( "-------- end print_superblock() ---------\n");
    free(sb);
}

int inode_block_num (int inode_num) {
    return inode_num / INODES_PER_BLOCK + 1; // four inodes per block, +1 for superblock
}

int inode_position (int inode_num) {
    return inode_num % INODES_PER_BLOCK; // INODES_PER_BLOCK inodes per block, +1 for superblock
}

// start_block and end_block may be longs
// make a test case for
int* get_block_nums (int inode_num, int start_block, int end_block) { // includes the end_block
    // read inode
    struct inode* inode_for_blocks = inode_read(inode_num);

    int* block_arr = malloc ((end_block - start_block + 1) * sizeof(int));
    
    int arr_counter = 0;
    int i;
    for (i = start_block; i < end_block +1; i++) {
        if (i < NUM_DIRECT_BLOCKS) { // direct blocks, 0-9
            block_arr[arr_counter] = inode_for_blocks->direct_blocks[i];
            // ("arr_counter = %d, block_arr[arr_counter] = %d\n", arr_counter, block_arr[arr_counter]);
        }
        else if (i < NUM_DIRECT_BLOCKS + INDIRECTIONS_PER_BLOCK) { // single indirect
            int index_after_direct_blocks = i - NUM_DIRECT_BLOCKS;

            // read the single indirect block
            struct indirect_block* indir_block = (struct indirect_block*)block_read (inode_for_blocks->single_indirect_block);
            // TODO: memcopy so we don't have to block_read every time
            block_arr[arr_counter] = indir_block->block_nums[index_after_direct_blocks];
            free (indir_block);
        }
        else if (i < NUM_DIRECT_BLOCKS + INDIRECTIONS_PER_BLOCK + 
            INDIRECTIONS_PER_BLOCK * INDIRECTIONS_PER_BLOCK) { // double indirect
            int index_after_single_indirect = i - NUM_DIRECT_BLOCKS - INDIRECTIONS_PER_BLOCK;

            struct indirect_block* double_indir_block = (struct  indirect_block*)block_read (inode_for_blocks->double_indirect_block);
            // get single indirect block
            int single_indirect_block_num = double_indir_block->block_nums[(index_after_single_indirect) / INDIRECTIONS_PER_BLOCK];
            //printf ("single_indirect_block_num = %d\n", single_indirect_block_num);
            struct indirect_block* single_indir_block = (struct indirect_block*)block_read (single_indirect_block_num);
            // TODO: memcopy so we don't have to block_read every time
            block_arr[arr_counter] = single_indir_block->block_nums[(index_after_single_indirect) % INDIRECTIONS_PER_BLOCK];
            free (double_indir_block);
            free (single_indir_block);
        }
        else { // triple indirect
            int index_after_double_indirect = i - NUM_DIRECT_BLOCKS - INDIRECTIONS_PER_BLOCK - INDIRECTIONS_PER_BLOCK * INDIRECTIONS_PER_BLOCK;

            struct indirect_block* triple_indir_block = (struct indirect_block*)block_read (inode_for_blocks->triple_indirect_block);
            int double_indirect_block_num = triple_indir_block->block_nums[(index_after_double_indirect) / (INDIRECTIONS_PER_BLOCK * INDIRECTIONS_PER_BLOCK)];

            struct indirect_block* double_indir_block = (struct indirect_block*)block_read (double_indirect_block_num);
            // get single indirect block
            int single_indirect_block_num = double_indir_block->block_nums[( (index_after_double_indirect) % (INDIRECTIONS_PER_BLOCK * INDIRECTIONS_PER_BLOCK) ) / INDIRECTIONS_PER_BLOCK ];

            struct indirect_block* single_indir_block = (struct indirect_block*)block_read (single_indirect_block_num);
            // TODO: memcopy so we don't have to block_read every time
            block_arr[arr_counter] = single_indir_block->block_nums[( (index_after_double_indirect) % (INDIRECTIONS_PER_BLOCK * INDIRECTIONS_PER_BLOCK) ) % INDIRECTIONS_PER_BLOCK];
            free (triple_indir_block);
            free (double_indir_block);
            free (single_indir_block);
        }
        arr_counter ++;
    }

    int u;
    for (u = 0; u < (end_block - start_block + 1); u++) {
        printf ("get_block_nums returns index[%d] = %d\n", u, block_arr[u]);
    }

    return block_arr;
}


int allocate_buffer_block() { // allocates the next free block, returns the block_num for the allocated block
    // read the superblock
    struct superblock* sb = (struct superblock*)block_read (0);

    // find the next free data block
    int block_num = sb->next_free_data_block;
    // printf ("1 allocate next_free_data_block = %d\n", block_num);
    // printf ("1 allocate set next_free_inode_num = %d\n", sb->next_free_inode_num);

    // whatever calls this doesn't get the memo that we've run out of space
    // Run out of space
    if (block_num == 0) {
        return 0;
    }

    // read the free block
    struct free_data_block* allocated_block = (struct free_data_block*)block_read (block_num);

    // write the free block's next block pointer into superblock
    sb->next_free_data_block = allocated_block->next_free_block;
    sb->buffer_allocated++;
    block_write (0, (struct block*) sb);
    //print_superblock();

    // printf ("2 allocate set next_free_inode_num = %d\n", sb->next_free_inode_num);
    // printf ("2 allocate set next_free_data_block = %d\n", sb->next_free_data_block);
    free (sb);
    free (allocated_block);
    return block_num;
}

// block_num is the single indirect block
// it may already contain information (starting_blocks is the number of blocks already allocated in the SIDB)
// return number of blocks allocated
int allocate_single_indirect_block (int block_num, int starting_blocks, int remaining_blocks) {
    struct indirect_block* in_block = (struct indirect_block*)block_read (block_num);
    
    int num_blocks_allocated = 0;
    int i;
    for (i = starting_blocks; i < remaining_blocks + starting_blocks && i < INDIRECTIONS_PER_BLOCK; i++) { // increment up to 1024 + 10 or total_blocks
        in_block->block_nums[i] = allocate_buffer_block();
        if (in_block->block_nums[i] == 0) {
            // run out of space in the file system
            break;
        }
        num_blocks_allocated ++;
    }

    block_write (block_num, (struct block*)in_block);
    free(in_block);
    return num_blocks_allocated;
}

// block_num is the double indirect block
// it may already contain information (starting_blocks is the number of blocks already allocated in the DIDB)
// return number of blocks allocated
int allocate_double_indirect_block (int block_num, int starting_blocks, int remaining_blocks) {
    struct indirect_block* in_block = (struct indirect_block*)block_read (block_num);
    // find which single indirect block to start
    // 1025 - second 1025 / 1024 = 1 index, starting block exists
    // 1024 - second 1024 / 1024 = 1 index, starting block doesn't exist
    // 1023 - first 1023 / 1024 = 0 index, starting block exists


    // starting_blocks = 1024
    // i = 1
    int starting_single_indirect = starting_blocks / INDIRECTIONS_PER_BLOCK;
    int num_blocks_allocated = 0;
    int i;
    for (i = starting_single_indirect; remaining_blocks > 0 && i < INDIRECTIONS_PER_BLOCK; i++) { // increment up to 1024 + 10 or total_blocks
        // how do we know if the first indirect blocks already exists?

        int single_indirect_block_num;
        int allocated_single_indirect_blocks;

        // only enter if statement if block already exists
        // Condition 1: starting_blocks % INDIRECTIONS_PER_BLOCK != 0, not starting with new single indirect
        // Condition 2: and not the first time
        if (starting_blocks % INDIRECTIONS_PER_BLOCK != 0) { // What is this??? -> && starting_blocks > i * INDIRECTIONS_PER_BLOCK
            // printf ("Single indirect block already exists kekw\n");
            // printf ("starting_blocks = %d\n", starting_blocks);

            // read the block from the in_block
            single_indirect_block_num = in_block->block_nums[i];
            allocated_single_indirect_blocks = allocate_single_indirect_block(single_indirect_block_num, starting_blocks % INDIRECTIONS_PER_BLOCK, remaining_blocks);
            remaining_blocks -= allocated_single_indirect_blocks;
            // // TODO: Fix later, only runs out of space when less space than is possible is allocated and less than remaining blocks needed to allocated
            // if (allocated_single_indirect_blocks < 
            //     INDIRECTIONS_PER_BLOCK - (starting_blocks % INDIRECTIONS_PER_BLOCK)) {
            //     // run out of space in the file system
            //     break;
            // }
        }
        else {
            // printf ("Single indirect block doesn't already exists kekw\n");
            // printf ("starting_blocks = %d\n", starting_blocks);

            // create a new single indirect block
            single_indirect_block_num = allocate_buffer_block();
            in_block->block_nums[i] = single_indirect_block_num;
            allocated_single_indirect_blocks = allocate_single_indirect_block(single_indirect_block_num, 0, remaining_blocks);
            remaining_blocks -= allocated_single_indirect_blocks;
            // // TODO: Fix later, only runs out of space when less space than is possible is allocated and less than remaining blocks needed to allocated
            // if (allocated_single_indirect_blocks < INDIRECTIONS_PER_BLOCK) {
            //     // run out of space in the file system
            //     break;
            // }
        
        }
        num_blocks_allocated += allocated_single_indirect_blocks;
    }

    block_write (block_num, (struct block*)in_block);
    free(in_block);
    return num_blocks_allocated;
}


// block_num is the triple indirect block
// it may already contain information (starting_blocks is the number of blocks already allocated in the DIDB)
// return number of blocks allocated
int allocate_triple_indirect_block (int block_num, int starting_blocks, int remaining_blocks) {
    struct indirect_block* in_block = (struct indirect_block*)block_read (block_num);
    // find which single indirect block to start
    // 1025 - second 1025 / 1024 = 1 index, starting block exists
    // 1024 - second 1024 / 1024 = 1 index, starting block doesn't exist
    // 1023 - first 1023 / 1024 = 0 index, starting block exists


    // starting_blocks = 1024
    // i = 1
    int starting_double_indirect = starting_blocks / (INDIRECTIONS_PER_BLOCK * INDIRECTIONS_PER_BLOCK);
    int num_blocks_allocated = 0;
    int i;
    for (i = starting_double_indirect; remaining_blocks > 0 && i < INDIRECTIONS_PER_BLOCK; i++) { // increment up to 1024 + 10 or total_blocks
        // how do we know if the first indirect blocks already exists?

        int double_indirect_block_num;
        int allocated_double_indirect_blocks;

        // only enter if statement if block already exists
        // Condition 1: starting_blocks % INDIRECTIONS_PER_BLOCK != 0, not starting with new single indirect
        // Condition 2: and not the first time
        if (starting_blocks % (INDIRECTIONS_PER_BLOCK * INDIRECTIONS_PER_BLOCK) != 0) { //  && starting_blocks > i * INDIRECTIONS_PER_BLOCK *INDIRECTIONS_PER_BLOCK
            // read the block from the in_block

            // printf ("Double indirect block already exists kekw\n");
            // printf ("starting_blocks = %d\n", starting_blocks);
            double_indirect_block_num = in_block->block_nums[i];
            allocated_double_indirect_blocks = allocate_double_indirect_block(double_indirect_block_num, 
                starting_blocks % (INDIRECTIONS_PER_BLOCK * INDIRECTIONS_PER_BLOCK), remaining_blocks);
            remaining_blocks -= allocated_double_indirect_blocks;
            // // TODO: Fix later, only runs out of space when less space than is possible is allocated and less than remaining blocks needed to allocated
            // if (allocated_double_indirect_blocks < 
            //     INDIRECTIONS_PER_BLOCK*INDIRECTIONS_PER_BLOCK - (starting_blocks % (INDIRECTIONS_PER_BLOCK * INDIRECTIONS_PER_BLOCK))) {
            //     // run out of space in the file system
            //     break;
            // }
        }
        else {
            // printf ("Double indirect block doesn't already exists kekw\n");
            // printf ("starting_blocks = %d\n", starting_blocks);

            // create a new double indirect block
            double_indirect_block_num = allocate_buffer_block();
            in_block->block_nums[i] = double_indirect_block_num;
            allocated_double_indirect_blocks = allocate_double_indirect_block(double_indirect_block_num, 0, remaining_blocks);
            remaining_blocks -= allocated_double_indirect_blocks;
            // // TODO: Fix later, only runs out of space when less space than is possible is allocated and less than remaining blocks needed to allocated
            // if (allocated_double_indirect_blocks < INDIRECTIONS_PER_BLOCK*INDIRECTIONS_PER_BLOCK) {
            //     // run out of space in the file system
            //     break;
            // }   
        }
        num_blocks_allocated += allocated_double_indirect_blocks;
    }

    block_write (block_num, (struct block*)in_block);
    free(in_block);
    return num_blocks_allocated;
}



int free_single_indirect_block (int block_num) {
    if (block_num == 0) {
        return 0;
    }
    
    // read indirect block
    struct indirect_block* in_block = (struct indirect_block*)block_read (block_num);

    // loop through and call buffer_free for each block
    int i;
    for (i = 0; i < INDIRECTIONS_PER_BLOCK; i++) {
        if (in_block->block_nums[i] != 0) {
            buffer_free(in_block->block_nums[i]);
        } 
    }
    free (in_block);
    buffer_free(block_num);
    return 0;
}

int free_double_indirect_block (int block_num) {
   if (block_num == 0) {
        return 0;
    }

    // read indirect block
    struct indirect_block* in_block = (struct indirect_block*)block_read (block_num);

    // loop through and call buffer_free for each block
    int i;
    for (i = 0; i < INDIRECTIONS_PER_BLOCK; i++) {
        if (in_block->block_nums[i] != 0) {
            free_single_indirect_block(in_block->block_nums[i]); 
        }
    }
    free (in_block);
    buffer_free(block_num);
    return 0;
}

int free_triple_indirect_block (int block_num) {
   if (block_num == 0) {
        return 0;
    }

    // read indirect block
    struct indirect_block* in_block = (struct indirect_block*)block_read (block_num);

    // loop through and call buffer_free for each block
    int i;
    for (i = 0; i < INDIRECTIONS_PER_BLOCK; i++) {
        if (in_block->block_nums[i] != 0) {
            free_double_indirect_block(in_block->block_nums[i]); 
        }
    }
    free (in_block);
    buffer_free(block_num);
    return 0;
}

int makefs () {


    allocate_memory (INODE_LIST_SIZE + NUM_BUFFER_BLOCKS + 1); 
    // a) write superblock (block at 0)
    // 1) next free inode number
    // 2) next free buffer block
    struct superblock * sb = malloc (BLOCK_SIZE);
    sb->next_free_inode_num = 0; // doesn't refer to a block
    sb->next_free_data_block = INODE_LIST_SIZE + 1; // superblock first, then i list, then first free data block
    sb->inodes_allocated = 0; 
    sb->max_inodes = INODE_LIST_SIZE * INODES_PER_BLOCK;
    sb->inodes_per_block = INODES_PER_BLOCK;
    sb->indirections_per_block = INDIRECTIONS_PER_BLOCK;
    sb->buffer_allocated = 0; 
    sb->max_buffer_blocks = NUM_BUFFER_BLOCKS; 

    block_write (0, (struct block*) sb);
    // printf("2\n");
    // print_superblock();
    
    free (sb);

    //int write (int block_num, struct block* write_buffer); // returns 0 if success, returns 1 if failure

    // b) write free pointers for inodes
    int i;
    for (i = 0; i < INODE_LIST_SIZE; i++) {
        struct free_inode* inode_block = malloc (BLOCK_SIZE);
        int j;
        for (j = 0; j < INODES_PER_BLOCK; j++) {
            inode_block[j].next_free_inode = i * INODES_PER_BLOCK + j + 1;
            inode_block[j].was_allocated = 0;
            if (i * INODES_PER_BLOCK + j + 1 >= INODES_PER_BLOCK * INODE_LIST_SIZE) {
                // If we've run out of inodes
                inode_block[j].next_free_inode = -1;
            }
        }
        block_write (i+1, (struct block*) inode_block);
        free (inode_block);
    }


    // c) write free pointers for buffer blocks
    // block 0: superblock
    // block 1-99: inodes
    // block 100-999: buffer
    for (i = INODE_LIST_SIZE + 1; i < NUM_BUFFER_BLOCKS + INODE_LIST_SIZE + 1; i++) {
        struct free_data_block* data_block = malloc (BLOCK_SIZE);
        data_block->next_free_block = i + 1;
        data_block->was_allocated = 0;
        if (i + 1 > NUM_BUFFER_BLOCKS + INODE_LIST_SIZE) {
            data_block->next_free_block = 0;
        }
        block_write (i, (struct block*) data_block);
        free (data_block);
    }

}
// first allocate space
// then handle superblock and free lists

int inode_allocate() {
    // read superblock
    struct superblock* sb = (struct superblock*)block_read (0);

    // get next free inode from superblock
    int next_inode = sb->next_free_inode_num;

    // We've run out of inodes, so return -1; no space left
    if (next_inode == -1) {
        return -1;
    }

    // change free list
    // read from the inode to get the next free inode
    struct free_inode* inode_block = (struct free_inode*)block_read (inode_block_num(next_inode));
    // array of four free_inodes
    sb->next_free_inode_num = inode_block [inode_position(next_inode)].next_free_inode; 
    // printf("-----------inode_block_num-------------- = %d\n", inode_block_num(next_inode));
    // printf("-----------next_inode-------------- = %d\n", next_inode);
    // printf("-----------next_free_inode_num-------------- = %d\n", sb->next_free_inode_num);
    sb->inodes_allocated ++;

    // write new superblock
    block_write (0, (struct block*) sb);
    // printf("3\n");
    // print_superblock();

    free (sb);
    free (inode_block);

    // may have to write an empty inode
    struct inode* empty_inode = (struct inode*)malloc (sizeof (struct inode));
    memset (empty_inode, 0, sizeof(struct inode));
    inode_write (next_inode, empty_inode);
    free(empty_inode);

    // return inode
    return next_inode;
} // returns the inode number for the newly allocated inode
// change superblock free list

int inode_free (int inode_num) {
    // read inode
    struct inode_block* inode_block = (struct inode_block*)block_read (inode_block_num(inode_num));
    struct inode* inode_to_free = (struct inode*) (&(inode_block->inode_arr[inode_position(inode_num)]));

    // loop through directs, call buffer_free for all single directs
    int i;
    for (i = 0; i < NUM_DIRECT_BLOCKS; i++) {
        if (inode_to_free->direct_blocks[i] != 0) {
            buffer_free(inode_to_free->direct_blocks[i]); 
        }
    }

    // single indirects
    free_single_indirect_block (inode_to_free->single_indirect_block);

    // double indirects
    free_double_indirect_block (inode_to_free->double_indirect_block);

    // same for triple indirects
    free_triple_indirect_block (inode_to_free->triple_indirect_block);


    // read superblock
    struct free_inode* freed_inode = (struct free_inode*)inode_to_free;
    
    struct superblock* sb = (struct superblock*)block_read (0);
    freed_inode->next_free_inode = sb->next_free_inode_num; // What is this???

    sb->next_free_inode_num = inode_num;
    sb->inodes_allocated--;
    // write blocks

    block_write (0, (struct block*) sb);
    // printf("4\n");
    // print_superblock();
    block_write (inode_block_num(inode_num), inode_block);
    free (sb);
    free (inode_block);
} // Do we need to return an inode pointer for the read? -- I don't think so
// call buffer_free for all blocks to be deallocated

struct inode* inode_read(int inode_num) {
    struct inode_block* inode_block = (struct inode_block*)block_read (inode_block_num(inode_num));
    struct inode* inode_to_free = (struct inode*)(&(inode_block->inode_arr[inode_position(inode_num)]));

    struct inode* inode_copy = malloc(sizeof(struct inode));
    memcpy( inode_copy, inode_to_free, sizeof(struct inode)); 
    free (inode_block);
    return inode_copy;
} // returns an inode pointer for the inode_num

int inode_write (int inode_num, struct inode* inode_data) {
    // read block for inode
    struct inode_block* inode_block = (struct inode_block*)block_read (inode_block_num(inode_num));
    struct inode* inode_to_write = (struct inode*)(&(inode_block->inode_arr[inode_position(inode_num)]));
    // copy data into the block
    memcpy(inode_to_write, inode_data, sizeof(struct inode)); 
    // write new block
    block_write (inode_block_num(inode_num), inode_block);

    free (inode_block);
} // returns 0 if write successful

int buffer_allocate (int inode_num, int size) { // size is in bytes
    //printf ("called buffer_allocate with inode_num = %d, size = %d\n", inode_num, size);

    // read the inode
    struct inode_block* inode_block = (struct inode_block*)block_read (inode_block_num(inode_num));
    struct inode* inode_to_allocate = (struct inode*)(&(inode_block->inode_arr[inode_position(inode_num)]));

    // based on filelength, calculate direct block or indirect block to extend
    // first calculate how many more blocks to allocate
    int total_blocks = (size + inode_to_allocate-> filelength + (BLOCK_SIZE - 1)) / BLOCK_SIZE;
    // round up to the number of blocks

    // find out how many blocks this file owns
    int current_blocks = (inode_to_allocate-> filelength + (BLOCK_SIZE - 1)) / BLOCK_SIZE;

    // file is 4097 bytes, current_blocks = 2
    // size is 2*4096, total_blocks = 4

    // start at 2, increment to 3
    // 0, 1, 2, 3

    // how many blocks are needed
    int new_blocks = total_blocks - current_blocks;
    int tmp_newly_allocated = new_blocks;

    if (new_blocks <= 0) {
        free (inode_block);
        return 0; // no new blocks are necessary to allocate, so return 0 blocks allocated
    }

    

    // max file size > INDIRECTIONS_PER_BLOCK^3, so needs to be long
    // file size is larger than max file
    if (total_blocks > INDIRECTIONS_PER_BLOCK * INDIRECTIONS_PER_BLOCK * INDIRECTIONS_PER_BLOCK 
        + INDIRECTIONS_PER_BLOCK * INDIRECTIONS_PER_BLOCK + INDIRECTIONS_PER_BLOCK + NUM_DIRECT_BLOCKS) {
        free (inode_block);
        return -1; // filesize is larger than max file size
    }

    struct superblock* sb = (struct superblock*)block_read (0);    

    // max file size > INDIRECTIONS_PER_BLOCK^3, so needs to be long
    // file size is larger than remaining blocks
    if (new_blocks >= sb->max_buffer_blocks - sb->buffer_allocated) {
        free (sb);
        free (inode_block);
        return -2; // run out of space
    }

    // current_blocks = 4 blocks already allocated, need new_blocks = 12 blocks
    // NUM_DIRECT_BLOCKS - 4 = 6

    // start of direct blocks
    if (current_blocks < NUM_DIRECT_BLOCKS && new_blocks > 0) { // only enter if there are fewer than NUM_DIRECT_BLOCKS blocks already allocated
        int i;
        for (i = current_blocks; i < total_blocks && i < NUM_DIRECT_BLOCKS; i++) { // increment up to NUM_DIRECT_BLOCKS or total_blocks
            inode_to_allocate->direct_blocks[i] = allocate_buffer_block();
        }
        if (total_blocks < NUM_DIRECT_BLOCKS) {
            current_blocks = total_blocks;
            new_blocks = 0; // we don't need to allocate anything else
        }
        else {
            int completed_blocks = (NUM_DIRECT_BLOCKS - current_blocks);
            current_blocks = NUM_DIRECT_BLOCKS;
            new_blocks = new_blocks - completed_blocks;
        }
    }
    
    // start of single indirect blocks
    if (current_blocks >= NUM_DIRECT_BLOCKS && current_blocks < INDIRECTIONS_PER_BLOCK + NUM_DIRECT_BLOCKS && new_blocks > 0) {
        // start by allocating space for the single indirect block if necessary
        if (inode_to_allocate->single_indirect_block == 0) {
            inode_to_allocate->single_indirect_block = allocate_buffer_block();
        }

        int completed_blocks = allocate_single_indirect_block(inode_to_allocate->single_indirect_block, current_blocks - NUM_DIRECT_BLOCKS, new_blocks);
        new_blocks -= completed_blocks;
        current_blocks += completed_blocks;  
    }

    // start of double indirect blocks
    if (current_blocks >= INDIRECTIONS_PER_BLOCK + NUM_DIRECT_BLOCKS 
        && current_blocks < INDIRECTIONS_PER_BLOCK * INDIRECTIONS_PER_BLOCK + INDIRECTIONS_PER_BLOCK + NUM_DIRECT_BLOCKS 
        && new_blocks > 0) {
        
        // start by allocating space for the double indirect block if necessary
        if (inode_to_allocate->double_indirect_block == 0) {
            inode_to_allocate->double_indirect_block = allocate_buffer_block();
        }

        int completed_blocks = allocate_double_indirect_block(inode_to_allocate->double_indirect_block, current_blocks - INDIRECTIONS_PER_BLOCK - NUM_DIRECT_BLOCKS, new_blocks);
        new_blocks -= completed_blocks;
        current_blocks += completed_blocks;    
    }
    
    // start of triple indirect blocks
    if (current_blocks >= INDIRECTIONS_PER_BLOCK * INDIRECTIONS_PER_BLOCK + INDIRECTIONS_PER_BLOCK + NUM_DIRECT_BLOCKS 
        && new_blocks > 0) {
        
        // start by allocating space for the triple indirect block if necessary
        if (inode_to_allocate->triple_indirect_block == 0) {
            inode_to_allocate->triple_indirect_block = allocate_buffer_block();
        }

        int completed_blocks = allocate_triple_indirect_block(inode_to_allocate->triple_indirect_block, 
            current_blocks - INDIRECTIONS_PER_BLOCK * INDIRECTIONS_PER_BLOCK - INDIRECTIONS_PER_BLOCK - NUM_DIRECT_BLOCKS, new_blocks);
        new_blocks -= completed_blocks;
        current_blocks += completed_blocks; 
    }
    block_write (inode_block_num(inode_num), inode_block);

    free (sb);
    free (inode_block);
    return tmp_newly_allocated;
} 

// What if we need to shorten the size of the file???
int buffer_free (int block_num){
    // check to make sure block_num != 0
    if (block_num == 0){
        return 0;
    }

    // read superblock
    struct superblock* sb = (struct superblock*)block_read (0);
    int next_free = sb->next_free_data_block;

    // overwrite buffer block with new next pointer
    struct free_data_block* data_block = malloc (BLOCK_SIZE);
    data_block -> next_free_block = next_free;
    block_write (block_num, (struct block*) data_block);

    // overwrite superblock with this block num's pointer
    sb->next_free_data_block = block_num;
    sb->buffer_allocated--;
    block_write (0, (struct block*) sb);
    // printf("5\n");
    // print_superblock();

    // free things
    free (sb);
    free (data_block);
} // frees the block, returns 0 if successful
// ??? for the parameter
// change superblock free list


// read from the inode
// start from the int seek and read until the length,
// returns a buffer (pass by reference) for what is read until the end of the file or end of length
// returns a int for the length of read (which could be less than length if file is shorter)
int buffer_read (int inode_num, const int seek, int length, char** buffer) {
    if (length == 0) {
        return 0;
    }

    //printf ("1 seek = %d\n", seek);

    // 1. read from inode
    struct inode* inode_to_read = inode_read(inode_num);

    // 2. trim length of read if too long
    // filelength = 9
    // seek = 0
    // length = 9
    // read_length = 9
    //int read_length = length;
    if (length + seek > inode_to_read->filelength) {
        length = inode_to_read->filelength - seek;
    }
    *buffer = (char *) malloc (length);
    char* buf = *buffer;

    // 3. Get start and end blocks to read
    int start_block = seek / BLOCK_SIZE; 
    int end_block = (seek+length) / BLOCK_SIZE; // Needs to be fixed (off by one) (if divisible by BLOCK_SIZE, then should be -1)

    if ((seek+length) % BLOCK_SIZE == 0 && (seek+length) != 0) { // TODO: Check
        end_block -= 1;
    }

    int* block_arr = get_block_nums (inode_num, start_block, end_block);
    int arr_length = end_block - start_block + 1;

    //printf ("read arr_length = %d\n", arr_length);

    // first block to read
    struct block* first_block = block_read(block_arr[0]);

    int copy_len = BLOCK_SIZE - (seek % BLOCK_SIZE);
    if (length < copy_len) {
        copy_len = length;
    }

    //printf ("seek mod BLOCK_SIZE = %d\n", seek % BLOCK_SIZE);
    memcpy (buf, &first_block->buffer[seek % BLOCK_SIZE], copy_len);
    free (first_block);

    // last block to read write
    if (end_block != start_block) {
        struct block* last_block = block_read(block_arr[arr_length - 1]);
        int first_block_bytes = BLOCK_SIZE - ((seek) % BLOCK_SIZE); // how many bytes were written in the first block
        int copy_len = (length - first_block_bytes) % BLOCK_SIZE;
        if (copy_len == 0) {
            copy_len = BLOCK_SIZE;
        }
        //printf ("1 Inside read, position = %d\n", first_block_bytes + BLOCK_SIZE * (arr_length -2));
        memcpy (&(buf[first_block_bytes + BLOCK_SIZE * (arr_length -2)]), last_block->buffer, copy_len);

        free (last_block);
    }

    int i;
    //struct block* write_block = (struct block*)malloc (BLOCK_SIZE);
    for (i = 1; i < arr_length - 1; i++) { // i starts at 1 because we handled the first block already
        struct block* read_block = (struct block*) block_read(block_arr[i]);
        int position = i * BLOCK_SIZE - ((seek) % BLOCK_SIZE);
        //printf ("i * BLOCK_SIZE = %d\n", i * BLOCK_SIZE);
        //printf ("2 seek = %d\n", seek);
        //printf ("(seek) mod BLOCK_SIZE = %d\n", (seek) % BLOCK_SIZE);
        //printf ("2 Inside read, position = %d\n", position);
        memcpy (&(buf[position]), read_block->buffer, BLOCK_SIZE);
        free (read_block);
        // if i = 1, then it means we are writing to the second block
    }
    //free (write_block);
    return length;
}

// returns an int for the length of the write
// automatically calls buffer_allocate if necessary
// seek might need to be a long, same for length
int buffer_write (int inode_num, int seek, char* string, int length){

    if (length == 0) {
        return 0;
    }

    // 1. read from inode
    struct inode* inode_to_read = inode_read(inode_num);


    // 2. allocate more space for the block if necessary
    int current_filelength = inode_to_read->filelength;
    free (inode_to_read);
    if (seek + length > current_filelength) {
        // printf ("buffer_write current_filelength = %d\n", current_filelength);
        // printf ("buffer_write seek = %d\n", seek);
        // printf ("buffer_write length = %d\n", length);

        int extend_file = seek + length - current_filelength;
        
        int file_extended = buffer_allocate (inode_num, extend_file);

        if (file_extended == -1) { // filesize > max filesize
            // handle case here
            return -1;
        }
        else if (file_extended == -2) { // disk has filled up
            // handle case
            return -2;
        }

        struct inode* inode_to_read2 = inode_read(inode_num);
        inode_to_read2->filelength = seek + length;
        inode_write (inode_num, inode_to_read2);
        free (inode_to_read2);
    }

    //struct inode* inode_to_read2 = inode_read(inode_num);
    // get starting block
    // get final block to write
    // iterate through list of blocks

    int start_block = seek / BLOCK_SIZE; 
    int end_block = (seek+length) / BLOCK_SIZE; // Needs to be fixed (off by one) (if divisible by BLOCK_SIZE, then should be -1)
    // last block we write to
    // Ex. seek = 0, length = 0
    // What it should be: end_block = 0  
    // Ex. seek = 0, length = 4096
    // What it should be: end_block = 0
    // Ex. seek = 0, length = 4097
    // What it should be: end_block = 1

    if ((seek+length) % BLOCK_SIZE == 0) {
        end_block -= 1;
    }


    int* block_arr = get_block_nums (inode_num, start_block, end_block);
    int arr_length = end_block - start_block + 1;
    // printf ("arr_length = %d\n", arr_length);

    // first block to read write
    // printf ("block_arr[0] = %d\n", block_arr[0]);
    fflush (stdout);
    struct block* first_block = block_read(block_arr[0]);

    int copy_len = BLOCK_SIZE - (seek % BLOCK_SIZE);
    if (length < copy_len) {
        copy_len = length;
    }

    // seek = 4096, refers to the first byte of block 2
    // seek = 0, refers to the first byte of block 1

    // Ex. seek = 4095, length = 5
    // First block needs to copy first 1 byte of string to the 4096th positions
    // position = 4095
    // minimum (length of copy) = 2
    // 
    //printf ("copy_len = %d\n", copy_len);

    memcpy (&first_block->buffer[seek % BLOCK_SIZE], string, copy_len);

    block_write (block_arr[0], first_block);
    free (first_block);

    // last block to read write
    if (end_block != start_block) {
        struct block* last_block = block_read(block_arr[arr_length - 1]);
        int first_block_bytes = BLOCK_SIZE - ((seek) % BLOCK_SIZE); // how many bytes were written in the first block
        int copy_len = (length - first_block_bytes) % BLOCK_SIZE;

        if (copy_len == 0) {
            copy_len = BLOCK_SIZE;
        }
        // first_block_bytes = 1
        // copy_len = 4
        
        // copy_len = 4096 - (4095 % 4096) = 1
    
        // Ex. seek = 4095, length = 5
        // First block needs to copy first 1 bytes of string to the 4096th positions
        // Second block needs to copy last 4 bytes of string to the 1st - 3rd position of block
        // copy_len = 4
        // position = 1
        memcpy (last_block->buffer, &string[first_block_bytes + BLOCK_SIZE * (arr_length -2)], copy_len);

        block_write (block_arr[arr_length - 1], first_block);
        free (last_block);
    }

    int i;
    struct block* write_block = (struct block*)malloc (BLOCK_SIZE);
    for (i = 1; i < arr_length - 1; i++) { // i starts at 1 because we handled the first block already
        int position = BLOCK_SIZE - ((seek) % BLOCK_SIZE) + BLOCK_SIZE * (i-1);
        memcpy (write_block->buffer, &string[position], BLOCK_SIZE);
        block_write (block_arr[i], write_block);
        // if i = 1, then it means we are writing to the second block
    }
    free (write_block);
    return length;
}
