/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartAtlasParamFree
import AlgebraicJacobian.Picard.JacobianDataCharts
import AlgebraicJacobian.Picard.DivSchemeQProj

/-!
# THE FOURTH ANTECEDENT: the chart-finiteness certificate of the real atlas

## Why this file exists

The board, and every lane working the Picard seam, prices the distance to representability as
the three undischarged antecedents of `pic0RepresentableByOfCharts`
(`Picard/Pic0SigmaSheaf.lean`): `IsChartUniv`, Zariski-local surjectivity of `Sigma.desc f`,
and a representation `rep` of the divisor functor.

**That is the antecedent list of the implication, not of the goal.**  The frozen north star of
`Challenge.lean` is `Jacobian C := (jacobianData C).J` with `jacobianData C : JacobianData C`,
and `JacobianData` (`Picard/JacobianData.lean`) has **four** fields — `J`, `rep`,
`locallyOfFiniteType`, `quasiCompact`.  Accordingly *every* producer of the datum from an atlas
takes a fourth input on top of `hf` and the local-surjectivity instance:

  `hlft : ∀ i, LocallyOfFiniteType (chartHom C f i)`

`JacobianData.ofCharts`, `JacobianData.ofChartsOfCompactSpace`,
`JacobianData.ofChartsOfAbelImage` and `JacobianData.ofChartsOfAbelLifts` all carry it.  So a
session that discharged all three tracked antecedents would still not have produced a
`JacobianData C`, and nothing in the tree produces `hlft` at any atlas: the only declaration in
`Picard/` whose conclusion is `LocallyOfFiniteType` is `locallyOfFiniteType_gluedHom`, which
*takes* `hlft` as a hypothesis.

## What is actually owed, and it is much less than the gap suggests

`Picard/Pic0ChartPair.lean` states, in prose, that the certificate is "inherited by every
restriction: being locally of finite type is local on the source, and an open immersion is
locally of finite type".  That sentence is correct and had never been proved — the shape this
workspace has repeatedly found to be the least-audited kind of claim.  Discharged here, and the
two ingredients are cheap:

* `chartHom_restrictChart` (`Pic0ChartPair.lean`) and `chartHom_abelSigmaChart`
  (`Pic0AtlasFromDivRep.lean`) identify the structure morphism of a *restricted Abel chart* as
  `V.ι ≫ D.hom`;
* mathlib's composition instance for `LocallyOfFiniteType` closes the rest, with an open
  immersion on the left — `inferInstance` alone, no lemma.

So the fourth antecedent, at the **real** atlas (heterogeneous parameters, restricted charts —
`mixedParamChart`, `Picard/Pic0ChartAtlasParamFree.lean`), reduces to
`LocallyOfFiniteType (D i).hom`: a property of the divisor scheme with no Picard content, no
chart parameter, and no dependence on the open `V i`.

**And that reduction is not a relocation.**  At the carrier the divisor-representability lane's
producers actually return — `DivOver`, a local notation for `divSchemeOver …` in
`DivRepGlobalClassify.lean` / `DivRepChartRange.lean` / `DivRepAffPullClause.lean` — the property
is a *global instance* (`locallyOfFiniteType_divSchemeOverHom`, `DivSchemeQProj.lean`), so it is
free by `inferInstance` with no hypothesis at all.  Verified at that exact carrier, with the
producer file's own variable bundle, rather than at `divSchemeOver` in the abstract: an
object-level match can be true and irrelevant if the consumer binds a different carrier.  Here it
does not.

One incidental measurement, recorded because it is the reason the freeness was not already
visible: `DivRepGlobalClassify.lean` — the file that *defines* `DivOver` — does not import
`DivSchemeQProj.lean`, so inside it neither finiteness instance can be found. Nothing is wrong
with either file; the instances simply never met the carrier.

## Main declarations

* `AlgebraicGeometry.chartHom_mixedParamChart` — the structure morphism of the `i`-th chart of
  the mixed-parameter atlas is `(V i).ι ≫ (D i).hom`.
* `AlgebraicGeometry.locallyOfFiniteType_chartHom_mixedParamChart` — **the fourth antecedent
  discharged** for the real atlas, from `LocallyOfFiniteType (D i).hom` alone.
