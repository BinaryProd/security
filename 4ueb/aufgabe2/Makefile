CC = clang
CFLAGS = -Wall -Wextra -Werror -O3
ARGS = echo test

all: semaphoren_shared_memory 

semaphoren_shared_memory: semaphoren_shared_memory.o
	$(CC) $(CFLAGS) -o semaphoren_shared_memory semaphoren_shared_memory.o

semaphoren_shared_memory.o: semaphoren_shared_memory.c
	$(CC) $(CFLAGS) -c semaphoren_shared_memory.c

run:
	- ./semaphoren_shared_memory $(ARGS)

clean:
	rm -f semaphoren_shared_memory *.o

