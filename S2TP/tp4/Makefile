CFLAGS=-Wall -pedantic -ansi
CC=gcc
PROGRAMS=tp4ex1 tp4ex2

all: ${PROGRAMS}

*.o : *.c

install : ${PROGRAMS}
	cp ${PROGRAMS} ${HOME}/usr/bin/

clean:
	rm -f ${PROGRAMS} *.o

