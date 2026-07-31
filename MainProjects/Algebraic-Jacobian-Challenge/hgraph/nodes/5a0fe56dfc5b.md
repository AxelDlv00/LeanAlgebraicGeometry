---
author: sync
content_type: definition
created: '2026-07-31T19:37:12'
decl: AlgebraicGeometry.Adelic.d2ProjectiveTwist
docstring: 'A concrete D2'' twist witness, selected from the projectivity theorem
  for a

  smooth proper geometrically integral curve.  Keeping the choice named makes

  the projective input consumable by later Grassmannian constructions without

  adding a rational-point binder or another representability class.'
file: AlgebraicJacobian/Picard/DivGrassmannianEmbedding.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.d2ProjectiveTwist
type: lean
updated: '2026-07-31T19:37:12'
---
noncomputable def d2ProjectiveTwist
    {k : Type} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] : C.left.Modules :=
  Classical.choose (exists_isProjectiveWith_of_smoothProperGeometricallyIntegral C)