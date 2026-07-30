---
author: sync
content_type: theorem
created: '2026-07-31T03:47:19'
decl: AlgebraicGeometry.Adelic.isProjective_of_smoothProperGeometricallyIrreducible
docstring: 'Projectivity under exactly the smooth, proper, geometrically irreducible

  curve hypotheses used by the algebraic Jacobian challenge.'
file: AlgebraicJacobian/Picard/CurveProjectivity.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.isProjective_of_smoothProperGeometricallyIrreducible
type: lean
updated: '2026-07-31T03:47:19'
---
theorem isProjective_of_smoothProperGeometricallyIrreducible
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] : C.hom.IsProjective := by
  letI : GeometricallyIntegral C.hom :=
    SmoothOfRelativeDimension.geometricallyIntegral 1 C.hom
  exact isProjective_of_smoothProperGeometricallyIntegral C