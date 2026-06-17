# Lean ↔ blueprint check — CechToCohomology.lean

Verify one Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechToCohomology.lean
(NEW file this iter; not yet imported into the build root — known handoff item.)

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated chapter; `% archon:covers … CechToCohomology.lean`). Relevant blocks:
`lem:cech_ses_of_basis` (L1) and `lem:quotient_vanishing_cech` (L2) of the 01EO chain.

## What to check
- L1 pin `lem:cech_ses_of_basis` → `AlgebraicGeometry.cechComplex_shortExact_of_basis`. Confirm
  name match and faithful realization.
- L2 pin `lem:quotient_vanishing_cech` → `AlgebraicGeometry.quotient_cech_vanishing_of_basis`.
- **IMPORTANT signature drift**: the prover used a COVER-LOCAL, hypothesis-driven form
  (`U : ι → Opens X`, `P : ShortComplex X.PresheafOfModules`, per-face `hface` hypothesis) instead
  of the effort-breaker's `𝒰 : X.OpenCover` / `S : ShortComplex X.Modules` sketch. Check whether the
  blueprint statement prose for L1/L2 reflects this cover-local signature or still describes the
  cover-global form — if the prose describes a different signature, flag it as a blueprint must-fix
  (prose needs updating to match the landed cover-local form).
- The many new helper decls (`sectionCechCosimplicialMap`, `sectionCechCosimplicialFunctor`,
  `sectionCechComplexFunctor`, `sectionCechComplexMap`, `cechCohomology`, `shortExact_piMap`,
  `faceShortComplex`, `sectionCechComplexShortComplex`, `cechHomology_quotient_vanishing`,
  `pi_π_map_apply`) have NO blueprint blocks — report as coverage debt.
- Blueprint → Lean: is the L1/L2 prose detailed enough, or too thin?

Report bidirectionally with must-fix / red-flag tags.
