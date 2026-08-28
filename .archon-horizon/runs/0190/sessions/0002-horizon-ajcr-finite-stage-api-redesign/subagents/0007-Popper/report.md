Split and committed the stable orbit layer.

Commit: `80c9378fc8`

Changes:

- Added `Pic0FiniteStageStableOrbitAffine.lean` with the stable-package group transport, finite-in-affine helper, and irreducible, connected, immersion, and projective orbit producers.
- Removed all stable declarations/imports from `Pic0FiniteStageOrbitAffine.lean`; legacy APIs remain intact.
- Updated `Pic0FiniteStageStableAffineCover.lean` to import the new stable module.

`lake env lean --src-deps` confirms neither stable module transitively imports `Pic0FiniteStageGluePackage`, `Pic0FiniteStageGlueDataFace`, or the legacy orbit module.

The focused two-target build hit the 300-second timeout without reaching the new module; no source diagnostics were emitted.
