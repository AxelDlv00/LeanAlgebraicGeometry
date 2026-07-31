---
author: sync
content_type: lemma
created: '2026-07-27T01:04:30'
decl: AlgebraicGeometry.JacobianData.homEquiv_ofRepresentableBy
file: AlgebraicJacobian/Picard/JacobianDataCharts.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.JacobianData.homEquiv_ofRepresentableBy
type: lean
updated: '2026-07-31T20:14:44'
---
lemma JacobianData.homEquiv_ofRepresentableBy (J : Over (Spec (.of k)))
    (rep : (pic0TypeFunctor C).RepresentableBy J)
    (hlft : LocallyOfFiniteType J.hom) (hqc : QuasiCompact J.hom)
    {T : Over (Spec (.of k))} (g : T ⟶ J) :
    (JacobianData.ofRepresentableBy C J rep hlft hqc).homEquiv g = rep.homEquiv g :=
  rfl

/-! ## The chart family and its glued object -/

section Charts

variable {ι : Type u} {X : ι → Scheme.{u}}
  (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)