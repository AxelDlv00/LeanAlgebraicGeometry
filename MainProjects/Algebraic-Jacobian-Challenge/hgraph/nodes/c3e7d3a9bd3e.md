---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.interLegHom_interProj
docstring: 'The face morphism intertwines the canonical component maps: projecting
  the `σ''`-leg

  onto its `δᵏ l`-th component agrees with first including `U_{σ''} ⊆ U_{σ''∘δᵏ}`
  and then

  projecting onto the `l`-th component.  Both lifts agree after the mono `𝒰.f _`.'
file: AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.interLegHom_interProj
type: lean
updated: '2026-07-24T03:02:09'
---
lemma interLegHom_interProj (𝒰 : X.OpenCover) {p : ℕ} (σ' : Fin (p + 2) → 𝒰.I₀)
    (k : Fin (p + 2)) (l : Fin (p + 1)) :
    interLegHom 𝒰 σ' k ≫ interProj 𝒰 (σ' ∘ (SimplexCategory.δ k).toOrderHom) l =
      interProj 𝒰 σ' ((SimplexCategory.δ k).toOrderHom l) := by
  have hfac : X.homOfLE (le_iInf (fun l' => iInf_le (fun j => coverOpen 𝒰 (σ' j))
        ((SimplexCategory.δ k).toOrderHom l'))) ≫
        coverInterToMember 𝒰 (σ' ∘ (SimplexCategory.δ k).toOrderHom) l =
      coverInterToMember 𝒰 σ' ((SimplexCategory.δ k).toOrderHom l) := by
    haveI : IsOpenImmersion (𝒰.f (σ' ((SimplexCategory.δ k).toOrderHom l))) := inferInstance
    refine IsOpenImmersion.lift_uniq (𝒰.f (σ' ((SimplexCategory.δ k).toOrderHom l)))
      (Scheme.Opens.ι (coverInterOpen 𝒰 σ')) ?_ _ ?_
    refine (Category.assoc _ _ _).trans ?_
    refine (congrArg (fun w => X.homOfLE (le_iInf (fun l' => iInf_le
        (fun j => coverOpen 𝒰 (σ' j)) ((SimplexCategory.δ k).toOrderHom l'))) ≫ w)
      (coverInterToMember_fac 𝒰 (σ' ∘ (SimplexCategory.δ k).toOrderHom) l)).trans ?_
    exact Scheme.homOfLE_ι _ _
  apply Over.OverMorphism.ext
  exact (Category.assoc _ _ _).symm.trans
    (congrArg (fun w => w ≫ Sigma.ι 𝒰.X (σ' ((SimplexCategory.δ k).toOrderHom l))) hfac)