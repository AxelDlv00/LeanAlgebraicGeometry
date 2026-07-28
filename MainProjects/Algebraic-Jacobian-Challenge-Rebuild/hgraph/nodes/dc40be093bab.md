---
author: sync
content_type: theorem
created: '2026-07-29T06:51:20'
decl: AlgebraicGeometry.isChartDatumPlusFibreAt_self
docstring: '**`IsChartDatumPlusFibreAt` at `L := κ(t)` IS `IsChartDatumPlusFibre`
  at `t`** — by

  `Iff.rfl`, so the generalisation in `L` is a genuine generalisation of the *same*
  equation and

  not a different statement that happens to specialise.


  This is the non-vacuity check for `hplus` below, and it is the sharp one: it shows
  the extra

  strength of `hplus` over `hfib` is exactly "the same identity at every extension",
  so a lane

  reading `hplus` knows precisely what it owes beyond `hfib` — the naturality of `cechPicClass`

  along `κ(t) → L`, and nothing else.'
file: AlgebraicJacobian/Picard/Pic0ChartPresentationConverse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isChartDatumPlusFibreAt_self
type: lean
updated: '2026-07-29T06:51:20'
---
theorem isChartDatumPlusFibreAt_self {A : Type u} [CommRing A] [Algebra k A]
    (μ : picEt C (overSpec k A)) (D : BasicOpenCocycleDatum C A π)
    (t : (overSpec k A).left) (h : IsChartDatumPlusFibre C π μ D) :
    IsChartDatumPlusFibreAt C π μ D t (Over.testPointField (T := overSpec k A) t) :=
  h t

/-! ## CHART-U(b)'s residue, assembled -/

variable (C π) in