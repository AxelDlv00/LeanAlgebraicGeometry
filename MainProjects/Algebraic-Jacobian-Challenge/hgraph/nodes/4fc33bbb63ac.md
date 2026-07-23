---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.diagonalRingMap_right
docstring: '`δ_{I,J}` on the right factor is the pre-localisation transition hom:

  `δ_{I,J}(1 ⊗ b) = θ̃_{I,J}(b)`. Project-local.'
file: AlgebraicJacobian/Picard/GrassmannianCells.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.diagonalRingMap_right
type: lean
updated: '2026-07-24T03:02:10'
---
theorem diagonalRingMap_right (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (b : MvPolynomial (Fin d × {q : Fin r // q ∉ J}) ℤ) :
    diagonalRingMap d r I J hI hJ (1 ⊗ₜ[ℤ] b) = transitionPreMap d r I J hI hJ b := by
  rw [diagonalRingMap, Algebra.TensorProduct.lift_tmul, map_one, one_mul]