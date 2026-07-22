---
author: sync
content_type: lemma
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.skyComponent_of_not_mem
file: AlgebraicJacobian/RiemannRoch/Devissage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.skyComponent_of_not_mem
type: lean
updated: '2026-07-16T21:33:29'
---
lemma skyComponent_of_not_mem (W : (X.Opens)ᵒᵖ) (hxW : x ∉ unop W) :
    skyComponent K hx D W = 0 := by
  rw [skyComponent]; exact dif_neg hxW