#!/usr/bin/env bash
# ==============================================================================
# 01_quality_control.sh
# Control de calidad inicial de lecturas crudas Illumina y PacBio mediante FastQC
# Proyecto: Ensamble De-Novo de Genoma Bacteriano
# Autores: Addiel Antonio Renteral Platas, Andrea Villarruel García
# ==============================================================================

set -euo pipefail

# Directorios
DATA_DIR="../../data"
OUT_DIR="fastqs"

mkdir -p "${OUT_DIR}"

echo "=== Paso 1: Ejecutando FastQC en lecturas crudas ==="

# Análisis de lecturas cortas (Illumina Paired-End)
fastqc -o "${OUT_DIR}" "${DATA_DIR}"/ILLU_GRP4_*.fq

# Análisis de lecturas largas (PacBio)
fastqc -o "${OUT_DIR}" "${DATA_DIR}"/PAC_GRP4.fastq

echo "=== FastQC completado. Reportes generados en: ${OUT_DIR}/ ==="
