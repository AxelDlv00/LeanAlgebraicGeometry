/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartRestrictedFibreSat

/-!
# Coverage at a PROPER `V` forces non-injectivity — so the `abel-noninj` fork is not a
question about the carve

`Picard/Pic0ChartRestrictedFibreSat.lean` refutes both endpoints of the `V`-interval of
`pic0RepresentableByOfCharts` and leaves one question: *is the pair (`huniv V`, `hcov V`)
inhabited at any `V`?*  Its `⊤`-end refutation
(`not_restrictedChartFibre_top_of_not_injective`) is **conditional** on the Abel chart failing
to be injective — the `abel-noninj` fork, which three file headers assert and no declaration
proves.  That row prices the fork as a question about the *carve*: does `DivScheme g` contain
points where `H¹` fails to vanish?

**The fork is also answered from the other side, by coverage, with no geometry at all.**  This
file proves it.

## The argument, and it has no divisor content

Let `f : yoneda.obj X ⟶ pic0SigmaSheaf C` be *any* map of big-site presheaves and `V ⊆ X` an
open with `V ≠ ⊤`.  Suppose the restricted family `restrictChart f V` satisfies
`PointwiseCoverage` (`Picard/Pic0ChartAtlasCoupling.lean:104`) — the datum antecedent 2 is
reduced to.  Instantiate coverage at

* the test `X` itself,
* the *tautological* section `f.app (op X) (𝟙 X)`,
* a point `t ∈ X \ V`, which exists because `V ≠ ⊤`.

Coverage returns an open `W ∋ t` and a point `x : ↑W ⟶ ↑V` whose restricted chart value is the
tautological section restricted to `W`.  Unfolding `restrictChart` (which is `rfl`) and the
naturality of `f` at `W.ι`, that equation reads

```
f.app (op ↑W) (x ≫ V.ι) = f.app (op ↑W) (W.ι)
```

and the two arguments are **different**: at the point `t` the left one lands inside `V` and the
right one is `t ∉ V`.  So `f.app (op ↑W)` is not injective.

Two things are worth noting about what that proof does *not* use.  It never looks at the
divisor scheme, the chart index, the twist, `rep`, or `pic⁰` — only that the coverage witness
factors through `V` while the tautological section does not.  And it is the *same* mechanism as
`not_coverageContainment_bot` (`Pic0ChartRestrictedFibreSat.lean:257`) pushed from `⊥` to an
arbitrary proper open: there the containment was refuted outright because `⊥` has no points;
here it is not refuted, it *costs* non-injectivity.

## What this decides, stated as a dichotomy

For a **one-chart** atlas, exactly one of the following holds:

* the Abel chart is non-injective on some test — the fork's negative branch.  Then `V = ⊤` is
  dead (`not_restrictedChartFibre_top_of_not_injective`) and, by
  `restrictedChartFibre_top_iff`, `IsChartLocusFibre` is dead with it;
* the Abel chart is injective on every test — the fork's positive branch, which the
  `abel-noninj` row's re-pricing (2) argues for at `n = g`.  Then coverage **fails at every
  proper `V`** (`not_pointwiseCoverage_of_injective_of_ne_top`), and since coverage also fails
  at `⊥` (`not_coverageContainment_bot`), the only `V` at which the seam can close is `⊤`.

So the fork and the `V`-interval are one question, not two: "any working `V` is a proper
intermediate open" (`chart-restrict`'s headline conclusion) is *equivalent* to the fork's
negative branch, rather than independent of it.  A lane cannot pick the restriction repair and
stay agnostic about the fork.

## The honest limits, stated rather than left for a reviewer

* **Nothing here is discharged.**  `PointwiseCoverage` at a proper `V` is a hypothesis with no
  producer — it is exactly the open question `chart-restrict` names — and so is its negation.
  Every theorem below is an implication between two open propositions.  What is new is that
  they are *linked*.
* **The argument is per-chart, and a multi-index atlas can evade it.**  Coverage at a general
  family returns *some* index `i`, not the index whose tautological section was tested; if
  `i ≠ i₀` the two chart values live on different sources and no non-injectivity of a single
  map follows.  So the dichotomy above is for a one-chart atlas — which is what
  `Pic0AtlasFromDivRep.lean` builds and what `IsChartUniv`, `RestrictedChartFibre` and
  `restrictedChartFibre_top_iff` are all stated for — and **not** for `mixedParamChart` at
  arbitrary `ι`.  The multi-index case is open and is *not* claimed here.
* **The conclusion is not free.**  A map into the Σ-sheaf that *is* injective on every test
  exists and is landed: `restrictChart f ⊥` for any `f`, by
  `isOpenImmersion_presheaf_restrictChart_bot` composed with the criterion's necessary
  direction.  That is `exists_injective_into_pic0Sigma` below, and it rules out the failure
  mode where "some test where the map is not injective" were provable for every `f`.

## Main declarations

