Implemented the stable consumer compatibility layer in [Pic0FiniteStageStableGluedOver.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageStableGluedOver.lean):

- Added `Pic0FiniteStageStableGluePackage.gluedOver`, aliasing the selected presentation’s `Over`.
- Added `[simp] gluedOver_hom`.
- No dependent finite-stage reconstruction introduced.

Verification:
- `horizon check --lean ...StableGluedOver.lean`: exited cleanly.
- `lake env lean ...StableGluedOver.lean`: exited cleanly.
- LSP timed out without diagnostics.

Commit was blocked by an existing shared ledger `index.lock` held by another agent’s Git process (PID 566191). The file remains available for you to stage and commit.
