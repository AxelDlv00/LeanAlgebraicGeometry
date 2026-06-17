# Lean Auditor Directive

## Slug
iter152

## Scope (files)
all `.lean` files under `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/`

## Focus areas (optional)
Pay extra attention to:
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` — three declarations had typeclass hypotheses added to their signatures this iter (`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`, `constants_integral_over_base_field`, `df_zero_factors_through_constant_on_chart`) and one body was re-routed to `sorry`. Check the signatures are well-formed Lean, the docstrings are not stale w.r.t. the new signatures, and whether any declaration compiles with NO `sorry` warning yet transitively depends on a `sorry` (axiom-set `sorryAx` laundering — a known prior issue on `df_zero_factors_through_constant_on_chart`).
- `AlgebraicJacobian/RigidityKbar.lean` — `rigidity_over_kbar` had `[IsAlgClosed kbar]`+`[CharZero kbar]` added.

## Known issues
- Declaration-level `sorry` count is 9 (Jacobian.lean 2, RigidityKbar.lean 1, Cotangent/ChartAlgebraS3.lean 4, Cotangent/ChartAlgebra.lean 2). These are expected open obligations; do not re-report each as "suspect body" unless the surrounding comment misrepresents the status.
- The four `(S3.*)` sorries in `ChartAlgebraS3.lean` are intentionally retained off-path scaffolds (descoped this iter); flag only if their docstrings claim they are load-bearing.
