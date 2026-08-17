---
author: sync
content_type: definition
created: '2026-08-17T13:21:29'
decl: AlgebraicJacobian.affineTransition
docstring: 'The affine transition induced contravariantly by `tau i j : B j i -> B
  i j`.'
file: AlgebraicJacobian/Descent/AffineRingGlueData.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.affineTransition
type: lean
updated: '2026-08-17T13:21:29'
---
abbrev affineTransition (tau : ∀ i j, B j i →ₐ[R] B i j) (i j : J) :
    Spec (CommRingCat.of (B i j)) ⟶ Spec (CommRingCat.of (B j i)) :=
  Spec.map (CommRingCat.ofHom (tau i j).toRingHom)