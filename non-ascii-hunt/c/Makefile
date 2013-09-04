CFLAGS=-Wall -pedantic -ansi
CC=gcc
PROGRAM=alm-non-ascii-hunt

all : ${PROGRAM}

alm-non-ascii-hunt : alm-non-ascii-hunt.c
	${CC} ${CFLAGS} -o $@ $<
clean:
	rm -f ${PROGRAM} *.o

