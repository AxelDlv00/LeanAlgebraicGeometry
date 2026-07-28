---
author: sync
content_type: lemma
created: '2026-07-28T12:23:40'
decl: AlgebraicGeometry.rowSnd_snd
file: AlgebraicJacobian/Albanese/Milne33Rows.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.rowSnd_snd
type: lean
updated: '2026-07-28T12:23:40'
---
lemma rowSnd_snd (pt : Spec (.of kbar) ⟶ X.left) (hpt : pt ≫ X.hom = 𝟙 _) :
    rowSnd pt hpt ≫ pullback.snd X.hom X.hom = X.hom ≫ pt :=
  pullback.lift_snd _ _ _

variable {X} in