COMP   = CC

CFLAGS = -std=c++11 -fopenmp -x hip
LFLAGS = -fopenmp

hello_jobstep: hello_jobstep.o
	${COMP} ${LFLAGS} hello_jobstep.o -o hello_jobstep

hello_jobstep.o: hello_jobstep.cpp
	${COMP} ${CFLAGS} -c hello_jobstep.cpp

.PHONY: clean

cleanall: clean
	rm -f *.out

clean:
	rm -f hello_jobstep *.o

