#include <stdio.h>

#include <inode_manipulation.h>


int main() {
    printf ("Before makefs.\n");
    makefs();

    print_superblock();

    // Allocates all inodes, should error out when x >= 396
    int x;
    for (x = 0; x < 400; x++) {
        int i = inode_allocate(); 
        printf ("inode_num [%d] = %d\n", x, i);
        print_superblock();
    }

    // Frees one of the inodes
    inode_free(20);
    print_superblock();

    // Inode 20 should be free since it was just freed
    int z = inode_allocate();
    printf ("Allocated inode z = %d\n", z); // z should be 20
    print_superblock();


    // Write to inode 300
    buffer_write (300, 0, "ABCDE", 6);
    print_superblock();

    inode_free(300);
    // Now the written block should be freed
    print_superblock();
    
    // Free inode 51
    inode_free(51);
    print_superblock();

    return 0;
}