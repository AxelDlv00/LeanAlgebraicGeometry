# Lean ↔ Blueprint Checker Directive

## Slug
gf

## Lean file
AlgebraicJacobian/Picard/FlatteningStratification.lean

## Blueprint chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Known issues
- No new top-level declarations this iter. The prover added in-proof scaffolding (`have`/`let`/`obtain`
  steps F1–F6) inside `exists_localizationAway_finite_mvPolynomial` (`lem:gf_noether_clear_denominators`,
  L4), which still carries one `sorry` for the denominator-clearing assembly. Assess whether the L4
  blueprint block gives enough detail (integral-descent route: inject `A ↪ B`, localize `B_K = K⊗_A B`,
  common denominator, integral finiteness via `Algebra.IsIntegral.finite`) to guide closing that
  residual `sorry` — i.e. is the chapter under-specified relative to the ~150-LOC assembly the Lean
  clearly needs?
- `genericFlatnessAlgebraic` and `genericFlatness` carry `sorry` by design (downstream, gated on L4).
