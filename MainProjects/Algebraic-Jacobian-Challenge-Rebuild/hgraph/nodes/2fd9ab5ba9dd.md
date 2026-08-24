---
author: sync
content_type: definition
created: '2026-08-17T13:21:29'
decl: AlgebraicJacobian.AffineTripleTensor
docstring: The coordinate ring of the pullback of the two overlaps based at chart
  `i`.
file: AlgebraicJacobian/Descent/AffineRingGlueData.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.AffineTripleTensor
type: lean
updated: '2026-08-18T20:50:53'
---
abbrev AffineTripleTensor (i j k : J) : Type u :=
  B i j ⊗[A i] B i k