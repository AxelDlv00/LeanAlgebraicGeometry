/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartAbelNonInjective

/-!
# THE FORK'S TARGET IS AN EQUALITY OF `relPic` CLASSES, PIECEWISE — the twist cancels and
the plus unit is injective

`Picard/Pic0ChartAbelNonInjective.lean` reduces the non-injectivity fork to divisor families:
a witness owes two *distinct* elements of `divFamZar C π n T` whose `chartValue` agree.  Its
closing paragraph, and three other sites, then price what remains on the *positive* side of
the fork — `ChartFibrePresented.exists_factor` — as "the relative form of DAT-C GAP-2", and
state that **nothing in the tree** concludes `s₁ = s₂` for two `divFamZar` sections from an
equality of their classes.

This file measures what that equality of `chartValue`s actually *is*, and the answer is two
steps shorter than the fork's own file suggests.

## The two steps, and why neither is bookkeeping

1. **The twist cancels.**  `chartValue s = abelDiv s · Σ_Z · (θ^m)⁻¹` in the abelian group
   `picEt C T`, and the two twist factors do not depend on `s`.  So `chartValue s₁ =
   chartValue s₂` is *equivalent* to `abelDiv s₁ = abelDiv s₂` — an `Iff`, by
   `mul_left_inj`/`mul_right_cancel`, with `m`, `Z` and `hdeg` playing no role at all.
   This matters because every statement of the fork carries `m`, `Z` and `hdeg`, and they are
   decoration in it: a witness-builder owes nothing about the twist, and a `Z` of the wrong
   degree cannot rescue injectivity.
2. **The plus unit is injective**, so the Abel values agree exactly when the `relPic` classes
   agree at every affine piece.  `abelDiv` is, componentwise, `PicEtAff.unit` of `relPicMk` of
   the piece's class (`abelDiv_val`), and `PicEtAff.unit_injective`
   (`Picard/CechKernelLemma.lean:361`, Kleiman 2.5(1) — the unconditional close of the ζ3
   campaign) is injective on **every** affine test algebra.  So the composite is injective iff
   `relPicMk ∘ picClass` is, piecewise.

Composing: `chartValue s₁ = chartValue s₂ ↔ ∀ U, relPicMk (s₁|U).picClass =
relPicMk (s₂|U).picClass`.  Both directions, no hypothesis beyond the standing package.

## What this changes about the fork, in both directions

* **The negative branch** (build a witness): the target is not "two divisors in one linear
  system", and not even "two families with equal `chartValue`".  It is two locally certified
  systems over one affine piece whose Čech classes agree **modulo `picFromBase`** — the
  subgroup `relPic` quotients by — and which are not `DivEq`.  Strictly easier than the old
  target (the class equality is now only required modulo base-pulled classes), and stated with
  no twist data.
* **The positive branch** (`exists_factor`): the residue is *not* "relative GAP-2 is absent
  from the tree".  It is the composite of two statements, of which the tree already has the
  harder-looking one.  `divFam_divEq_of_eps_eq_total`
  (`Picard/DivSchemeMonoBridgeRel.lean:417`) is a **relative** mono over an *arbitrary*
  commutative test ring with **no** Noetherian hypothesis and no residual seam: two certified
  families with equal ε-pairs are equal in `DivFam`.  What is genuinely missing is the *other*
  half — that a `relPic` class separates locally certified systems at one ring — which
  `RelPicSeparatesDivFamZar` names below.  Whether that half factors through the ε-window (and
  so through the landed relative mono) is **not settled here**: `divFamEps` is in this file's
  import closure but the mono chain is not, so composing them is a further step and this file
  does not take it.

**MEASURED, and it is why the four sites could say what they say**: `DivSchemeMonoBridgeRel`
is in the import closure of **no** chart file — not `Pic0ChartPair`, not
`Pic0ChartUnivReduce`, not `Pic0ChartOpenImmersionCriterion`, not
`Pic0ChartAbelNonInjective`, not `Pic0ChartRestrictedFibre`.  The absence claims are true of
each file's own scope and false of the project.

## Main declarations

