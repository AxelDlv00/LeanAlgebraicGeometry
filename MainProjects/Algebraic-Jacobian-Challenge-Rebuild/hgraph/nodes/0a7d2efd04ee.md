---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.pieceComparisonUnit_spec
docstring: '**The defining property of the per-piece comparison unit**: on each member
  of the

  trimmed comparison cover it restricts to the trivialization-twisted witness value.'
file: AlgebraicJacobian/Picard/EffectivityComparisonUnit.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.pieceComparisonUnit_spec
type: lean
updated: '2026-07-16T21:33:28'
---
lemma pieceComparisonUnit_spec {𝒩 : (XB).PointedCover} {γ : (XB).unitsCocycle 𝒩}
    (W : NormalizedCechComparison k A B C σ 𝒩 γ) {V : (XA).Opens}
    (T : PieceTrivialization C 𝒩 γ V) (x : Xq) :
    (Xq).unitsRestrict (inf_le_right : W.cover.opens x ⊓ (cgq) ⁻¹ᵁ V ≤ (cgq) ⁻¹ᵁ V)
        (pieceComparisonUnit C σ W T)
      = unitsTrivTwistCochain (u₁) (u₂) W.cover 𝒩 W.θ
          W.le_pullbackInl W.le_pullbackInr ((cg) ⁻¹ᵁ V) ((cgq) ⁻¹ᵁ V)
          (cgqPreimage_le_inl C V) (cgqPreimage_le_inr C V) T.triv x :=
  (exists_glued_unitsTrivTwist (u₁) (u₂) W.cover 𝒩 W.θ (Scheme.unitsEvInf γ)
    W.le_pullbackInl W.le_pullbackInr ((cg) ⁻¹ᵁ V) ((cgq) ⁻¹ᵁ V)
    (cgqPreimage_le_inl C V) (cgqPreimage_le_inr C V) T.triv
    W.witness T.triv_rel).choose_spec x