* `AlgebraicGeometry.chart_map_ι_apply` — naturality of a chart map at an opens inclusion,
  elementwise, named because three proofs below use it.
* `AlgebraicGeometry.not_injective_of_pointwiseCoverage_of_ne_top` — **the step**: coverage for
  the family restricted to a proper `V` gives a test on which the *unrestricted* map fails to
  be injective.  Arbitrary presheaf map; no divisor content.
* `AlgebraicGeometry.not_pointwiseCoverage_of_injective_of_ne_top` — the contrapositive, which
  is the form the fork's positive branch reads: injectivity confines coverage to `V = ⊤`.
* `AlgebraicGeometry.not_restrictedChartFibre_top_of_pointwiseCoverage_of_ne_top` and
  `AlgebraicGeometry.not_isChartLocusFibre_of_pointwiseCoverage_of_ne_top` — the compositions
  at the Abel chart: coverage at a proper `V` kills the `⊤` end and the old route with it.
* `AlgebraicGeometry.exists_injective_into_pic0Sigma` — the non-vacuity check.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π] {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

noncomputable section

/-! ## The naturality step, named -/

/-- **A chart map read at an opens inclusion.**

`f.app` at the open `W` applied to `W.ι ≫ u` is the restriction along `W.ι` of `f.app` at the
whole scheme applied to `u`.  This is `NatTrans.naturality_apply` at `(W.ι).op`, with the
`yoneda`-side map being precomposition.

Named rather than inlined because all three refutations below consume it, and because the
`yoneda`-side unfolding is the only thing that has to be got right: an attempt to use the
Σ-sheaf's own restriction on the wrong side does not typecheck. -/
theorem chart_map_ι_apply {X : Scheme.{u}}
    (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) (W : X.Opens) (u : X ⟶ X) :
    (pic0SigmaSheaf C).1.map (W.ι).op (f.app (op X) u)
      = f.app (op (W : Scheme.{u})) (W.ι ≫ u) :=
  (NatTrans.naturality_apply f (W.ι).op u).symm

/-! ## The step -/

variable (C) in
/-- **COVERAGE AT A PROPER `V` FORCES NON-INJECTIVITY OF THE UNRESTRICTED MAP.**

For an arbitrary map of big-site presheaves `f : yoneda.obj X ⟶ pic0SigmaSheaf C` and an open
`V ≠ ⊤`: if the one-chart family `restrictChart f V` satisfies `PointwiseCoverage`, then `f`
fails to be injective on some test.

The proof is the tautological section at the test `X`, read at a point outside `V`; see the
module docstring.  No divisor, no chart index, no `rep`, no `pic⁰` fact is used — only that a
coverage witness factors through `V` and the identity does not.

Note the hypothesis is coverage for the family *restricted to `V`*, which is what the seam
consumes at a restricted atlas (`Pic0ChartAtlasCoupling.liftPointwiseToOpens`), not
unrestricted coverage. -/
theorem not_injective_of_pointwiseCoverage_of_ne_top
    {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) (V : X.Opens)
    (hV : V ≠ ⊤)
    (hcov : PointwiseCoverage C (fun _ : PUnit.{u+1} => restrictChart f V)) :
    ∃ T : Scheme.{u}ᵒᵖ, ¬ Function.Injective (f.app T) := by
  -- `V ≠ ⊤` gives a point of `X` outside `V`
  obtain ⟨t, htV⟩ : ∃ t : X, t ∉ V := by
    by_contra h
    exact hV (top_le_iff.mp fun t _ => not_not.mp fun ht => h ⟨t, ht⟩)
  obtain ⟨W, htW, iu, x, hx⟩ := hcov X (f.app (op X) (𝟙 X)) t
  refine ⟨op (W : Scheme.{u}), fun hinj => ?_⟩
  -- the coverage witness and the identity have the same chart value over `W`
  have hxv : f.app (op (W : Scheme.{u})) (x ≫ V.ι)
      = f.app (op (W : Scheme.{u})) (W.ι ≫ 𝟙 X) := by
    rw [← chart_map_ι_apply f W (𝟙 X)]
    exact hx
  have heq := hinj hxv
  -- but they disagree at `t`: the witness lands in `V` and `t` does not
  have hpt : ((x ≫ V.ι).base ⟨t, htW⟩ : X) = ((W.ι ≫ 𝟙 X).base ⟨t, htW⟩ : X) := by
    rw [heq]
  have hmem : ((x ≫ V.ι).base ⟨t, htW⟩ : X) ∈ V := (x.base ⟨t, htW⟩).2
  rw [hpt] at hmem
  exact htV (by simpa using hmem)

variable (C) in
/-- **The contrapositive: injectivity confines coverage to `V = ⊤`.**

If a chart map is injective on every test, then no proper open supports coverage for its
restriction.  Read with `not_coverageContainment_bot` — which refutes the containment at `⊥` —
this says an injective chart leaves exactly one candidate value of `V`, namely `⊤`.

This is the form the fork's *positive* branch reads, and the reason this file's finding is not
one-sided: the branch that the `abel-noninj` row argues for (uniqueness of the degree-`g`
representative, hence injectivity) is the branch that kills the restriction apparatus. -/
theorem not_pointwiseCoverage_of_injective_of_ne_top
    {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) (V : X.Opens)
    (hV : V ≠ ⊤) (hinj : ∀ T : Scheme.{u}ᵒᵖ, Function.Injective (f.app T)) :
    ¬ PointwiseCoverage C (fun _ : PUnit.{u+1} => restrictChart f V) := by
  intro hcov
  obtain ⟨T, hT⟩ := not_injective_of_pointwiseCoverage_of_ne_top C f V hV hcov
  exact hT (hinj T)

/-! ## The compositions at the Abel chart

The two theorems above are about an arbitrary presheaf map.  Instantiated at `abelSigmaChart`
they close the `⊤` end of the `V`-interval *unconditionally on the fork*, which is what makes
the fork and the interval one question. -/

variable (C π n) in
/-- **Coverage at a proper `V` kills the `⊤` end.**

`not_restrictedChartFibre_top_of_not_injective` (`Pic0ChartRestrictedFibreSat.lean:381`) needs
a test on which the Abel chart is not injective, and says so conditionally — the `abel-noninj`
fork.  Coverage at any proper `V` *supplies* that test, by
`not_injective_of_pointwiseCoverage_of_ne_top`.

So a lane holding coverage at a proper `V` does not have to decide the fork to know that
`V = ⊤` is dead: coverage decides it. -/
theorem not_restrictedChartFibre_top_of_pointwiseCoverage_of_ne_top
    {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (V : D.left.Opens) (hV : V ≠ ⊤)
    (hcov : PointwiseCoverage C
      (fun _ : PUnit.{u+1} => restrictChart (abelSigmaChart C π n rep m Z hdeg) V)) :
    ¬ RestrictedChartFibre C π n rep m Z hdeg ⊤ := by
  obtain ⟨T, hT⟩ := not_injective_of_pointwiseCoverage_of_ne_top C
    (abelSigmaChart C π n rep m Z hdeg) V hV hcov
  exact not_restrictedChartFibre_top_of_not_injective rep m Z hdeg T hT

variable (C π n) in
/-- **Coverage at a proper `V` kills `IsChartLocusFibre`** — the old route to antecedent 1.

Composite of the previous theorem with `restrictedChartFibre_top_iff`
(`Pic0ChartRestrictedFibreSat.lean:355`), which identifies `IsChartLocusFibre` with the `⊤`
instance of the restricted class.

This is the sharp statement of the finding: the guard
`not_isChartLocusFibre_of_not_injective` was waiting on two divisors in one linear system, and
coverage at a proper open produces the same conclusion with no divisor at all. -/
theorem not_isChartLocusFibre_of_pointwiseCoverage_of_ne_top
    {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (V : D.left.Opens) (hV : V ≠ ⊤)
    (hcov : PointwiseCoverage C
      (fun _ : PUnit.{u+1} => restrictChart (abelSigmaChart C π n rep m Z hdeg) V)) :
    ¬ IsChartLocusFibre C π n rep m Z hdeg := fun h =>
  not_restrictedChartFibre_top_of_pointwiseCoverage_of_ne_top C π n rep m Z hdeg V hV hcov
    ((restrictedChartFibre_top_iff C π n rep m Z hdeg).mpr h)

/-! ## Non-vacuity: the conclusion is not free

`not_injective_of_pointwiseCoverage_of_ne_top` concludes "some test where `f` is not
injective".  If that conclusion held for *every* map into the Σ-sheaf, the theorem would carry
no information.  It does not. -/

variable (C) in
/-- **A map into the Σ-sheaf that IS injective on every test exists.**

Take `restrictChart f ⊥` for any `f`: it is an open immersion of presheaves
(`isOpenImmersion_presheaf_restrictChart_bot`), hence injective on every test by the
criterion's necessary direction.

So the conclusion of `not_injective_of_pointwiseCoverage_of_ne_top` is a genuine constraint on
`f` and `V` rather than a fact about the Σ-sheaf, and the theorem is not vacuously informative.

Read as a caution rather than as a route: the witness is the `⊥` restriction, where coverage is
refuted outright (`not_coverageContainment_bot`) — so it is exactly *not* a counterexample to
the theorem, which is the point of exhibiting it. -/
theorem exists_injective_into_pic0Sigma {X : Scheme.{u}}
    (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) :
    ∀ T : Scheme.{u}ᵒᵖ,
      Function.Injective ((restrictChart f (⊥ : X.Opens)).app T) :=
  fun T => injective_of_isOpenImmersion_presheaf
    (isOpenImmersion_presheaf_restrictChart_bot C f) T

end

end AlgebraicGeometry
