# Lean Auditor Directive

## Slug

iter150

## Scope

Audit every `.lean` file under the project tree. Pay extra attention to
the two files that received prover edits this iteration:

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean`

Other top-level files to walk:

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RigidityKbar.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Rigidity.lean`
- Any other `.lean` files you can locate under `AlgebraicJacobian/`.

## Focus areas

- Private helper proofs added under `_finsupp_sub_single_eq_of_one_le`,
  `_mvPoly_coeff_pderiv_at_shifted`, `_mvPoly_mem_range_C_of_pderiv_eq_zero`,
  `_mvPoly_mem_range_C_of_D_eq_zero` (ChartAlgebra.lean). Audit Lean
  idioms, naming, deprecation warnings (the iter-150 diagnostics flagged
  `push_neg` deprecated), unused hypotheses, dead code.
- Excuse-comments and TODO-style placeholders in either prover-touched
  file. Distinguish in your report between structured-sorry comment
  blocks (acceptable when they document the residual gap honestly) vs
  excuse-comments that openly admit the code is wrong.
- New helper lemma at the end of ChartAlgebraS3.lean
  (`Algebra.IsSeparable.of_finite_of_perfectField`) — verify the body
  is sound and the lemma is well-stated.
- Deprecated tactics: the prover used `push_neg` in at least one spot
  and Lean flagged it as deprecated. Are there other deprecations
  worth surfacing this iter?

## Acceptance criteria

Per-file checklist (clean / minor / major / critical), plus a global
flagged-issues block. Use severity tags consistently. If you find
nothing must-fix-this-iter, say so explicitly — that's a valid finding.
