---
author: sync
content_type: instance
created: '2026-07-28T12:23:40'
decl: AlgebraicGeometry.Scheme.PicScheme.{k
docstring: 'Projection of `PicSchemeLocallyOfFiniteType` to the Mathlib morphism

  property, so that instance search finds `LocallyOfFiniteType (PicScheme

  C).hom` whenever the carrier class is in scope (as the identity-component

  substrate requires).'
file: AlgebraicJacobian/Picard/FGAPicRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.{k
type: lean
updated: '2026-07-28T12:23:40'
---
instance {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicSchemeLocallyOfFiniteType C] :
    LocallyOfFiniteType (PicScheme C).hom :=
  PicSchemeLocallyOfFiniteType.locallyOfFiniteType