---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.matrixProj
docstring: 'The **matrix presentation** over `S`: the composite of the coordinate
  identification

  `S ⊗[k] (Fin r → k) ≃ (Fin r → S)` with multiplication by `X`.  For

  `X = universalMatrix` this is the tautological presentation `chartTautologicalProj`.'
file: AlgebraicJacobian/Picard/GrassmannianMatrixPoint.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.matrixProj
type: lean
updated: '2026-08-01T09:44:15'
---
noncomputable def matrixProj (X : Matrix (Fin d) (Fin r) S) :
    TensorProduct k S (Fin r → k) →ₗ[S] (Fin d → S) :=
  (Matrix.mulVecLin X).comp (TensorProduct.piScalarRight k S S (Fin r)).toLinearMap

@[simp]