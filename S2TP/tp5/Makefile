CFLAGS=-Wall -pedantic -ansi
CC=gcc
PROGRAMS=tp5ex1 tp5ex2 tp5ex3 tp5ex4
LDFLAGS=-lm

all: ${PROGRAMS}

*.o : *.c

install : ${PROGRAMS}
	cp ${PROGRAMS} ${HOME}/usr/bin/

clean:
	rm -f ${PROGRAMS} *.o

