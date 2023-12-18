all:
	nvcc -O3 -Xcompiler -fopenmp Matriz-DispersaXVector.cu -o prog