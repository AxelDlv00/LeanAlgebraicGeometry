# Lean ↔ Blueprint Checker Directive

## Slug
FreePresheafComplex

## Lean file
AlgebraicJacobian/Cohomology/FreePresheafComplex.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Known issues
- This consolidated chapter blueprints several files; only audit blocks whose \lean{...} targets
  live in FreePresheafComplex.lean, plus check whether FreePresheafComplex.lean's declarations are covered by the chapter.
- This iter the prover added infrastructure helpers that are NOT yet bundled into \lean{...} lists
  (known coverage debt — report which substantive decls lack a block, but treat trivial helpers as acceptable).
- The named lane target may NOT have been built (handed off as a decomposition). Report the gap; the
  prover landed sub-infrastructure instead. Specifically:
  - FreePresheafComplex: target cechFreeComplex_quasiIso NOT built (augmentation chain map built instead).
  - CechBridge: target cechComplex_hom_identification NOT built (per-degree iso + naturality core built).
  - CechAcyclic: section-form target sectionCech_affine_vanishing NOT built; AwayComparison/CechLocalized
    localisation algebra built instead; line ~74/109 sorry is a superseded relative-form decl (intentional).
  - HigherDirectImagePresheaf: named target higherDirectImage_isSheafify_presheafCohomology NOT built;
    resolution form higherDirectImage_iso_sheafify_presheafHomology built instead (a flagged design fork).
