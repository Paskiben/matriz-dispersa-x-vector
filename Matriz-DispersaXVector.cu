#include <stdio.h>
#include <omp.h>
#include <cuda.h>
#define BSIZE 1024
#define PRINT 0

// Funcion para la multiplicacion en CPU
void mulMdCPU(const float *CSR, const float *V,const float *CI, const float *RI, float *answer, const long int n);
// Kernel, multipicacion en GPU
__global__ void mulMdGPU(const float *CSR, const float *V, const float *CI, const float *RI, float *answer, const long int n);
// Funciones para imprimir la Matriz
void printMatrix(float *M, long int n);
// Funcion para imprimir el vector
void printVector(float *V, long n);

int main(int argc, char** argv) {
    
    // Comprobacion de los argumentos
    if(argc < 6){
        fputs_unlocked("Debe ejecutarse como ./prog <n> <d> <m> <s> <nt>\n", stdout);
        exit(EXIT_FAILURE);
    }
    
    // Recibir argumentos
    long int n = atoi(argv[1]);
    float d = atof(argv[2]);
    int m = atoi(argv[3]);
    float s = atof(argv[4]);
    int nt = atoi(argv[5]);
    omp_set_num_threads(nt);
    srand(s); // Semilla

    // Md = matriz dispersa con valores nulos (contiene la data de la matriz), V = vector a calcular, RI = Row Index, answer = respuesta.
    float *Md = new float[n*n]{0}, *V = new float[n],
    *RI = new float[n+1], *answer = new float[n]{},
    *dV, *dRI, *danswer;
    long int nelem=0;

    // Iniciar la distribucion random de la matriz y el vector (CPU)
    printf("inicializando...."); fflush(stdout);
    double t1 = omp_get_wtime();
    for(int i=0; i<n; ++i){
        V[i] = rand();
        for(int j=0; j<n; ++j){
            if((float)rand()/RAND_MAX<=d){
                Md[i*n + j] = rand();
                nelem++;
            }
        }
    }

    // Imprimir la matriz y el vector
    if (PRINT){
        fputs_unlocked("\n", stdout);
        printMatrix(Md, n);
        fputs_unlocked("\n", stdout);
        printVector(V, n);
    }
    
    // CSR  = Vector de los valores no nulos de la matriz, CI = Column Index
    float *CSR = new float[nelem], *CI = new float[nelem],
     *dCSR, *dCI;
    int k = 0;
    
    // Alocacion de datos del CSR y CI
    for(int i = 0; i < n; ++i){
        RI[i] = k;
        for(int j = 0; j < n; ++j)
            if(Md[i*n + j] != 0){
                CSR[k] = Md[i*n + j];
                CI[k++] = j; 
            }
    }
    RI[n] = k;
    delete[] Md;

    double t2 = omp_get_wtime();
    printf("ok: %f secs\n", t2-t1); fflush(stdout);

    // Alocar memoria en device  (GPU)
    cudaMalloc(&dCSR, sizeof(float) * nelem);
    cudaMalloc(&dV, sizeof(float) * n);
    cudaMalloc(&dCI, sizeof(float) * nelem);
    cudaMalloc(&dRI, sizeof(float) * (n+1));
    cudaMalloc(&danswer, sizeof(float) * n);

    // Copiar de Host -> Device
    cudaMemcpy(dCSR, CSR, sizeof(float)*nelem, cudaMemcpyHostToDevice);
    cudaMemcpy(dV, V, sizeof(float)*n, cudaMemcpyHostToDevice);
    cudaMemcpy(dCI, CI, sizeof(float)*nelem, cudaMemcpyHostToDevice);
    cudaMemcpy(dRI, RI, sizeof(float)*(n+1), cudaMemcpyHostToDevice);

    // Definition of block and grid sizes
    dim3 block(BSIZE, 1, 1);  // (x, y, z) --> bloque de x * y * z threads
    dim3 grid((n + BSIZE-1)/BSIZE, 1, 1);
    
    // Se crea un evento en cuda
    cudaEvent_t start, stop;
	cudaEventCreate(&start); cudaEventCreate(&stop);
	printf("calculando...."); fflush(stdout);
	cudaEventRecord(start);

    // Modo GPU o CPU
	if (m) {
		printf("GPU\n"); fflush(stdout);
		mulMdGPU<<<grid, block>>>(dCSR, dV, dCI, dRI, danswer, n);
	}
	else {
		printf("CPU\n"); fflush(stdout);
		mulMdCPU(CSR, V, CI, RI, answer, n);
	}
    // Inicialisacion mediciones de tiempo
	cudaDeviceSynchronize(); cudaEventRecord(stop);
	cudaEventSynchronize(stop);
	float milliseconds = 0;
	cudaEventElapsedTime(&milliseconds, start, stop);
    
    // Recuperar los datos del device a la RAM
	if (m) { cudaMemcpy(answer, danswer, sizeof(float)*n, cudaMemcpyDeviceToHost); }
    
    // Calculo de tiempos de ejecucion
	float time = milliseconds/1000.0f;
	float tflops = ((float)n*n*(2*n)/time)/(1e12);
	printf("ok: %f secs (%f TFLOPS)\n", time, tflops); fflush(stdout);
    if (PRINT) {fputs_unlocked("\n", stdout); printVector(answer, n);}
    
    // Borrar los arreglos dinamicos
    delete[] CSR; delete[] V; delete[] CI; delete[] RI; delete[] answer;
}

// Funcion para el calculo paralelo de CPU de la matriz 
void mulMdCPU(const float *CSR, const float *V,const float *CI, const float *RI, float *answer, const long int n) {
    #pragma omp parallel for
    for(int i=0; i <= n; ++i){
        float tempAnswer=0.0f;
        for(int j=RI[i]; j<RI[i+1]; ++j)
            tempAnswer += CSR[j]*V[(int)CI[j]];
        answer[i] = tempAnswer;
    }
}

// Funcion para el calculo paralelo de GPU de la matriz 
__global__ void mulMdGPU(const float *CSR, const float *V, const float *CI, const float *RI, float *answer, const long int n) {
    int tidx = (blockDim.x * blockIdx.x)  + threadIdx.x;
    if (tidx < (n)) {
        float tempAnswer=0.0f;
        for (int i = RI[tidx]; i < RI[tidx + 1]; ++i)
            tempAnswer += CSR[i] * V[(int)CI[i]];
        answer[tidx] = tempAnswer;
    }
}

// Funcion para imprir Matrices
void printMatrix(float *M, long int n) {
    for(int i = 0; i < n; ++i){
        for(int j = 0; j<n; ++j)
            printf("%.0f ", M[i*n + j]);
        fputs_unlocked("\n", stdout);
    }
}

// Funcion para imprir Vectores
void printVector(float *V, long n) {
    for(int i=0; i<n; ++i)
        printf("%.0f ", V[i]);
    fputs_unlocked("\n", stdout);
}