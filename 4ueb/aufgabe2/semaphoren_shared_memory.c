#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/shm.h>
#include <sys/wait.h>
#include <time.h>

#define N_DATA 2000000
#define N_SHARED 2000

union semun {
    int val;                // Value for SETVAL
    struct semid_ds *buf;   // Buffer for IPC_STAT, IPC_SET
    unsigned short *array;  // Array for GETALL, SETALL
    struct seminfo *__buf;  // Buffer for IPC_INFO (Linux-specific)
};

int main() {
    key_t key = ftok(".", 'a');
    int semid_empty = semget(key, 1, IPC_CREAT | 0600);  // Empty semaphore
    int semid_full = semget(key + 1, 1, IPC_CREAT | 0600);  // Full semaphore
    int shmid = shmget(key, N_SHARED * sizeof(int), IPC_CREAT | 0600);

    if (semid_empty == -1 || semid_full == -1) {
        perror("semget");
        exit(EXIT_FAILURE);
    }
    if (shmid == -1) {
        perror("shmget");
        exit(EXIT_FAILURE);
    }

    union semun arg;
    arg.val = N_SHARED;  // Initialize the empty semaphore with the size of shared memory
    if (semctl(semid_empty, 0, SETVAL, arg) == -1) {
        perror("semctl");
        exit(EXIT_FAILURE);
    }

    struct sembuf sem_wait_empty = {0, -1, 0};       // Decrement empty count
    struct sembuf sem_signal_empty = {0, 1, 0};     // Increment empty count
    struct sembuf sem_wait_full = {0, -1, 0};        // Decrement full count
    struct sembuf sem_signal_full = {0, 1, 0};       // Increment full count

    int *shared_memory = shmat(shmid, NULL, 0);
    if (shared_memory == (void *)-1) {
        perror("shmat");
        exit(EXIT_FAILURE);
    }

    pid_t pid = fork();
    switch (pid) {
        case -1:
            perror("fork");
            exit(EXIT_FAILURE);
        case 0:
            for (int i = 0; i < N_DATA; i++) {
                if (semop(semid_full, &sem_wait_full, 1) == -1) {
                    perror("semop");
                    exit(EXIT_FAILURE);
                }

                int data = shared_memory[i % N_SHARED];
                printf("Consumed: %d\n", data);

                if (semop(semid_empty, &sem_signal_empty, 1) == -1) {
                    perror("semop");
                    exit(EXIT_FAILURE);
                }
            }
            exit(EXIT_SUCCESS);
        default:
            srand48(time(NULL));
            for (int i = 0; i < N_DATA; i++) {
                if (semop(semid_empty, &sem_wait_empty, 1) == -1) {
                    perror("semop");
                    exit(EXIT_FAILURE);
                }

                int data = lrand48();
                shared_memory[i % N_SHARED] = data;
                printf("Produced: %d\n", data);

                if (semop(semid_full, &sem_signal_full, 1) == -1) {
                    perror("semop");
                    exit(EXIT_FAILURE);
                }
            }
            wait(NULL);

            semctl(semid_empty, 0, IPC_RMID, 0);
            semctl(semid_full, 0, IPC_RMID, 0);
            shmctl(shmid, IPC_RMID, 0);
            exit(EXIT_SUCCESS);
    }

    exit(EXIT_SUCCESS);
}

