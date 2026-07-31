---
author: sync
content_type: definition
created: '2026-08-01T00:55:15'
decl: CategoryTheory.Functor.RepresentableBy.Over.mapCompPresheafFace
docstring: 'Assemble a direct presheaf comparison from a common outer pullback and
  an inner

  presheaf comparison.'
file: AlgebraicJacobian/Picard/RepresentableByCocycle.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Functor.RepresentableBy.Over.mapCompPresheafFace
type: lean
updated: '2026-08-01T00:55:15'
---
noncomputable def Over.mapCompPresheafFace
    {D : Type u} [Category.{v, u} D]
    {X Y Z : D} (r₀ r₁ : X ⟶ Z) (q : X ⟶ Y)
    (p₀ p₁ : Y ⟶ Z) (h₀ : r₀ = q ≫ p₀) (h₁ : r₁ = q ≫ p₁)
    {F : (Over Z)ᵒᵖ ⥤ Type v}
    (θ : (Over.map p₀).op ⋙ F ≅ (Over.map p₁).op ⋙ F) :
    (Over.map r₀).op ⋙ F ≅ (Over.map r₁).op ⋙ F :=
  Over.mapCompPresheafOfEq r₀ q p₀ h₀ F ≪≫
    Functor.isoWhiskerLeft (Over.map q).op θ ≪≫
    (Over.mapCompPresheafOfEq r₁ q p₁ h₁ F).symm