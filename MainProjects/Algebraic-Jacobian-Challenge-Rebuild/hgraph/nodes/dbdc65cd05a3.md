---
author: sync
content_type: lemma
created: '2026-07-24T17:02:46'
decl: AlgebraicGeometry.stepG_R₁₂
docstring: 'The `w₁₂`-pullback of the descended comparison unit, in canonical three-insertions

  normal form (the base square collapses `w₁₂ ≫ u₂` onto `w₂₃ ≫ u₁`).'
file: AlgebraicJacobian/Picard/CoherentWitnessExists.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.stepG_R₁₂
type: lean
updated: '2026-07-30T15:28:04'
---
private lemma stepG_R₁₂ (𝒲 : (Sq).PointedCover) (θ₀ : ∀ x : Sq, Γ(Sq, 𝒲.opens x)ˣ)
    (𝒜 : (XB).PointedCover) (α : ∀ v : XB, Γ(XB, 𝒜.opens v)ˣ)
    (ψ : Γ(Xq, ⊤)ˣ)
    (hψ : ∀ s : Xq,
      (Xq).unitsRestrict le_top ψ = Over.comparisonCochain C 𝒲 θ₀ 𝒜 α s)
    (x : Xcb) :
    (w₁₂).unitsAppLE ⊤ ((stepGCover C 𝒲 𝒜).opens x) le_top ψ
      = (w₁₂ ≫ (p₂)).unitsAppLE (𝒲.opens ((w₁₂ ≫ (p₂)).base x))
          ((stepGCover C 𝒲 𝒜).opens x)
          ((stepGCover_le_w₁₂ C 𝒲 𝒜 x).trans
            ((w₁₂).preimage_mono inf_le_left))
          (θ₀ ((w₁₂ ≫ (p₂)).base x))
        * ((w₂₃ ≫ (u₁)).unitsAppLE (𝒜.opens ((w₂₃ ≫ (u₁)).base x))
            ((stepGCover C 𝒲 𝒜).opens x)
            ((stepGCover_le_w₂₃ C 𝒲 𝒜 x).trans
              ((w₂₃).preimage_mono (inf_le_right.trans inf_le_left)))
            (α ((w₂₃ ≫ (u₁)).base x))
          / (w₁₂ ≫ (u₁)).unitsAppLE (𝒜.opens ((w₁₂ ≫ (u₁)).base x))
            ((stepGCover C 𝒲 𝒜).opens x)
            ((stepGCover_le_w₁₂ C 𝒲 𝒜 x).trans
              ((w₁₂).preimage_mono (inf_le_right.trans inf_le_left)))
            (α ((w₁₂ ≫ (u₁)).base x))) := by
  exact unitsAppLE_ratio_pullback (w₁₂) (p₂) (u₂) (u₁)
    (w₁₂ ≫ (p₂)) (w₂₃ ≫ (u₁)) (w₁₂ ≫ (u₁)) θ₀ α ψ
    (stepGCover_le_w₁₂ C 𝒲 𝒜 x) x
    inf_le_left (inf_le_right.trans inf_le_right) (inf_le_right.trans inf_le_left)
    (hψ ((w₁₂).base x))
    rfl
    (Over.whiskerLeft_face₁₂_inr (k := k) (A := A) (B := B) C)
    rfl
    ((stepGCover_le_w₁₂ C 𝒲 𝒜 x).trans ((w₁₂).preimage_mono inf_le_left))
    ((stepGCover_le_w₂₃ C 𝒲 𝒜 x).trans
      ((w₂₃).preimage_mono (inf_le_right.trans inf_le_left)))
    ((stepGCover_le_w₁₂ C 𝒲 𝒜 x).trans
      ((w₁₂).preimage_mono (inf_le_right.trans inf_le_left)))