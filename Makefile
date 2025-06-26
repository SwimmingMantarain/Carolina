CC = gcc
CFLAGS = -Wall -Wextra -Werror
RM = rm -f
TARGET = caro
SRCS = main.c lex.c
OBJS = $(SRCS:.c=.o)
HEAD = lex.h

default: $(TARGET)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

%.o: %.c $(HEAD)
	$(CC) -c $<

clean:
	$(RM) $(TARGET) $(OBJS)
