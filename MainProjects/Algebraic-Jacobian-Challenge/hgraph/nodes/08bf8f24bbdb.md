---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.side_collapse_left
docstring: '**Generic left-side assembly for the conjugated cocycle**: substitute
  the cast

  coherence (`hcast`), migrate the counit decoration `Y` through the three trailing

  comparisons by the naturality squares `nY1`–`nY3`, peel the chart component off
  the

  front by `nX`, and fold the chart-level collapse `hfold`. Pure rebracketing in an

  abstract category, applied to the concrete pullback chain by unification.

  Project-local.'
file: AlgebraicJacobian/Picard/GlueDescent.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.Modules.side_collapse_left
type: lean
updated: '2026-07-28T13:22:16'
---
private lemma side_collapse_left {𝒞 : Type*} [Category 𝒞]
    {x₀ x₁ y₁ y₂ y₃ y₄ y₅ a₁ a₂ a₃ a₄ a₅ a₆ b₁ m₁ m₂ m₃ : 𝒞}
    {X : x₀ ⟶ x₁} {c₁ : x₁ ⟶ y₁} {c₂ : y₁ ⟶ y₂} {c₃ : y₂ ⟶ y₃} {w : y₃ ⟶ y₅}
    {c₄ : y₃ ⟶ y₄} {Y : y₄ ⟶ y₅}
    {F1 : x₁ ⟶ a₁} {F2 : a₁ ⟶ a₂} {F3 : a₂ ⟶ a₃} {F4 : a₃ ⟶ a₄} {F5 : a₄ ⟶ a₅}
    {F6 : a₅ ⟶ a₆} {F7 : a₆ ⟶ y₄}
    {F1' : x₀ ⟶ b₁} {X' : b₁ ⟶ a₁}
    {Y₁ : a₆ ⟶ m₁} {F7' : m₁ ⟶ y₅} {Y₂ : a₅ ⟶ m₂} {F6' : m₂ ⟶ m₁}
    {Y₃ : a₄ ⟶ m₃} {F5' : m₃ ⟶ m₂} {Z : b₁ ⟶ m₃}
    (hw : w = c₄ ≫ Y)
    (hcast : c₁ ≫ c₂ ≫ c₃ ≫ c₄ = F1 ≫ F2 ≫ F3 ≫ F4 ≫ F5 ≫ F6 ≫ F7)
    (nX : X ≫ F1 = F1' ≫ X')
    (nY1 : F7 ≫ Y = Y₁ ≫ F7')
    (nY2 : F6 ≫ Y₁ = Y₂ ≫ F6')
    (nY3 : F5 ≫ Y₂ = Y₃ ≫ F5')
    (hfold : X' ≫ F2 ≫ F3 ≫ F4 ≫ Y₃ = Z) :
    X ≫ c₁ ≫ c₂ ≫ c₃ ≫ w = F1' ≫ Z ≫ F5' ≫ F6' ≫ F7' := by
  rw [hw]
  calc X ≫ c₁ ≫ c₂ ≫ c₃ ≫ c₄ ≫ Y
      = X ≫ (c₁ ≫ c₂ ≫ c₃ ≫ c₄) ≫ Y := by simp only [Category.assoc]
    _ = X ≫ (F1 ≫ F2 ≫ F3 ≫ F4 ≫ F5 ≫ F6 ≫ F7) ≫ Y := by rw [hcast]
    _ = X ≫ F1 ≫ F2 ≫ F3 ≫ F4 ≫ F5 ≫ F6 ≫ F7 ≫ Y := by simp only [Category.assoc]
    _ = F1' ≫ X' ≫ F2 ≫ F3 ≫ F4 ≫ F5 ≫ F6 ≫ Y₁ ≫ F7' := by
        rw [reassoc_of% nX, nY1]
    _ = F1' ≫ X' ≫ F2 ≫ F3 ≫ F4 ≫ F5 ≫ Y₂ ≫ F6' ≫ F7' := by rw [reassoc_of% nY2]
    _ = F1' ≫ X' ≫ F2 ≫ F3 ≫ F4 ≫ Y₃ ≫ F5' ≫ F6' ≫ F7' := by rw [reassoc_of% nY3]
    _ = F1' ≫ (X' ≫ F2 ≫ F3 ≫ F4 ≫ Y₃) ≫ F5' ≫ F6' ≫ F7' := by
        simp only [Category.assoc]
    _ = F1' ≫ Z ≫ F5' ≫ F6' ≫ F7' := by rw [hfold]