


int mkdir (const char* path, char* dirname);

int mknod (const char* path, char* filename); // TODO

int readdir (const char* dirname);

int unlink (const char* path);

int open (const char* pathname, int flags); // returns a file descriptor

int close (int fd);

int write (int fd, const void* buf, int count);

int read (int fd, void* buf, int count);


