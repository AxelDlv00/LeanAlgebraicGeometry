---
author: sync
content_type: theorem
created: '2026-07-28T14:03:58'
decl: AlgebraicGeometry.Scheme.Pic0.proper_of_ambient_universallyClosed
docstring: '**Properness of `Pic⁰_{C/k}` from universal closedness of the ambient
  `Pic_{C/k}`** —

  proved (run 0067). The composite of `universallyClosed_of_ambient` with

  `proper_of_universallyClosed`.


  ⚠ **RETRACTED AS A REDUCTION (run 0067 r6), for the reason given in full at

  `universallyClosed_of_ambient` above.** This text used to call it "the sharpest
  form of

  the properness reduction currently available … what remains is one property of

  `Pic_{C/k}`". It is a true theorem whose hypothesis `UniversallyClosed (PicScheme
  C).hom`

  cannot hold: universal closedness over an affine base implies `CompactSpace` of
  the

  source, while `Pic_{C/k}` is an infinite disjoint union over `deg ∈ ℤ`. See

  `Picard/AmbientPicNotProper.lean`.


  The separatedness and finite-type conjuncts, and the closed-immersion passage from
  the

  ambient scheme to the identity component, are genuinely discharged — the defect
  is

  entirely in *which object* the remaining property is asked of. Use

  `proper_of_valuativeCriterion` instead.'
file: AlgebraicJacobian/Picard/Pic0AbelianVariety.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Pic0.proper_of_ambient_universallyClosed
type: lean
updated: '2026-07-29T06:43:22'
---
theorem proper_of_ambient_universallyClosed {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C]
    (hPic : UniversallyClosed (PicScheme C).hom) :
    IsProper (Pic0Scheme C).hom :=
  proper_of_universallyClosed C (universallyClosed_of_ambient C hPic)