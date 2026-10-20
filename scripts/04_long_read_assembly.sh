#!/usr/bin/env bash
# ==============================================================================
# 04_long_read_assembly.sh
# Ensamblaje de novo con lecturas largas PacBio usando Canu y Flye
# Proyecto: Ensamble De-Novo de Genoma Bacteriano
# Autores: Addiel Antonio Renteral Platas, Andrea Villarruel García
# ==============================================================================

set -euo pipefail

DATA_DIR="../../data"
PACBIO_READS="${DATA_DIR}/PAC_GRP4.fastq"
GENOME_SIZE="5.7m"
THREADS=15

mkdir -p ensamble/Canu ensamble/Flye

# ------------------------------------------------------------------------------
# 1. CANU
# ------------------------------------------------------------------------------
echo "=== Paso 4A: Ensamblaje con Canu ==="
cd ensamble/Canu

canu \
  -p GRP4 \
  -d CANU_V1 \
  genomeSize="${GENOME_SIZE}" \
  maxThreads="${THREADS}" \
  -pacbio "${PACBIO_READS}"

# ------------------------------------------------------------------------------
# 2. FLYE
# ------------------------------------------------------------------------------
cd ../Flye
echo "=== Paso 4B: Ensamblaje con Flye ==="

# Flags:
# -g: tamano estimado de genoma (5.7 Mb)
# -t: numero de hilos
# --pacbio-corr: lecturas PacBio corregidas
flye \
  -g "${GENOME_SIZE}" \
  -t "${THREADS}" \
  --pacbio-corr "${PACBIO_READS}" \
  -o FLYE_V1

echo "=== Ensamblajes de lecturas largas Canu y Flye completados exitosamente ==="
