# Lean ↔ Blueprint Checker Directive

## Slug
freepresheafcomplex

## Lean file
AlgebraicJacobian/Cohomology/FreePresheafComplex.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

(Consolidated chapter. Relevant blocks for this Lean file: `def:cech_free_presheaf_complex`
(`\label{def:cech_free_presheaf_complex}`) and `lem:cech_free_complex_quasi_iso`
(`\label{lem:cech_free_complex_quasi_iso}`). Focus your check on these.)

## Known issues
- This iter the prover built the file from 0 → 8 axiom-clean declarations: `freeYoneda`,
  `coverOpen`, `coverInterOpen`, `coverInterOpen_comp_le`, `cechFreeSimplicial`,
  `cechFreePresheafComplex` (the `def:cech_free_presheaf_complex` deliverable),
  `cechFreePresheafComplex_X`, `sigma_ι_eqToHom_transport`. All 0 sorry.
- A design decision was made: `[Finite 𝒰.I₀]` was added to `cechFreeSimplicial` /
  `cechFreePresheafComplex`, and `∐` (coproduct) was used rather than `⨁` (biproduct).
  The blueprint `def:cech_free_presheaf_complex` prose may state `⨁`. Please assess whether this
  coproduct-vs-biproduct and the finiteness restriction are consistent with the blueprint prose
  or need reconciliation — this is a key thing to report.
- `cechFreeComplex_quasiIso` (`lem:cech_free_complex_quasi_iso`) is NOT yet formalized (needs an
  augmentation object `O_𝒰` that does not exist yet). Report whether the chapter prose is adequate
  to guide that future formalization.
