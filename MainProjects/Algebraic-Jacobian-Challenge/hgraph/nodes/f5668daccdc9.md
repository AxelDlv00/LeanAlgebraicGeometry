---
author: sync
content_type: lemma
created: '2026-07-30T19:28:49'
decl: AlgebraicJacobian.GaloisDescent.SemilinearGalAction.preimage_basicOpen_actApp
docstring: 'Pulling back a basic open by the action is the basic open of the transported

  section.  This is the pointwise bridge between orbit containment and the norm

  construction in `exists_invariant_basicOpen_le`.'
file: AlgebraicJacobian/Picard/GaloisQuotientGlue.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.SemilinearGalAction.preimage_basicOpen_actApp
type: lean
updated: '2026-07-30T19:28:49'
---
lemma preimage_basicOpen_actApp (γ : L ≃ₐ[K] L) (s : Γ(X, U)) :
    (ρ.act γ).hom ⁻¹ᵁ X.basicOpen s = X.basicOpen (ρ.actApp hU γ s) := by
  have h1 : ρ.actApp hU γ s
      = X.presheaf.map (homOfLE (hU γ).ge).op ((ρ.act γ).hom.app U s) := rfl
  have hle : X.basicOpen ((ρ.act γ).hom.app U s) ≤ U :=
    (X.basicOpen_le _).trans_eq (hU γ)
  calc
    (ρ.act γ).hom ⁻¹ᵁ X.basicOpen s
        = X.basicOpen ((ρ.act γ).hom.app U s) := Scheme.preimage_basicOpen _ _
    _ = U ⊓ X.basicOpen ((ρ.act γ).hom.app U s) := (inf_eq_right.mpr hle).symm
    _ = X.basicOpen (ρ.actApp hU γ s) := by rw [h1, Scheme.basicOpen_res]