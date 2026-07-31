---
author: sync
content_type: lemma
created: '2026-07-21T12:32:00'
decl: AlgebraicGeometry.relThetaSectionSnd_val_snd
file: AlgebraicJacobian/Picard/DivisorFamilyThetaSections.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.relThetaSectionSnd_val_snd
type: lean
updated: '2026-07-31T20:14:48'
---
lemma relThetaSectionSnd_val_snd :
    (relThetaSectionSnd C R π a).val.2 =
      (relCurve C R).resHom inf_le_right (relFiberCoordOnePow C R π a) := rfl

/-- The section `(1, t₁ᵃ)` reads as `1` on the first pinned chart. -/
@[simp]