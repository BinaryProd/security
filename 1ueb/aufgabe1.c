#include <stdio.h>
#include <time.h>

int main ()
{
    time_t t;
    struct tm * timeinfo;
    char buffer[80];

    if (!time(&t)) return -1;

    timeinfo = localtime(&t);
    if (!timeinfo) return -1;

    if (!strftime(buffer, 80, "%c", timeinfo)) return -1;

    printf("With localtime() and strftime:\n");
    printf("%s\n", buffer);

    printf("With ctime():\n");
    printf("%s", ctime(&t));

    return 0;
}
