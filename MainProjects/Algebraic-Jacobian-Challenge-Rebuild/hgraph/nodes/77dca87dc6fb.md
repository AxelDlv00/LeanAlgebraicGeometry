---
author: sync
content_type: definition
created: '2026-07-19T15:31:13'
decl: AlgebraicGeometry.abelDivPlus
docstring: 'The Abel transformation at an affine test, plus-construction form: the
  étale-unit

  image of the relative Picard class of `𝒪(F₀)`.'
file: AlgebraicJacobian/Picard/DivSchemeAbel.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.abelDivPlus
type: lean
updated: '2026-07-29T15:26:25'
---
def abelDivPlus (A : Type u) [CommRing A] [Algebra k A] (F₀ : DivFamZar C A π n) :
    PicEtAff C A :=
  PicEtAff.unit C A (relPicMk C (overSpec k A) F₀.picClass)

variable (C π) in