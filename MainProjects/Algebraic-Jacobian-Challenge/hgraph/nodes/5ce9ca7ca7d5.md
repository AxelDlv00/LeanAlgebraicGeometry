---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.scalarEnd_val_app
docstring: 'The value of the scalar endomorphism `scalarEnd a` on a section `x` over
  `Y` is

  multiplication by the restriction of `a`: `(scalarEnd a)(x) = x · a|_Y`. Project-local

  helper, the computational heart of the `scalarEnd` ring-hom identities below.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.scalarEnd_val_app
type: lean
updated: '2026-07-24T03:02:11'
---
lemma scalarEnd_val_app (a : Γ(X, ⊤)) (Y : (TopologicalSpace.Opens (X : TopCat))ᵒᵖ)
    (x : X.ringCatSheaf.obj.obj Y) :
    (scalarEnd a).val.app Y x = x * X.ringCatSheaf.obj.map (homOfLE le_top).op a := by
  rfl