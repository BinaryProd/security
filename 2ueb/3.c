#include <stdio.h>    
#include <time.h>
#include <pwd.h>      // for getpwuid
#include <grp.h>      // for getgrgid
#include <stdint.h>   // for uintmax_t
#include <sys/stat.h> // for lstat

int main(int argc, char **argv) {
    if ( argc < 2 ) {
        perror("Error: No argument provided");
        return 1;
    }

    struct stat sb;
    for ( int i = 1; i < argc; i++) {

        if (lstat(argv[i], &sb) == -1) {
            perror("lstat");
            return 1;
        }

        printf("File name:                %s\n", argv[i]);
        printf("File type:                ");

        switch (sb.st_mode & S_IFMT) {
            case S_IFBLK:  printf("block device\n");            break;
            case S_IFCHR:  printf("character device\n");        break;
            case S_IFDIR:  printf("directory\n");               break;
            case S_IFIFO:  printf("FIFO/pipe\n");               break;
            case S_IFLNK:  printf("symlink\n");                 break;
            case S_IFREG:  printf("regular file\n");            break;
            case S_IFSOCK: printf("socket\n");                  break;
            default:       printf("unknown?\n");                break;
        }

        struct passwd *pw = getpwuid(sb.st_uid);
        struct group  *gr = getgrgid(sb.st_gid);
        if ( pw == NULL ) {
            perror("error ");
            return 1;
        }
        if ( gr == NULL ) {
            perror("error ");
            return 1;
        }

        printf("Name :                    %s\n", pw->pw_name);
        printf("autre :                   %s\n", gr->gr_name);

        printf("Ownership:                UID=%ju   GID=%ju\n", 
                (uintmax_t) sb.st_uid, (uintmax_t) sb.st_gid);
        printf("Mode:                     %jo (octal)\n",
                (uintmax_t) sb.st_mode);

        printf("Last file access:         %s", ctime(&sb.st_atime));
        printf("Last status change:       %s", ctime(&sb.st_ctime));
        printf("Last file modification:   %s", ctime(&sb.st_mtime));
        printf("\n\n");
    }

    return 0;
}