* `AlgebraicGeometry.locallyOfFiniteType_gluedHom_mixedParamChart` — hence the glued object is
  locally of finite type over the base field, which is the `JacobianData` field itself.
* `AlgebraicGeometry.jacobianDataOfMixedParamCharts` — **the assembly**: the mixed-parameter
  atlas plus `hf`, local surjectivity, per-index `LocallyOfFiniteType (D i).hom` and
  quasi-compactness of the glued object produce `JacobianData C`.  Landed so that the obligations
  that remain are visible in **one signature** rather than spread over four files: everything in
  it other than `hf`, the local-surjectivity instance and `rep` is now discharged.

## What this does NOT do, stated plainly

It closes no gate of the seam.  `IsChartUniv` (`hf`), Zariski-local surjectivity and `rep` are
untouched and remain unproduced, and each is another lane's target.  The `quasiCompact` field is
*not* discharged here either: for the class-indexed atlas it is genuinely a-posteriori
(`JacobianDataCharts.lean` records that `CompactSpace` of the glued object is a theorem about the
Jacobian, supplied by `JacobianData.ofChartsOfAbelImage` from a surjective Abel map).  What is
removed is a *fourth* undischarged antecedent that no row tracked, so that discharging the three
tracked ones now genuinely reaches the north star's datum.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

noncomputable section

/-! ## The structure morphism of a chart of the real atlas -/

variable (C π) in
/-- **The structure morphism of the `i`-th chart of the mixed-parameter atlas** is the
inclusion of `V i` followed by the structure morphism of the `i`-th representing object.

Both ingredients were already in the tree and had never been composed: `chartHom_restrictChart`
moves `chartHom` across a restriction, and `chartHom_abelSigmaChart` identifies the unrestricted
Abel chart's structure morphism as `D.hom`.  Note that the chart *parameter* `nn i`, the twist
exponent `m i` and the chart index `Z i` do not occur on the right-hand side: the finiteness of a
chart is independent of the heterogeneity this atlas exists to permit. -/
lemma chartHom_mixedParamChart {ι : Type u} (nn : ι → ℕ)
    (D : ι → Over (Spec (.of k)))
    (rep : ∀ i, (divFunctor C π (nn i)).RepresentableBy (D i))
    (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i)
      = (m i : ℤ) * classDeg k (thetaCechClass C) - (nn i : ℤ))
    (V : ∀ i, (D i).left.Opens) (i : ι) :
    chartHom C (mixedParamChart C π nn D rep m Z hdeg V) i = (V i).ι ≫ (D i).hom :=
  (chartHom_restrictChart _ (V i) i).trans (by rw [chartHom_abelSigmaChart])

/-! ## The fourth antecedent -/

variable (C π) in
/-- **THE FOURTH ANTECEDENT OF THE NORTH STAR, DISCHARGED AT THE REAL ATLAS**: each chart of the
mixed-parameter atlas is locally of finite type over the base field as soon as its representing
object is.

This is the `hlft` hypothesis that `JacobianData.ofCharts` and all three of its variants carry
and that the board's three-antecedent picture omits.  `Pic0ChartPair.lean` asserts the inheritance
in prose; this is the proof, and it consumes nothing but `chartHom_mixedParamChart` and mathlib's
composition instance — an open immersion is locally of finite type and the property is stable
under composition.

The hypothesis is a statement about the divisor scheme alone.  In particular it does not mention
`pic⁰`, the chart parameter, the twist, or the open `V i` — so it is discharged for *every*
restriction of a chart at once, and a lane that produces `rep` at a parameter automatically
supplies it whenever the representing object is of finite type over `k`. -/
theorem locallyOfFiniteType_chartHom_mixedParamChart {ι : Type u} (nn : ι → ℕ)
    (D : ι → Over (Spec (.of k)))
    (rep : ∀ i, (divFunctor C π (nn i)).RepresentableBy (D i))
    (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i)
      = (m i : ℤ) * classDeg k (thetaCechClass C) - (nn i : ℤ))
    (V : ∀ i, (D i).left.Opens)
    (hD : ∀ i, LocallyOfFiniteType (D i).hom) (i : ι) :
    LocallyOfFiniteType (chartHom C (mixedParamChart C π nn D rep m Z hdeg V) i) := by
  rw [chartHom_mixedParamChart]
  haveI := hD i
  infer_instance

