#!/usr/bin/env bash
# ==============================================================================
# 07_polishing_pilon.sh
# Mapeo con Bowtie2 y pulido/correccion del ensamble con Pilon (Canu y Flye)
# Proyecto: Ensamble De-Novo de Genoma Bacteriano
# Autores: Addiel Antonio Renteral Platas, Andrea Villarruel García
# ==============================================================================

set -euo pipefail

DATA_DIR="../../data"
R1="${DATA_DIR}/ILLU_GRP4_1.fq"
R2="${DATA_DIR}/ILLU_GRP4_2.fq"
THREADS=10

mkdir -p ensamble/pilon/canu ensamble/pilon/flye

# ------------------------------------------------------------------------------
# 1. PILON SOBRE ENSAMBLAJE CANU
# ------------------------------------------------------------------------------
echo "=== Paso 7A: Pulido de ensamble Canu con lecturas cortas ==="
cd ensamble/pilon/canu

CANU_FASTA="../../Canu/CANU_V1/GRP4.contigs.fasta"

# Construccion de indice Bowtie2 y mapeo
bowtie2-build "${CANU_FASTA}" CANU_BUILD
bowtie2 -p "${THREADS}" --no-unal -x CANU_BUILD -1 "${R1}" -2 "${R2}" -S assembly.sam

# SAM a BAM ordenado e indexado
samtools view -bSo assembly.bam assembly.sam
samtools sort -o assembly_sort.bam assembly.bam
samtools index assembly_sort.bam

# Pulido con Pilon
pilon \
  --genome "${CANU_FASTA}" \
  --bam assembly_sort.bam \
  --output assembly_canu_pilon \
  --outdir . \
  --changes \
  --chunksize 1000000

# ------------------------------------------------------------------------------
# 2. PILON SOBRE ENSAMBLAJE FLYE
# ------------------------------------------------------------------------------
cd ../flye
echo "=== Paso 7B: Pulido de ensamble Flye con lecturas cortas ==="

FLYE_FASTA="../../Flye/FLYE_V1/assembly.fasta"

# Construccion de indice Bowtie2 y mapeo
bowtie2-build "${FLYE_FASTA}" FLYE_BUILD
bowtie2 -p "${THREADS}" --no-unal -x FLYE_BUILD -1 "${R1}" -2 "${R2}" -S assembly.sam

# SAM a BAM ordenado e indexado
samtools view -bSo assembly.bam assembly.sam
samtools sort -o assembly_sort.bam assembly.bam
samtools index assembly_sort.bam

# Pulido con Pilon
pilon \
  --genome "${FLYE_FASTA}" \
  --bam assembly_sort.bam \
  --output assembly_flye_pilon \
  --outdir . \
  --changes \
  --chunksize 1000000

# ------------------------------------------------------------------------------
# 3. EVALUACION DE LOS ENSAMBLES PULIDOS CON QUAST
# ------------------------------------------------------------------------------
echo "=== Paso 7C: Evaluando ensambles pulidos con QUAST ==="
quast -m 200 \
  assembly_canu_pilon.fasta \
  assembly_flye_pilon.fasta \
  -o ../../quast_results/comparison_pilon

echo "=== Pulido con Pilon finalizado con exito ==="
