# lean-auditor directive (iter-146 review phase)

## Files in scope

The iter-146 prover lane touched exactly one file:

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/ChartAlgebra.lean`

Please audit this file as Lean — no strategic context, no
"the project is trying to prove X" framing.

## Focus areas

- Sorry-bodied placeholders: 3 inline `sorry`s remain (L97 β-core
  `: True := sorry`, L107 KDM `: True := sorry`, L177 inside
  `constants_integral_over_base_field`'s body).
- New imports + the `attribute [local instance]
  Algebra.TensorProduct.rightAlgebra` at file scope.
- Comment hygiene + signatures that look refined this iter
  (`algebra_isPushout_of_affine_product`,
  `constants_integral_over_base_field`,
  `Scheme.Over.ext_of_diff_zero`).
- Any dead-load / unused hypothesis / suspect tactic patterns.
- File-level structure: where `: True := sorry` placeholders sit
  next to substantive declarations — flag if that mixing is
  problematic.

## Output

Per-file checklist + flagged-issues block per the lean-auditor
descriptor. Write your report to
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/task_results/lean-auditor-iter146.md`.
