.PHONY: a.pdf

all: a.pdf

a.pdf : a.tex
	xelatex -output-driver=xdvipdfmx a.tex

clean :
	rm -f *.pdf *.aux

