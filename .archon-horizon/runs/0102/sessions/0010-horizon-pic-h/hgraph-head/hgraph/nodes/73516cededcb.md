---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: IsLocalization.Away.tensorAwayAlgebra
docstring: 'The canonical `B₁ ⊗[A] B₂`-algebra structure on `Si ⊗[A] Sj`, given by
  `tensorMap`.


  Provided as a `def` (introduce it with `letI`), *not* a global instance: as a global

  instance it would compete with `Algebra.id` in the degenerate case `Si = B₁`, `Sj
  = B₂`.'
file: AlgebraicJacobian/Algebra/TensorAway.lean
generated: lean
lean_status: lean_ok
title: IsLocalization.Away.tensorAwayAlgebra
type: lean
updated: '2026-08-01T09:44:09'
---
@[reducible] noncomputable def tensorAwayAlgebra : Algebra (B₁ ⊗[A] B₂) (Si ⊗[A] Sj) :=
  (tensorMap A B₁ B₂ Si Sj).toRingHom.toAlgebra