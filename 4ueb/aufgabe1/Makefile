CC = clang
CFLAGS = -Wall -Wextra -Werror -O3
ARGS = echo test

all: start run clean

start: start.o
	$(CC) $(CFLAGS) -o start start.o

start.o: start.c
	$(CC) $(CFLAGS) -c start.c

run:
	- ./start $(ARGS)

clean:
	rm -f start *.o

