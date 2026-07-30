---
author: sync
content_type: instance
created: '2026-07-30T11:05:08'
decl: Pr.twistIso_hom_left_isIso
docstring: 'The underlying map is an ISO of schemes -- from the slice iso via the

  forgetful functor''s action on morphisms, no geometric instance.'
file: probe_p4_iso.lean
generated: lean
lean_status: sorry
title: Pr.twistIso_hom_left_isIso
type: lean
updated: '2026-07-31T03:47:23'
---
instance twistIso_hom_left_isIso (γ : k' ≃ₐ[k] k') :
    IsIso (twistIso C rep γ).hom.left :=
  ⟨(twistIso C rep γ).inv.left, by
      rw [← Over.comp_left, (twistIso C rep γ).hom_inv_id]; rfl,
    by rw [← Over.comp_left, (twistIso C rep γ).inv_hom_id]; rfl⟩

/-- MULTIPLICATIVITY: is it free? -/
example (γ τ : k' ≃ₐ[k] k') :
    (twistIso C rep (γ * τ)).hom.left
      = (twistIso C rep γ).hom.left ≫ (twistIso C rep τ).hom.left := by
  sorry