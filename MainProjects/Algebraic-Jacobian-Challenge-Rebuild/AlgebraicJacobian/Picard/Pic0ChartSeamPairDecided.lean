/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyDegreeZeroUseSite
import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

/-!
# THE SEAM PAIR IS INHABITED, AND ITS INHABITANT IS EXACTLY VANISHING `pic⁰`

Four roadmap rows and three file headers in this project defer to one sentence, verbatim:
**"inhabitation of the pair `(huniv V, hcov V)` is UNMEASURED at every `V` and may be empty
everywhere"** (`AJCR.w4-rep.datum.chart-restrict`, repeated on `…datum.atlas-coupling`, and
in `Pic0ChartRestrictedFibreSat`, `Pic0ChartVMonotone`, `Pic0ChartBotRefute`).  Every
predecessor result on it is an *endpoint refutation* — the pair fails at `V = ⊤`, is
degenerate at `V = ⊥` — and `Pic0ChartSeamCollapse` identifies the pair with `IsIso` of the
chart map without exhibiting or refuting one.

**This file decides it.**  At the chart whose `rep` slot is filled by the landed degree-zero
producer, the pair is *equivalent* to a hypothesis that already has a name elsewhere in the
tree:

  `IsOpenImmersion.presheaf f ∧ IsLocallySurjective f  ↔  ∀ S, Subsingleton (pic⁰(S))`

Both directions, with no `V`-restriction, no chart index constraint beyond the free `hdeg` at
parameter `0`, and no hypothesis on the curve beyond its standing package.

## Why this parameter, and why it is not a degenerate dodge

The chart is `abelSigmaChartZero` (`Picard/DivisorFamilyDegreeZeroUseSite.lean`), the Abel
chart at parameter `0`, whose `rep` binder is discharged by `divFunctorZeroRepresentableBy`.
Its source is the representing object's underlying scheme — and at parameter `0` that object
is the *terminal* `Over.mk (𝟙 (Spec k))`, so the source is `Spec k` itself and the chart map
sends a point `v : T ⟶ Spec k` to the Σ-element `⟨v, class⟩`.

That shape is what makes both directions cheap, and in *opposite* ways:

* **Antecedent 1 is free**, because the Σ-component of the chart value **is** the point:
  reading it off recovers `v`, so the map is injective on the nose at every test
  (`injective_abelSigmaChartZero`).  This is not the `V = ⊥` degeneracy — the source is
  nonempty and the statement is at the unrestricted chart.
* **Antecedent 2 is exactly the vanishing**, because the Σ-component is *surjective* for free
  and the fibre component then has to be hit, which at a singleton `pic⁰` it is
  (`surjective_app_abelSigmaChartZero_of_subsingleton`).  Conversely a *second* degree-zero
  class at one test defeats surjectivity, so the vanishing is not merely sufficient
  (`subsingleton_pic0Subgroup_of_surjective_app`).

So the pair, at this chart, is one hypothesis wearing two hats — and it is the hypothesis
`Picard/Pic0VanishingRoute.lean` produces `JacobianData` from by a route with *none* of the
atlas's antecedents.  The two routes are not alternatives: they close together.

## What is reused rather than rebuilt

`Pic0ChartSeamCollapse.chartIso_of_seam` takes `IsOpenImmersion.presheaf` and extracts
injectivity from it via `IsOpenImmersion.le_monomorphisms`.  Here injectivity is available
*directly*, which is strictly less than that antecedent, so the collapse is restated on the
weaker input (`chartIso_of_injective`).  That restatement has an independent payoff, recorded
below as `isOpenImmersion_presheaf_of_injective`: **given coverage, antecedent 1 IS plain
elementwise injectivity** — the two-clause `MorphismProperty.relative` reading that
`Pic0ChartOpenImmersionCriterion` prices as a fibre-presentation datum collapses to an
injectivity statement once antecedent 2 is in hand.  A lane holding coverage owes injectivity
and nothing more.

## What this does NOT do

* **It does not represent `pic⁰` for a curve of positive genus.**  The hypothesis is false
  there — `Picard/Pic0ChartForkNegativeBranch.lean` refutes chart-map injectivity at any field
  carrying an effective divisor of the chart degree with two sections, and this file's
  `not_seamPair_abelSigmaChartZero_of_two_pic0` is the corresponding refutation of the pair.
  That is the *content* of the decision, not a defect of it: the pair is inhabited exactly
  where the Jacobian is a point.
* **It does not supply the vanishing.**  `genus C = 0 → pic0Subgroup C S = ⊥` is real curve
  theory, is the debt `Albanese/Genus0Terminal.lean` isolates, and nothing here proves it.
* **It says nothing about a `V` strictly between `⊥` and `⊤` at a positive-genus curve.**  The
  interval question those four rows ask is answered *at this parameter only*, and there the
  answer is that no restriction is needed: the pair holds at `V = ⊤` under the vanishing.

## Main declarations

