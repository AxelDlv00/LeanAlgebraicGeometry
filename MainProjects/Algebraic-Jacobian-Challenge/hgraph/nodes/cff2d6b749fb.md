---
author: sync
content_type: theorem
created: '2026-07-31T11:58:56'
decl: AlgebraicGeometry.Scheme.finiteInAffine_left_of_isAffineHom
docstring: '**The relative producer**: an object of `Over (Spec k)` whose structure

  morphism is affine satisfies `FiniteInAffine`.


  Weaker than it looks useful for — the Picard scheme is *not* affine over `k` — but

  it is the form a chart-by-chart argument would consume, and it makes the

  hypothesis satisfiable at named objects in the slice category the antecedent

  actually lives in, not merely at bare affine schemes.'
file: AlgebraicJacobian/Picard/PicEtPointedReduction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.finiteInAffine_left_of_isAffineHom
type: lean
updated: '2026-07-31T11:58:56'
---
theorem finiteInAffine_left_of_isAffineHom {k : Type u} [Field k]
    (X : Over (Spec (CommRingCat.of k))) [IsAffineHom X.hom] :
    FiniteInAffine X.left :=
  haveI := isAffine_of_isAffineHom X.hom
  finiteInAffine_of_isAffine _