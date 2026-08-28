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
updated: '2026-08-01T11:45:14'
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