---
author: sync
content_type: theorem
created: '2026-07-28T14:03:58'
decl: AlgebraicGeometry.Scheme.Pic0.proper_of_ambient_universallyClosed
docstring: '**Properness of `Pic⁰_{C/k}` from universal closedness of the ambient
  `Pic_{C/k}`** —

  proved (run 0067). The composite of `universallyClosed_of_ambient` with

  `proper_of_universallyClosed`.


  This is the sharpest form of the properness reduction currently available: `Pic⁰_{C/k}`
  is

  proper over `k` as soon as `Pic_{C/k}` is universally closed over `k`. Both the
  separatedness

  and finite-type conjuncts of `IsProper`, and the passage from the ambient scheme
  to the

  identity component, are discharged; what remains is one property of `Pic_{C/k}`,
  which is

  where Kleiman §5 Thm.~`th:qpp&p` speaks.'
file: AlgebraicJacobian/Picard/Pic0AbelianVariety.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Pic0.proper_of_ambient_universallyClosed
type: lean
updated: '2026-07-28T14:03:58'
---
theorem proper_of_ambient_universallyClosed {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C]
    (hPic : UniversallyClosed (PicScheme C).hom) :
    IsProper (Pic0Scheme C).hom :=
  proper_of_universallyClosed C (universallyClosed_of_ambient C hPic)