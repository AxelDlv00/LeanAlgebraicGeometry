---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: Module.DescentDatum.coaction_actionMap
docstring: 'The coaction retracts onto the kernel of `coactionSub ⊗ B`: any `x : B
  ⊗[A] M` on which

  the two liftings agree is a coaction value, namely of `actionMap x`.  This is the

  contracting-homotopy computation at the heart of both effectivity and Amitsur exactness.'
file: AlgebraicJacobian/Descent/ModuleDescent.lean
generated: lean
lean_status: lean_ok
title: Module.DescentDatum.coaction_actionMap
type: lean
updated: '2026-07-30T15:46:01'
---
theorem coaction_actionMap {x : B ⊗[A] M}
    (hx : (D.coaction.restrictScalars A).baseChange B x =
      (TensorProduct.mk A B M 1).baseChange B x) :
    D.coaction (actionMap A B M x) = x :=
  (actionMap_baseChange D.coaction x).symm.trans <| by rw [hx, actionMap_baseChange_mk]