CC=g++
CXXFLAGS= -std=c++0x -g -O3
OBJ = fault_atalanta.o fault_c.o pattern.o

fa: $(OBJ)
	$(CC) $(CXXFLAGS) -o fa fault_atalanta.o fault_c.o pattern.o -I.

clean:
	rm -f $(binaries) *.o

