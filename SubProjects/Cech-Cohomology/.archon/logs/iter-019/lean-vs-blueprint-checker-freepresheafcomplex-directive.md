# Lean ↔ Blueprint Checker Directive

## Slug
freepresheafcomplex

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/FreePresheafComplex.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Known issues
- CONSOLIDATED chapter: only check blocks whose `\lean{...}` targets live in
  `FreePresheafComplex.lean`, principally `def:cech_free_presheaf_complex` (line ~880) and
  `lem:cech_free_complex_quasi_iso` (line ~1177). Ignore blocks targeting other files.
- The named target `lem:cech_free_complex_quasi_iso` (`AlgebraicGeometry.cechFreeComplex_quasiIso`)
  is NOT yet a declaration in the file (only comment-referenced). This iter the prover landed the
  objectwise-reduction step: `quasiIso_of_evaluation` (non-private) + two private helpers
  (`isIso_Fmap_homologyMap`, `isIso_of_evaluation`). So `lem:cech_free_complex_quasi_iso` is
  expected to have NO Lean target yet — do not classify that as a placeholder/sorry defect; note
  it as legitimately-not-yet-built.
- `quasiIso_of_evaluation` is a new `lean_aux` helper with no blueprint block yet — known coverage
  debt, not a new defect.
- Focus on blueprint ADEQUACY: the prover's task result reports the per-`V` sectionwise contracting
  homotopy (steps 2–3, the bulk of the quasi-iso proof) is a large build not yet present. Judge
  whether the chapter's `lem:cech_free_complex_quasi_iso` proof sketch is detailed enough to guide
  that remaining build, or whether it is under-specified and needs a blueprint-writer expansion.
