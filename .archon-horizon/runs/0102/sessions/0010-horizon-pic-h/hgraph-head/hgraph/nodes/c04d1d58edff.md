---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.PicEtAff.degAff_inv
docstring: The degree of an inverse plus class is the negation of the degree.
file: AlgebraicJacobian/Picard/DegreeZero.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicEtAff.degAff_inv
type: lean
updated: '2026-08-01T09:44:11'
---
theorem PicEtAff.degAff_inv (a : PicEtAff C K) :
    PicEtAff.degAff K a⁻¹ = -PicEtAff.degAff K a := by
  have h := PicEtAff.degAff_mul a⁻¹ a
  rw [inv_mul_cancel, PicEtAff.degAff_one] at h
  omega