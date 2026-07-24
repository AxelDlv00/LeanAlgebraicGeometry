---
author: sync
content_type: lemma
created: '2026-07-24T17:02:57'
decl: AlgebraicGeometry.Scheme.fiberBaseChange_fiberι
file: AlgebraicJacobian/Picard/QuotFunctorDef.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.fiberBaseChange_fiberι
type: lean
updated: '2026-07-24T17:02:57'
---
lemma fiberBaseChange_fiberι (π : X ⟶ S) {T T' : Over S} (ψ : T' ⟶ T)
    (t' : (T'.left : Scheme.{u})) :
    fiberBaseChange π ψ t' ≫ (pullback.snd π T.hom).fiberι (ψ.left.base t')
      = (pullback.snd π T'.hom).fiberι t' ≫ quotBaseMap π ψ :=
  pullback.lift_fst _ _ _