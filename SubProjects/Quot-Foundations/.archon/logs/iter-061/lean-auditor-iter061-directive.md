# Audit scope

Read and audit these files as Lean (no strategy context, no blueprint):

- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean

## Focus
This iter added to GrassmannianQuot.lean:
- Two NEW closed theorems: `matrixToFreeIso_mul`, `bundleTransition_cocycle_matrix`.
- SEVEN `private … '` helper copies ported verbatim from `GrassmannianCells.lean`
  (where the originals are `private`): `cocycle_imageMatrix_eq'`, `imageMatrix_map_eq'`,
  `inv_mul_inv_mul_cancel'`, `isUnit_algebraMap_away_left'`, `map_map_eq_of_comp'`,
  `map_nonsing_inv'`, `mul_submatrix_col'`.
- A documented `sorry` in `bundleTransition_cocycle` (C2) preceded by `apply Iso.ext`.

Check: are the ported `'` copies genuine duplicates of the Cells originals (or do signatures
drift)? Is the C2 `sorry` honest (no fake/placeholder statement, no laundering)? Any dead-end
proof scaffolding, suspect definitions, outdated comments, bad Lean practice? Flag the 7 ports
as duplication if warranted.

Output the standard per-file checklist + flagged-issues block to your task_results report.
