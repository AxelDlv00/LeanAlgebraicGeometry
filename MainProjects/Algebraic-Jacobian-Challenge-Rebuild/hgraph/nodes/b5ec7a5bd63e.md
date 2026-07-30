---
author: sync
content_type: definition
created: '2026-07-30T00:56:03'
decl: AlgebraicGeometry.abelDivAffPlus
docstring: '**The Abel transformation of a widened locally certified class at an affine
  test**: the

  étale-unit image of the relative Picard class of `𝒪(F₀)`.


  Verbatim `abelDivPlus` (`Picard/DivSchemeAbel.lean`) with `DivFamZarAff` in place
  of

  `DivFamZar` — the class map `DivFamZarAff.picClass` is all that is consumed, and
  it never saw

  the cover, so no chart typing enters.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffAbel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.abelDivAffPlus
type: lean
updated: '2026-07-30T15:46:03'
---
def abelDivAffPlus (A : Type u) [CommRing A] [Algebra k A] (F₀ : DivFamZarAff C A n) :
    PicEtAff C A :=
  PicEtAff.unit C A (relPicMk C (overSpec k A) F₀.picClass)