Implemented `StacksPart02Lib/AffineBasics.lean` with sorry-free affine spectrum foundations:

- Standard-open membership, openness, basis
- `D(1) = ⊤`, `D(0) = ⊥`
- `D(fg) = D(f) ∩ D(g)` at open and set levels
- Nilpotence criterion for empty standard opens
- Continuity of spectrum maps
- Standard-open pullback under ring maps
- Composition and pointwise composition of spectrum maps

`lake env lean StacksPart02Lib/AffineBasics.lean` passes cleanly. The file is untracked and uncommitted, as requested.
