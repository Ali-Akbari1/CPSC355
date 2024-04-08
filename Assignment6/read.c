#include <stdio.h>
#include <fcntl.h> // for openat
#include <unistd.h> // for close, read


int main()
{

    long num;

    /*
        int openat (int dirfd, const char * path, int flag, mode_t mode)
    */
    register int fd = openat(-100, "input.bin", 0, 0);

    if (fd <= -1)
    {
        printf("Error opening file!\n");
        return -1;
    }

    register long bytes_read;

    /*
        long read(int fd, void * buf, unsigned long buf_size)
    */
    while ((bytes_read = read(fd, &num, 8)) == 8)
    {
        printf("num is %ld\n", num);
    }

    close(fd);
    return 0;
}