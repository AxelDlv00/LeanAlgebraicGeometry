/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartUnivReduce

/-!
# `IsChartLocusFibre` implies the UNRESTRICTED certificate — the guard, instantiated

`Picard/Pic0ChartUnivReduce.lean` reduces `IsChartUniv` to `IsChartLocusFibre` (`:152`) and
describes that residue as "`ChartFibrePresented` with its `W` field already discharged — it is
`chartLocus`" (`:138`).  `Picard/Pic0ChartOpenImmersionCriterion.lean` separately proves the
guard `isEmpty_forall_chartFibrePresented_of_not_injective` (`:219`): no family of
`ChartFibrePresented` data exists for a chart map that fails to be injective on some test.

**The tree holds the reduction and its own guard as separate facts and draws the consequence
nowhere.**  This file draws it.

**AN ATTRIBUTION CORRECTION, from a fresh-context audit (2026-07-29, inbox `I-0895`).**  An
earlier draft of this header said the instantiation "is what nobody had written".  That
overstates it: the term proving the unrestricted certificate below is character-for-character
the inner argument that `isChartUniv_of_isChartLocusFibre` was *already* passing to
`isOpenImmersion_presheaf_restrictChart` (`Pic0ChartUnivReduce.lean:177-178`, present before
this file).  The unrestricted certificate was never missing — it was sitting inside the
existing reduction, unnamed.  What is new here is only that it is *stated*, so that its
conflict with the three headers is visible to a reader and to a grep.  The value is routing,
not mathematics.

The two facts are one instantiation apart:

* `IsChartLocusFibre` quantifies `Nonempty (ChartFibrePresented C (abelSigmaChart …) g)` — the
  datum for the **unrestricted** Abel chart, with `W` a *free field* of the structure.  Neither
  `chartLocus` nor the restriction open `V` occurs in its statement, nor in the proof of
  `isChartUniv_of_isChartLocusFibre`.  So the `:138` docstring is wrong: the `W` field is not
  "already discharged — it is `chartLocus`"; it is universally quantified inside a `Nonempty`,
  and the criterion consumes it for the unrestricted `f`;
* therefore `IsChartLocusFibre` **implies** `IsOpenImmersion.presheaf (abelSigmaChart …)` at
  `V = ⊤`, hence `Mono`, hence injectivity on every test.

That conclusion is exactly what three headers cite as the *reason* the unrestricted route
fails — the Abel map has the linear systems `|D|` as fibres, so it is not a monomorphism
(`Pic0AtlasFromDivRep.lean:54`, `Pic0ChartPair.lean:14`,
`Pic0ChartOpenImmersionCriterion.lean:214`).  If those headers are correct then
`IsChartLocusFibre` is **unsatisfiable**, and a lane proving its `exists_factor` field is
working a false goal.  Note the conditional: the headers are *prose*, so this file establishes
an implication, not a refutation.  Nothing in the tree connected the two, and a `sorry`-census
cannot flag the connection, because both ends are sorry-free and axiom-clean.

## What this file does and does not settle

It does **not** prove the Abel chart is non-injective — that is a statement about the linear
system `|D|` in families and it is asserted by prose in three places and proved nowhere.  This
file makes the conditional precise and machine-checked in both directions, so that the
question becomes a single decidable fork rather than a docstring:

* if the Abel chart is non-injective on even one test, `IsChartLocusFibre` is FALSE
  (`not_isChartLocusFibre_of_not_injective`);
* if `IsChartLocusFibre` holds, the Abel chart is a monomorphism and the three headers are
  wrong (`mono_abelSigmaChart_of_isChartLocusFibre`).

Those two are contrapositives of one implication, so this file does **not** decide between
them — neither branch is proved here, and a lane must settle the fork before spending a session
on `exists_factor`.  The fork is `AJCR.w4-rep.datum.dat-c.c9-chartlocus.abel-noninj`.  The
honest repair — a fibre criterion at the *restricted* chart, whose `exists_factor` quantifies
only over points landing in `V` — is a different statement, is not weakened by anything here,
and is landed separately in `Picard/Pic0ChartRestrictedFibre.lean`.

## Main declarations

* `AlgebraicGeometry.isOpenImmersion_presheaf_abelSigmaChart_of_isChartLocusFibre` — the
  reduction's residue implies the UNRESTRICTED certificate.  One term; `V` never appears.
