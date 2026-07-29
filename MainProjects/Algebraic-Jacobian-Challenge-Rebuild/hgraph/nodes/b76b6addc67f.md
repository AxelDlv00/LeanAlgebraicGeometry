---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.imageMatrix_submatrix_I
docstring: 'The `I`-minor of the image matrix `M = (X^I_J)⁻¹ X^I` is the Cramer inverse:

  `M_I = (X^I_J)⁻¹ X^I_I = (X^I_J)⁻¹`.'
file: AlgebraicJacobian/Picard/GrassmannianChart.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Grassmannian.imageMatrix_submatrix_I
type: lean
updated: '2026-07-29T15:26:32'
---
theorem imageMatrix_submatrix_I (k : Type u) [Field k] (d r : ℕ) (I J : Finset (Fin r))
    (hI : I.card = d) (hJ : J.card = d) :
    (imageMatrix k d r I J hI hJ).submatrix id
      (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))
      = universalMinorInv k d r I J hI hJ := by
  have h1 : (imageMatrix k d r I J hI hJ).submatrix id
        (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))
      = universalMinorInv k d r I J hI hJ *
        (((universalMatrix k d r I hI).map (algebraMap _ _)).submatrix id
          (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))) := mul_submatrix_col _ _ _
  rw [h1, Matrix.submatrix_map, universalMatrix_submatrix_self,
    Matrix.map_one _ (map_zero _) (map_one _), mul_one]