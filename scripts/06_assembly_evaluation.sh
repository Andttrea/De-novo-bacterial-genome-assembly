#!/usr/bin/env bash
# ==============================================================================
# 06_assembly_evaluation.sh
# Evaluacion y comparativa de ensambles con QUAST y alineamiento con MUMmer
# Proyecto: Ensamble De-Novo de Genoma Bacteriano
# Autores: Addiel Antonio Renteral Platas, Andrea Villarruel García
# ==============================================================================

set -euo pipefail

mkdir -p ensamble/MUMMER/Mummer_Canu_Flye ensamble/MUMMER/Mummer_UniHyb_Canu

echo "=== Paso 6A: Evaluacion global con QUAST ==="
# Comparacion de ensamblajes de lecturas cortas, largas e hibridos
quast -m 200 \
  ensamble/Unicycler/UNI_LONG_V1/assembly.fasta \
  ensamble/Unicycler/UNI_SHORT_V1/assembly.fasta \
  ensamble/Unicycler/UNI_HYBRID_V1/assembly.fasta \
  ensamble/Canu/CANU_V1/GRP4.contigs.fasta \
  ensamble/Flye/FLYE_V1/assembly.fasta \
  -o ensamble/quast_results/comparison_all

echo "=== Paso 6B: Alineamiento estructural con MUMmer (Canu vs Flye) ==="
cd ensamble/MUMMER/Mummer_Canu_Flye

nucmer --coords ../../Canu/CANU_V1/GRP4.contigs.fasta ../../Flye/FLYE_V1/assembly.fasta
mummerplot -p out out.delta

cd ../Mummer_UniHyb_Canu
echo "=== Paso 6C: Alineamiento estructural con MUMmer (UniHybrid vs Canu) ==="

nucmer --coords ../../Unicycler/UNI_HYBRID_V1/assembly.fasta ../../Canu/CANU_V1/GRP4.contigs.fasta
mummerplot -p out out.delta

echo "=== Evaluacion con QUAST y MUMmer completada ==="
