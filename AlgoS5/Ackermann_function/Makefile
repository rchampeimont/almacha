OCAMLFIND = ocamlfind
PROGRAMS = ackermann_caml ackermann_haskell ackermann_c ackermann_c_O2 ackermann_caml_bytecode ackermann_cs.exe Ackermann_java.class

all : ${PROGRAMS}

ackermann_caml : ackermann_caml.ml
	${OCAMLFIND} ocamlopt -package num -linkpkg -o $@ $<

ackermann_caml_bytecode : ackermann_caml.ml
	${OCAMLFIND} ocamlc -package num -linkpkg -o $@ $<

ackermann_haskell : ackermann_haskell.hs
	ghc -O2 --make -o $@ $<

ackermann_c : ackermann_c.c
	gcc -Wall -pedantic -ansi -o $@ $<

ackermann_c_O2 : ackermann_c.c
	gcc -O2 -Wall -pedantic -ansi -o $@ $<

ackermann_cs.exe : ackermann_cs.cs
	gmcs -out:$@ $<

Ackermann_java.class : Ackermann_java.java
	javac $<

clean :
	rm -f ${PROGRAMS}
