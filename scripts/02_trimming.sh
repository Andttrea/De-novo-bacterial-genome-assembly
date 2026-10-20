#!/usr/bin/env bash
# ==============================================================================
# 02_trimming.sh
# Limpieza y recorte de adaptadores/bases de baja calidad (Trim Galore y Trimmomatic)
# Proyecto: Ensamble De-Novo de Genoma Bacteriano
# Autores: Addiel Antonio Renteral Platas, Andrea Villarruel García
# ==============================================================================

set -euo pipefail

DATA_DIR="../../data"
ADAPTERS="/export/storage/users/addielpr/GENOMICA/TRIMM/TRIMMOMATIC/TruSeq3-PE.fa"

mkdir -p trimm/trimm_galore trimm/trimmomatic

echo "=== Paso 2A: Recorte con Trim Galore ==="
cd trimm/trimm_galore

# Flags:
# --fastqc: genera reportes FASTQC antes y despues del recorte
# -j 4: 4 hilos de ejecucion
# --clip_R1 12: recorta 12 nt del extremo 5' en R1 (detectado en FastQC)
# --clip_R2 12: recorta 12 nt del extremo 5' en R2
# --paired: datos paired-end
# --retain_unpaired: conserva lecturas cuya pareja se descarto
trim_galore --fastqc -j 4 --clip_R1 12 --clip_R2 12 --paired --retain_unpaired \
  "${DATA_DIR}/ILLU_GRP4_1.fq" "${DATA_DIR}/ILLU_GRP4_2.fq"

cd ../trimmomatic
echo "=== Paso 2B: Recorte con Trimmomatic ==="

# Flags:
# PE: Paired-End mode
# ILLUMINACLIP: eliminacion de adaptadores TruSeq
# LEADING:3 / TRAILING:3: remueve bases con Q < 3 en extremos
# SLIDINGWINDOW:4:20: ventana de 4 pb con calidad minima promedio Q20
# MINLEN:25: descarta lecturas menores a 25 pb
trimmomatic PE \
  "${DATA_DIR}/ILLU_GRP4_1.fq" "${DATA_DIR}/ILLU_GRP4_2.fq" \
  ILLU_GRP4_1_pair.fq ILLU_GRP4_1_unpair.fq \
  ILLU_GRP4_2_pair.fq ILLU_GRP4_2_unpair.fq \
  ILLUMINACLIP:"${ADAPTERS}":2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:25

# FastQC post-trimmomatic
fastqc ILLU_GRP4_*pair.fq

echo "=== Trimming completado. Comparar reportes para determinar si se usan lecturas filtradas o crudas. ==="
