# Lean ↔ blueprint check — QcohTildeSections.lean

Verify one Lean file against its blueprint chapter, bidirectionally.

## Lean file
`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean`

## Blueprint chapter
`/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(this consolidated chapter blueprints QcohTildeSections.lean; the relevant labels are
`lem:qcoh_iso_tilde_sections`, `lem:qcoh_iso_tilde_sections_of_presentation`, and
`rem:o1i8_decomposition`, near line ~3510).

## What to check
- Does the Lean file match the blueprint statements (no fake/placeholder/over-general signatures,
  no signature mismatch with the `\lean{...}` pins)?
- This iter added 3 Lean decls not yet blueprinted: `free_isQuasicoherent`,
  `isIso_fromTildeΓ_of_genSections`, `qcoh_iso_tilde_sections_of_genSections`. Confirm they are
  faithful Lean (genuine content) and flag that they lack blueprint blocks (coverage gap).
- The named target `qcoh_iso_tilde_sections` remains in the **conditional** `[IsIso F.fromTildeΓ]`
  form (the unconditional qcoh upgrade is blocked on 01I8 step 1). Confirm the blueprint `% NOTE`
  at the lemma accurately discloses this and that no blueprint prose overclaims the Lean.
- Report bidirectionally: is the blueprint adequate to guide the remaining formalization, or too
  thin / divergent?