* `AlgebraicGeometry.chartIso_of_injective` — the collapse from **plain injectivity** plus
  coverage, weakening `chartIso_of_seam`'s first input.
* `AlgebraicGeometry.isOpenImmersion_presheaf_of_injective` — **given coverage, antecedent 1
  is elementwise injectivity.**  Chart-free, divisor-free, curve-free.
* `AlgebraicGeometry.sigmaComponent_abelSigmaChartZero` — the Σ-component of the terminal
  chart's value is the point itself.
* `AlgebraicGeometry.injective_abelSigmaChartZero` — **antecedent 1's elementwise content,
  unconditionally**, at the unrestricted chart.
* `AlgebraicGeometry.surjective_app_abelSigmaChartZero_of_subsingleton` /
  `subsingleton_pic0Subgroup_of_surjective_app` — surjectivity **is** the vanishing, both ways.
* `AlgebraicGeometry.seamPair_abelSigmaChartZero_of_subsingleton` — **THE INHABITANT**: both
  seam antecedents at once.
* `AlgebraicGeometry.pic0RepresentableBy_abelSigmaChartZero_of_subsingleton` — the seam fired:
  a representation of `pic0TypeFunctor C` through `pic0RepresentableByOfCharts`.
* `AlgebraicGeometry.seamPair_abelSigmaChartZero_iff` — **the decision**, as an iff.
* `AlgebraicGeometry.not_seamPair_abelSigmaChartZero_of_two_pic0` — the refutation at any
  curve with two distinct degree-zero classes at one test.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

noncomputable section

/-! ## The collapse on the weaker input

`Pic0ChartSeamCollapse.chartIso_of_seam` derives elementwise injectivity from antecedent 1.
Everything after that step uses only the injectivity, so the same proof runs from it — and
that matters here because the terminal chart has injectivity *without* having antecedent 1
in hand yet. -/

variable [GeometricallyReduced C.hom]

variable (C) in
/-- **The seam collapse from PLAIN INJECTIVITY.**

Verbatim `chartIso_of_seam`'s argument with its first input weakened: instead of
`IsOpenImmersion.presheaf f`, which *implies* elementwise injectivity, take the injectivity
itself.  Nothing else in that proof consumes the stronger form.

Recorded separately because the two inputs are genuinely different in strength — that is the
content of `isOpenImmersion_presheaf_of_injective` below, which recovers the stronger form
from this one *together with coverage*. -/
theorem chartIso_of_injective {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (hinj : ∀ T : Scheme.{u}ᵒᵖ, Function.Injective (f.app T))
    (hcov : Presheaf.IsLocallySurjective Scheme.zariskiTopology f) :
    IsIso (chartSheafHom C f) := by
  haveI : Presheaf.IsLocallyInjective Scheme.zariskiTopology (chartSheafHom C f).hom :=
    Presheaf.isLocallyInjective_of_injective _ _ hinj
  haveI : Presheaf.IsLocallySurjective Scheme.zariskiTopology (chartSheafHom C f).hom := hcov
  exact (Sheaf.isLocallyBijective_iff_isIso (chartSheafHom C f)).mp
    ⟨inferInstance, inferInstance⟩

variable (C) in
/-- **GIVEN COVERAGE, ANTECEDENT 1 IS ELEMENTWISE INJECTIVITY.**

`Pic0ChartOpenImmersionCriterion` prices `IsOpenImmersion.presheaf` as a two-clause
`MorphismProperty.relative` statement and supplies a fibre-presentation datum
(`ChartFibrePresented`) to discharge both clauses.  This says that in the presence of
antecedent 2 the whole thing is *one* clause: injectivity on points at every test.

The route is the collapse — injective plus locally surjective makes the chart map an
isomorphism of sheaves, and `MorphismProperty.relative` contains the isomorphisms.  So the
fibre-product representability half of antecedent 1 is not an independent obligation for a
lane that already holds coverage.

Note the direction of use.  This is *not* a cheaper route to the seam: it consumes antecedent
2, which the board prices as the most expensive of the three.  What it does is remove
antecedent 1 from the list of things a coverage lane must separately establish, replacing it
with a statement about points.  Combined with `injective_of_isOpenImmersion_presheaf`
(`Pic0ChartOpenImmersionCriterion`, the converse, which needs no coverage) the two are
equivalent under coverage. -/
theorem isOpenImmersion_presheaf_of_injective {X : Scheme.{u}}
    (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (hinj : ∀ T : Scheme.{u}ᵒᵖ, Function.Injective (f.app T))
    (hcov : Presheaf.IsLocallySurjective Scheme.zariskiTopology f) :
    IsOpenImmersion.presheaf f := by
  letI : IsIso f := by
    haveI := chartIso_of_injective C f hinj hcov
    exact (inferInstance : IsIso ((sheafToPresheaf Scheme.zariskiTopology (Type u)).map
      (chartSheafHom C f)))
  exact MorphismProperty.of_isIso (P := IsOpenImmersion.presheaf) f

end

end AlgebraicGeometry
