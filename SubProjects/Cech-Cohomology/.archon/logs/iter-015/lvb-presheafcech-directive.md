# Lean ↔ Blueprint Checker Directive

## Slug
presheafcech

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/PresheafCech.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Known issues
- Consolidated chapter (`% archon:covers` lists three files). Restrict your audit
  to blocks relevant to PresheafCech.lean: `lem:injective_cech_acyclic`,
  `lem:cech_complex_hom_identification`, `def:section_cech_complex`,
  `def:cech_free_presheaf_complex` and their neighbours.
- Only 2 of ~5 planned declarations were built this iter:
  `injective_toPresheafOfModules` (Part 1 of `lem:injective_cech_acyclic`) and
  `freeYonedaHomEquiv` (a per-term `Equiv` core of
  `lem:cech_complex_hom_identification`, deliberately NOT yet additive/natural).
  The other planned decls (`sectionCechComplex`, `cechFreePresheafComplex`,
  the full hom-identification iso, `cechFreeComplex_quasiIso`) are not yet in the
  file — that is known, expected, not a Lean error. Focus on whether the chapter
  is detailed enough to have guided the 2 that WERE built, and whether those 2
  match the prose.
