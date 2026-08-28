Implemented [OpenImmersionFieldDescent.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/OpenImmersionFieldDescent.lean) with:

- `AlgebraicGeometry.isOpenImmersion_of_fpqc_pushout`
- `AlgebraicGeometry.isOpenImmersion_of_tensorProduct`

Both signatures match the requested shapes at universe `u`. Verification passed:

- LSP diagnostics: clean
- `lake env lean AlgebraicJacobian/Descent/OpenImmersionFieldDescent.lean`: passed
- `lean_verify` for both declarations: only standard axioms, no source warnings
- No `sorry`, `admit`, `axiom`, or `unsafe`

No other files were edited and no commit was created.
