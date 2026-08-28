---
author: sync
chapter: Lattice finiteness over the Laurent ring
content_type: theorem
created: '2026-07-16T21:33:29'
generated: blueprint
label: thm:tensorCollapse_piAssemblyUnit
lean_status: lean_ok
order: 197
title: The collapse of the assembled unit is the descent unit of the cover cocycle
type: tex
updated: '2026-07-17T16:57:15'
---
Let \((c_{ij})\), \(c_{ij} \in T_{ij}^{\times}\), be a cover cocycle for \(f\), and suppose
  the componentwise units \(w_{ij}\) collapse onto it: \(\kappa_{ij}(w_{ij}) = c_{ij}\) for
  all \(i, j\). Then the collapse of the composite descent unit along the tower
  \(A \to B \to P\) is the descent unit of \(c\):
  \[
    \pi\bigl(\mathrm{piAssembly}(w)\bigr) = \mathrm{cocycleUnit}(c)
    \quad\text{in } (P \otimes_B P)^{\times},
  \]
  where \(\mathrm{cocycleUnit}(c)\) is the unit of \(P \otimes_B P\) corresponding to the
  family \((c_{ij})\) under the pairwise decomposition
  \(P \otimes_B P \cong \prod_{ij} T_{ij}\).