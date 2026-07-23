---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.universalMinorInv_mul_cancel
docstring: 'The Cramer inverse is a two-sided inverse (`lem:gr_universalMinorInv_identities`):

  since `det(X^I_J)` is a unit, `(X^I_J)⁻¹` is a genuine left and right inverse.

  Project-local.'
file: AlgebraicJacobian/Picard/GrassmannianCells.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.universalMinorInv_mul_cancel
type: lean
updated: '2026-07-24T03:02:10'
---
theorem universalMinorInv_mul_cancel (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) :
    universalMinorInv d r I J hI hJ * universalMinor d r I J hI hJ = 1 ∧
    universalMinor d r I J hI hJ * universalMinorInv d r I J hI hJ = 1 :=
  ⟨Matrix.nonsing_inv_mul _ (isUnit_det_universalMinor d r I J hI hJ),
   Matrix.mul_nonsing_inv _ (isUnit_det_universalMinor d r I J hI hJ)⟩