# Lean ↔ Blueprint Checker Directive

## Slug
presheafcech

## Lean file
AlgebraicJacobian/Cohomology/PresheafCech.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

(Consolidated chapter. Relevant blocks for this Lean file: `def:section_cech_complex`
(`\label{def:section_cech_complex}`), `lem:cech_complex_hom_identification`
(`\label{lem:cech_complex_hom_identification}`), and `lem:injective_cech_acyclic`
(`\label{lem:injective_cech_acyclic}`). Focus your check on these.)

## Known issues
- This iter the prover added `sectionCechCosimplicial`, `sectionCechComplex`,
  `freeYonedaHomEquiv_apply`, `freeYonedaHomAddEquiv` (all axiom-clean, 0 sorry).
- The prover flagged a potential blueprint reconcile: it built `sectionCechComplex` with codomain
  category `Ab` (= AddCommGrp) rather than "O_X(U)-modules". Please assess whether the blueprint's
  `def:section_cech_complex` prose is consistent with the `Ab`-valued Lean choice, or whether the
  chapter needs reconciliation. This is a key thing to report on.
- `cechComplex_hom_identification` is NOT yet formalized (blocked on cross-file
  `cechFreePresheafComplex`); the blueprint block exists. Report whether the chapter prose is
  adequate for the eventual formalization.
