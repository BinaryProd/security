#include <stdio.h>
#include <time.h>

int main ()
{
    time_t t;

    time(&t);
    struct tm * timeinfo;

    timeinfo = localtime(&t);

    printf("With localtime():\n");
    printf("%s", asctime(timeinfo));
    printf("With ctime():\n");
    printf("%s", ctime(&t));

    return 0;
}
