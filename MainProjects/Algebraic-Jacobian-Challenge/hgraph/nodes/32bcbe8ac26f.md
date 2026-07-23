---
author: sync
content_type: instance
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.PicScheme.instPicSchemeLocallyOfFiniteType
docstring: 'Existence instance for `PicSchemeLocallyOfFiniteType` — **PROVED** (run

  0010): Kleiman §4 Thm `th:main`(1) makes local finiteness part of the same

  existence package as representability, so the strengthened `HasPicScheme`

  existential carries it and the property of the chosen witness is the second

  component of its `choose_spec`. The instance hypothesis is now

  `[HasPicScheme C]` rather than `[HasRationalPoint C]`: the rational-point

  conditionality lives entirely in `instHasPicScheme` (which supplies

  `HasPicScheme C`), and any consumer able to name `PicScheme C` already

  quantifies over `[HasPicScheme C]`.'
file: AlgebraicJacobian/Picard/FGAPicRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.instPicSchemeLocallyOfFiniteType
type: lean
updated: '2026-07-16T21:14:26'
---
instance instPicSchemeLocallyOfFiniteType {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C] :
    PicSchemeLocallyOfFiniteType C :=
  ⟨(HasPicScheme.has_pic_scheme (C := C)).choose_spec.2.1⟩

/-- Projection of `PicSchemeLocallyOfFiniteType` to the Mathlib morphism
property, so that instance search finds `LocallyOfFiniteType (PicScheme
C).hom` whenever the carrier class is in scope (as the identity-component
substrate requires). -/
instance {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicSchemeLocallyOfFiniteType C] :
    LocallyOfFiniteType (PicScheme C).hom :=
  PicSchemeLocallyOfFiniteType.locallyOfFiniteType