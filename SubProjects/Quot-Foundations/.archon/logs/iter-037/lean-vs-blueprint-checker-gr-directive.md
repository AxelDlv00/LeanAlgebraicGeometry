# Lean ↔ blueprint check — GrassmannianCells

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

## Lean file
`/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean`

## Blueprint chapter
`/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianCells.tex`

## What changed this iter
Three new declarations closing the GR existence-step "E3-full" gap:
- `det_one_updateCol` (private helper — determinant of a column-substituted identity matrix).
- `exists_minorDet_eq_free_entry` (NEW public; cofactor sub-step — a free universal-matrix entry equals ±a signed minor). The prover flags this as needing a fresh blueprint lemma block (suggested label `lem:gr_free_entry_eq_signed_minor`); check whether the chapter already covers it.
- `existence_factor_through_valuationRing` (pinned `lem:gr_existence_factor_through_valuation_ring`).

## Report
(a) Lean → blueprint: any fake/placeholder statements, `\lean{...}` signature mismatches, proof divergence.
(b) Blueprint → Lean: is the chapter detailed enough; are there uncovered new decls (coverage debt)?
Flag must-fix-this-iter items explicitly. Read-only.
