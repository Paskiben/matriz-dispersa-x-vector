#include <cstdio>
#include <cstdlib>
#include <string>
using namespace std;
#define MODE 0

int main(int argc, char** argv) {
    if(argc <6){
        fputs_unlocked("Debe ejecutarse como ./prog <n> <d> <m> <s> <nt>\n", stdout);
        exit(EXIT_FAILURE);
    }

    //CSR vs Clasic
    if(MODE==0){
        string callMd = string()+"bin/./progd "+ argv[1]+" "+argv[2]+" "+argv[3]+" "+argv[4]+" "+argv[5];
        string callMc = string()+"bin/./progc "+ argv[1]+" "+argv[2]+" "+argv[4]+" "+argv[5];
        fputs_unlocked("Matriz dispersa CSR\n", stdout);
        system(callMd.c_str());
        fputs_unlocked("\nMatriz dispersa Clasic\n", stdout);
        system(callMc.c_str());
    }

    // //Speedup CPU 1 vs CPU x
    else if(MODE==1){
        for(int i=1;i<=10;++i){
            string callMd = string()+"bin/./progd "+ argv[1]+" "+argv[2]+" "+argv[3]+" "+argv[4]+" "+ to_string(i);
            printf("Matriz dispersa %d threads:\n", i);
            for(int j=0;j<3;++j)
                system(callMd.c_str());
        }
    }

    // //Speedup CPU 1 vs GPU
    else if(MODE==2){
        for(int i=8;i<=16;++i){
            string callMdCPU = string()+"bin/./progd $((2**"+ to_string(i) +")) "+argv[2]+" "+to_string(0)+" "+argv[4]+" "+to_string(1);
            string callMdGPU = string()+"bin/./progd $((2**"+ to_string(i) +")) "+argv[2]+" "+to_string(1)+" "+argv[4]+" "+to_string(1);
            printf("Matriz dispersa n= 2**%d\n", i);
            for(int j=0;j<3;++j){
                system(callMdCPU.c_str());
                system(callMdGPU.c_str());
            }
        }
    }

}