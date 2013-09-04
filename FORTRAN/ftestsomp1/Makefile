FC = gfortran
PROGRAMS = testomp1

all: ${PROGRAMS}

# With OpenMP
testomp1: testomp1.f95
	${FC} -std=f95 -fopenmp -o $@ $<




clean:
	rm -f *.o *.mod ${PROGRAMS}

