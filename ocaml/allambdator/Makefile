OCAMLFIND = ocamlfind

all : allambdator.cgi

allambdator.cgi : allambdator.ml
	${OCAMLFIND} ocamlopt -package cgi,num -linkpkg -o $@ $<

clean :
	rm -f allambdator.cgi
