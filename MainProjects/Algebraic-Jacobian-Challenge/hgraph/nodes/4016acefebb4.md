---
author: sync
content_type: lemma
created: '2026-07-24T19:18:18'
decl: AlgebraicGeometry.Scheme.QcohAlgebra.pullback_fst_isAffineHom
docstring: '**Affineness of the structural pullback projection.**


  Given `g : T ⟶ X` and `𝒜 : X.QcohAlgebra`, the projection

  `q := pullback.fst g (structureMorphism 𝒜) : (T ×_X Spec_X(𝒜)) ⟶ T` is an affine

  morphism. Combined with `RelativeSpec.UniversalProperty 𝒜` (which exhibits the

  relative-spec structure morphism as affine) and the fact that affineness is

  stable under base change (`MorphismProperty.pullback_fst` on `@isAffineHom`),

  this is purely an instance derivation.'
file: AlgebraicJacobian/Picard/RelativeSpec.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.QcohAlgebra.pullback_fst_isAffineHom
type: lean
updated: '2026-07-24T19:18:18'
---
lemma QcohAlgebra.pullback_fst_isAffineHom {X T : Scheme.{u}} (g : T ⟶ X)
    (𝒜 : X.QcohAlgebra) :
    IsAffineHom (CategoryTheory.Limits.pullback.fst g
      (RelativeSpec.structureMorphism 𝒜)) := by
  haveI : IsAffineHom (RelativeSpec.structureMorphism 𝒜) :=
    RelativeSpec.UniversalProperty 𝒜
  exact MorphismProperty.pullback_fst _ _ inferInstance