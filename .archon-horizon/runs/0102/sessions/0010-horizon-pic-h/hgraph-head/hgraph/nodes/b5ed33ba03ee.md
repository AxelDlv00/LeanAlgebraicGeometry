---
author: sync
content_type: definition
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.restrictChart
docstring: '**The chart map restricted to an open of its source.**


  `f` is the unrestricted chart map (in practice `abelSigmaChart`, whose source is
  the divisor

  scheme) and `V` an open subscheme of the source; the restriction is the composition
  with the

  yoneda image of the open inclusion.


  The point of restricting is that the unrestricted Abel map is *not* an open immersion
  of

  presheaves — see the `Pic0AtlasFromDivRep` header — while its restriction to the
  locus where

  the fibre is a single point is.  This definition is neutral about which open `V`
  is; the

  chart-locus choice enters only in the certificate.'
file: AlgebraicJacobian/Picard/Pic0ChartPair.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.restrictChart
type: lean
updated: '2026-08-01T09:44:16'
---
def restrictChart {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (V : X.Opens) : yoneda.obj (V : Scheme.{u}) ⟶ (pic0SigmaSheaf C).1 :=
  yoneda.map V.ι ≫ f