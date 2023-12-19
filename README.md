# Matriz-Dispersa-x-Vector
Tarea 2, INFO-188 Programación en paradigma funcional y paralelo

# Descripcion
Matriz-DispersaXVector.cu: Este programa realiza una multiplicacion ente una matriz dispersa nxn y un vector nx1 de forma paralela, teniendo modo para GPU y CPU
Macros:
    PRINT = indica si se imprimen las matrices o no

pruebas.cpp: Se encarga de realizar pruebas entre CPU con un thread y varios threads, CPU y GPU, ademas del metodo clasico de multiplicacion vs la version con CSR
Macros:
    MODE = 0 para metodo clasico de multiplicacion vs la version con CSR
            1 para CPU 1 thread vs CPU x threads
            2 CPU vs GPU
    DENSITIL = limite inferior de densidad para Mode=0
    DENSITIR = limite superior de densidad para Mode=0
    NUM_THREADL = limite inferior de threads para Mode=1
    NUM_THREADR = limite superior de threads para Mode=1
    NL = limite inferior de 2**n para Mode=2
    NR = limite superior de 2**n para Mode=2

Compressed Sparse Row (CSR).
Md = matriz dispersa con valores nulos (contiene la data de la matriz), V = vector a multiiplicar,
RI = Row Index, CSR  = Vector de los valores no nulos de la matriz, CI = Column Index

# Ejecucion:
    Matriz-DispersaXVector.cu debe ejecutarse como `bin/prog <n> <d> <m> <s> <nt>`
    pruebas.cpp debe ejecutarse como `bin/prog <n> <d> <m> <s> <nt>`
    Ej: bin/prog $((2**16)) 0.3 0 2 4
    
    Donde:
        <n>: lado de la matriz de n x n, y a la vez largo del vector.
        <d>: densidad de valores distintos de cero, valor entre 0 y 1.
        <m>: modo CPU (0) o GPU (1).
        <s>: semilla para valores aleatorios.
        <nt>: numero de threads OpenMP (para el modo CPU).

# Compilacion:
    Basta con usar el archivo Makefile al hacer `$ make`
