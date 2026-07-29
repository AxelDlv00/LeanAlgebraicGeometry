---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.unitsCorrCochain
docstring: 'The **corrected witness value** at a point `y`, on `𝒞.opens y ⊓ D`:

  `r₁^♯ γZ(a, r₁ y) ⋅ (c y)⁻¹ ⋅ r₂^♯ γZ(r₂ y, b)`.  See the module docstring for why
  this

  is the unique orientation making the values glue over `D` and collapse onto `γZ(a,
  b)`

  on the diagonal.'
file: AlgebraicJacobian/Picard/WitnessCorrection.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.unitsCorrCochain
type: lean
updated: '2026-07-29T15:31:48'
---
noncomputable def unitsCorrCochain (y : Y) : Γ(Y, 𝒞.opens y ⊓ D)ˣ :=
  r₁.unitsAppLE (𝒩.opens a ⊓ 𝒩.opens (r₁.base y)) (𝒞.opens y ⊓ D)
      (r₁.le_preimage_inf (inf_le_right.trans hDa) (inf_le_left.trans (h𝒞₁ y)))
      (Scheme.unitsEvInf γZ a (r₁.base y))
    * (Y.unitsRestrict (inf_le_left : 𝒞.opens y ⊓ D ≤ 𝒞.opens y) (c y))⁻¹
    * r₂.unitsAppLE (𝒩.opens (r₂.base y) ⊓ 𝒩.opens b) (𝒞.opens y ⊓ D)
      (r₂.le_preimage_inf (inf_le_left.trans (h𝒞₂ y)) (inf_le_right.trans hDb))
      (Scheme.unitsEvInf γZ (r₂.base y) b)