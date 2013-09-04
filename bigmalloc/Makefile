PROGRAMS=bigmalloc bigcalloc bigfork fastnothing fibtest sleepforever

all: ${PROGRAMS}

*.o : *.c

install : ${PROGRAMS}
	cp ${PROGRAMS} ${HOME}/usr/bin/

clean:
	rm -f ${PROGRAMS} *.o

