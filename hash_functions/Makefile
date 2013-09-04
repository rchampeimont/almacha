.PHONY : hash_functions.pdf clean all

all : hash_functions.pdf

hash_functions.pdf : hash_functions.tex
	pdflatex hash_functions.tex
	bibtex hash_functions
	pdflatex hash_functions.tex
	pdflatex hash_functions.tex

clean:
	rm -f hash_functions.pdf *.aux *.bbl
