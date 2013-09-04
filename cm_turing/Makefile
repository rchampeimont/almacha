CFLAGS=-Wall -pedantic -ansi
CC=gcc
PROGRAM=cm_turing
OBJECTS=cm_machine.o main.o cm_f.o cm_algo.o cm_bf.o cm_bs.o
HEADERS=cm_machine.h cm_f.h cm_algo.h cm_bf.h cm_bs.h

all : ${PROGRAM}

${PROGRAM} : ${OBJECTS}
	@echo "==> Linking..."
	${CC} -o ${PROGRAM} ${OBJECTS}

${OBJECTS} : ${HEADERS}

install : ${PROGRAM}
	cp ${PROGRAM} ${HOME}/usr/bin/

clean:
	rm -f ${PROGRAM} *.o

