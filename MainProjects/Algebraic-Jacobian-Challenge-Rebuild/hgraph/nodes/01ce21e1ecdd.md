---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.unitsTrivTwistCochain_def
file: AlgebraicJacobian/Picard/EffectivityComparisonUnit.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.unitsTrivTwistCochain_def
type: lean
updated: '2026-07-29T15:26:07'
---
lemma unitsTrivTwistCochain_def (r₁ r₂ : Y ⟶ Z)
    (𝒞 : Y.PointedCover) (𝒩 : Z.PointedCover)
    (c : ∀ y : Y, Γ(Y, 𝒞.opens y)ˣ)
    (h𝒞₁ : ∀ y, 𝒞.opens y ≤ r₁ ⁻¹ᵁ 𝒩.opens (r₁.base y))
    (h𝒞₂ : ∀ y, 𝒞.opens y ≤ r₂ ⁻¹ᵁ 𝒩.opens (r₂.base y))
    (DZ : Z.Opens) (DY : Y.Opens)
    (hDY₁ : DY ≤ r₁ ⁻¹ᵁ DZ) (hDY₂ : DY ≤ r₂ ⁻¹ᵁ DZ)
    (t : ∀ z : Z, Γ(Z, 𝒩.opens z ⊓ DZ)ˣ) (y : Y) :
    unitsTrivTwistCochain r₁ r₂ 𝒞 𝒩 c h𝒞₁ h𝒞₂ DZ DY hDY₁ hDY₂ t y
      = Y.unitsRestrict (inf_le_left : 𝒞.opens y ⊓ DY ≤ 𝒞.opens y) (c y)
        * r₂.unitsAppLE (𝒩.opens (r₂.base y) ⊓ DZ) (𝒞.opens y ⊓ DY)
            (r₂.le_preimage_inf (inf_le_left.trans (h𝒞₂ y)) (inf_le_right.trans hDY₂))
            (t (r₂.base y))
        * (r₁.unitsAppLE (𝒩.opens (r₁.base y) ⊓ DZ) (𝒞.opens y ⊓ DY)
            (r₁.le_preimage_inf (inf_le_left.trans (h𝒞₁ y)) (inf_le_right.trans hDY₁))
            (t (r₁.base y)))⁻¹ :=
  rfl