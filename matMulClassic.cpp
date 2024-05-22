#include <cstdio>
#include <cstdlib>
#include <omp.h>
#include <chrono>
using namespace std;

void matMul(const float *Md, const float *V, float *answer, const long int n);

int main(int argc, char** argv){
    if(argc <5){
        fputs_unlocked("Debe ejecutarse como ./prog <n> <d> <s> <nt>\n", stdout);
        exit(EXIT_FAILURE);
    }

    long int n = atoi(argv[1]);
    float d = (float)atof(argv[2]);
    float s = (float)atof(argv[3]);
    int nt = atoi(argv[4]);
    omp_set_num_threads(nt);
    srand((uint)s);

    float *Md = new float[n*n]{}, *V = new float[n],
    *answer = new float[n]{};

    double t1 = omp_get_wtime();
    printf("inicializando...."); fflush(stdout);
    for(int i=0; i<n; ++i){
        V[i] = (float)(rand()%10);
        for(int j=0; j<n; ++j){
            if((float)rand()/(float)RAND_MAX<=d){
                Md[i*n + j] = (float)(rand()%10);
            }
        }
    }
    double t2 = omp_get_wtime();
    printf("ok: %f secs\n", t2-t1); fflush(stdout);

    //Calculo duracion del proceso
    auto start = chrono::high_resolution_clock::now();
    matMul(Md, V, answer, n);
    auto end = chrono::high_resolution_clock::now();
    auto elapsed = chrono::duration_cast<chrono::microseconds>(end - start);
    double tflops = (double)(n*n*(2*n)/elapsed.count())/1e6;
    printf("ok: %f secs (%f TFLOPS)\n", (double)elapsed.count()/1e6, tflops); fflush(stdout);
}

void matMul(const float *Md, const float *V, float *answer, const long int n) {
    #pragma omp parallel for
    for (int i = 0; i < n; ++i) {
        float tempAnswer=0.0f;
        for (int j = 0; j < n; ++j)
            tempAnswer += Md[i*n + j] * V[j];
        answer[i] = tempAnswer;
    }
}