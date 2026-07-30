---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.cechPicMap_sectionOfPoint_snd
docstring: '**The retraction identity** on Čech Picard groups: pullback along the
  section of the

  projection retracts pullback along the projection — `g_T^* ∘ f_T^* = 1` in Kleiman''s

  notation.'
file: AlgebraicJacobian/Picard/Rigidification.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.cechPicMap_sectionOfPoint_snd
type: lean
updated: '2026-07-30T15:28:03'
---
lemma cechPicMap_sectionOfPoint_snd (σ : T ⟶ C) (N : T.left.CechPic) :
    CechPic.map (sectionOfPoint σ).left (CechPic.map (snd C T).left N) = N := by
  rw [← MonoidHom.comp_apply, ← Scheme.CechPic.map_comp, ← Over.comp_left,
    sectionOfPoint_snd, Over.id_left, Scheme.CechPic.map_id]
  rfl

end sectionOfPoint

/-! ## Rigidified classes and `lm:idn` -/

section IsRigidified

variable {T T' : Over (Spec (.of k))}