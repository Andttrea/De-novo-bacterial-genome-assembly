#!/usr/bin/env bash
# ==============================================================================
# 09_functional_annotation.sh
# Identificacion taxonomica con BLASTn y anotacion funcional completa con Prokka
# Proyecto: Ensamble De-Novo de Genoma Bacteriano
# Autores: Addiel Antonio Renteral Platas, Andrea Villarruel García
# ==============================================================================

set -euo pipefail

GENOME_FASTA="ensamble/pilon/flye/assembly_flye_pilon.fasta"
PREDICTED_GENES="glimmer/flye_run1.ffn"
BLAST_DB="/export/storage/data/blast/db/nt"
THREADS=12

mkdir -p prokka/blastn

# ------------------------------------------------------------------------------
# 1. IDENTIFICACION TAXONOMICA CON BLASTN
# ------------------------------------------------------------------------------
echo "=== Paso 9A: Busqueda de homologos con BLASTn contra base nt ==="
blastn \
  -query "${PREDICTED_GENES}" \
  -db "${BLAST_DB}" \
  -out prokka/blastn/blast_results.txt \
  -evalue 1e-5 \
  -outfmt 6 \
  -num_threads "${THREADS}"

echo "Top hits obtenidos en BLASTn:"
head -n 10 prokka/blastn/blast_results.txt
# Hit mayoritario: Cupriavidus gilardii (Acceso: CP104386.1)

# ------------------------------------------------------------------------------
# 2. ANOTACION FUNCIONAL CON PROKKA
# ------------------------------------------------------------------------------
echo "=== Paso 9B: Anotacion funcional automatizada con Prokka ==="
prokka \
  --outdir prokka/Cupriavidus10_prokka \
  --prefix CP10 \
  --genus Cupriavidus \
  --species gilardii \
  --strain WM02 \
  --locustag CP10 \
  --cpus 10 \
  --force \
  "${GENOME_FASTA}"

echo "=== Estadisticas generales de la anotacion: ==="
cat prokka/Cupriavidus10_prokka/CP10.txt

echo "=== Anotacion funcional completada exitosamente ==="
