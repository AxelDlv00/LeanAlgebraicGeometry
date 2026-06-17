# Lean ↔ Blueprint Checker Directive

## Slug
gf

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean

## Blueprint chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Known issues
- L3 chain closed this iter: `exact_localizedModule_powers_of_shortExact` (L3a),
  `free_localizationAway_of_free_of_eq_mul` (L3b),
  `free_of_shortExact_of_free_free` (L3c), and the assembly
  `exists_free_localizationAway_of_shortExact` — all sorry-free this iter.
- `exists_localizationAway_finite_mvPolynomial` (L4) was RE-SIGNED: the prover
  added one existential binder `(_ : Algebra A_g B_g)` before the AlgHom `φ`,
  because the AlgHom target is ill-typed without it. The chapter's
  `% LEAN SIGNATURE` block for `lem:gf_noether_clear_denominators` reportedly
  omits this binder. Please VERIFY whether the blueprint signature comment
  matches the landed Lean signature and report the direction of any mismatch
  (this is the key thing to check this dispatch).
- L4 and L5 (`exists_free_localizationAway_polynomial`) carry known residual
  `sorry`s (the Mathlib-absent dévissage steps). genericFlatnessAlgebraic /
  genericFlatness are deferred stubs. Flag only signature/adequacy issues, not
  the known `sorry`s themselves.
