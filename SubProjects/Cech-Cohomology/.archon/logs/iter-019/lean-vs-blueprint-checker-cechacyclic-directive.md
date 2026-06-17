# Lean ↔ Blueprint Checker Directive

## Slug
cechacyclic

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechAcyclic.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Known issues
- This is a CONSOLIDATED chapter covering several Lean files; only check the blocks whose
  `\lean{...}` targets live in `CechAcyclic.lean` (the `SectionCechModule.*`, `AwayComparison.*`,
  `CombinatorialCech.*`, `CechLocalized.*` declarations, and `lem:cech_acyclic_affine` /
  `lem:section_cech_homology_exact`). Ignore blocks targeting other files.
- The named L1 target was re-signed (iter-017) to the *absolute section-complex* form. The Lean
  file still carries one deliberately-superseded `sorry` on the OLD relative-form `CechAcyclic.affine`
  (~line 109). Do not treat that superseded sorry as a blueprint-violation defect; note it.
- This iter the prover landed `SectionCechModule.dDiff_exact` (positive-degree exactness of the
  un-localised section Čech module complex `D•`) plus ~23 supporting decls. These are NEW
  `lean_aux` helpers not yet bundled into the chapter's `\lean{}` lists — that coverage debt is
  already known and tracked for the planner; you may note under-coverage but it is not a new defect.
- Focus your judgment on: (a) does `dDiff_exact`'s statement faithfully realize step (a) of the
  section-form `lem:cech_acyclic_affine` / `lem:section_cech_homology_exact` prose? (b) is the
  chapter's proof sketch detailed enough to have guided this build, or is it under-specified?
