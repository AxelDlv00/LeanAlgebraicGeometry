# Lean ↔ blueprint check — CechBridge.lean (iter-020)

Verify bidirectionally one Lean file against its blueprint chapter.

- Lean file: /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechBridge.lean
- Blueprint chapter: /home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
  (consolidated chapter; `% archon:covers` CechBridge.lean. Relevant blocks:
  `lem:cech_complex_hom_identification`, `lem:injective_cech_acyclic`, and the
  cosimplicial/hom-transport material.)

This session added (per task_results/CechBridge.md): `homCechCosimplicial_δ` (private),
`homCechComplex_d_eq` (private, resolves the iter-019 probe sorry), `homCechComplexMapOpIso`,
`sectionCechComplexMapOpIso`. The named target `cechComplex_hom_identification` landed
iter-019. `injective_cech_acyclic` is intentionally NOT built (gated on Lane-1
`cechFreeComplex_quasiIso`).

Report:
(a) Does the Lean follow the blueprint — fake/placeholder statements, signature mismatches
    with `\lean{...}`-named blocks, claimed-but-unproved. Confirm CechBridge.lean has 0 sorries.
(b) Are the new bridge decls (`homCechComplexMapOpIso`, `sectionCechComplexMapOpIso`) covered
    by blueprint blocks, or are they uncovered `lean_aux` needing new entries? Is the blueprint
    adequate to guide the remaining `injective_cech_acyclic` assembly?
