#include <stdio.h>

#include <inode_manipulation.h>

int main() {
    // printf() displays the string inside quotation
    printf ("Before makefs.\n");
    makefs();
    printf ("After makefs\n");
    int i = inode_allocate(); 
    printf ("inode_num i = %d\n", i);
    int written =  buffer_write (i, 0, "ABCDEFGH\0", 9); 
    printf ("written = %d\n", written);

    int b = inode_allocate();
    printf ("inode_num b = %d\n", b);
    int written2 =  buffer_write (b, 0, "IJKLMOPQRS\0", 11); 
    printf ("written2 = %d\n", written2);


    char* read1;
    int num_read1 = buffer_read (i, 1, 8, &read1); 
    printf ("int num_read1 = %d\n", num_read1);
    printf ("read1 = %s\n", read1);

    char* read2;
    int num_read2 = buffer_read (b, 2, 9, &read2); 
    printf ("int num_read2 = %d\n", num_read2);
    printf ("read2 = %s\n", read2);

    return 0;
}