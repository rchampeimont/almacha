CFLAGS=-Wall -pedantic -ansi
CC=gcc
PROGRAMS=tp7ex1 tp7ex2 tp7ex3
LDFLAGS=-lm

all: ${PROGRAMS}

*.o : *.c

install : ${PROGRAMS}
	cp ${PROGRAMS} ${HOME}/usr/bin/

clean:
	rm -f ${PROGRAMS} *.o

