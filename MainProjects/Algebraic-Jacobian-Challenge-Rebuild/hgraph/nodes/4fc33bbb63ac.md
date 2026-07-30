---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.diagonalRingMap_right
docstring: '`δ_{I,J}` on the right factor is the pre-localisation transition hom:

  `δ_{I,J}(1 ⊗ b) = θ̃_{I,J}(b)`.'
file: AlgebraicJacobian/Picard/GrassmannianDiagonal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.diagonalRingMap_right
type: lean
updated: '2026-07-30T15:46:05'
---
theorem diagonalRingMap_right (k : Type u) [Field k] (d r : ℕ) (I J : Finset (Fin r))
    (hI : I.card = d) (hJ : J.card = d) (b : ChartRing k d r J) :
    diagonalRingMap k d r I J hI hJ (1 ⊗ₜ[k] b) = transitionPreMap k d r I J hI hJ b := by
  rw [diagonalRingMap, Algebra.TensorProduct.lift_tmul, map_one, one_mul]