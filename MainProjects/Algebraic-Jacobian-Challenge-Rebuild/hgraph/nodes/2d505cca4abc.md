---
author: sync
content_type: theorem
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.isOpenImmersion_presheaf_restrictChart
docstring: '**The composition half of the `hf` certificate**: a restriction of an
  open immersion of

  presheaves along an open immersion is again one.


  `IsOpenImmersion.presheaf` is `MorphismProperty.relative` at `yoneda`, which is
  stable under

  composition (`MorphismProperty.relative_isStableUnderComposition`, needing `yoneda`
  full and

  faithful and `IsOpenImmersion` stable under composition — all instances).  Together
  with

  `isOpenImmersion_presheaf_yoneda_map` this discharges, for free and in full generality,
  the

  part of C9b that is bookkeeping.


  What it does NOT discharge, and what is therefore the whole remaining content of
  C9b: the

  hypothesis `hfV`.  For `f := abelSigmaChart` that hypothesis is FALSE for `V = ⊤`
  and is

  expected to be true for `V = chartLocus` — it is CHART-U(c), whose proof needs the

  uniqueness of the normalized effective representative (DAT-C GAP-2) and the classifier.  A

  lane must not read this lemma as reducing C9b to plumbing; it isolates the plumbing
  so the

  mathematics is visible.'
file: AlgebraicJacobian/Picard/Pic0ChartPair.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isOpenImmersion_presheaf_restrictChart
type: lean
updated: '2026-07-31T20:15:27'
---
theorem isOpenImmersion_presheaf_restrictChart {X : Scheme.{u}}
    {f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1} (V : X.Opens)
    (hfV : IsOpenImmersion.presheaf f) :
    IsOpenImmersion.presheaf (restrictChart f V) :=
  MorphismProperty.IsStableUnderComposition.comp_mem _ _
    (isOpenImmersion_presheaf_yoneda_map V.ι) hfV

/-! ## CHART-U(c): the remaining obligation, pinned

With the composition half discharged, `hf` for a restricted Abel chart reduces to a single
statement.  It is pinned here as a definition so that the gate has a name in Lean and not
only in a worksheet — the pattern `Pic0ChartLocusIsOpen.IsChartDatumPresentation` uses.

**Its field-level input is available.**  DAT-C GAP-2 (Σ-UNIQ-fld) is *landed*:
`Scheme.CurveDivisor.eq_of_picClass_eq_of_h0_one`
(`RiemannRoch/EffectiveUniqueness.lean:144`) — for effective `D`, `D'` with equal Čech class
and `h⁰(𝒪(D)) = 1`, `D' = D`.  (The `w4-datc` §0.3 GAP-2 row claimed no such lemma existed;
that claim was stale and is corrected there as of 2026-07-28.)  What CHART-U(c) still needs
beyond it is the *relative* statement — uniqueness in families over the locus — plus the
classifier `divRepClassifyZar`. -/

variable (C π n) in