#!/bin/bash
# Usage: run_docking.sh protein.pdbqt ligand.pdbqt outdir

set -e

PROTEIN=$1
LIGAND=$2
OUTDIR=$3

mkdir -p ${OUTDIR}/docking

echo "=== Defining docking box automatically ==="
BOX=$(python3 /pipeline/scripts/define_box.py ${RECEPTOR})

echo "=== Running AutoDock Vina docking ==="

vina --receptor ${PROTEIN} \
     --ligand ${LIGAND} \
     ${BOX} \
     --exhaustiveness 8 \
     --out ${OUTDIR}/docking/docked.pdbqt \
     --log ${OUTDIR}/docking/docking.log

echo "=== Docking finished ==="
