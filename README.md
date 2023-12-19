# Matriz-Dispersa-x-Vector
Tarea 2, INFO-188 Programación en paradigma funcional y paralelo

Compressed Sparse Row (CSR).
bin/./prog $((2**16)) 0.3 0 2 10

bin/./prog $((2**16)) 0.3 0 2 1
inicializando....ok: 94.622939 secs
calculando....CPU
ok: 1.605127 secs (350.719910 TFLOPS)

bin/./prog $((2**16)) 0.3 0 2 10
inicializando....ok: 81.269167 secs
calculando....CPU
ok: 0.215069 secs (2617.529541 TFLOPS)

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