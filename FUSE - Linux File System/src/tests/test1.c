#include <stdio.h>

#include <inode_manipulation.h>

int allocate_inode_write_and_read (int num_blocks_to_write) {
    int i = inode_allocate(); 

    // Writes one block to inode i
    int num_blocks = num_blocks_to_write;
    int size = num_blocks * 4096;

    char* str = malloc (size);
    memset(str, 'd', size);
    int k;
    for (k = 0; k < num_blocks; k++) {
        str[(k)*4096] = 64 + k;
        str[(k+1)*4096 -1] = 65 + k;
    }

    buffer_write (i, 0, str, size);

    char* buf_read;
    int num_read = buffer_read (i, 0, size, &buf_read);
    printf ("Read %d bytes for inode #%d:\n%s\n", num_read, i, buf_read);
    free (buf_read);
    free (str);
}



int main() {
    printf ("Before makefs.\n");
    makefs();

    print_superblock();

    // Up to end of direct blocks (if NUM_DIRECT_BLOCKS is 1)
    allocate_inode_write_and_read (1);
    print_superblock();


    // Up to end of Single Indirect Blocks (if INDIRECTIONS_PER_BLOCK is 2)
    allocate_inode_write_and_read (3);
    print_superblock();

    // Up to end of Double Indirect Blocks
    allocate_inode_write_and_read (7);
    print_superblock();

    // Up to end of Triple Indirect Blocks
    allocate_inode_write_and_read (15);
    print_superblock();

    // Errors out because file size is too large
    allocate_inode_write_and_read (16);
    print_superblock();

    return 0;
}