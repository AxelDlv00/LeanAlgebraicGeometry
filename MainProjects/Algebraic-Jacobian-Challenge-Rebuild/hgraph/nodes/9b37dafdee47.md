---
author: sync
content_type: lemma
created: '2026-07-31T00:08:48'
decl: AlgebraicGeometry.sigmaComponent_abelSigmaChartZero
docstring: '**The Σ-component of the terminal chart''s value is the point itself.**


  `abelSigmaChart` sends `v` to the Σ-element with structure morphism `v ≫ D.hom`

  (`toSigmaExtension_app_fst`), and at parameter `0` the representing object is

  `Over.mk (𝟙 (Spec k))`, so `D.hom` is the identity.  Hence reading off the Σ-component

  recovers `v` on the nose — no transport, no naturality.


  Everything in this section is this lemma read in one of two directions.'
file: AlgebraicJacobian/Picard/Pic0ChartSeamPairDecided.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.sigmaComponent_abelSigmaChartZero
type: lean
updated: '2026-07-31T20:15:27'
---
lemma sigmaComponent_abelSigmaChartZero (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - ((0 : ℕ) : ℤ))
    (T : Scheme.{u}) (v : T ⟶ (Over.mk (𝟙 (Spec (CommRingCat.of k)))).left) :
    ((abelSigmaChartZero (C := C) (pi := pi) m Z hdeg).app (op T) v).1 = v := by
  change v ≫ 𝟙 _ = v
  rw [Category.comp_id]

omit [GeometricallyReduced C.hom] in
variable (C pi) in
/-- **ANTECEDENT 1'S ELEMENTWISE CONTENT IS UNCONDITIONAL AT THIS CHART**: the terminal chart
is injective on points at every test, with no hypothesis whatsoever.

**Not new content, and the docstring should say so.**  This is the parameter-`0` instance of a
landed arbitrary-`n` lemma in this file's own import closure:
`injective_abelSigmaChart_of_subsingleton rep m Z hdeg divFunctorObjSubsingleton_zero T`
typechecks as a direct replacement for the proof below.  The direct proof is kept because it
exhibits the *reason* — the Σ-component is the point — which is what the rest of this section
consumes; the credit for the fact belongs upstream.

Two points a lane must not misread.

* This is **not** the `V = ⊥` degeneracy of `isChartUniv_bot`
  (`Pic0ChartRestrictedFibreSat`) — but **an earlier version of this bullet gave the wrong
  reason**, and the wrong reason matters because it would send a lane looking in the wrong
  place.  It said the distinction is that "here the source is `Spec k`, not the empty scheme".
  That is not it: `isOpenImmersion_presheaf_restrictChart_bot` applies to *this* chart too, so
  the bot degeneracy is available at this source as well.  The real distinction is the **value
  of `V`**: the bot lemmas give antecedent 1 at `V = ⊥`, where by `isChartUniv_antitone`
  (`Pic0ChartVMonotone`) it is *easiest*, and coverage is refuted; what is new here is
  antecedent 1 at `V = ⊤`, unconditionally, where antitonicity makes it *hardest*.
  Antitonicity therefore cannot derive this from the bot results — it runs the other way.
* It is also not in tension with `Pic0ChartForkNegativeBranch`'s refutation of chart-map
  injectivity.  That refutation is at a chart of degree `n` with two distinct effective
  divisors in one class, which needs `2 ≤ h⁰`; at parameter `0` the functor value is a
  singleton (`instSubsingletonDivFamZarSectionZero`), so there is no pair to separate.  The
  fork's negative branch and this lemma live at different parameters, and the fork's own
  hypothesis `2 ≤ Sheaf.h0` is what keeps them apart. -/
-- RENAMED by pic-g (0096 r3), not by this file's author, to unbreak the ROOT build.
-- This theorem was declared here as `injective_abelSigmaChartZero`, which
-- `Pic0ChartMonoUnconditional.lean:82` had already taken for the SAME statement nine hours
-- earlier by a different route (via `injective_abelSigmaChart_of_subsingleton`).  Neither file
-- imports the other, so each compiled alone and the clash appeared only in the root's import
-- closure -- `AlgebraicJacobian.lean` failed with "environment already contains".  The suffix
-- names the route used below: the Σ-component of the chart value IS the point.  Nothing else
-- changed, and no external declaration referenced the old name.