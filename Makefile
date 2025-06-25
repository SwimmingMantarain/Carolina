CC = gcc
CFLAGS = -g
RM = rm -f

default: all

all: main

main: main.c
	$(CC) $(CFLAGS) -o caro main.c

clean:
	$(RM) caro
