---
author: sync
content_type: lemma
created: '2026-07-17T10:20:05'
decl: AlgebraicGeometry.rowSnd_snd
file: AlgebraicJacobian/Albanese/Milne33Rows.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.rowSnd_snd
type: lean
updated: '2026-08-01T09:44:08'
---
lemma rowSnd_snd (pt : Spec (.of kbar) ⟶ X.left) (hpt : pt ≫ X.hom = 𝟙 _) :
    rowSnd pt hpt ≫ pullback.snd X.hom X.hom = X.hom ≫ pt :=
  pullback.lift_snd _ _ _

variable {X} in