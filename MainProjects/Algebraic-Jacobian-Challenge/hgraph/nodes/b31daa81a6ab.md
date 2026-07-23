---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.combine_naturality_squares
docstring: 'Generic two-square paste used to assemble the module-naturality of `θ`
  across the

  `SheafOfModules`/`Iso.hom` defeq seam: applied by `exact`, the morphism arguments
  are read off

  the goal''s giant `leftAdjointUniq` term first-order, so no giant-term defeq is
  required.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse/PresheafDualPullbackNatural.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.combine_naturality_squares
type: lean
updated: '2026-07-16T21:14:28'
---
private lemma combine_naturality_squares {C : Type*} [Category C]
    {A B₁ B₂ E F G : C}
    (p : A ⟶ B₁) (i₁ : B₁ ⟶ E) (s₁ : E ⟶ F) (i₂ : A ⟶ B₂) (q : B₂ ⟶ E)
    (s₂ : B₂ ⟶ G) (d : G ⟶ F)
    (h1 : p ≫ i₁ = i₂ ≫ q) (h2 : q ≫ s₁ = s₂ ≫ d) :
    p ≫ i₁ ≫ s₁ = (i₂ ≫ s₂) ≫ d := by
  rw [← Category.assoc, h1, Category.assoc, h2, ← Category.assoc]