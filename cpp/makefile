CC=g++-7
CXXFLAGS=-g -I.
LIBS = -fopenmp
DEPS = constants.h pattern.h fault_c.h
OBJ = fault_atalanta.o fault_c.o pattern.o

%.o: %.cpp $(DEPS)
	$(CC) -c -o $@ $< $(CXXFLAGS) $(LIBS)

fa: $(OBJ)
	$(CC) -o $@ $^ $(CXXFLAGS) $(LIBS) 

clean:
	rm -f $(binaries) *.o

