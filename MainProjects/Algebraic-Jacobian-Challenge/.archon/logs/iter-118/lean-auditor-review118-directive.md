# Lean Auditor Directive

## Slug
review118

## Iteration
118

## Scope (files)
all

## Focus areas (optional)
- `AlgebraicJacobian/Differentials.lean` — refactor agent renamed
  `smooth_iff_locally_free_omega` (iff form) → `smooth_locally_free_omega`
  (forward implication), dropped `LocallyOfFinitePresentation` premise,
  switched from deprecated `IsSmoothOfRelativeDimension` to
  `SmoothOfRelativeDimension`, made `n` implicit. The body remains
  `sorry`. Audit the post-refactor signature for soundness as Lean
  (no excuse-comments, no fake content, no parallel API).
- `AlgebraicJacobian/Jacobian.lean` — bears the project's single
  surviving foundational `sorry` (`nonempty_jacobianWitness:179`).
  Audit the surrounding declarations for excuse-comments, drift,
  or shape issues.

## Known issues
- `AlgebraicJacobian/Jacobian.lean:178` — `nonempty_jacobianWitness`
  has body `sorry`. This is the project's single explicit
  foundational hypothesis; flagging it as `:= sorry` is intended,
  not an excuse-comment. Do flag it in the per-file checklist but
  do not classify as must-fix.
- `AlgebraicJacobian/Differentials.lean:93` — `smooth_locally_free_omega`
  body is `sorry`. This is the scheduled iter-119 prover lane; not
  an excuse-comment. Do flag it but do not classify as must-fix.

## Absolute paths to read
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelJacobi.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/SheafCompose.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Rigidity.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean
