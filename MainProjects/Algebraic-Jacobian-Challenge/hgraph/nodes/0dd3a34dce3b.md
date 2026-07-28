---
author: sync
content_type: lemma
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.skyComponent_of_not_mem
file: AlgebraicJacobian/RiemannRoch/Ledger/Devissage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.skyComponent_of_not_mem
type: lean
updated: '2026-07-28T18:12:20'
---
lemma skyComponent_of_not_mem (W : (X.Opens)ᵒᵖ) (hxW : x ∉ unop W) :
    skyComponent K hx D W = 0 := by
  rw [skyComponent]; exact dif_neg hxW