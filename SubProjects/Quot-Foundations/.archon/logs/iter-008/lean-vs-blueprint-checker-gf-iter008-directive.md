# Lean ↔ Blueprint Checker Directive

## Slug
gf-iter008

## Lean file
AlgebraicJacobian/Picard/FlatteningStratification.lean

## Blueprint chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Known issues
- This file intentionally still carries `sorry`s on `exists_localizationAway_finite_mvPolynomial`
  (L4), `gf_torsion_reindex` (Mathlib-absent Nagata change-of-variables),
  `exists_free_localizationAway_polynomial` (L5, 1 inner sorry blocked on `gf_torsion_reindex`),
  `genericFlatnessAlgebraic`, and `genericFlatness` (deferred geo leg). Those are tracked
  scaffolding — do not report them as placeholder failures.
- The L5 theorem `exists_free_localizationAway_polynomial` had its signature changed this iter
  from `(A : Type*) … (N : Type*)` to a SHARED universe `(A N : Type u)`, to make the
  base-domain-generalizing strong induction universe-stable. Verify the chapter's
  `% LEAN SIGNATURE` for `lem:gf_polynomial_core` matches (or flag that it needs a `% NOTE`
  recording the shared-universe form — the review agent will add the marker).
- `gf_generic_rank_ses` and `gf_clear_one_denominator` are proven axiom-clean this iter
  (verified `[propext, Classical.choice, Quot.sound]`). Focus on whether their Lean signatures
  match the blueprint prose for `lem:gf_generic_rank_ses` / `lem:gf_clear_one_denominator`,
  and whether the proofs follow the blueprint sketch.
- Note for context (do not re-investigate): the GF chapter currently has zero `\leanok`
  markers despite these closures — a sync_leanok discrepancy the review agent is handling
  separately. Do not treat missing `\leanok` as a Lean-vs-blueprint mismatch.
