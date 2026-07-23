---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.quasiCompact_toSpecZ
docstring: 'The structure morphism `Gr(d,r) → Spec ℤ` is **quasi-compact**: `Spec
  ℤ` is affine and the

  Grassmannian scheme is a compact space (`compactSpace_scheme`). Project-local: the
  `QuasiCompact`

  input to the valuative criterion for properness.'
file: AlgebraicJacobian/Picard/GrassmannianCells.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.quasiCompact_toSpecZ
type: lean
updated: '2026-07-16T21:14:27'
---
theorem quasiCompact_toSpecZ (d r : ℕ) : QuasiCompact (toSpecZ d r) := by
  have : CompactSpace (scheme d r) := compactSpace_scheme d r
  exact HasAffineProperty.iff_of_isAffine.mpr this