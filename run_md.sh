#!/bin/bash
# Usage: run_md.sh outdir

set -e

OUTDIR=$1
MDP_DIR=/pipeline/mdp   # 存放mdp参数文件
WORKDIR=${OUTDIR}/md

mkdir -p ${WORKDIR}
cd ${WORKDIR}

echo "=== Step 1: Convert docked PDBQT to PDB ==="
obabel ../docking/docked.pdbqt -O complex.pdb

echo "=== Step 2: Generate topology with pdb2gmx ==="
gmx pdb2gmx -f complex.pdb -o processed.gro -water tip3p -ff charmm27 -ignh

echo "=== Step 3: Define simulation box ==="
gmx editconf -f processed.gro -o boxed.gro -c -d 1.0 -bt cubic

echo "=== Step 4: Solvate ==="
gmx solvate -cp boxed.gro -cs spc216.gro -o solvated.gro -p topol.top

echo "=== Step 5: Add ions ==="
gmx grompp -f ${MDP_DIR}/ions.mdp -c solvated.gro -p topol.top -o ions.tpr
echo "SOL" | gmx genion -s ions.tpr -o solv_ions.gro -p topol.top -pname NA -nname CL -neutral

echo "=== Step 6: Energy minimization ==="
gmx grompp -f ${MDP_DIR}/minim.mdp -c solv_ions.gro -p topol.top -o em.tpr
gmx mdrun -deffnm em

echo "=== Step 7: NVT Equilibration ==="
gmx grompp -f ${MDP_DIR}/nvt.mdp -c em.gro -p topol.top -o nvt.tpr
gmx mdrun -deffnm nvt

echo "=== Step 8: NPT Equilibration ==="
gmx grompp -f ${MDP_DIR}/npt.mdp -c nvt.gro -p topol.top -o npt.tpr
gmx mdrun -deffnm npt

echo "=== Step 9: Production MD ==="
gmx grompp -f ${MDP_DIR}/md.mdp -c npt.gro -p topol.top -o md.tpr
gmx mdrun -deffnm md

echo "=== MD simulation completed ==="
