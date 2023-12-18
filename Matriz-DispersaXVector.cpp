#include <string>
#include <vector>
#include <omp.h>
#include <chrono>
using namespace std;


int main(int argc, char** argv) {
    if(argc <6){
        fputs_unlocked("Debe ejecutarse como ./prog <n> <d> <m> <s> <nt>", stdout);
        exit(EXIT_FAILURE);
    }
    int n = atoi(argv[1]);
    float d = atoi(argv[2]);
    int m = atoi(argv[3]);
    float s = atoi(argv[4]);
    int nt = atoi(argv[5]);
    omp_set_num_threads(nt);
    srand(s);

    //Se cran las matrices a multiplicar y en la que se guardara el resultado
    vector<vector<int>> matrizDispersa(n, vector<int>(n,0));
    vector<vector<int>> vect(n, vector<int>(n));
    vector<vector<int>> resultado(n, vector<int>(n, 0));



    auto start_parallel = chrono::high_resolution_clock::now();
    // modo==1? multiplicarMatricesCuadradasBloques(matrizA, matrizB, resultado, blockSize):
    // modo==2? multiplicarMatricesCuadradas(matrizA, matrizB, resultado):
    // (void)fputs_unlocked("Modo ingresado no existente!\n",stdout);
    auto end_parallel = chrono::high_resolution_clock::now();
    auto duration_parallel = chrono::duration_cast<chrono::milliseconds>(end_parallel - start_parallel).count();

    // Imprime el resultado
    cout << "Tiempo tardado:" << endl;
    printf("%ldms\n",duration_parallel);
}