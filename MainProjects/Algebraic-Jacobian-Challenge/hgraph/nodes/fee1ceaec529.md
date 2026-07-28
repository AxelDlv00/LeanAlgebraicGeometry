---
author: sync
content_type: definition
created: '2026-07-28T15:48:28'
decl: AlgebraicGeometry.Scheme.WeilDivisor.addEquivNonGeneric
docstring: '**The divisor-level index comparison, additively.** `Finsupp.domCongr`
  of ajc-rr''s

  point-level `PrimeDivisor.equivNonGeneric`; additive because relabelling the index
  set of a

  finitely-supported function commutes with pointwise addition.


  Additivity is what makes this usable for a *degree* statement: `degree` is an

  `AddMonoidHom` (`degree_hom`), and a bare `Equiv` of divisor groups would not respect
  it.'
file: AlgebraicJacobian/RiemannRoch/CurveDivisorIndexBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.WeilDivisor.addEquivNonGeneric
type: lean
updated: '2026-07-28T15:48:28'
---
noncomputable def addEquivNonGeneric (hdim : ∀ z : X, Order.coheight z ≤ 1) :
    X.WeilDivisor ≃+ ({x : X // x ≠ genericPoint X} →₀ ℤ) :=
  Finsupp.domCongr (Scheme.PrimeDivisor.equivNonGeneric hdim)