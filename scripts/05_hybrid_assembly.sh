#!/usr/bin/env bash
# ==============================================================================
# 05_hybrid_assembly.sh
# Ensamblajes con Unicycler (modo long-read, short-read e hibrido)
# Proyecto: Ensamble De-Novo de Genoma Bacteriano
# Autores: Addiel Antonio Renteral Platas, Andrea Villarruel García
# ==============================================================================

set -euo pipefail

DATA_DIR="../../data"
R1="${DATA_DIR}/ILLU_GRP4_1.fq"
R2="${DATA_DIR}/ILLU_GRP4_2.fq"
LONG="${DATA_DIR}/PAC_GRP4.fastq"
THREADS=10

mkdir -p ensamble/Unicycler
cd ensamble/Unicycler

echo "=== Paso 5A: Unicycler modo Long-Reads ==="
unicycler \
  -t "${THREADS}" \
  --linear_seqs 1 \
  -l "${LONG}" \
  -o UNI_LONG_V1

echo "=== Paso 5B: Unicycler modo Short-Reads ==="
unicycler \
  -t "${THREADS}" \
  -1 "${R1}" \
  -2 "${R2}" \
  -o UNI_SHORT_V1

echo "=== Paso 5C: Unicycler modo Hibrido (Illumina + PacBio) ==="
unicycler \
  -t "${THREADS}" \
  -1 "${R1}" \
  -2 "${R2}" \
  -l "${LONG}" \
  -o UNI_HYBRID_V1

echo "=== Ensamblajes con Unicycler completados exitosamente ==="
