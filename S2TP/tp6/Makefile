CFLAGS=-Wall -pedantic -ansi
CC=gcc
PROGRAMS=tp6ex1 tp6ex2
LDFLAGS=-lm

all: ${PROGRAMS}

*.o : *.c

install : ${PROGRAMS}
	cp ${PROGRAMS} ${HOME}/usr/bin/

clean:
	rm -f ${PROGRAMS} *.o

