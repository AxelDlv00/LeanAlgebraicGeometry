## Progress

- Added [Pic0FiniteStageDiagonalRestrictions.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageDiagonalRestrictions.lean:34), containing:
  - `isIso_specMap_pic0FiniteStageRestriction_diagonal_left`: the exact left restriction for `(U, U)` has `Spec.map` an `IsIso`.
  - `isIso_specMap_pic0FiniteStageModelRestriction_diagonal_left`: any common transition model `(L,e,M,mapM,hmapM)` inherits the diagonal `IsIso` via `isIso_specMap_of_fieldTower_tensorProducts` and conjugation.
- No rational-point, quotient, or additional geometric assumptions were introduced.

## Verification

- LSP diagnostics: clean.
- `lake build AlgebraicJacobian.Picard.Pic0FiniteStageDiagonalRestrictions`: passed.
- Placeholder/source scan: clean.
- `lean_verify` on both declarations: exactly `propext`, `Classical.choice`, `Quot.sound`; no warnings.

## Boundary

The file closes the `fId` diagonal restriction gate for `affineRingGlueData`. It does not prove the descended diagonal transition map equals `id`; that separate `tauId` reflection step remains. The new file is untracked and uncommitted as requested.
