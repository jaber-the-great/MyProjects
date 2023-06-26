#include <stdio.h>

#include <inode_manipulation.h>

int main() {
    // printf() displays the string inside quotation
    printf ("Before makefs.\n");
    makefs();

    print_superblock();

    printf ("After makefs\n");
    int x;
    for (x = 0; x < 400; x++) {
        int i = inode_allocate(); 
        printf ("inode_num [%d] = %d\n", x, i);
        print_superblock();
    }


    int num_blocks = 15;
    int size = num_blocks * 4096;

    char* str = malloc (size);
    memset(str, 'c', size);
    int k;
    for (k = 0; k < num_blocks; k++) {
        str[(k)*4096] = 64 + k;
        str[(k+1)*4096 -1] = 65 + k;
    }

    buffer_write (5, 0, str, size);
    print_superblock();

    int written = buffer_write (6, 0, str, 2 * 4096);
    printf ("written 6 = %d\n", written);
    print_superblock();

    written = buffer_write (7, 0, str, 1);
    printf ("written 7 = %d\n", written);
    print_superblock();

    printf("Before inode_free(5)\n");
    inode_free (5);
    print_superblock();

    // printf("Before inode_free(37)\n");
    // inode_free (37);
    // print_superblock();

    // printf("Before inode_free(11)\n");
    // inode_free (11);
    // print_superblock();

    // int i = inode_allocate();
    // printf ("inode_num [11] = %d\n", i);
    // print_superblock();

    // i = inode_allocate();
    // printf ("inode_num [37] = %d\n", i);
    // print_superblock();

    int i = inode_allocate();
    printf ("inode_num [5] = %d\n", i);
    print_superblock();

    return 0;
}