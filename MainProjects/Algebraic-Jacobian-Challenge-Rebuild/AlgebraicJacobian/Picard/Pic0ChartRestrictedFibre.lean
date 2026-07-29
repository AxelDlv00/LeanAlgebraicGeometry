/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartUnivReduce
import AlgebraicJacobian.Picard.Pic0ChartAtlasParamFree
import AlgebraicJacobian.Picard.Pic0ChartAtlasCoupling
import AlgebraicJacobian.Picard.Pic0ChartLocusFibreGuard

/-!
# The fibre criterion at the RESTRICTED chart, and the `V`-coupling to coverage

`Picard/Pic0ChartUnivReduce.lean` reduces `IsChartUniv` — antecedent 1 of
`pic0RepresentableByOfCharts` — to `IsChartLocusFibre`.  **That reduction passes through the
unrestricted certificate, which the project's headers assert to be false**, and this file is
the repair.

## The defect, measured

`IsChartLocusFibre` (`Pic0ChartUnivReduce.lean:152`) asks for a
`ChartFibrePresented C (abelSigmaChart …) g` at every test — the datum for the *unrestricted*
chart, with `W` a free structure field.  Nothing pins `W := chartLocus`, although the docstring
there says the `W` field "is already discharged — it is `chartLocus`".  So the open `V` never
enters the hypothesis, and one term gives back the unrestricted certificate:

```
isOpenImmersion_presheaf_of_chartFibrePresented _ fun T g => (h T g).some
  : IsOpenImmersion.presheaf (abelSigmaChart …)
```

That measurement is **not** repeated here: it is landed as
`isOpenImmersion_presheaf_abelSigmaChart_of_isChartLocusFibre` and
`mono_abelSigmaChart_of_isChartLocusFibre` in `Picard/Pic0ChartLocusFibreGuard.lean`, together
with `not_isChartLocusFibre_of_not_injective` — the criterion's own emptiness guard, finally
instantiated at the Abel chart.  In `isChartUniv_of_isChartLocusFibre` the restriction to `V` is
applied *after* the unrestricted certificate is in hand, so restricting buys nothing on the way
in.

**The precise status of "false".**  `Pic0AtlasFromDivRep.lean:54`, `Pic0ChartPair.lean:14` and
`Pic0ChartOpenImmersionCriterion.lean:214` all assert that the Abel chart is not injective (the
linear system `|D|`), and by the guard above that assertion makes `IsChartLocusFibre`
unsatisfiable.  But **no declaration proves the non-injectivity**: the guard takes
`¬ Function.Injective` as a hypothesis.  So `IsChartLocusFibre` is *conditionally* unsatisfiable
— dead if the headers are right, and nobody has shown they are.  This file therefore does not
claim the old route is dead; it claims the old route is gated on a proposition the project
believes false and has never checked, which is reason enough not to build on it.

The criterion itself is **not** at fault: it is stated for an arbitrary morphism of presheaves
and is correct.  What was wrong is the *instantiation* — at `abelSigmaChart` rather than at
`restrictChart (abelSigmaChart …) V`.

## What this file provides

* `RestrictedChartFibre` — the same datum demanded at the **restricted** chart, so
  `exists_factor` only has to factor test points *of `V`*.
* `isChartUniv_of_restrictedChartFibre` — it gives `IsChartUniv` at that same `V`, one
  application of the existing criterion, with no unrestricted certificate in between.
* `necessity_of_restrictedChartFibre` — the weakening did not delete the content: the restricted
  datum still forces injectivity of the restricted chart on every test.
* `pic0RepresentableBy_of_restrictedChartFibre` — **the `V`-coupled assembly** (inbox `I-0861`):
  per-index restricted fibre data on the `hf` side, and on the coverage side the containment
  hypothesis `hV` of `Pic0ChartAtlasCoupling.liftPointwiseToOpens`, together give the
  representation.  The two sides are made to share the same `V` by typing.

## Division of labour with the two sibling files landed the same round

`Pic0ChartLocusFibreGuard.lean` records why the *old* route must not be used, and
`Pic0ChartAtlasCoupling.lean` supplies the **coverage** half of the `V`-coupling
(`liftPointwiseToOpens`, and the converse `pointwise_of_pointwise_restrictChart` showing `hV` is
exactly the gap).  This file supplies the **`hf`** half — the fibre datum at the restricted
chart — and the assembly that consumes both.  Nothing here re-proves either sibling.

## The honest limits, stated rather than left for a reviewer

* **Nothing here produces any input.**  This file replaces a badly-gated route by a
  well-gated one; it discharges no antecedent.  `rep` (divisor representability) is a hypothesis
  throughout, and `IsChartUniv` is not even statable without it.
* **`RestrictedChartFibre` at `V = ⊥` is cheap** — no nonempty test has a point of the empty
  open subscheme, so the injectivity content vanishes there (measured in `I-0861`).  It is
  therefore not a self-standing certificate: it carries content only against a coverage
  hypothesis reaching the same `V`, which is why the assembly takes both and why they are not
  offered separately.
* **The weakening is not verified to be strict.**  A transport
  `IsChartLocusFibre → RestrictedChartFibre` at every `V` is *not* proved here: it needs the
  preimage `r ⁻¹ V` pushed forward along the open immersion `W.ι`, which is real work and buys
  nothing (a lane holding the old form already gets `IsChartUniv` directly).  So this file does
  not certify that `RestrictedChartFibre` is *strictly* weaker — only that it is weaker in the
  way that matters, namely that it does not entail the unrestricted certificate.
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

/-! ## The datum at the restricted chart -/

