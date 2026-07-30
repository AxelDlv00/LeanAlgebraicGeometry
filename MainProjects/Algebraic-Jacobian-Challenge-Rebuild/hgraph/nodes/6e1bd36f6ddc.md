---
author: sync
content_type: lemma
created: '2026-07-17T10:20:05'
decl: AlgebraicGeometry.selfDiag_snd
file: AlgebraicJacobian/Albanese/Milne33Rows.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.selfDiag_snd
type: lean
updated: '2026-07-30T15:28:00'
---
lemma selfDiag_snd : selfDiag X ≫ pullback.snd X.hom X.hom = 𝟙 X.left :=
  pullback.lift_snd _ _ _

variable {X} in