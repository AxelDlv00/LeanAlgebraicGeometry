# Lean ↔ Blueprint Checker Directive

## Slug
avr-iter160

## Lean file
AlgebraicJacobian/AbelianVarietyRigidity.lean

## Blueprint chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Known issues
- This iter the prover decomposed bridge 2 into two named top-level sub-lemmas:
  `morphism_eq_of_eqAt_closedPoints` (Step 2 — fully proven, axiom-clean) and
  `rigidity_eqAt_closedPoint_of_proper_into_affine` (Step 1 — `sorry` deep residual).
  The main lemma `rigidity_eqOn_saturated_open_to_affine` body now also carries an in-body
  `:= sorry` at a `JacobsonSpace U` instance (a SIGNATURE GAP: route B needs the chain to be
  locally of finite type / Jacobson, which the current signatures do not provide). Verify:
  (a) whether the two NEW sub-lemmas have corresponding `\lean{}` blocks / `\uses` edges in the
  chapter (the prover's task result requests them be added — they may be missing);
  (b) whether the chapter prose still claims `[IsAlgClosed]` is the only enabling instance, vs the
  finite-type/Jacobson requirement the Lean now demonstrably needs (blueprint adequacy);
  (c) signature fidelity of `rigidity_eqOn_saturated_open_to_affine` (should be unchanged byte-identical).
- The pre-existing deferred scaffolds (`morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`,
  `rigidity_genus0_curve_to_grpScheme`) are intentionally `sorry` (cube / Riemann–Roch) — do not flag.
