---
author: sync
content_type: lemma
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.isUnit_det_frameMinor_inv
docstring: The inverse of a unit `I`-minor again has unit determinant.
file: AlgebraicJacobian/Picard/GrassmannianChartFrame.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.isUnit_det_frameMinor_inv
type: lean
updated: '2026-07-17T08:59:07'
---
lemma isUnit_det_frameMinor_inv (X : Matrix (Fin d) (Fin r) S) (I : Finset (Fin r))
    (hI : I.card = d) (hu : IsUnit (frameMinor k d r S X I hI).det) :
    IsUnit ((frameMinor k d r S X I hI)⁻¹).det :=
  IsUnit.of_mul_eq_one _ (by
    rw [← Matrix.det_mul, Matrix.nonsing_inv_mul _ hu, Matrix.det_one] :
    ((frameMinor k d r S X I hI)⁻¹).det * (frameMinor k d r S X I hI).det = 1)