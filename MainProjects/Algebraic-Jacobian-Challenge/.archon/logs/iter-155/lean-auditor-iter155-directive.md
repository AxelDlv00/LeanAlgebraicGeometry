# Lean Auditor Directive

## Slug
iter155

## Scope (files)
all

## Focus areas (optional)
- `AlgebraicJacobian/Jacobian.lean` — `genusZeroWitness` was rewritten this iter
  from a bare `sorry` into a `where`-record skeleton. Pay extra attention to
  whether the new structural fields and the uniqueness clause are honest (no
  placeholder/`:= True`/`rfl`-on-nontrivial), and whether the single residual
  `sorry` (the `key` hypothesis) is faithfully isolated rather than laundered.
  Also check the long iter-155 docstring above the declaration for accuracy
  against the code below it.

## Known issues
- `Jacobian.lean` has 2 known declaration-level sorries: `genusZeroWitness`
  (residual `key` hypothesis) and `positiveGenusWitness` (bare sorry, Route A
  off-critical-path). `RigidityKbar.lean` has 1: `rigidity_over_kbar`. These three
  are the project's known open obligations — report on their honesty/comments but
  do not re-flag their mere existence as new.
- `ChartAlgebra.lean` four `local instance` warnings are the intended
  `Algebra.TensorProduct.rightAlgebra` re-enablement (documented).
