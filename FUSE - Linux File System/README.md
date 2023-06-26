# CS270-FileSystemProject
### Team members (Alphabetical order)
1. Fahed Abudayyeh
2. Jaber Daneshamooz
3. Lawrence Lim


### Installation
Please use a CentOS7 machine and follow the installations in INSTALLATION.txt

### Compilation
To compile, simply run the following command:
```
./compile-build
```

### Progress so far
We have completed and debugged to the best of our knowledge layer 1, which includes 
```int makefs () ```
Allocates space, writes the superblock, sets up the free lists.

```int inode_allocate() ```
Allocates the next free inode, returning the inode number

```int inode_free (int inode_num)``` 
Frees the inode and all data blocks associated with the inode. Updates the free i-list.

```struct inode* inode_read(int inode_num)``` 
Returns an inode pointer containing information on the inode for the inode number

```int inode_write (int inode_num, struct inode* inode_data)```
Writes the inode data to the appropriate inode number

```int buffer_allocate (int inode_num, int size)``` 
Allocates disk blocks for an inode given the size

```int buffer_free (int block_num)``` 
Frees the block number in disk, updating the free list.

```int buffer_read (int inode_num, int seek, int length, char** buffer)``` 
Reads from the blocks associated with the inode number from the seek. Returns an integer for the amount read and passes by reference the data to be returned.

```int buffer_write (int inode_num, int seek, char* string, int length)``` 
Writes the data to the inode_num from the seek position. Calls buffer_allocate() if necessary.


For testing and debugging purposes, our code is currently configured so that each indirection block only holds two pointers to other blocks. To change the parameters and sizes of our file system, inode_manipulation.h contains definitions for variables that can be changed. At the moment, they are configured as follows:
```
#define INODES_PER_BLOCK 4
#define INODE_LIST_SIZE 99
#define NUM_BUFFER_BLOCKS 900
#define INDIRECTIONS_PER_BLOCK 2
#define NUM_DIRECT_BLOCKS 1
```
### Limitations
The size of the files are also limited by our use of the integer data type rather than long data type or types with more bits. This will be changed in the future to reflect that.

We have a free list for inodes and a free list for data blocks. The free list is currently implemented naively so that each free block contains a pointer to the next free block.

### Tests to run
```
build/src/tests/test1
build/src/tests/test2
build/src/tests/test3
```
