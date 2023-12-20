#include <cstdio>
#include <cstdlib>
#include <string>
using namespace std;
#define MODE 0
#define DENSITIL 1
#define DENSITIR 10
#define NUM_THREADL 11
#define NUM_THREADR 20
#define NL 6
#define NR 16


int main(int argc, char** argv) {
    if(argc <6){
        fputs_unlocked("Debe ejecutarse como ./prog <n> <d> <m> <s> <nt>\n", stdout);
        exit(EXIT_FAILURE);
    }

    //CSR vs Clasic
    if(MODE==0){
        for(int i=DENSITIL ;i<=DENSITIR ;++i){
            string callMd = string()+"bin/./progd "+ argv[1]+" "+to_string((float)i/10)+" "+argv[3]+" "+argv[4]+" "+argv[5];
            string callMc = string()+"bin/./progc "+ argv[1]+" "+to_string((float)i/10)+" "+argv[4]+" "+argv[5];
            printf("\nMatriz dispersa con dispersion = %.1f :\n", (float)i/10);
            fputs_unlocked("Matriz dispersa CSR\n", stdout);
            for(int j=0;j<3;++j){
                system(callMd.c_str());
            }
            fputs_unlocked("\nMatriz dispersa Clasic\n", stdout);
            for(int k=0;k<3;++k){
                system(callMc.c_str());
            }
        }
    }

    // //Speedup CPU 1 vs CPU x
    else if(MODE==1){
        for(int i=NUM_THREADL ;i<=NUM_THREADR ;++i){
            string callMd = string()+"bin/./progd "+ argv[1]+" "+argv[2]+" "+to_string(0)+" "+argv[4]+" "+ to_string(i);
            printf("\nMatriz dispersa %d threads:\n", i);
            for(int j=0;j<3;++j)
                system(callMd.c_str());
        }
    }

    // //Speedup CPU 1 vs GPU
    else if(MODE==2){
        for(int i=NL;i<=NR;++i){
            string callMdCPU = string()+"bin/./progd $((2**"+ to_string(i) +")) "+argv[2]+" "+to_string(0)+" "+argv[4]+" "+to_string(1);
            string callMdGPU = string()+"bin/./progd $((2**"+ to_string(i) +")) "+argv[2]+" "+to_string(1)+" "+argv[4]+" "+to_string(1);
            printf("\nMatriz dispersa n= 2**%d\n", i);
            fputs_unlocked("Matriz dispersa CPU\n", stdout);
            for(int j=0;j<3;++j){
                system(callMdCPU.c_str());
            }
            fputs_unlocked("Matriz dispersa GPU\n", stdout);
            for(int j=0;j<3;++j){
                system(callMdGPU.c_str());
            }
        }
    }

}