/-! ## The glued object, and the assembly to the north star's datum -/

variable (C π) in
/-- **The glued object of the real atlas is locally of finite type over the base field** — the
`JacobianData.locallyOfFiniteType` field itself, from a property of the divisor schemes.

`locallyOfFiniteType_gluedHom` descends the certificate from the charts (the property is local on
the source and the glue maps cover), and the previous theorem supplies the charts.  Note that no
finiteness of the index type is used anywhere on this route: the certificate descends to an
infinite atlas exactly as it does to a finite one, which matters because the classical atlas is
indexed by divisor classes. -/
theorem locallyOfFiniteType_gluedHom_mixedParamChart {ι : Type u} (nn : ι → ℕ)
    (D : ι → Over (Spec (.of k)))
    (rep : ∀ i, (divFunctor C π (nn i)).RepresentableBy (D i))
    (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i)
      = (m i : ℤ) * classDeg k (thetaCechClass C) - (nn i : ℤ))
    (V : ∀ i, (D i).left.Opens)
    (hf : ∀ i, IsOpenImmersion.presheaf (mixedParamChart C π nn D rep m Z hdeg V i))
    [Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc (mixedParamChart C π nn D rep m Z hdeg V))]
    (hD : ∀ i, LocallyOfFiniteType (D i).hom) :
    LocallyOfFiniteType (gluedHom C (mixedParamChart C π nn D rep m Z hdeg V) hf) :=
  locallyOfFiniteType_gluedHom C _ hf
    (locallyOfFiniteType_chartHom_mixedParamChart C π nn D rep m Z hdeg V hD)

variable (C π) in
/-- **THE ASSEMBLY: the real atlas produces the north star's datum.**

Every obligation of `JacobianData C` at the mixed-parameter restricted atlas, in one signature.
Read it as the corrected antecedent list of the *goal*:

* `rep` — a representation of the divisor functor at each parameter.  **Open** (another lane's
  target; `Pic0AtlasFromDivRep.lean` takes it as a hypothesis and constructs no representation);
* `hf` — the per-index chart certificate, i.e. `IsChartUniv`.  **Open**;
* the `Presheaf.IsLocallySurjective` instance — DAT-B coverage.  **Open**;
* `hD` — `LocallyOfFiniteType (D i).hom`.  **Discharged**, and at the carrier the producers of
  `rep` return it is free by `inferInstance` (the `Discharged` section above).  So a lane that
  produces `rep` supplies this input in the same breath;
* `hcpt` — `CompactSpace` of the glued object.  **Open, and genuinely a-posteriori**: for the
  class-indexed atlas this is a theorem about the Jacobian (`JacobianDataCharts.lean` says so),
  and `JacobianData.ofChartsOfAbelImage` supplies it from a surjective Abel map.

So this declaration is an *implication*, not a witness: it produces no `JacobianData` at any curve
until the four open inputs above are produced.  Its value is that the fourth antecedent is no
longer among them, and that the list is now checkable in one place instead of being distributed
over `JacobianDataCharts`, `Pic0ChartPair`, `Pic0AtlasFromDivRep` and
`Pic0ChartAtlasParamFree`. -/
def jacobianDataOfMixedParamCharts {ι : Type u} (nn : ι → ℕ)
    (D : ι → Over (Spec (.of k)))
    (rep : ∀ i, (divFunctor C π (nn i)).RepresentableBy (D i))
    (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i)
      = (m i : ℤ) * classDeg k (thetaCechClass C) - (nn i : ℤ))
    (V : ∀ i, (D i).left.Opens)
    (hf : ∀ i, IsOpenImmersion.presheaf (mixedParamChart C π nn D rep m Z hdeg V i))
    [Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc (mixedParamChart C π nn D rep m Z hdeg V))]
    (hD : ∀ i, LocallyOfFiniteType (D i).hom)
    (hcpt : CompactSpace (Scheme.LocalRepresentability.glueData hf).glued) :
    JacobianData C :=
  JacobianData.ofChartsOfCompactSpace C _ hf
    (locallyOfFiniteType_chartHom_mixedParamChart C π nn D rep m Z hdeg V hD) hcpt

