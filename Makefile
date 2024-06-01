.PHONY: all clean
# CXX = nvcc
# CXXFLAGS = -O3 -std=c++20 -Xcompiler -fopenmp
# EXECUTABLED = bin/progd
# $(CXX) $(CXXFLAGS) Matriz-DispersaXVector.cu -o $(EXECUTABLED)
CC = g++
CCFLAGS = -std=c++23 -Ofast -Wall -Wextra -Wconversion -Wdouble-promotion -Wduplicated-cond -Wfatal-errors -Wfloat-equal -Wformat=2 -Wlogical-op -Wpedantic -Wshadow -Wundef -Wno-unused-parameter -fopenmp
EXECUTABLEC = bin/progc
EXECUTABLE = bin/prog

all:
	$(CC) $(CCFLAGS) matMulClassic.cpp -o $(EXECUTABLEC)
	$(CC) $(CCFLAGS) pruebas.cpp -o $(EXECUTABLE)

clean:
	@echo " [CLN] Cleaning"
	rm -rf $(EXECUTABLE) $(EXECUTABLED) $(EXECUTABLEC)