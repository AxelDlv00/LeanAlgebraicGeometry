---
author: sync
content_type: structure
created: '2026-08-01T10:43:31'
decl: CategoryTheory.Pseudofunctor.DescentCocycle'
docstring: An invertible chosen-pullback cocycle before diagonal normalization.
file: AlgebraicJacobian/Descent/DescentDataNormalization.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Pseudofunctor.DescentCocycle'
type: lean
updated: '2026-08-01T10:43:31'
---
structure DescentCocycle' where
  obj : ∀ i, F.obj (.mk (op (X i)))
  hom : ∀ i j, (F.map (sq i j).p₁.op.toLoc).toFunctor.obj (obj i) ⟶
    (F.map (sq i j).p₂.op.toLoc).toFunctor.obj (obj j)
  homIso : ∀ i j, IsIso (hom i j)
  pullHom'_hom_comp : ∀ i₁ i₂ i₃,
    DescentData'.pullHom' hom (sq₃ i₁ i₂ i₃).p
        (sq₃ i₁ i₂ i₃).p₁ (sq₃ i₁ i₂ i₃).p₂ ≫
      DescentData'.pullHom' hom (sq₃ i₁ i₂ i₃).p
        (sq₃ i₁ i₂ i₃).p₂ (sq₃ i₁ i₂ i₃).p₃ =
      DescentData'.pullHom' hom (sq₃ i₁ i₂ i₃).p
        (sq₃ i₁ i₂ i₃).p₁ (sq₃ i₁ i₂ i₃).p₃

namespace DescentCocycle'

variable {F sq sq₃}

/-- Normalize the diagonal of an invertible cocycle and package it as descent
data. -/
noncomputable opaque toDescentData (D : F.DescentCocycle' sq sq₃) :
    F.DescentData' sq sq₃ :=
  { obj := D.obj
    hom := D.hom
    pullHom'_hom_self :=
      pullHom'_hom_self_of_comp F sq sq₃ D.hom D.homIso D.pullHom'_hom_comp
    pullHom'_hom_comp := D.pullHom'_hom_comp }