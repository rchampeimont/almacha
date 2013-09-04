CFLAGS=-Wall -pedantic -ansi
CC=gcc
PROGRAMS=tp8ex1

all: ${PROGRAMS}

*.o : *.c

install : ${PROGRAMS}
	cp ${PROGRAMS} ${HOME}/usr/bin/

clean:
	rm -f ${PROGRAMS} *.o