/-! ## `hD` is not merely reduced to — it is DISCHARGED at the carrier the producer returns

The theorems above take `hD : ∀ i, LocallyOfFiniteType (D i).hom` as a hypothesis, which by
itself would only *relocate* the fourth antecedent.  It does not: the divisor-representability
lane's producers all return `RepresentableBy DivOver` with `DivOver` a local notation for
`divSchemeOver …` (`DivRepGlobalClassify.lean`, `DivRepChartRange.lean`,
`DivRepAffPullClause.lean`), and at *that* carrier both finiteness inputs are global instances
(`locallyOfFiniteType_divSchemeOverHom`, `compactSpace_divScheme`, `DivSchemeQProj.lean`).

Worth recording precisely, because the two are easy to confuse and the difference is the whole
value of this section: the instances hold *at the carrier*, and they were nevertheless not in
scope where the carrier is defined — `DivRepGlobalClassify.lean` does not import
`DivSchemeQProj.lean`, so inside that file neither is findable.  Importing `DivSchemeQProj` here
is what makes them available to a consumer of this module, and it is why the examples below are
`inferInstance` rather than named applications. -/

section Discharged

open Scheme

variable (k) in
/-- **The fourth antecedent is free at the divisor-representability lane's own carrier**: for a
`divSchemeOver`, `LocallyOfFiniteType` of the structure morphism needs no hypothesis.

So a lane that produces `rep` supplies `hD` at the same moment, at no cost, and the fourth
antecedent is *discharged* rather than relocated. -/
example {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of k))]
    [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of k))] [IsIntegral X]
    (A B : X.CurveDivisor) (n r₁ r₂ : ℕ)
    (b₁ : Module.Basis (Fin r₁) k ↥(divisorSections k B ⊤))
    (b₂ : Module.Basis (Fin r₂) k ↥(divisorSections k (A + B) ⊤)) :
    LocallyOfFiniteType (divSchemeOver k A B n r₁ r₂ b₁ b₂).hom :=
  inferInstance

variable (k) in
/-- **And so is the compactness input** of `JacobianData.ofCharts`'s finite route, at the same
carrier — `DivScheme` is a closed subscheme of the compact Grassmannian pair.

This does **not** discharge `hcpt` of the assembly below, and the distinction matters: `hcpt` is
`CompactSpace` of the **glued** object, which for a class-indexed atlas is not the compactness of
any one chart.  What is free is the *per-chart* compactness, i.e. exactly the hypothesis of the
finite-index route `JacobianData.ofCharts`. -/
example {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of k))]
    [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of k))] [IsIntegral X]
    (A B : X.CurveDivisor) (n r₁ r₂ : ℕ)
    (b₁ : Module.Basis (Fin r₁) k ↥(divisorSections k B ⊤))
    (b₂ : Module.Basis (Fin r₂) k ↥(divisorSections k (A + B) ⊤)) :
    CompactSpace (divSchemeOver k A B n r₁ r₂ b₁ b₂).left :=
  inferInstance

end Discharged

@[simp]
lemma jacobianDataOfMixedParamCharts_J {ι : Type u} (nn : ι → ℕ)
    (D : ι → Over (Spec (.of k)))
    (rep : ∀ i, (divFunctor C π (nn i)).RepresentableBy (D i))
    (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i)
      = (m i : ℤ) * classDeg k (thetaCechClass C) - (nn i : ℤ))
    (V : ∀ i, (D i).left.Opens)
    (hf : ∀ i, IsOpenImmersion.presheaf (mixedParamChart C π nn D rep m Z hdeg V i))
    [Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc (mixedParamChart C π nn D rep m Z hdeg V))]
    (hD : ∀ i, LocallyOfFiniteType (D i).hom)
    (hcpt : CompactSpace (Scheme.LocalRepresentability.glueData hf).glued) :
    (jacobianDataOfMixedParamCharts C π nn D rep m Z hdeg V hf hD hcpt).J
      = gluedOfCharts C (mixedParamChart C π nn D rep m Z hdeg V) hf :=
  rfl

end

end AlgebraicGeometry
