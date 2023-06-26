#include <stdio.h>

#include <inode_manipulation.h>

int main() {
    // printf() displays the string inside quotation
    printf ("Before makefs.\n");
    makefs();

    print_superblock();

    printf ("After makefs\n");
    int i = inode_allocate(); 
    printf ("inode_num i = %d\n", i);

    print_superblock();

    int num_blocks = 15;
    int size = num_blocks * 4096;

    char* str = malloc (size);
    memset(str, 'c', size);
    int k;
    for (k = 0; k < num_blocks; k++) {
        str[(k)*4096] = 64 + k;
        str[(k+1)*4096 -1] = 65 + k;
    }

    int written =  buffer_write (i, 0, str, size - 10000); 
    printf ("written = %d\n", written);

    print_superblock();

    int b = inode_allocate();
    printf ("inode_num b = %d\n", b);
    int written2 =  buffer_write (b, 0, "IJKLMOPQRS", 11); 
    printf ("written2 = %d\n", written2);

    // print_superblock();

    printf ("size - 10000 = %d\n", size - 10000);

    written =  buffer_write (i, size - 20000, &str[size - 20000], 20000); 
    printf ("written = %d\n", written);

    // int written3 =  buffer_write (b, 10, "IJKLMOPQRS", 11); 
    // printf ("written3 = %d\n", written2);

    // int written4 =  buffer_write (i, 10000, str, 10000); 
    // printf ("written4 = %d\n", written);

    print_superblock();

    char* read1;
    int num_read1 = buffer_read (i, 0, size, &read1); 
    printf ("int num_read1 = %d\n", num_read1);
    printf ("read1 = %s\n", read1);

    char* read2;
    int num_read2 = buffer_read (b, 5, 8, &read2); 
    printf ("int num_read2 = %d\n", num_read2);
    printf ("read2 = %s\n", read2);

    return 0;
}