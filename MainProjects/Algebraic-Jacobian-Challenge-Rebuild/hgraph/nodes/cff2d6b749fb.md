---
author: sync
content_type: theorem
created: '2026-08-01T14:45:38'
decl: AlgebraicGeometry.Scheme.finiteInAffine_left_of_isAffineHom
docstring: An object affine over a field spectrum satisfies `FiniteInAffine`.
file: AlgebraicJacobian/Descent/FiniteInAffine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.finiteInAffine_left_of_isAffineHom
type: lean
updated: '2026-08-07T05:01:46'
---
theorem finiteInAffine_left_of_isAffineHom {k : Type u} [Field k]
    (X : Over (Spec (CommRingCat.of k))) [IsAffineHom X.hom] :
    FiniteInAffine X.left :=
  haveI := isAffine_of_isAffineHom X.hom
  finiteInAffine_of_isAffine _