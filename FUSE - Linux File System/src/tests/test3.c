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
    return i;
}



int main() {
    printf ("Before makefs.\n");
    makefs();

    print_superblock();

    // Allocate an inode and write 2 blocks of data
    int i = allocate_inode_write_and_read (2);
    print_superblock();

    // appends to the end of the file
    int written = buffer_write (i, 2 * 4096, "ABCD", 5);
    printf ("Wrote %d bytes into inode_num %d\n", written, i);

    // tries to read past the end of file, so num_read clips to the filelength
    char* read;
    int num_read = buffer_read (i, 0, 3 * 4096, &read); 
    printf ("Read %d bytes from inode %d\n%s\n", num_read, i, read);

    // Overwrites in the middle of the file
    written = buffer_write(i, 200, "EFGHI", 5); 
    printf ("Overwrote %d bytes from byte 200\n", written);

    char* read2;
    num_read = buffer_read (i, 195, 15, &read2);
    printf ("Read %d bytes from position 195 in inode %d\n%s\n", num_read, i, read2);
    // Due to the string not being null terminated, will see special characters at the end of this printf

    return 0;
}