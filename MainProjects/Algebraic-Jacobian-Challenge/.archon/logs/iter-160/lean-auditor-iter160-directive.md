# Lean Auditor Directive

## Slug
iter160

## Scope (files)
all

## Focus areas (optional)
- `AlgebraicJacobian/AbelianVarietyRigidity.lean` received prover work this iter. Pay extra
  attention to the new top-level declarations near lines 100–250:
  `morphism_eq_of_eqAt_closedPoints`, `rigidity_eqAt_closedPoint_of_proper_into_affine`,
  `rigidity_eqOn_saturated_open_to_affine`. In particular check whether any `sorry` body is
  attached to a statement that may be FALSE as stated, and whether the in-body `:= sorry`
  at the `JacobsonSpace` instance is honestly documented or laundering content.

## Known issues
- Pre-existing deferred scaffolds in `AbelianVarietyRigidity.lean`:
  `morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`,
  `rigidity_genus0_curve_to_grpScheme` (cube / Riemann–Roch, intentionally `sorry`). No need to
  re-flag these as new.
- `Jacobian.lean` (`genusZeroWitness.key`, `positiveGenusWitness`) and `RigidityKbar.lean`
  (`rigidity_over_kbar`, the named-gap fallback) carry known downstream sorries.
- Stale section docstrings in `Cotangent/GrpObj.lean` (around L297–327, L428–451) were flagged
  iter-159 (cosmetic, file has no live sorries) — only re-flag if still present and you judge
  them worse than cosmetic.
