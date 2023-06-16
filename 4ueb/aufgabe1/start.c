#include <stdio.h>
#include <stdlib.h> // EXIT_SUCCESS, EXIT_FAILURE
#include <unistd.h> // execvp + fork
#include <sys/resource.h> // setpriority
#include <sys/wait.h> // wait
#include <signal.h> // psignal

int main(int argc, char **argv) {
    
    if (argc < 2) {
        printf("Usage: %s <prog> <...arg>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    pid_t pid = fork();
    switch (pid) {
        case -1:
            perror("fork");
            exit(EXIT_FAILURE);
        case 0:
            if ( setpriority(PRIO_PROCESS, 0, 19)  == -1 ) {
                perror("setpriority");
                exit(EXIT_FAILURE);
            }
            execvp(argv[1],argv+1);
            perror("execvp");
            
        default:
            printf("Child is PID %d\n", pid);

            int status;
            wait(&status);

            if (WIFEXITED(status)) {
                printf("Return code of prog: %d\n", WEXITSTATUS(status));
            }

            if (WIFSIGNALED(status)) {
                int signum = WTERMSIG(status);
                printf("Child terminated by signal %d\n", signum);
            }

            exit(EXIT_SUCCESS);
    }
    return 0;
}
