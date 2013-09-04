CFLAGS=-Wall -pedantic -ansi
CC=gcc
PROGRAM=fillram

all : ${PROGRAM}

fillram : fillram.c
	${CC} ${CFLAGS} -o $@ $<
clean:
	rm -f ${PROGRAM} *.o

