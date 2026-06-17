# Lean ↔ Blueprint Checker Directive

## Slug
cechbridge

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechBridge.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Known issues
- CONSOLIDATED chapter: only check blocks whose `\lean{...}` targets live in `CechBridge.lean`,
  principally `lem:cech_complex_hom_identification` (line ~1034, `\lean{AlgebraicGeometry.cechComplex_hom_identification, ...}`).
  Ignore blocks targeting other files.
- This iter the prover landed the named target `AlgebraicGeometry.cechComplex_hom_identification`
  and a new helper `AlgebraicGeometry.homCechSectionCosimplicialIso`. The helper is a new
  `lean_aux` node not yet bundled into the chapter `\lean{}` list — known coverage debt, not a
  new defect.
- `injective_cech_acyclic` is NOT in this file yet (gated on `cechFreeComplex_quasiIso`, a Lane-2
  target that doesn't exist yet). Don't flag its absence as a defect.
- Two pre-existing `linter.style.show` warnings inside `freeYonedaHomAddEquiv_naturality` (lines
  ~185/187) are untouched/known.
- Focus: does `cechComplex_hom_identification`'s signature (`homCechComplex 𝒰 F ≅ sectionCechComplex
  (coverOpen 𝒰) F`) faithfully match the blueprint prose of `lem:cech_complex_hom_identification`?
