---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: CategoryTheory.Adjunction.conjugateEquiv_leftAdjointUniq_hom
docstring: 'The mate (conjugate) of a `leftAdjointUniq` comparison of two left adjoints
  of the *same* right

  adjoint `G` is the identity of `G`.  This is the abstract content behind every `leftAdjointUniq`

  cocycle: the comparison transports the unit of one adjunction to the other and is
  therefore mate to

  `𝟙 G`.  Used to collapse the `H1` factors in `leftAdjointUniq_leftAdjointCompIso_comm`.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse/PresheafDualPullback.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Adjunction.conjugateEquiv_leftAdjointUniq_hom
type: lean
updated: '2026-07-24T03:02:12'
---
lemma conjugateEquiv_leftAdjointUniq_hom {F F' : C₀ ⥤ C₁} {G : C₁ ⥤ C₀}
    (adj1 : F ⊣ G) (adj2 : F' ⊣ G) :
    conjugateEquiv adj2 adj1 (leftAdjointUniq adj1 adj2).hom = 𝟙 G := by
  rw [leftAdjointUniq, Iso.symm_hom, conjugateIsoEquiv_symm_apply_inv, Iso.refl_inv,
    Equiv.apply_symm_apply]

variable {F₀₁ : C₀ ⥤ C₁} {F₁₂ : C₁ ⥤ C₂} {F₀₂ : C₀ ⥤ C₂}
  {G₁₀ : C₁ ⥤ C₀} {G₂₁ : C₂ ⥤ C₁} {G₂₀ : C₂ ⥤ C₀}