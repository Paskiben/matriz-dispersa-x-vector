.PHONY: all clean
CXX = nvcc
CXXFLAGS = -O3 -Xcompiler -fopenmp
EXECUTABLE = bin/prog

all:
	$(CXX) $(CXXFLAGS) Matriz-DispersaXVector.cu -o $(EXECUTABLE)

clean:
	@echo " [CLN] Cleaning"
	rm -rf bin/prog