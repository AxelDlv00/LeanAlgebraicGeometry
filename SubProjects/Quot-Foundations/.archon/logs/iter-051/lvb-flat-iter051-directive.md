# lean-vs-blueprint-checker — FlatteningStratification iter-051

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

## Focus
- New Lean decls: `module_finite_of_ringEquiv_semilinear` (no blueprint block yet),
  `gf_qcoh_finite_sections_of_genSections` (lem:gf_qcoh_finite_sections_of_genSections),
  `gf_qcoh_fintype_finite_sections` (lem:gf_qcoh_fintype_finite_sections).
- Bidirectional check: do the Lean signatures match the blueprint statements? In particular the Lean
  `gf_qcoh_finite_sections_of_genSections` requires only `[F.IsQuasicoherent]` (NOT `[F.IsFiniteType]`) — does the
  blueprint over-state hypotheses? Flag any signature mismatch / fake statement / blueprint-too-thin findings.

## Output
Lean→blueprint and blueprint→Lean findings with severity; name any % NOTE / blueprint-writer fix needed.
