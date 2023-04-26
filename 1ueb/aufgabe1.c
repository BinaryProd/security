#include <stdio.h>
#include <time.h>

int main ()
{
    time_t t;

    time(&t);
    struct tm * timeinfo;

    timeinfo = localtime(&t);
    char buffer[80];

    printf("With localtime() and strftime:\n");
    strftime(buffer, 80, "%c", timeinfo);
    printf("%s\n", buffer);

    printf("With ctime():\n");
    printf("%s", ctime(&t));

    return 0;
}
