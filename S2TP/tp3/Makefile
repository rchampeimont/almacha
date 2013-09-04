CFLAGS=-Wall -pedantic -ansi
CC=gcc
PROGRAMS=ex1 ex2 ex3 ex4

all: ${PROGRAMS}

*.o : *.c

install : ${PROGRAMS}
	cp ${PROGRAMS} ${HOME}/usr/bin/

clean:
	rm -f ${PROGRAMS} *.o

