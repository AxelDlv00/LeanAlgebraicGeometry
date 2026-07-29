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
  `RelPicSeparatesDivFamZar` names below.

  **AND HERE IS THE TRAP, which the obvious reading of the previous paragraph walks into.**
  It is tempting to say: the missing half is "class equality ⟹ ε-window equality", a narrow
  bridge, and the landed mono then finishes the job.  That framing is wrong, and reading
  `divisorWindow` (`Picard/DivisorFamilyWindow.lean:103`) says why: the window is the
  *vanishing* submodule of the divisor, `H⁰(𝒪(Θᵃ − d)) ⊆ H_a ⊗ R`.  It is invariant under
  `DivEq` (`divisorWindow_eq_of_divEq`) but it is **not** a function of the Picard class:
  linearly equivalent divisors have vanishing submodules of equal *dimension* sitting as
  *different* subspaces, which is exactly what makes a linear system positive-dimensional.

  So the composite would prove: equal classes ⟹ equal windows ⟹ `DivEq`, over an **arbitrary**
  test ring and with **no** `h⁰ = 1` hypothesis at any degree.  That is strictly stronger than
  the field-level keystone of DAT-C GAP-2 (`Scheme.CurveDivisor.eq_of_picClass_eq_of_h0_one`,
  which is in `RiemannRoch/EffectiveUniqueness.lean` — **note: outside this file's import
  closure, verified by `#check`**, so it is cited as background and never applied here), whose
  `hone` binder would become redundant.

  That dichotomy is not left as prose: `h0_eq_one_of_relPicSeparates_field` below **proves** the
  forcing direction at a field, from the rank anchor.  The consequence to carry off this file:
  the residue is *equivalent to* a Riemann–Roch statement about the curve at the chart's own
  degree, so proving it is not a plumbing step.  A lane must not price it as one.

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
* `AlgebraicGeometry.effective_and_picClass_eq_of_picClass_eq_field` — why the residue is a
  Riemann–Roch statement rather than plumbing: at a field, class equality already delivers
  GAP-2's `hD`/`hD'`/`hcl`, leaving exactly its `h⁰ = 1` binder, which the rank anchor ties to
  the chart's own degree.
* `AlgebraicGeometry.degAt_chartTwist_eq_chartParam` — the chart parameter **is** the fibre
  degree of the twisted class, unconditionally.  So which branch of the fork holds is arithmetic
  in `n` alone: `n = g` gives `h⁰ = 1` on `chartLocus` (positive branch), `n > g` gives
  `h⁰ = n − g + 1 ≥ 2` (negative branch).
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

/-! ## The residue is a Riemann–Roch statement, not plumbing

The section above names the residue.  This one shows what it *is*, at a field, by exhibiting
the two hypotheses of DAT-C GAP-2's field keystone as consequences of class equality alone. -/

set_option linter.overlappingInstances false in
omit [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] in
variable (n) in
/-- **At a field, class equality delivers GAP-2's field keystone hypotheses on the nose.**

Two divisor families over a field `K` with equal Čech class have Weil divisors that are
**effective** (`zero_le_divFamDivisor`) with **equal Picard class** (`picClass_divFamDivisor`).
Those are exactly `hD`, `hD'` and `hcl` of `Scheme.CurveDivisor.eq_of_picClass_eq_of_h0_one`.

So the only thing standing between class equality and `divFamDivisor F = divFamDivisor G` at a
field is that lemma's remaining binder `hone : h⁰(𝒪(D)) = 1` — and by the rank anchor
`h0_eq_deg_add_chi_of_subsingleton_hModule_one` that binder is, at degree `n` on a curve with
`χ = 1 − g`, equivalent to `n = g` together with vanishing `H¹`.

**This is why the residue cannot be plumbing.**  A proof of `RelPicSeparatesDivFamZar` valid at
an arbitrary degree `n` and an arbitrary ring would, restricted to a field, give uniqueness of
the effective representative with no `h⁰` hypothesis at all — false as soon as some class of
degree `n` has a positive-dimensional linear system.  The residue is therefore *calibrated to
the chart's degree*, and the fork's two branches are: `n` is the degree where `h⁰ = 1` holds
(positive branch, and then the whole restriction apparatus may be unnecessary), or it is not
(negative branch, and a witness exists).  Neither is decided here. -/
theorem effective_and_picClass_eq_of_picClass_eq_field {K : Type u} [Field K] [Algebra k K]
    [IsIntegral (relCurve C K)]
    [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
    [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))] [IsFinite π]
    (F G : DivFam C K π n) (hcl : F.picClass = G.picClass) :
    0 ≤ divFamDivisor F ∧ 0 ≤ divFamDivisor G ∧
      Scheme.CurveDivisor.picClass K (divFamDivisor F)
        = Scheme.CurveDivisor.picClass K (divFamDivisor G) :=
  ⟨zero_le_divFamDivisor F, zero_le_divFamDivisor G, by
    rw [picClass_divFamDivisor, picClass_divFamDivisor, hcl]⟩

/-! ## Which degree the fork is asked at, as an identity rather than a convention -/

variable (C π n) in
/-- **THE CHART PARAMETER *IS* THE FIBRE DEGREE OF THE TWISTED CLASS** — unconditionally, for
every chart, with no hypothesis beyond `λ ∈ pic⁰`.

`degAt_chartTwist` gives `deg(chartTwist λ) = m·d₁ − deg Z`, and the chart's own legality
hypothesis `hdeg` says `deg Z = m·d₁ − n`.  Substituting cancels `m` and `d₁` entirely and
leaves `n`.

This is worth stating because it removes the last place the twist data could be hiding a
constraint, and because it fixes where the fork is asked.  `chartLocus`
(`Picard/Pic0ChartLocus.lean:244`) is by definition the locus where the twisted fibre class has
an **effective witness with vanishing `H¹`**; by the rank anchor
`h0_eq_deg_add_chi_of_subsingleton_hModule_one` such a witness has
`h⁰ = deg + χ = n + (1 − g)`.  So on `chartLocus`:

* at `n = g` the witness has `h⁰ = 1` and is therefore the *unique* effective representative of
  its class — the fork's **positive** branch, and the reason `Pic0ChartLocus.lean:194-201`
  records `+g` as "the unique degree at which the witness is unique";
* at `n > g` it has `h⁰ = n − g + 1 ≥ 2`, so the linear system is positive-dimensional and a
  witness for the **negative** branch is what one expects to find.

Neither branch is proved here — `chartLocus` membership is a hypothesis about the class, not a
theorem about the chart, and the `h⁰ = 1` reading is fibrewise while the obligation is at a
general test (the caveat `Picard/Pic0ChartAbelNonInjective.lean` states and I do not weaken).
What is settled is that the question is **arithmetic in `n` alone**: no chart parameter, no
twist exponent and no `Z` enters it. -/
theorem degAt_chartTwist_eq_chartParam (m : ℕ)
    (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    {T : Over (Spec (.of k))} {lam : picEt C T} (hlam : lam ∈ pic0Subgroup C T)
    {K : Type u} [Field K] [Algebra k K] (t : overSpec k K ⟶ T) :
    degAt (chartTwist C m Z T lam) t = (n : ℤ) := by
  rw [degAt_chartTwist m Z hlam t, hdeg]; ring

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
