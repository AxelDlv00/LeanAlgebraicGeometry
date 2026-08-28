---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.universalMinorInv_mul_cancel
docstring: 'The Cramer inverse is a two-sided inverse: since `det(X^I_J)` is a unit,

  `(X^I_J)⁻¹` is a genuine left and right inverse.'
file: AlgebraicJacobian/Picard/GrassmannianChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.universalMinorInv_mul_cancel
type: lean
updated: '2026-08-01T09:44:15'
---
theorem universalMinorInv_mul_cancel (k : Type u) [Field k] (d r : ℕ)
    (I J : Finset (Fin r)) (hI : I.card = d) (hJ : J.card = d) :
    universalMinorInv k d r I J hI hJ * universalMinor k d r I J hI hJ = 1 ∧
    universalMinor k d r I J hI hJ * universalMinorInv k d r I J hI hJ = 1 :=
  ⟨Matrix.nonsing_inv_mul _ (isUnit_det_universalMinor k d r I J hI hJ),
   Matrix.mul_nonsing_inv _ (isUnit_det_universalMinor k d r I J hI hJ)⟩