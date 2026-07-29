---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: CategoryTheory.PresheafOfGroups.OneCocycle.res_ev
file: AlgebraicJacobian/Picard/CechH1.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.PresheafOfGroups.OneCocycle.res_ev
type: lean
updated: '2026-07-29T15:31:37'
---
lemma res_ev (γ : OneCocycle G U) (f : ∀ i, V i ⟶ U i) (i j : I) {T : C}
    (a : T ⟶ V i) (b : T ⟶ V j) :
    (γ.res f).ev i j a b = γ.ev i j (a ≫ f i) (b ≫ f j) :=
  rfl

@[simp]