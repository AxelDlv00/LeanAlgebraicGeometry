## Progress

- Added [GaloisQuotientDescent.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GaloisQuotientDescent.lean), porting effective Galois descent and invariant-projection witnesses.
- Added [GaloisQuotientOverlap.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GaloisQuotientOverlap.lean), porting stable-affine overlaps, cocycles, gluing, and the non-affine quotient instance.
- Exported endpoints include `galoisQuotientWitnessOfInvariantProjection`, `StableAffineOpen.isGaloisQuotient_glued`, and `StableAffineOpen.hasGaloisQuotient_of_orbitsInAffineOpen`.
- Both narrow builds pass. Normalized diffs against AJC are empty except the required AJCR parameter-name adaptation.
- Source scans found no placeholders. Selected headline declarations use exactly `propext`, `Classical.choice`, and `Quot.sound`.

## Issues

- LSP remained on a stale-import-cache diagnostic for the overlap file, although its kernel build and `lean_verify` checks passed.
- Files remain uncommitted as requested; ledger status shows exactly these two new files.
