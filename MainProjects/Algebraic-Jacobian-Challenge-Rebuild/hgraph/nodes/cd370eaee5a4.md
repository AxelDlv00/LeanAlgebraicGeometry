---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicJacobian.Diagonal.mapRightTwo
docstring: The second-factor push `B ⊗[Polynomial k] B → B ⊗[Polynomial k] F` along
  `c`.
file: AlgebraicJacobian/Algebra/PointFiberIdeal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.Diagonal.mapRightTwo
type: lean
updated: '2026-07-31T20:15:16'
---
noncomputable def mapRightTwo :
    B ⊗[Polynomial k] B →ₐ[Polynomial k] B ⊗[Polynomial k] F :=
  Algebra.TensorProduct.map (AlgHom.id (Polynomial k) B) c

omit [Algebra k B] [IsScalarTower k (Polynomial k) B]
  [Algebra k F] [IsScalarTower k (Polynomial k) F] in