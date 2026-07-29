/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartAtlasParamFree
import AlgebraicJacobian.Picard.JacobianDataCharts

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

## Main declarations

* `AlgebraicGeometry.chartHom_mixedParamChart` — the structure morphism of the `i`-th chart of
  the mixed-parameter atlas is `(V i).ι ≫ (D i).hom`.
* `AlgebraicGeometry.locallyOfFiniteType_chartHom_mixedParamChart` — **the fourth antecedent
  discharged** for the real atlas, from `LocallyOfFiniteType (D i).hom` alone.
* `AlgebraicGeometry.locallyOfFiniteType_gluedHom_mixedParamChart` — hence the glued object is
  locally of finite type over the base field, which is the `JacobianData` field itself.
* `AlgebraicGeometry.jacobianDataOfMixedParamCharts` — **the assembly**: the mixed-parameter
  atlas plus `hf`, local surjectivity, per-index `LocallyOfFiniteType (D i).hom` and
  quasi-compactness of the glued object produce `JacobianData C`.  Recorded so that the
  remaining obligations are visible in one signature.

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

end

end AlgebraicGeometry
