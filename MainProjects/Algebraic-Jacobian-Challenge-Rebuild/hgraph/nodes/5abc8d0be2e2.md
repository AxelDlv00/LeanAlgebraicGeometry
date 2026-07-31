---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.trimmed_le_inl
docstring: 'The trimmed comparison-cover member is bounded by the `u₁`-preimage of
  the trimmed

  representing member.'
file: AlgebraicJacobian/Picard/EffectivityPieceClass.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.trimmed_le_inl
type: lean
updated: '2026-07-31T20:14:44'
---
lemma trimmed_le_inl {𝒩 : (XB).PointedCover} {γ : (XB).unitsCocycle 𝒩}
    (W : NormalizedCechComparison k A B C σ 𝒩 γ) (V : (XA).Opens) (x : Xq) :
    W.cover.opens x ⊓ (cgq) ⁻¹ᵁ V
      ≤ (u₁) ⁻¹ᵁ (𝒩.opens ((u₁).base x) ⊓ (cg) ⁻¹ᵁ V) :=
  (u₁).le_preimage_inf (inf_le_left.trans (W.le_pullbackInl x))
    (inf_le_right.trans (cgqPreimage_le_inl C V))