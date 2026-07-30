---
author: sync
content_type: definition
created: '2026-07-30T10:40:20'
decl: Pr.act
file: probe_p4_idcomp.lean
generated: lean
lean_status: lean_ok
stale: true
title: Pr.act
type: lean
updated: '2026-07-31T02:29:52'
---
noncomputable def act (γ : k' ≃ₐ[k] k') :
    (Tw (k := k) γ).op ⋙ ((restrictTest k k').op ⋙ picEt C)
      ≅ (restrictTest k k').op ⋙ picEt C :=
  (Functor.associator _ _ _).symm ≪≫
    Functor.isoWhiskerRight (NatIso.op (tr (k := k) γ)).symm (picEt C)
example (γ : k' ≃ₐ[k] k') (T : Over (Spec (CommRingCat.of k'))) :
    (act C γ).hom.app (Opposite.op T)
      = (picEt C).map ((tr (k := k) γ).inv.app T).op := by
  show 𝟙 _ ≫ _ = _
  rw [Category.id_comp]
  rfl