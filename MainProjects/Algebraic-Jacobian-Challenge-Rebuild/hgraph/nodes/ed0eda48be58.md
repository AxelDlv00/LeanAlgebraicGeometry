---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.relPicFunctor_map
file: AlgebraicJacobian/Picard/RelPic.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.relPicFunctor_map
type: lean
updated: '2026-07-29T15:26:37'
---
lemma relPicFunctor_map {T T' : (Over (Spec (.of k)))ᵒᵖ} (g : T ⟶ T')
    (x : relPic C T.unop) :
    (relPicFunctor C).map g x = relPicMap C g.unop x :=
  rfl

/-! ## Naturality in the curve -/

variable {C} {C' C'' : Over (Spec (.of k))}