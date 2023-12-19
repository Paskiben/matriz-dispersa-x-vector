.PHONY: all clean
CXX = nvcc
CXXFLAGS = -O3 -std=c++20 -Xcompiler -fopenmp
EXECUTABLED = bin/progd
CC = g++
CCFLAGS = -std=c++23 -Wall -O4 -fopenmp
EXECUTABLEC = bin/progc
EXECUTABLE = bin/prog

all:
	$(CXX) $(CXXFLAGS) Matriz-DispersaXVector.cu -o $(EXECUTABLED)
	$(CC) $(CCFLAGS) matMulClassic.cpp -o $(EXECUTABLEC)
	$(CC) $(CCFLAGS) pruebas.cpp -o $(EXECUTABLE)

clean:
	@echo " [CLN] Cleaning"
	rm -rf $(EXECUTABLE) $(EXECUTABLED) $(EXECUTABLEC)