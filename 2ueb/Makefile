CC = clang
CFLAGS = -Wall -Wextra -Werror -O3

all: 3

3: 3.o
	$(CC) $(CFLAGS) -o 3 3.o

3.o: 3.c
	$(CC) $(CFLAGS) -c 3.c

clean:
	rm -f 3 *.o