variable (C π n) in
/-- **The fibre datum demanded at the restricted chart** — the repair of `IsChartLocusFibre`.

Identical to `IsChartLocusFibre` except that the presented morphism is
`restrictChart (abelSigmaChart …) V` rather than `abelSigmaChart …`.  The difference is the
whole point: `exists_factor` now only factors test points *of `V`*, so proving it does not
entail that the unrestricted Abel chart is a monomorphism.

`V` is a parameter and no choice is privileged here; the intended instantiation is the chart
locus, whose openness is CHART-U(b) and a separate obligation. -/
def RestrictedChartFibre {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (V : D.left.Opens) : Prop :=
  ∀ (T : Scheme.{u}) (g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1),
    Nonempty (ChartFibrePresented C
      (restrictChart (abelSigmaChart C π n rep m Z hdeg) V) g)

/-- **The repaired reduction**: the restricted datum gives `IsChartUniv` at the same `V`.

One application of the existing criterion, at the restricted chart.  Compare
`isChartUniv_of_isChartLocusFibre`, which applies it at the unrestricted chart and composes
afterwards — and therefore needs the unrestricted certificate on the way in. -/
theorem isChartUniv_of_restrictedChartFibre {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (V : D.left.Opens) (h : RestrictedChartFibre C π n rep m Z hdeg V) :
    IsChartUniv C π n rep m Z hdeg V :=
  isOpenImmersion_presheaf_of_chartFibrePresented _ fun T g => (h T g).some

/-- **The content was relocated, not deleted**: the restricted datum still forces the
restricted chart to be injective on every test.

This is what keeps the weakening honest — the relative form of DAT-C GAP-2 is still required,
over `V` instead of over `D.left`.  At `V = ⊥` the statement is vacuous, which is the limit
recorded in the module docstring. -/
theorem necessity_of_restrictedChartFibre {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (V : D.left.Opens) (h : RestrictedChartFibre C π n rep m Z hdeg V)
    (T : Scheme.{u}ᵒᵖ) :
    Function.Injective
      ((restrictChart (abelSigmaChart C π n rep m Z hdeg) V).app T) :=
  injective_of_chartFibrePresented _ (fun T' g => (h T' g).some) T

/-! ## The `V`-coupled assembly -/

variable (C π) in
/-- The `hf` clause of a mixed-parameter atlas, from per-index restricted fibre data.

Named because the representing object of the assembly below mentions it. -/
theorem mixedParamHf {ι : Type u} (nn : ι → ℕ)
    (D : ι → Over (Spec (.of k)))
    (rep : ∀ i, (divFunctor C π (nn i)).RepresentableBy (D i))
    (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i)
      = (m i : ℤ) * classDeg k (thetaCechClass C) - (nn i : ℤ))
    (V : ∀ i, (D i).left.Opens)
    (huniv : ∀ i, RestrictedChartFibre C π (nn i) (rep i) (m i) (Z i) (hdeg i) (V i))
    (i : ι) :
    IsOpenImmersion.presheaf (mixedParamChart C π nn D rep m Z hdeg V i) :=
  isChartUniv_of_restrictedChartFibre (rep i) (m i) (Z i) (hdeg i) (V i) (huniv i)

variable (C π) in
/-- **THE `V`-COUPLED ASSEMBLY** — the composition inbox `I-0861` names as missing.

Antecedents 1 and 2 of `pic0RepresentableByOfCharts` are *not* independent.  Coverage produces a
point `x : (W : Scheme) ⟶ X i` of the chart **source**, which for the real atlas is
`(V i : Scheme)` — so coverage has to reach the very `V i` at which `hf` was certified, and no
statement in the tree said so.  Here they are forced to share `V` by typing: `huniv` certifies
the charts at `V`, and `hcov`'s witness lands in the same `V i`.

**This closes no gate.**  `rep`, `huniv` and `hcov` are all hypotheses and none has a producer.
What the statement buys is that a lane discharging `hf` and a lane discharging coverage can no
longer each succeed at a *different* `V` and report the pair as composed. -/
def pic0RepresentableBy_of_restrictedChartFibre {ι : Type u} (nn : ι → ℕ)
    (D : ι → Over (Spec (.of k)))
    (rep : ∀ i, (divFunctor C π (nn i)).RepresentableBy (D i))
    (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i)
      = (m i : ℤ) * classDeg k (thetaCechClass C) - (nn i : ℤ))
    (V : ∀ i, (D i).left.Opens)
    (huniv : ∀ i, RestrictedChartFibre C π (nn i) (rep i) (m i) (Z i) (hdeg i) (V i))
    (hcov : ∀ (T : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op T)) (t : ↥T),
      ∃ (W : T.Opens) (_ : t ∈ W) (i : ι)
        (x : (W : Scheme.{u}) ⟶ (D i).left),
        (abelSigmaChart C π (nn i) (rep i) (m i) (Z i) (hdeg i)).app
            (op (W : Scheme.{u})) x
          = (pic0SigmaSheaf C).1.map (W.ι).op s ∧
        Set.range (x.base) ⊆ Set.range ((V i).ι.base)) :
    Σ J : Over (Spec (.of k)), (pic0TypeFunctor C).RepresentableBy J :=
  letI : Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc (mixedParamChart C π nn D rep m Z hdeg V)) :=
    isLocallySurjective_restrictChart_of_pointwise C
      (fun i => abelSigmaChart C π (nn i) (rep i) (m i) (Z i) (hdeg i)) V hcov
  ⟨_, pic0RepresentableByOfCharts C (mixedParamChart C π nn D rep m Z hdeg V)
    (mixedParamHf C π nn D rep m Z hdeg V huniv)⟩

end

end AlgebraicGeometry
