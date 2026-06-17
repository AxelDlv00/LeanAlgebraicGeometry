# lean-vs-blueprint-checker directive — CechBridge (iter-024)

Verify one Lean file against its blueprint chapter, bidirectionally.

## Lean file
`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechBridge.lean`

## Blueprint chapter
`/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(consolidated chapter; it declares `% archon:covers ... CechBridge.lean`. The relevant node is
`lem:ses_cech_h1`, `\lean{AlgebraicGeometry.ses_cech_h1}`, around line 2681.)

## What landed this iter
- `AlgebraicGeometry.ses_cech_h1` — surjectivity on sections from Čech-H¹ vanishing
  (full sheaf-gluing assembly), built axiom-clean this iter.
- 10 supporting `private` helpers: `restr_trans`, `restr_inj_of_eq`, `restr_op_unique`,
  `restr_g'_transport`, `fι_sectionCechFaceRestr`, `coverConst_iInf`, `coverPair_iInf`,
  `pair_comp_δ0`, `pair_comp_δ1`, plus prior `sectionCech_*_of_isZero_homology`.

## Checks
- Does `ses_cech_h1`'s Lean signature faithfully realize `lem:ses_cech_h1`? In particular the
  task result notes the blueprint's "cofinal system of covers" is captured by taking a SINGLE
  cover satisfying `Ȟ¹(U,F)=0` + the local-lift property as hypotheses. Is this a faithful
  realization or a weakening the blueprint does not authorize? Report which.
- Bidirectional: is the blueprint detailed enough to have guided this proof, or did the Lean
  clearly need detail the chapter lacks? Flag fake/placeholder statements either way.
- Note any helper with no blueprint entry (coverage debt) — but that is informational here.
