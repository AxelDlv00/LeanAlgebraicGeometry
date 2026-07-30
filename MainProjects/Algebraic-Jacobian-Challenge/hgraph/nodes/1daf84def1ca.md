---
author: sync
content_type: definition
created: '2026-07-31T02:29:39'
decl: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators.localProjectiveFamily
docstring: 'The family of local projective-coordinate morphisms over the two-open

  cover.'
file: AlgebraicJacobian/Picard/FiniteMapProjectiveGluing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators.localProjectiveFamily
type: lean
updated: '2026-07-31T02:29:39'
---
def localProjectiveFamily (b : ULift.{u} Bool) :
    (G.projectiveOpen b).toScheme ⟶
      Proj (MvPolynomial.homogeneousSubmodule G.ProjectiveIndex (ULift.{u} ℤ)) :=
  match b with
  | ⟨true⟩ => G.localProjectiveMap0
  | ⟨false⟩ => G.localProjectiveMap1