* `AlgebraicGeometry.mono_abelSigmaChart_of_isChartLocusFibre` /
  `AlgebraicGeometry.injective_abelSigmaChart_of_isChartLocusFibre` — the consequences the
  three headers deny.
* `AlgebraicGeometry.not_isChartLocusFibre_of_not_injective` — **the guard, instantiated at
  the Abel chart**: non-injectivity on one test refutes `IsChartLocusFibre` outright.
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

variable {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
variable (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
variable (hdeg : Scheme.CurveDivisor.deg k Z
  = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))

/-- **The reduction's residue implies the UNRESTRICTED certificate.**

`IsChartLocusFibre` supplies a `ChartFibrePresented` datum for *every* test and *every* class,
for the unrestricted `abelSigmaChart`; the criterion consumes exactly that.  So the restriction
open `V` — the thing `IsChartUniv` is parameterised by and the thing the atlas is built from —
plays no part, and this is one term.

This is the statement `Pic0ChartUnivReduce.lean:138` implicitly denies when it calls the `W`
field "already discharged — it is `chartLocus`".  `W` is a free field of the structure;
`chartLocus` is not mentioned anywhere in `IsChartLocusFibre`. -/
theorem isOpenImmersion_presheaf_abelSigmaChart_of_isChartLocusFibre
    (h : IsChartLocusFibre C π n rep m Z hdeg) :
    IsOpenImmersion.presheaf (abelSigmaChart C π n rep m Z hdeg) :=
  isOpenImmersion_presheaf_of_chartFibrePresented _ fun T g => (h T g).some

/-- **Hence the Abel chart is a monomorphism** — which `Pic0AtlasFromDivRep.lean:54`,
`Pic0ChartPair.lean:14` and `Pic0ChartOpenImmersionCriterion.lean:214` all assert it is not,
the linear systems `|D|` being its fibres. -/
theorem mono_abelSigmaChart_of_isChartLocusFibre
    (h : IsChartLocusFibre C π n rep m Z hdeg) :
    Mono (abelSigmaChart C π n rep m Z hdeg) :=
  mono_of_isOpenImmersion_presheaf
    (isOpenImmersion_presheaf_abelSigmaChart_of_isChartLocusFibre rep m Z hdeg h)

/-- **Hence the Abel chart is injective on the points of every test**, unrestricted.

The elementwise form, which is where the contradiction with `|D|` would be exhibited: two
distinct effective divisors in one linear system give one class, and this says that cannot
happen over any test whatsoever. -/
theorem injective_abelSigmaChart_of_isChartLocusFibre
    (h : IsChartLocusFibre C π n rep m Z hdeg) (T : Scheme.{u}ᵒᵖ) :
    Function.Injective ((abelSigmaChart C π n rep m Z hdeg).app T) :=
  injective_of_isOpenImmersion_presheaf
    (isOpenImmersion_presheaf_abelSigmaChart_of_isChartLocusFibre rep m Z hdeg h) T

/-- **THE GUARD, INSTANTIATED AT THE ABEL CHART**: if the Abel chart fails to be injective on
even one test, `IsChartLocusFibre` is false.

`isEmpty_forall_chartFibrePresented_of_not_injective`
(`Pic0ChartOpenImmersionCriterion.lean:219`) is the general statement; it lives in the same
file as the criterion and was never instantiated at the Abel chart, which is the only chart the
tree has.  This is that instantiation, and it is the declaration a lane should consult before
attacking `exists_factor`.

So the fork is sharp: EITHER the three headers are right that the Abel map is not a
monomorphism — and then `IsChartLocusFibre` is unsatisfiable and `isChartUniv_of_isChartLocusFibre`,
though sorry-free, can never fire — OR they are wrong. The two cannot both hold. -/
theorem not_isChartLocusFibre_of_not_injective (T : Scheme.{u}ᵒᵖ)
    (hT : ¬ Function.Injective ((abelSigmaChart C π n rep m Z hdeg).app T)) :
    ¬ IsChartLocusFibre C π n rep m Z hdeg := fun h =>
  hT (injective_abelSigmaChart_of_isChartLocusFibre rep m Z hdeg h T)

end

end AlgebraicGeometry
