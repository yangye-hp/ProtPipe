#!/usr/bin/env python3
import sys
from Bio.SeqUtils import ProtParam
from Bio import SeqIO
import pandas as pd

if len(sys.argv) < 3:
    print("Usage: run_physchem.py protein.fasta output_dir")
    sys.exit(1)

fasta_file = sys.argv[1]
outdir = sys.argv[2]

record = SeqIO.read(fasta_file, "fasta")
sequence = str(record.seq)

analyzer = ProtParam.ProteinAnalysis(sequence)

results = {
    "Sequence_ID": record.id,
    "Length": len(sequence),
    "Molecular_Weight": analyzer.molecular_weight(),
    "Theoretical_pI": analyzer.isoelectric_point(),
    "Aromaticity": analyzer.aromaticity(),
    "Instability_Index": analyzer.instability_index(),
    "GRAVY": analyzer.gravy(),
    "Aliphatic_Index": analyzer.aliphatic_index()
}

df = pd.DataFrame([results])
df.to_csv(f"{outdir}/physchem_results.csv", index=False)

print("=== Physicochemical analysis finished ===")
print(df)
