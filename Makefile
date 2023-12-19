.PHONY: all clean
CXX = nvcc
CXXFLAGS = -O3 -std=c++20 -Xcompiler -fopenmp
EXECUTABLE = bin/prog

all:
	$(CXX) $(CXXFLAGS) Matriz-DispersaXVector.cu -o $(EXECUTABLE)

clean:
	@echo " [CLN] Cleaning"
	rm -rf bin/prog