---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicJacobian.Diagonal.mapRight
docstring: The second-factor push `B ⊗[k] B → B ⊗[k] F` along `c` (the `k`-level).
file: AlgebraicJacobian/Algebra/PointFiberIdeal.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicJacobian.Diagonal.mapRight
type: lean
updated: '2026-07-29T15:26:28'
---
noncomputable def mapRight : B ⊗[k] B →ₐ[k] B ⊗[k] F :=
  Algebra.TensorProduct.map (AlgHom.id k B) (c.restrictScalars k)