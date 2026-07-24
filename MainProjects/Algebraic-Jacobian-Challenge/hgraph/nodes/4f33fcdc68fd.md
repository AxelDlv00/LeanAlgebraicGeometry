---
author: sync
content_type: lemma
created: '2026-07-24T17:02:56'
decl: AlgebraicGeometry.ι_whiskerEquiv_inv
file: AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ι_whiskerEquiv_inv
type: lean
updated: '2026-07-24T17:02:56'
---
private lemma ι_whiskerEquiv_inv {β γ : Type*} {f : β → C} {g : γ → C}
    [HasCoproduct f] [HasCoproduct g] (e : β ≃ γ) (w : ∀ b, g (e b) ≅ f b) (c : γ) :
    Limits.Sigma.ι g c ≫ (Sigma.whiskerEquiv e w).inv =
      (eqToHom (by rw [e.apply_symm_apply]) ≫ (w (e.symm c)).hom) ≫
        Limits.Sigma.ι f (e.symm c) :=
  Limits.Sigma.ι_comp_map' _ _ _

variable [HasPullbacks C] [FinitaryPreExtensive C] {ι : Type} [Finite ι]
  [HasFiniteCoproducts C]