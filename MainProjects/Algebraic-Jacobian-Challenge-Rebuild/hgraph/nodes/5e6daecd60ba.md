---
author: sync
content_type: lemma
created: '2026-07-24T17:02:46'
decl: AlgebraicGeometry.Over.amitsurPairOpen_le_insertion₂
docstring: 'The pairwise overlap is bounded by the second-insertion preimage of the

  `𝒩`-overlap.'
file: AlgebraicJacobian/Picard/AmitsurProductCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.amitsurPairOpen_le_insertion₂
type: lean
updated: '2026-07-24T17:02:46'
---
lemma amitsurPairOpen_le_insertion₂ (𝒩 : (XB).PointedCover) (𝒲 : (Xq).PointedCover)
    (hW₁ : ∀ x, 𝒲.opens x ≤ (u₁) ⁻¹ᵁ 𝒩.opens ((u₁).base x)) (z z' : Xcb) :
    amitsurPairOpen C 𝒲 z z'
      ≤ (v₂) ⁻¹ᵁ (𝒩.opens ((v₂).base z) ⊓ 𝒩.opens ((v₂).base z')) :=
  Scheme.Hom.le_preimage_inf_of_comp (w₂₃) (u₁) (v₂)
    (face₂₃_comp_inl C) 𝒩.opens 𝒲.opens hW₁ z z'
    (amitsurPairOpen_le_face₂₃ C 𝒲 z z')