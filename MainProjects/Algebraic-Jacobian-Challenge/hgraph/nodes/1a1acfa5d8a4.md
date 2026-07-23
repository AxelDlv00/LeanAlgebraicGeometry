---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: PresheafOfModules.revOuterLeg_apply
docstring: 'Evaluation of the outer leg: it is the inner descent.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean
generated: lean
lean_status: lean_ok
title: PresheafOfModules.revOuterLeg_apply
type: lean
updated: '2026-07-24T03:02:12'
---
private lemma revOuterLeg_apply (U : Opens X) (hxU : x ∈ U) (a : ↑(A.obj (op U)))
    (ξ : ↑(TopCat.Presheaf.stalk B.presheaf x)) :
    (revOuterLeg A B x U hxU a) ξ = (ConcreteCategory.hom (revInner A B x U hxU a)) ξ :=
  rfl