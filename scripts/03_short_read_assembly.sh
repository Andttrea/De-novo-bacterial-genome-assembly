#!/usr/bin/env bash
# ==============================================================================
# 03_short_read_assembly.sh
# Ensamblaje de lecturas cortas (Illumina) con Velvet y SPAdes
# Proyecto: Ensamble De-Novo de Genoma Bacteriano
# Autores: Addiel Antonio Renteral Platas, Andrea Villarruel García
# ==============================================================================

set -euo pipefail

DATA_DIR="../../data"
THREADS=10

mkdir -p ensamble/VelvetOptimiser ensamble/VelvetH ensamble/VelvetG ensamble/Spades

# ------------------------------------------------------------------------------
# 1. VELVET & VELVET OPTIMISER
# ------------------------------------------------------------------------------
echo "=== Paso 3A: Optimizacion de k-meros con VelvetOptimiser ==="
cd ensamble/VelvetOptimiser

# Exploracion inicial de k-meros entre 21 y 61
VelvetOptimiser.pl --s 21 --e 61 --x 2 --t 16 \
  -f "-fastq -shortPaired -separate ${DATA_DIR}/ILLU_GRP4_1.fq ${DATA_DIR}/ILLU_GRP4_2.fq"

# Rango refinado: evaluacion con k=43 como mejor valor seleccionado
cd ../VelvetH
echo "=== Ejecutando VelvetH con k=43 ==="
velveth VELVET_43 43 -fastq -shortPaired -separate \
  "${DATA_DIR}/ILLU_GRP4_1.fq" "${DATA_DIR}/ILLU_GRP4_2.fq"

cd ../VelvetG
echo "=== Ejecutando VelvetG con k=43 ==="
ln -sf ../VelvetH/VELVET_43 .
velvetg VELVET_43 -cov_cutoff auto -exp_cov auto -ins_length 300 -scaffolding no

# ------------------------------------------------------------------------------
# 2. SPADES
# ------------------------------------------------------------------------------
cd ../Spades
echo "=== Paso 3B: Ensamblaje con SPAdes en multiples conjuntos de k-meros ==="

# Version 1: k = 21,33,55,77
spades.py --careful -t "${THREADS}" \
  -1 "${DATA_DIR}/ILLU_GRP4_1.fq" -2 "${DATA_DIR}/ILLU_GRP4_2.fq" \
  -k 21,33,55,77 -o SPADES_V1

# Version 2: k = 51,61,63,69,71
spades.py --careful -t "${THREADS}" \
  -1 "${DATA_DIR}/ILLU_GRP4_1.fq" -2 "${DATA_DIR}/ILLU_GRP4_2.fq" \
  -k 51,61,63,69,71 -o SPADES_V2

# Version 3: k = 17,23,31,41,53,67,79
spades.py --careful -t "${THREADS}" \
  -1 "${DATA_DIR}/ILLU_GRP4_1.fq" -2 "${DATA_DIR}/ILLU_GRP4_2.fq" \
  -k 17,23,31,41,53,67,79 -o SPADES_V3

echo "=== Ensamblajes de lecturas cortas completados exitosamente ==="
