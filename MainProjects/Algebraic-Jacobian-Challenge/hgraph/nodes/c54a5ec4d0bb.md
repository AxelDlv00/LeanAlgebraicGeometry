---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.PicScheme.degree
docstring: 'A **conditional totalisation of a legacy Abel-compatible candidate**.


  This declaration requires the legacy `[HasPicScheme C]` and an unproduced

  `[ClassDegreePinned C]`. On sections of `(PicScheme C).hom` it evaluates the candidate
  stored

  by that interface; on arbitrary underlying morphisms that are not sections it assigns
  `0`.

  `degree_eq_degreeOfSectionPinned` records exactly the first branch.


  This is not the arbitrary-field degree on the étale-sheafified Picard functor. For
  that target,

  an étale-local representative `L` on `C ×ₖ U` should have fibre value

  `χ(C_u, L_u) - χ(C_u, O_{C_u})` at every `u`, with pullback naturality, quotient
  invariance,

  local constancy, and additivity. None of those properties is a field of `ClassDegreePinned`.

  Accordingly, this declaration proves no homomorphism or functoriality property and
  no

  identification with Euler-characteristic degree.'
file: AlgebraicJacobian/Picard/IdentityComponent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.degree
type: lean
updated: '2026-08-03T08:55:16'
---
noncomputable def degree {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C] [ClassDegreePinned C] :
    (Spec (.of k) ⟶ (PicScheme C).left) → ℤ :=
  fun lambda =>
    if h : lambda ≫ (PicScheme C).hom = 𝟙 (Spec (.of k)) then
      degreeOfSectionPinned C lambda h
    else 0