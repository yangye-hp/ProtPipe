#!/bin/bash
# =====================================================
# Convert PDB to PDBQT using OpenBabel
# Usage:
#    pdb_to_pdbqt.sh input.pdb output.pdbqt
# =====================================================

set -e

INPUT_PDB=$1
OUTPUT_PDBQT=$2

if [ -z "$INPUT_PDB" ] || [ -z "$OUTPUT_PDBQT" ]; then
    echo "Usage: pdb_to_pdbqt.sh input.pdb output.pdbqt"
    exit 1
fi

echo "=== Converting PDB to PDBQT ==="

obabel ${INPUT_PDB} \
       -O ${OUTPUT_PDBQT} \
       --partialcharge gasteiger \
       --addhydrogens

echo "=== Conversion finished ==="
echo "Output: ${OUTPUT_PDBQT}"
