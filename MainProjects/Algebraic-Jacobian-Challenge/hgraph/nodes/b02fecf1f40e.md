---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: CategoryTheory.Adjunction.conjugateEquiv_leftAdjointCompIso_hom
docstring: 'The mate (conjugate) of the *hom* of `leftAdjointCompIso` is `e.inv` (the
  companion of

  `conjugateEquiv_leftAdjointCompIso_inv`, which computes the conjugate of the `inv`).'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse/PresheafDualPullback.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Adjunction.conjugateEquiv_leftAdjointCompIso_hom
type: lean
updated: '2026-07-24T03:02:12'
---
lemma conjugateEquiv_leftAdjointCompIso_hom
    (adj₀₁ : F₀₁ ⊣ G₁₀) (adj₁₂ : F₁₂ ⊣ G₂₁) (adj₀₂ : F₀₂ ⊣ G₂₀) (e : G₂₁ ⋙ G₁₀ ≅ G₂₀) :
    conjugateEquiv adj₀₂ (adj₀₁.comp adj₁₂)
        (leftAdjointCompIso adj₀₁ adj₁₂ adj₀₂ e).hom = e.inv := by
  have hcomp : conjugateEquiv adj₀₂ (adj₀₁.comp adj₁₂)
        (leftAdjointCompIso adj₀₁ adj₁₂ adj₀₂ e).hom ≫ e.hom = 𝟙 _ := by
    conv_lhs => rw [show e.hom = conjugateEquiv (adj₀₁.comp adj₁₂) adj₀₂
      (leftAdjointCompIso adj₀₁ adj₁₂ adj₀₂ e).inv from
        (conjugateEquiv_leftAdjointCompIso_inv adj₀₁ adj₁₂ adj₀₂ e).symm]
    rw [conjugateEquiv_comp, Iso.inv_hom_id, conjugateEquiv_id]
  rw [← cancel_mono e.hom, hcomp, e.inv_hom_id]