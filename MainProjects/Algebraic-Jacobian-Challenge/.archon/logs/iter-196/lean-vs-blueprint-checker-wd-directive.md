# Lean ↔ Blueprint Checker Directive

## Slug
wd

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/WeilDivisor.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RiemannRoch_WeilDivisor.tex

## Focus areas
- iter-196 plan-phase demoted `instance instIsRegularInCodimOneProjectiveLineBar`
  to non-private `theorem isRegularInCodimOneProjectiveLineBar` (~L750) to prevent
  silent sorryAx propagation through typeclass synthesis. Verify blueprint reflects
  this naming change (was an `\lean{...inst...}` hint, should now be the theorem name).
- iter-196 ported the Route 2 PID-transfer recipe inside `isRegularInCodimOneProjectiveLineBar`
  body: 8 explicit Lean tactic steps via chart cover → `Spec.stalkIso` → PID/Dedekind
  on `Away (projectiveLineBarGrading kbar) (X i)` (Mathlib polynomial-ring DVR chain) →
  named residual `hy_ne_bot : y.asIdeal ≠ ⊥` (Stacks 02IZ/005X gap). Verify blueprint
  describes this route and the named residual gap.
- L1067 `degree_positivePart_principal_eq_finrank` body unchanged from iter-195
  (substrate gap on Hartshorne I.6.12 function-field correspondence).
- L249 `rationalMap_order_finite_support`, L538 `principal_degree_zero`
  non-constant — unchanged; off-critical-path.

## Out of scope
- The new `hLPUnif` uniformiser hypothesis signature, which was settled in iter-194.
