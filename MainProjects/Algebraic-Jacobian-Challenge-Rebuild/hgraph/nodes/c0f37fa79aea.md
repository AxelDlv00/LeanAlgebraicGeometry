---
author: sync
content_type: lemma
created: '2026-07-24T17:02:47'
decl: AlgebraicGeometry.Over.pieceAmitsurOpen_le_insertion₁
docstring: 'The trimmed Amitsur member is bounded by the first-insertion preimage
  of the

  trimmed representing member.'
file: AlgebraicJacobian/Picard/EffectivityPieceClass.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.pieceAmitsurOpen_le_insertion₁
type: lean
updated: '2026-07-30T15:46:04'
---
lemma pieceAmitsurOpen_le_insertion₁ {𝒩 : (XB).PointedCover}
    {γ : (XB).unitsCocycle 𝒩} (W : NormalizedCechComparison k A B C σ 𝒩 γ)
    (V : (XA).Opens) (z : Xcb) :
    pieceAmitsurOpen C W.cover V z
      ≤ (v₁) ⁻¹ᵁ (𝒩.opens ((v₁).base z) ⊓ (cg) ⁻¹ᵁ V) :=
  Scheme.Hom.le_preimage_of_comp (w₁₂) (u₁) (v₁) (face₁₂_comp_inl C)
    (fun b => 𝒩.opens b ⊓ (cg) ⁻¹ᵁ V)
    (fun x => W.cover.opens x ⊓ (cgq) ⁻¹ᵁ V) (trimmed_le_inl C σ W V) z
    ((w₁₂).le_preimage_inf (pieceAmitsurOpen_le_w₁₂ C W.cover V z)
      (pieceAmitsurOpen_le_w₁₂_piece C W.cover V z))