all: tibo

# -g is for debug
tibo: tibo.c
	gcc tibo.c -o tibo -std=c99 -pedantic -Wall -I/usr/include/igraph -ligraph -g

clean:
	rm -f tibo
