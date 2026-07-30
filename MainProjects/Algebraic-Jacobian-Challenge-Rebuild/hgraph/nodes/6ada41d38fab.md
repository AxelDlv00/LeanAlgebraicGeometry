---
author: sync
content_type: definition
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.IsChartUniv
docstring: '**CHART-U(c), pinned**: the chart map is an open immersion of presheaves
  after restriction

  to the locus where the fibre class has a unique effective representative.


  This is the whole remaining content of C9b''s `hf`.  Stated as a `Prop`-valued definition

  rather than proved, because its proof needs the *relative* form of GAP-2 over `chartLocus`

  together with `divRepClassifyZar`; a lane that discharges it gets `hf` by feeding
  it to

  `isOpenImmersion_presheaf_restrictChart`.


  Deliberately stated about `abelSigmaChart` and a *given* open `V`, rather than about

  `chartLocus` directly: the openness of `chartLocus` is a separate obligation

  (`Pic0ChartLocusIsOpen`), and keeping the two apart means neither has to wait for
  the

  other.'
file: AlgebraicJacobian/Picard/Pic0ChartPair.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.IsChartUniv
type: lean
updated: '2026-07-30T15:28:00'
---
def IsChartUniv {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (V : D.left.Opens) : Prop :=
  IsOpenImmersion.presheaf (restrictChart (abelSigmaChart C π n rep m Z hdeg) V)