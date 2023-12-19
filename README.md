# Matriz-Dispersa-x-Vector
Tarea 2, INFO-188 Programación en paradigma funcional y paralelo

Compressed Sparse Row (CSR).
pruebas debe ejecutarse como ./prog <n> <d> <m> <s> <nt>

El punto de densidad en el cual la matriz dispersa comienza a ocupar mas memoria es en 0.5
El punto de densidad en el cual el calculo de la matriz dispersa CSR comienza a ser igual de eficiente que el clasico es ~0.8

bin/./prog $((2**16)) 0.3 0 2 10

CPU:
    bin/./prog $((2**16)) 0.3 0 2 1
    inicializando....ok: 93.609161 secs
    calculando....CPU
    ok: 1.599539 secs (351.945221 TFLOPS)

    bin/./prog $((2**16)) 0.3 0 2 1
    inicializando....ok: 94.622939 secs
    calculando....CPU
    ok: 1.605127 secs (350.719910 TFLOPS)

    bin/./prog $((2**16)) 0.3 0 2 10
    inicializando....ok: 81.269167 secs
    calculando....CPU
    ok: 0.215069 secs (2617.529541 TFLOPS)
    
    bin/./prog $((2**16)) 0.3 0 2 10
    inicializando....ok: 81.040840 secs
    calculando....CPU
    ok: 0.214066 secs (2629.791016 TFLOPS)

GPU:
    bin/./prog $((2**16)) 0.3 1 2 10
    inicializando....ok: 81.206891 secs
    calculando....GPU
    ok: 0.354392 secs (1588.497192 TFLOPS)

    bin/./prog $((2**16)) 0.3 1 2 10
    inicializando....ok: 81.081268 secs
    calculando....GPU
    ok: 0.353379 secs (1593.050293 TFLOPS)

    bin/./prog $((2**16)) 0.3 1 2 10
    inicializando....ok: 81.100218 secs
    calculando....GPU
    ok: 0.354483 secs (1588.088013 TFLOPS)