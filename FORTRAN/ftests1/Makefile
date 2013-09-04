FC = gfortran -g
PROGRAMS = hello max roots type1 tests2 modernmax moyenne_simple \
	concat_array_test array_functions_test input output kinds \
	tests3 tests4 initialvalues recursive1 matrix fastreallynothing

all: ${PROGRAMS}

hello: hello.f
	${FC} -o $@ $<

max: max.f
	${FC} -o $@ $<

fastreallynothing: fastreallynothing.f
	${FC} -std=f95 -fimplicit-none -o $@ $<

modernmax: modernmax.f95
	${FC} -std=f95 -o $@ $<

moyenne_simple: moyenne_simple.f95
	${FC} -std=f95 -o $@ $<

concat_array_test: concat_array_test.f95 concat_array_module.o
	${FC} -std=f95 -o $@ $< concat_array_module.o

concat_array_module.o: concat_array_module.f95
	${FC} -std=f95 -c -o $@ $<

array_functions_test: array_functions_test.f95 array_functions.o
	${FC} -std=f95 -o $@ $< array_functions.o

array_functions.o: array_functions.f95
	${FC} -c -std=f95 -o $@ $<

roots: roots.f95
	${FC} -std=f95 -o $@ $<

tests.o: tests.f95
	${FC} -c -std=f95 -o $@ $<

type1: type1.f95
	${FC} -std=f95 -o $@ $<

tests2.o: tests2.f95 tests.o
	${FC} -c -std=f95 -o $@ $<

tests2: tests2.o tests.o
	${FC} -std=f95 -o $@ $< tests.o

input: input.f95
	${FC} -std=f95 -o $@ $<

output: output.f95
	${FC} -std=f95 -o $@ $<

kinds: kinds.f95
	${FC} -std=f95 -o $@ $<

tests3: tests3.f95
	${FC} -std=f95 -fimplicit-none -o $@ $<

tests4: tests4.f95
	${FC} -std=f95 -fimplicit-none -o $@ $<

initialvalues: initialvalues.f95
	${FC} -std=f95 -fimplicit-none -o $@ $<

recursive1: recursive1.f95
	${FC} -std=f95 -fimplicit-none -o $@ $<

matrix: matrix.f95
	${FC} -std=f95 -fimplicit-none -o $@ $<


clean:
	rm -f *.o *.mod ${PROGRAMS}
