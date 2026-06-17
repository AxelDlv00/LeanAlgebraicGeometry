# Lean ↔ blueprint check — CechSectionIdentification.lean (iter-062)

Bidirectionally verify ONE Lean file against its blueprint chapter.

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated chapter; it declares `% archon:covers AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`)

## What to check
- Lean → blueprint: do this iter's new declarations have faithful blueprint statements? Any
  fake/placeholder/Subsingleton-laundered Lean statement? Any signature mismatch with the \lean{...}
  target?
- blueprint → Lean: is the chapter detailed enough to have guided this formalization, or did the Lean
  clearly need more detail than the chapter provides? In particular assess whether the blueprint proofs
  of `lem:pushPull_binary_coprod_prod` (CSI) and `lem:pushforward_slice_pullback_iso` /
  `lem:slice_structureSheaf_hom` (OpenImm) are complete enough for the remaining assembly.
- Report any `% NOTE:`/`\notready`/`\lean{}` markers that are now stale.

## Output
Bidirectional report with must-fix-this-iter vs informational severity. Write to task_results/.
