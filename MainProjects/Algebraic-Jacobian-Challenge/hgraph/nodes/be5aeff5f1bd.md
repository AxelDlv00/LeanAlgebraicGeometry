---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.ProjTwist.overlapRingHom
docstring: 'The ring homomorphism carrying degree-zero fractions over `XᵢXⱼ` to

  sections of the structure sheaf on the scheme-theoretic overlap.'
file: AlgebraicJacobian/Picard/SerreTwist.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjTwist.overlapRingHom
type: lean
updated: '2026-07-24T03:02:12'
---
def overlapRingHom (i j : n) :
    Away (homogeneousSubmodule n (ULift.{u} ℤ)) (X i * X j) →+*
      Γ(pullback ((basicOpenCover n).f i) ((basicOpenCover n).f j), ⊤) :=
  ((overlapHom n i j).appTop.hom.comp
    ((Proj.basicOpen (homogeneousSubmodule n (ULift.{u} ℤ))
      (X i * X j)).topIso.inv.hom)).comp
    (Proj.awayToSection (homogeneousSubmodule n (ULift.{u} ℤ)) (X i * X j)).hom