#!/usr/bin/env bash
# ==============================================================================
# 08_gene_prediction_glimmer.sh
# Prediccion ab initio de genes con Glimmer3 sobre el ensamble pulido (Flye + Pilon)
# Proyecto: Ensamble De-Novo de Genoma Bacteriano
# Autores: Addiel Antonio Renteral Platas, Andrea Villarruel García
# ==============================================================================

set -euo pipefail

GENOME_FASTA="glimmer/assembly_flye_pilon.fasta"
OUT_PREFIX="glimmer/flye_run1"

mkdir -p glimmer

# Asegurar enlace o copia del ensamble pulido seleccionado
if [ ! -f "${GENOME_FASTA}" ]; then
  cp ensamble/pilon/flye/assembly_flye_pilon.fasta "${GENOME_FASTA}"
fi

echo "=== Paso 8A: Identificacion de ORFs largos para entrenamiento ==="
# -n: No inicia ORFs con codones alternativos
# -t 1.15: Umbral minimo de relacion codificante
long-orfs -n -t 1.15 "${GENOME_FASTA}" "${OUT_PREFIX}.longorfs"

echo "=== Paso 8B: Extraccion de coordenadas de entrenamiento ==="
extract -t "${GENOME_FASTA}" "${OUT_PREFIX}.longorfs" > "${OUT_PREFIX}.train"

echo "=== Paso 8C: Construccion del modelo ICM (Interpolated Context Model) ==="
build-icm -r "${OUT_PREFIX}.icm" < "${OUT_PREFIX}.train"

echo "=== Paso 8D: Prediccion de genes con Glimmer3 ==="
# -o 50: Longitud minima de ORFs (50 nt)
# -g 110: Tamano minimo de gen predicho (110 nt)
# -t 30: Umbral de puntuacion (threshold) para llamar un gen
glimmer3 -o 50 -g 110 -t 30 "${GENOME_FASTA}" "${OUT_PREFIX}.icm" "${OUT_PREFIX}.glimmer"

echo "=== Paso 8E: Extraccion de secuencias de genes predichos (FFN) ==="
extract -t "${GENOME_FASTA}" "${OUT_PREFIX}.glimmer.predict" > "${OUT_PREFIX}.ffn"

echo "=== Total de ORFs predichos: ==="
grep -c ">" "${OUT_PREFIX}.ffn"

echo "=== Prediccion de genes completada ==="
