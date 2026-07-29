---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.Hom.unitsAppLE_glued_trivTwist
docstring: '**Pullback expansion of a glued twisted unit, in composite normal form**:
  for

  `φ : X'' ⟶ Y` and composites `φ ≫ r₁ = m₁`, `φ ≫ r₂ = m₂`, the `φ`-pullback of the
  glued

  unit expands into the pulled witness value and the two `m`-pullbacks of the

  trivialization — the workhorse for the diagonal normalization and the coherence
  of the

  comparison unit.  All spelling changes happen here, over abstract schemes.'
file: AlgebraicJacobian/Picard/EffectivityComparisonUnit.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.Hom.unitsAppLE_glued_trivTwist
type: lean
updated: '2026-07-29T15:26:17'
---
theorem Scheme.Hom.unitsAppLE_glued_trivTwist {X' : Scheme.{u}} (r₁ r₂ : Y ⟶ Z)
    (φ : X' ⟶ Y) (m₁ m₂ : X' ⟶ Z) (hm₁ : φ ≫ r₁ = m₁) (hm₂ : φ ≫ r₂ = m₂)
    (𝒞 : Y.PointedCover) (𝒩 : Z.PointedCover)
    (c : ∀ y : Y, Γ(Y, 𝒞.opens y)ˣ)
    (h𝒞₁ : ∀ y, 𝒞.opens y ≤ r₁ ⁻¹ᵁ 𝒩.opens (r₁.base y))
    (h𝒞₂ : ∀ y, 𝒞.opens y ≤ r₂ ⁻¹ᵁ 𝒩.opens (r₂.base y))
    (DZ : Z.Opens) (DY : Y.Opens)
    (hDY₁ : DY ≤ r₁ ⁻¹ᵁ DZ) (hDY₂ : DY ≤ r₂ ⁻¹ᵁ DZ)
    (t : ∀ z : Z, Γ(Z, 𝒩.opens z ⊓ DZ)ˣ)
    {v : Γ(Y, DY)ˣ}
    (hv : ∀ y : Y,
      Y.unitsRestrict (inf_le_right : 𝒞.opens y ⊓ DY ≤ DY) v
        = unitsTrivTwistCochain r₁ r₂ 𝒞 𝒩 c h𝒞₁ h𝒞₂ DZ DY hDY₁ hDY₂ t y)
    (x : X') {O : X'.Opens}
    (hO𝒞 : O ≤ φ ⁻¹ᵁ 𝒞.opens (φ.base x)) (hOD : O ≤ φ ⁻¹ᵁ DY)
    (e₂ : O ≤ m₂ ⁻¹ᵁ (𝒩.opens (m₂.base x) ⊓ DZ))
    (e₁ : O ≤ m₁ ⁻¹ᵁ (𝒩.opens (m₁.base x) ⊓ DZ)) :
    φ.unitsAppLE DY O hOD v
      = φ.unitsAppLE (𝒞.opens (φ.base x)) O hO𝒞 (c (φ.base x))
        * m₂.unitsAppLE (𝒩.opens (m₂.base x) ⊓ DZ) O e₂ (t (m₂.base x))
        * (m₁.unitsAppLE (𝒩.opens (m₁.base x) ⊓ DZ) O e₁ (t (m₁.base x)))⁻¹ := by
  subst hm₁ hm₂
  have h := congrArg
    (φ.unitsAppLE (𝒞.opens (φ.base x) ⊓ DY) O (φ.le_preimage_inf hO𝒞 hOD))
    (hv (φ.base x))
  rw [unitsTrivTwistCochain_def] at h
  simp only [map_mul, map_inv, Scheme.Hom.map_unitsAppLE,
    Scheme.unitsAppLE_unitsAppLE] at h
  exact h

end TrivTwist

variable {k : Type u} [Field k]
variable {A B : Type u} [CommRing A] [CommRing B] [Algebra k A] [Algebra k B]
  [Algebra A B] [IsScalarTower k A B]
variable (C : Over (Spec (.of k)))

-- product-side objects and maps
set_option quotPrecheck false in
local notation "XA" => (C ⊗ overSpec k A).left
set_option quotPrecheck false in
local notation "XB" => (C ⊗ overSpec k B).left
set_option quotPrecheck false in
local notation "Xq" => (C ⊗ overSpec k (B ⊗[A] B)).left
set_option quotPrecheck false in
local notation "u₁" => (C ◁ Over.overSpecMap (tensorInl (A := A) (B := B))).left
set_option quotPrecheck false in
local notation "u₂" => (C ◁ Over.overSpecMap (tensorInr (A := A) (B := B))).left
set_option quotPrecheck false in
local notation "cg" => (C ◁ Over.overSpecMap ((Algebra.ofId A B).restrictScalars k)).left
set_option quotPrecheck false in
local notation "cgq" =>
  (C ◁ Over.overSpecMap ((Algebra.ofId A (B ⊗[A] B)).restrictScalars k)).left

namespace Over

/-! ## The coprojections over the cover inclusions -/