#include <stdio.h>
#include <omp.h>
#include <cuda.h>
#define BSIZE 1024
#define PRINT 0
using namespace std;

void mulMdCPU(float *&CSR, float *&V, float *&CI, float *&RI, float *&answer, long n);
__global__ void mulMdGPU(float *CSR, float *V, float *CI, float *RI, float *answer, long int n);

void printMatrix(float *&M, long n){
    for(int i = 0; i < n; i++){
        for(int j=0; j<n; ++j)
            printf("%d ", M[i*n + j]);
        fputs_unlocked("\n", stdout);
    }
}

void printVector(float *&M, long n){
    for(int i=0; i<n; ++i)
        printf("%d ", M[i]);
    fputs_unlocked("\n", stdout);
}

int main(int argc, char** argv) {
    if(argc <6){
        fputs_unlocked("Debe ejecutarse como ./prog <n> <d> <m> <s> <nt>", stdout);
        exit(EXIT_FAILURE);
    }

    long int n = atoi(argv[1]);
    float d = atof(argv[2]);
    int m = atoi(argv[3]);
    float s = atof(argv[4]);
    int nt = atoi(argv[5]);
    omp_set_num_threads(nt);
    srand(s);

    //md = matriz dispersa (contiene la data de la matriz), v = vector a calcular, CI = Column Index, RI = Row Index, R = respuesta.
    float *Md = new float[n*n]{}, *V = new float[n],
    *RI = new float[n+1], *answer = new float[n]{},
    *dV, *dRI, *danswer;
    long int nelem=0;
    
    // inicializar arreglos en Host (CPU)
    double t1 = omp_get_wtime();
    //Inicialisacion de las matrices
    printf("inicializando...."); fflush(stdout);
    fputs_unlocked("\n", stdout);
    int x, y;
    //#pragma omp parallel for
    for(int i=0; i<n; ++i){
        x = rand()%10;
        V[i] = x; 
        for(int j=0; j<n; ++j){
            if((float)rand()/RAND_MAX<=d){
                y = rand()%10 + 1;
                Md[i*n + j] = y;
                nelem++;
            }
        }
    }
    if(PRINT){
        printMatrix(Md, n);
        fputs_unlocked("\n", stdout);
        printVector(V, n);
    }
    
    float *CSR = new float[nelem], *CI = new float[nelem],
    *dCSR, *dCI;
    int k = 0;
    //#pragma omp parallel for
    for(int i = 0; i < n; i++){
        RI[i]= k;
        for(int j=0; j<n; ++j){
            if(Md[i*n + j] != 0){
                CSR[k] = Md[i*n + j];
                CI[k] = j; 
                k++;
            }
        }
    }
    RI[n]= k;
    delete(Md);

    double t2 = omp_get_wtime();
    printf("ok: %f secs\n", t2-t1); fflush(stdout);

    // allocar memoria en device  (GPU)
    cudaMalloc(&dCSR, sizeof(float) * nelem);
    cudaMalloc(&dV, sizeof(float) * n);
    cudaMalloc(&dCI, sizeof(float) * nelem);
    cudaMalloc(&dRI, sizeof(float) * (n+1));
    cudaMalloc(&danswer, sizeof(float) * n);

    // copiar de Host -> Device
    cudaMemcpy(dCSR, CSR, sizeof(float)*nelem, cudaMemcpyHostToDevice);
    cudaMemcpy(dV, V, sizeof(float)*n, cudaMemcpyHostToDevice);
    cudaMemcpy(dCI, CI, sizeof(float)*nelem, cudaMemcpyHostToDevice);
    cudaMemcpy(dRI, RI, sizeof(float)*(n+1), cudaMemcpyHostToDevice);

    //Definition of block and grid sizes
    dim3 block(BSIZE, 1, 1);  // (x, y, z) --> bloque de x * y * z threads
    dim3 grid((n + BSIZE-1)/BSIZE, 1, 1);

    cudaEvent_t start, stop;
	cudaEventCreate(&start); cudaEventCreate(&stop);
	printf("calculando...."); fflush(stdout);
	cudaEventRecord(start);
	if(m){
		printf("GPU\n"); fflush(stdout);
		mulMdGPU<<<grid, block>>>(dCSR, dV, dCI, dRI, danswer, n);
	}
	else{
		printf("CPU\n"); fflush(stdout);
		mulMdCPU(CSR, V, CI, RI, answer, n);
	}
	cudaDeviceSynchronize(); cudaEventRecord(stop);
	cudaEventSynchronize(stop);
	float milliseconds = 0;
	cudaEventElapsedTime(&milliseconds, start, stop);
	if(m){ cudaMemcpy(answer, danswer, sizeof(float)*n, cudaMemcpyDeviceToHost); }
	float time = milliseconds/1000.0f;
	float tflops = ((float)n*n*(2*n)/time)/(1e12);
	printf("ok: %f secs (%f TFLOPS)\n", time, tflops); fflush(stdout);
    if(PRINT){fputs_unlocked("\n", stdout); printVector(answer, n);}
    
    delete(CSR); delete(V); delete(CI); delete(RI); delete(answer);
}

void mulMdCPU(float *&CSR, float *&V, float *&CI, float *&RI, float *&answer, long int n) {
    #pragma omp parallel for
    for(int i=0;i<n+1;++i){
        for(int j=RI[i];j<RI[i+1];++j)
            answer[i] += CSR[j]*V[(int)CI[j]];
    }
}

__global__ void mulMdGPU(float *CSR, float *V, float *CI, float *RI, float *answer, long int n) {
    int tidx = (blockDim.x * blockIdx.x)  + threadIdx.x;
    if (tidx < (n)) {
        for (int i = RI[tidx]; i < RI[tidx + 1]; ++i) {
            answer[tidx] += CSR[i] * V[(int)CI[i]];
        }
    }
}