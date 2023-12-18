#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <cuda.h>
#define BSIZE 16
using namespace std;


int main(int argc, char** argv) {
    if(argc <6){
        fputs_unlocked("Debe ejecutarse como ./prog <n> <d> <m> <s> <nt>", stdout);
        exit(EXIT_FAILURE);
    }
    long n = atoi(argv[1]);
    float d = atoi(argv[2]);
    int m = atoi(argv[3]);
    float s = atoi(argv[4]);
    int nt = atoi(argv[5]);
    omp_set_num_threads(nt);
    srand(s);
    long nelem = n*n;

    //Se cran las matrices a multiplicar y en la que se guardara el resultado
    float *md, *V, *CI, *RI, *R, rowCont=0;
    Md = new float[nelem]; V = new float[nelem];
    CI = new float[nelem]; RI = new float[n]; R = new float[n];

    // inicializar arreglos en Host (CPU)
    double t1 = omp_get_wtime();
    //Inicialisacion de las matrices
    printf("inicializando...."); fflush(stdout);
    #pragma omp parallel for
    for(int i=0; i<n; ++i){
        RI[i]=rowCont;
        R[i]=0;
        V[i] = rand();
        for(int j=0; j<n; ++j){
            if(rand()/RAND_MAX<d)
            else{
                Md[i*n + j] = rand();
                CI[i*n + j] = i
                ++rowCont;
            }
        }
    }
    

    double t2 = omp_get_wtime();
    printf("ok: %f secs\n", t2-t1); fflush(stdout);

    // allocar memoria en device  (GPU)
    cudaMalloc(&dMd, sizeof(float) * nelem);
    cudaMalloc(&dV, sizeof(float) * n);
    cudaMalloc(&dCI, sizeof(float) * nelem);
    cudaMalloc(&dRI, sizeof(float) * n);
    cudaMalloc(&dR, sizeof(float) * n);

    // copiar de Host -> Device
    cudaMemcpy(dMd, Md, sizeof(float)*nelem, cudaMemcpyHostToDevice);
    cudaMemcpy(dV, V, sizeof(float)*n, cudaMemcpyHostToDevice);
    cudaMemcpy(dCI, CI, sizeof(float)*nelem, cudaMemcpyHostToDevice);
    cudaMemcpy(dRI, RI, sizeof(float)*n, cudaMemcpyHostToDevice);


    dim3 block(BSIZE, BSIZE, 1);  // (x, y, z) --> bloque de x * y * z threads
    dim3 grid((n + BSIZE-1)/BSIZE, (n + BSIZE-1)/BSIZE, 1);

    

    cudaEvent_t start, stop;
	cudaEventCreate(&start); cudaEventCreate(&stop);
	printf("calculando...."); fflush(stdout);
	cudaEventRecord(start);
	if(m){
		printf("GPU\n"); fflush(stdout);
		//mikernel<<<grid, block>>>(dA, dB, dC, n);
	}
	else{
		printf("CPU\n"); fflush(stdout);
		//cpu(A, B, C, n);	
	}
	cudaDeviceSynchronize(); cudaEventRecord(stop);
	cudaEventSynchronize(stop);
	float milliseconds = 0;
	cudaEventElapsedTime(&milliseconds, start, stop);
	if(m){ cudaMemcpy(C, dC, sizeof(float)*nelem, cudaMemcpyDeviceToHost); }
	float time = milliseconds/1000.0f;
	float tflops = ((float)n*n*(2*n)/time)/(1e12);
	printf("ok: %f secs (%f TFLOPS)\n", time, tflops); fflush(stdout);
	print_mat(C, n, "MATRIX C");
}

void multiplicarMatrizDispersaCPU(float& *md, float& *V, float& *CI, float& *RI, float& *R,long n){
    #pragma omp parallel for 
    for(int i=0;i<n;++i){
        s
    }
}

void
      push_back(const value_type& __x)
      {
	if (this->_M_impl._M_finish != this->_M_impl._M_end_of_storage)
	  {
	    _GLIBCXX_ASAN_ANNOTATE_GROW(1);
	    _Alloc_traits::construct(this->_M_impl, this->_M_impl._M_finish,
				     __x);
	    ++this->_M_impl._M_finish;
	    _GLIBCXX_ASAN_ANNOTATE_GREW(1);
	  }
	else
	  _M_realloc_insert(end(), __x);
      }