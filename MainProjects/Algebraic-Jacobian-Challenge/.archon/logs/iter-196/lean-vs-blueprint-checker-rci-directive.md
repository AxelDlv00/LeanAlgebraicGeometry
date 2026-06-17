# Lean ↔ Blueprint Checker Directive

## Slug
rci

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex

## Focus areas
- iter-196 reformulated `phi_left_locallyQuasiFinite_of_finrank_one` (L873) body:
  swapped abstract per-fibre LQF goal for concrete `(φ.left ⁻¹' {x}).Finite`,
  using `LocallyQuasiFinite.of_finite_preimage_singleton` + in-scope derivation
  of `IsProper φ.left` + `LocallyOfFiniteType φ.left`. Verify blueprint adequately
  describes this set-theoretic preimage-finiteness route.
- L463 `localParameterAtInfty_uniformiser_witness` unchanged (3-step substrate gap
  documented in iter-195).
- L962 `phi_left_fromNormalization_isIso_of_smoothProper_finrank_one` unchanged
  (gated on `IsNormalScheme` Mathlib substrate).

## Out of scope
- WeilDivisor.lean's `isRegularInCodimOneProjectiveLineBar` (consumer-side typeclass
  binders threaded through this file by the iter-196 plan-phase demotion refactor).
