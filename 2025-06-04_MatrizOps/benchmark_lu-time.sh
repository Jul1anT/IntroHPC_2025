#!/bin/bash

MAX_THREADS=$(nproc)  # Usa todos los cores disponibles
OUTPUT_FILE="lu_benchmark.tsv"
REPETITIONS=5

# Bucle de pruebas
for threads in $(seq 1 $MAX_THREADS); do
    echo "Probando con $threads hilos..."
    
    # Ejecutar el programa con las repeticiones
    # (El número de hilos se controla con variables de entorno para OpenMP)
    export OMP_NUM_THREADS=$threads

for MATRIX_SIZE in $(seq 1000 1000 5000); do

# Configuración
#export MATRIX_SIZE=$size

$OMP_NUM_THREADS ./lu_time.x $MATRIX_SIZE $REPETITIONS >> temp_results.txt

# Encabezado TSV (usamos tabulaciones para mejor alineación)
echo -e "Threads\tMean_WTime(s)\tSigma_WTime\tMean_CTime(s)\tSigma_CTime" > $OUTPUT_FILE



# Procesar resultados (tu programa ya hace el promedio internamente)
awk 'BEGIN{OFS="\t"} {print NR, $2, $3, $4, $5}' temp_results.txt >> $OUTPUT_FILE


# Limpieza y resultados
rm temp_results.txt
echo "Resultados guardados en $OUTPUT_FILE"
column -t -s $'\t' $OUTPUT_FILE  # Muestra bonita en terminal

done
done


