#!/usr/bin/env bash
# ==============================================================================
# run_pipeline.sh
# Script maestro para la reproduccion secuencial del pipeline de ensamblaje
# Proyecto: Ensamble De-Novo de Genoma Bacteriano (Cupriavidus gilardii WM02)
# Autores: Addiel Antonio Renteral Platas, Andrea Villarruel García
# ==============================================================================

set -euo pipefail

echo "========================================================================"
echo " Pipeline de Ensamble De Novo, Evaluacion y Anotacion Funcional"
echo "========================================================================"

echo "[1/9] Control de Calidad con FastQC..."
./scripts/01_quality_control.sh

echo "[2/9] Limpieza y Filtrado de Lecturas..."
./scripts/02_trimming.sh

echo "[3/9] Ensamblaje de Lecturas Cortas (Velvet, SPAdes)..."
./scripts/03_short_read_assembly.sh

echo "[4/9] Ensamblaje de Lecturas Largas (Canu, Flye)..."
./scripts/04_long_read_assembly.sh

echo "[5/9] Ensamblaje Hibrido (Unicycler)..."
./scripts/05_hybrid_assembly.sh

echo "[6/9] Evaluacion Comparativa (QUAST & MUMmer)..."
./scripts/06_assembly_evaluation.sh

echo "[7/9] Pulido Genomico con Pilon..."
./scripts/07_polishing_pilon.sh

echo "[8/9] Prediccion de Genes con Glimmer3..."
./scripts/08_gene_prediction_glimmer.sh

echo "[9/9] Identificacion Taxonomica (BLASTn) y Anotacion (Prokka)..."
./scripts/09_functional_annotation.sh

echo "========================================================================"
echo " Pipeline finalizado con exito."
echo "========================================================================"