* `AlgebraicGeometry.chartValue_eq_iff_abelDiv_eq` — step 1, the twist cancels (an `Iff`).
* `AlgebraicGeometry.abelDiv_eq_iff_forall_relPicMk_picClass_eq` — step 2, piecewise, from
  plus-unit injectivity.
* `AlgebraicGeometry.chartValue_eq_iff_forall_relPicMk_picClass_eq` — the composite: the
  fork's hypothesis, twist-free and unit-free.
* `AlgebraicGeometry.not_isChartLocusFibre_of_relPicMk_picClass_eq` — the fork's negative
  branch restated at the sharp target.
* `AlgebraicGeometry.RelPicSeparatesDivFamZar` — the honest residue of the positive branch,
  named at ONE test algebra.  No instance of it is proved here.
* `AlgebraicGeometry.injective_chartValue_of_relPicSeparates` — it suffices: piecewise
  separation makes the chart map injective on `divFamZar` sections at every test.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

attribute [local instance] Over.sectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π] {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

noncomputable section

/-! ## Step 1: the twist cancels -/

variable (C π n) in
/-- **The twist factors cancel**: two sections have equal chart value exactly when they have
equal Abel value.

`chartValue s = abelDiv s * Σ_Z * (θ^m)⁻¹` and the last two factors are independent of `s`, so
this is group cancellation in `picEt C T`.  Stated as an `Iff` so it cannot be read as a
weakening in either direction.

**The consequence for the fork is that `m`, `Z` and `hdeg` are decoration.**  Every statement
of the non-injectivity fork carries them; none of them constrains the question. -/
theorem chartValue_eq_iff_abelDiv_eq (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (T : Over (Spec (.of k))) (s₁ s₂ : divFamZar C π n T) :
    chartValue C π n m Z T s₁ = chartValue C π n m Z T s₂
      ↔ abelDiv C π n T s₁ = abelDiv C π n T s₂ := by
  rw [chartValue, chartValue, mul_left_inj, mul_left_inj]

/-! ## Step 2: the plus unit is injective, piecewise -/

omit [SmoothOfRelativeDimension 1 C.hom] in
variable (C π n) in
/-- **The Abel value determines, and is determined by, the piecewise `relPic` classes.**

Forward: `abelDiv_val` reads the value at an affine open as `PicEtAff.unit` of `relPicMk` of
that piece's class, and `PicEtAff.unit_injective` — unconditional on every affine test algebra
— strips the unit.  Backward: congruence.

This is the step no CHART-U row cites, and it is what makes the fork's target a statement
about *classes* rather than about the sheafified group.

**A measurement, not a claim**: the `omit` is the linter's, not decoration.  This step does
not use `SmoothOfRelativeDimension 1 C.hom` — the curve enters only through `PicEtAff`'s
étale separatedness, which needs properness and geometric integrality and nothing about
dimension. -/
theorem abelDiv_eq_iff_forall_relPicMk_picClass_eq [GeometricallyReduced C.hom]
    (T : Over (Spec (.of k))) (s₁ s₂ : divFamZar C π n T) :
    abelDiv C π n T s₁ = abelDiv C π n T s₂
      ↔ ∀ U : T.left.affineOpens,
          relPicMk C (overSpec k Γ(T.left, U.1)) (s₁.1 U).picClass
            = relPicMk C (overSpec k Γ(T.left, U.1)) (s₂.1 U).picClass :=
  ⟨fun h U => PicEtAff.unit_injective C _ (congrFun (congrArg Subtype.val h) U),
    fun h => picEt.ext fun U => congrArg (PicEtAff.unit C _) (h U)⟩

/-! ## The composite: the fork's hypothesis, twist-free -/

variable (C π n) in
/-- **THE FORK'S HYPOTHESIS, MEASURED**: equal chart values is equal piecewise `relPic`
classes.  No twist, no unit, no `hdeg`. -/
theorem chartValue_eq_iff_forall_relPicMk_picClass_eq (m : ℕ)
    (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (T : Over (Spec (.of k))) (s₁ s₂ : divFamZar C π n T) :
    chartValue C π n m Z T s₁ = chartValue C π n m Z T s₂
      ↔ ∀ U : T.left.affineOpens,
          relPicMk C (overSpec k Γ(T.left, U.1)) (s₁.1 U).picClass
            = relPicMk C (overSpec k Γ(T.left, U.1)) (s₂.1 U).picClass :=
  (chartValue_eq_iff_abelDiv_eq C π n m Z T s₁ s₂).trans
    (abelDiv_eq_iff_forall_relPicMk_picClass_eq C π n T s₁ s₂)

/-! ## The honest residue of the positive branch, named -/

variable (C π n) in
/-- **THE RESIDUE, at one affine test algebra**: the `relPic` class of a locally certified
divisor class determines the class.

This is what the fork's positive branch actually owes, and it is *strictly weaker* than the
"relative form of DAT-C GAP-2" that four sites price it at, in two independent ways:

* it is about `relPicMk ∘ picClass` at a **single ring**, with no test object, no chart, no
  twist, no representing object and no `Σ`-component;
* it is the **only** thing left, because `chartValue`'s two other layers are now discharged:
  the twist by cancellation and the plus unit by `PicEtAff.unit_injective`.

**Read the quantifier carefully — this is a `Prop` about one `A`, deliberately.**  It is not
asserted here for any `A`, and this file proves no instance of it.  Note also what it is *not*:
it is not injectivity of `picClass` itself.  `relPicMk` quotients by `picFromBase`, so the
demand is only that two locally certified systems whose Čech classes differ by a *base-pulled*
class are already equal — the weakest form of the separation the fork needs. -/
def RelPicSeparatesDivFamZar (A : Type u) [CommRing A] [Algebra k A] : Prop :=
  Function.Injective
    (fun F : DivFamZar C A π n => relPicMk C (overSpec k A) F.picClass)

variable (C π n) in
/-- **The residue suffices, at every test**: piecewise class separation makes the chart map
injective on the sections of `divFamZar` — which is exactly the statement whose failure the
fork's negative branch needs and whose truth the positive branch needs.

So the whole fork reduces to `RelPicSeparatesDivFamZar` at the section algebras of the test.
`m`, `Z` and `hdeg` do not appear in the hypothesis. -/
theorem injective_chartValue_of_relPicSeparates [GeometricallyReduced C.hom]
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor) (T : Over (Spec (.of k)))
    (hsep : ∀ U : T.left.affineOpens, RelPicSeparatesDivFamZar C π n Γ(T.left, U.1)) :
    Function.Injective (chartValue C π n m Z T) := by
  intro s₁ s₂ h
  refine divFamZar.ext fun U => hsep U ?_
  exact (chartValue_eq_iff_forall_relPicMk_picClass_eq C π n m Z T s₁ s₂).mp h U

/-! ## The negative branch at the sharp target -/

/-- **The fork's negative branch, restated where a witness-builder can work.**

Two distinct sections whose piecewise `relPic` classes agree refute `IsChartLocusFibre`, hence
antecedent 1's only non-circular route.  Compared with
`not_isChartLocusFibre_of_divFamZar` this drops the twist entirely: the witness owes an
equality of classes **modulo `picFromBase`**, at each affine piece, and nothing about `Z`. -/
theorem not_isChartLocusFibre_of_relPicMk_picClass_eq {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    {T : Over (Spec (.of k))} (s₁ s₂ : divFamZar C π n T) (hne : s₁ ≠ s₂)
    (hcl : ∀ U : T.left.affineOpens,
      relPicMk C (overSpec k Γ(T.left, U.1)) (s₁.1 U).picClass
        = relPicMk C (overSpec k Γ(T.left, U.1)) (s₂.1 U).picClass) :
    ¬ IsChartLocusFibre C π n rep m Z hdeg :=
  not_isChartLocusFibre_of_divFamZar rep m Z hdeg s₁ s₂ hne
    ((chartValue_eq_iff_forall_relPicMk_picClass_eq C π n m Z T s₁ s₂).mpr hcl)

end

end AlgebraicGeometry
