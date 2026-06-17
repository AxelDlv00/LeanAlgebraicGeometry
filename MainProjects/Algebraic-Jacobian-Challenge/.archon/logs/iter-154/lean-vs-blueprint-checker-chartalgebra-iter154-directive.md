# lean-vs-blueprint-checker — ChartAlgebra.lean ↔ RigidityKbar.tex (iter-154)

## Lean file (absolute path)

/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/ChartAlgebra.lean

## Blueprint chapter (absolute path)

/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex

## Context

There is NO dedicated `AlgebraicJacobian_Cotangent_ChartAlgebra.tex` chapter.
The informal content for `ChartAlgebra.lean`'s critical-path lemma
`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (label
`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`) and its delegate
`lem:chart_algebra_df_zero_factors_through_constant_on_chart` is maintained in
`RigidityKbar.tex` (the FT block + "Iter-152 alg-closed pivot" section).

This iter the prover CLOSED the KDM lemma (was a `sorry`, now axiom-clean) via
the single-element / perfect-field / Jacobi–Zariski `H1Cotangent` route
(FT.1)–(FT.3) documented in `analogies/ftthree-kernel-iter154.md`.

## Verify bidirectionally

1. Lean → blueprint: do the closed Lean statement + its hypotheses
   (`[IsAlgClosed k] [CharZero k] [IsDomain B] [Algebra.FiniteType k B]
   [IsStandardSmoothOfRelativeDimension n k B]`) match the blueprint's stated
   lemma? Does the blueprint's FT.1–FT.3 prose still describe the actual proof
   the Lean now contains (or does it still describe a "Mathlib gap / residual
   sorry" that no longer exists)?
2. Blueprint → Lean: is the blueprint prose detailed enough, and are there stale
   claims (e.g. "FT.3 absent from Mathlib", "bright-line STOP") that the iter-154
   closure contradicts and should be flagged for the plan/blueprint agent to fix?
3. Report any `\lean{...}` name mismatch, any orphaned `\uses{...}` pointing at
   the now-removed `_mvPoly_*` helpers, and whether the constants /
   `df_zero_factors_through_constant_on_chart` blocks remain consistent.

Report must-fix items distinctly from minor/housekeeping.
