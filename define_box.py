#!/usr/bin/env python3
# Automatically define docking box from receptor PDBQT
#根据受体结构自动计算几何中心和合理搜索盒尺寸

import sys
import numpy as np

pdbqt = sys.argv[1]

coords = []

with open(pdbqt) as f:
    for line in f:
        if line.startswith(("ATOM", "HETATM")):
            x = float(line[30:38])
            y = float(line[38:46])
            z = float(line[46:54])
            coords.append([x,y,z])

coords = np.array(coords)

center = coords.mean(axis=0)
size = coords.max(axis=0) - coords.min(axis=0) + 10  # add margin

print(f"--center_x {center[0]:.3f} --center_y {center[1]:.3f} --center_z {center[2]:.3f} "
      f"--size_x {size[0]:.1f} --size_y {size[1]:.1f} --size_z {size[2]:.1f}")
