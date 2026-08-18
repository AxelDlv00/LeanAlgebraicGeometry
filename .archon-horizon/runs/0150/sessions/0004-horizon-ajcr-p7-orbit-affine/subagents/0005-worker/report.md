Implemented the immersion API in the two assigned files:

- Added `FiniteInAffine` and `OrbitsInAffineOpen` producers from a finite projective-space immersion.
- Added stable affine cover and finite-Galois descent consumers.
- Preserved all projectivity APIs as compatibility wrappers.

Verification:

- LSP diagnostics: `[]` for both files.
- Full project build: passed, 9658 jobs.
- All four new declarations use exactly `propext`, `Classical.choice`, and `Quot.sound`.
- Source scans found no `sorry`, custom axioms, or suspicious patterns.
- No commit created.
