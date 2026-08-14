## Progress

- [Pic0GaloisInvariantMatch.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0GaloisInvariantMatch.lean): fixed `Scheme.PicScheme` scope and proved the honest theta-based invariant/equivariant correspondence.
- Added `pic0GaloisInvariantEquivGaloisEquivariantOver` with the requested orientation.
- Added `pic0GaloisInvariantEquivGaloisEquivariantOver_precomp`, comparing both existing `precomp` operations.
- No `sorry`, `admit`, `axiom`, or new restated-equivariance hypothesis.

## Checks

- Full LSP diagnostics: clean.
- `lake env lean AlgebraicJacobian/Picard/Pic0GaloisInvariantMatch.lean`: exit 0, no output.
- `git diff --check`: passed.
- No commit made. Ownership released.
