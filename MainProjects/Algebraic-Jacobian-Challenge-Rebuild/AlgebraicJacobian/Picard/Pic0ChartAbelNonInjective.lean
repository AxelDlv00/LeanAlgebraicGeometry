/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartLocusFibreGuard

/-!
# DECIDING THE FORK: what non-injectivity of the unrestricted Abel chart actually costs

`Picard/Pic0ChartLocusFibreGuard.lean` makes the fork precise and machine-checked:
`IsChartLocusFibre` implies the Abel chart is a monomorphism, which three headers
(`Pic0AtlasFromDivRep.lean:54`, `Pic0ChartPair.lean:14`,
`Pic0ChartOpenImmersionCriterion.lean:214`) assert it is not.  Exactly one side is right, and
the guard leaves the deciding statement — non-injectivity — as prose.

**This file reduces that statement to divisor data.**  The reduction is what was missing: the
Abel chart's app does not take divisors, it takes `D.left`-points, so "two divisors in one
linear system" is not by itself a witness.  Reading `abelChartApp_eq`
(`Pic0ChartCoverageAbel.lean:105`), a point `x : Y ⟶ D.left` is sent to the **pair**

  `⟨x ≫ D.hom, chartValue … (rep.homEquiv (Over.homMk x rfl))⟩`

so a non-injectivity witness owes *two* agreements, not one: the Σ-components `x ≫ D.hom` must
agree before the classes are in the same type at all.  That is the trap the c9b row names.

## What is proved here

The reduction, in the direction a witness-builder needs, and its converse:

* `exists_not_injective_abelSigmaChart_of_chartValue_eq` — from two `D.left`-points over one
  test with **equal structure morphism** and **equal chart value** but distinct as points, the
  Abel chart fails to be injective, hence (composing with the guard)
  `IsChartLocusFibre` is false.
* `abelChartApp_inj_iff` — the exact shape injectivity has at a test: it is *precisely*
  injectivity of `x ↦ ⟨x ≫ D.hom, chartValue … (rep.homEquiv …)⟩`, so no reformulation can
  avoid the Σ-component.
* `not_isChartLocusFibre_of_divFamZar` — the version stated on the **divisor families**
  rather than on the points, obtained by transporting along `rep.homEquiv`: two distinct
  families over one test with equal chart value.  This is the shape the linear-system argument
  produces, and the transport is where `rep` does its work.  Note the Σ-component obligation
  **disappears** here: both points are `(rep.homEquiv.symm sᵢ).left`, whose structure morphism
  is the test's own by `Over.w`, so `hstruct` holds by construction rather than by hypothesis.
  That is the payoff of stating it at the family level.

## What is NOT proved here, stated so this file is not over-read

**Nothing here exhibits a curve on which the hypothesis holds, and no theorem below closes the
fork.**  Every statement here is an implication whose antecedent is open.  What remains is
exactly:

  for some curve, some test `T`, and some `n`: two *distinct* elements of `divFamZar C π n T`
  whose `chartValue` agree.

Three things to know before pricing that, and the third is the one that moves.

1. Over a field test it is the classical `h⁰(𝒪(D)) ≥ 2 ⇒ |D|` has two points.
   `Scheme.CurveDivisor.eq_of_picClass_eq_of_h0_one` (`RiemannRoch/EffectiveUniqueness.lean:144`)
   is the exact boundary: uniqueness holds **at** `h⁰ = 1`, so the hypothesis to arrange is
   `h⁰ ≥ 2`.  It is the statement to contradict, not to apply.
2. The passage from two *divisors* to two distinct *elements of `divFamZar`* is not free: the
   families are a quotient of local-equation data (`DivisorFamilyZar.lean:235`), so distinct
   divisors need not give distinct families until that equivalence is read.  Nothing here
   assumes otherwise.
3. **`n` is not free, and this is where the fork is actually decided.**  At `n = g` the chart's
   own degree calibration makes the fibre a single point *for free*: an effective divisor of
   degree `g` with `Subsingleton H¹` has `h⁰ = 1` exactly (`degAt_chartTwist`'s `+g` discussion
   in `Pic0ChartLocus.lean:178-201`, and the rank anchor
   `h0_eq_deg_add_chi_of_subsingleton_hModule_one`, `RiemannRoch/FLVClass.lean:412`, giving
   `h⁰ = g + (1 − g) = 1`).  So at the representability degree the two branches of the fork are
   *not* "is the Abel map a mono" in the abstract — they are **"does `DivScheme g` contain
   points where `H¹` fails to vanish"**.  If it does not, the unrestricted chart is injective at
   `n = g` and the three headers are wrong *at that degree*; if it does, the restriction to
   `chartLocus` is precisely the restriction to the `H¹`-vanishing locus, which is why
   `chartLocus` is the right `V` rather than an arbitrary one.

Consequence for the two lanes reading this: the headers' claim is about a *positive-dimensional*
linear system, i.e. `h⁰ ≥ 2`, i.e. `H¹ ≠ 0` at degree `g`.  A witness must therefore exhibit a
point of the divisor scheme with non-vanishing `H¹`; a bare "two divisors in a linear system" is
not enough, because at `n = g` with `h¹ = 0` there are none.  (The degree-`g`/`h⁰ = 1` link is
`ajcr-p4`'s measurement, I-0888.)
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

/-! ## The exact shape of injectivity at a test -/

/-- **Injectivity of the Abel chart at a test, unfolded.**

`abelChartApp_eq` is `rfl`, so injectivity of the app at `op Y` is *literally* injectivity of
the pair-valued map below.  Recorded as an `Iff` on the nose so that a lane attacking either
branch of the fork works with the two components explicitly and cannot silently drop the
Σ-component. -/
theorem abelChartApp_inj_iff (Y : Scheme.{u}) :
    Function.Injective ((abelSigmaChart C π n rep m Z hdeg).app (op Y))
      ↔ Function.Injective (fun x : Y ⟶ D.left =>
          (⟨x ≫ D.hom, ⟨chartValue C π n m Z (Over.mk (x ≫ D.hom))
              (rep.homEquiv (Over.homMk x rfl)),
            chartValue_mem_pic0Subgroup C π n m Z hdeg _ _⟩⟩ :
            (pic0SigmaSheaf C).1.obj (op Y))) :=
  Iff.rfl

/-! ## The reduction, in the direction a witness-builder needs -/

/-- **Two `D.left`-points over one test with the same chart value refute the certificate.**

The hypotheses are exactly the two agreements `abelChartApp_eq` demands — equal structure
morphism (`hstruct`) and equal chart value after that identification (`hval`) — together with
distinctness of the points themselves.

Note `hval` is stated at the *transported* family: once `hstruct` identifies the Σ-components,
both chart values live over `Over.mk (x₁ ≫ D.hom)` and the equation typechecks. -/
theorem not_injective_abelSigmaChart_of_points {Y : Scheme.{u}} (x₁ x₂ : Y ⟶ D.left)
    (hne : x₁ ≠ x₂) (hstruct : x₁ ≫ D.hom = x₂ ≫ D.hom)
    (hval : chartValue C π n m Z (Over.mk (x₁ ≫ D.hom))
        (rep.homEquiv (Over.homMk x₁ rfl))
      = chartValue C π n m Z (Over.mk (x₁ ≫ D.hom))
          (rep.homEquiv (Over.homMk x₂ hstruct.symm))) :
    ¬ Function.Injective ((abelSigmaChart C π n rep m Z hdeg).app (op Y)) := by
  intro hinj
  refine hne (hinj ?_)
  -- both values are Σ-elements over the *same* structure morphism after `hstruct`
  refine Over.sigmaExtension_ext (pic0TypeFunctor C) hstruct ?_
  -- the transport of `x₂`'s family along `mkCongr hstruct` is `x₂` read over `x₁`'s base
  have hmap : (divFunctor C π n).map (Over.mkCongr hstruct).op
        (rep.homEquiv (Over.homMk x₂ rfl))
      = rep.homEquiv (Over.homMk x₂ hstruct.symm) := by
    rw [← rep.homEquiv_comp]
    exact congrArg rep.homEquiv (Over.OverMorphism.ext (Category.id_comp x₂))
  have hnat := ConcreteCategory.congr_hom
    ((chartValueTrans C π n m Z hdeg).naturality (Over.mkCongr hstruct).op)
    (rep.homEquiv (Over.homMk x₂ rfl))
  refine hnat.symm.trans ?_
  rw [ConcreteCategory.comp_apply, hmap]
  exact Subtype.ext hval.symm

/-- **Hence `IsChartLocusFibre` is false** — the composite with the landed guard
`not_isChartLocusFibre_of_not_injective` (`Pic0ChartLocusFibreGuard.lean:134`).

This is the deliverable of the fork's negative branch: a witness at ONE test kills the only
non-circular route to `IsChartUniv`, hence to antecedent 1 of `pic0RepresentableByOfCharts`. -/
theorem not_isChartLocusFibre_of_points {Y : Scheme.{u}} (x₁ x₂ : Y ⟶ D.left)
    (hne : x₁ ≠ x₂) (hstruct : x₁ ≫ D.hom = x₂ ≫ D.hom)
    (hval : chartValue C π n m Z (Over.mk (x₁ ≫ D.hom))
        (rep.homEquiv (Over.homMk x₁ rfl))
      = chartValue C π n m Z (Over.mk (x₁ ≫ D.hom))
          (rep.homEquiv (Over.homMk x₂ hstruct.symm))) :
    ¬ IsChartLocusFibre C π n rep m Z hdeg :=
  not_isChartLocusFibre_of_not_injective rep m Z hdeg (op Y)
    (not_injective_abelSigmaChart_of_points rep m Z hdeg x₁ x₂ hne hstruct hval)

/-! ## The divisor-family form: where `rep` does the work -/

/-- **The obligation stated on divisor families rather than on points.**

This is the shape the linear-system argument produces: two *families* over one test with equal
chart value.  Transporting along `rep.homEquiv` (a bijection) turns them into two points of
`D.left` over that test, and `Over.homMk`'s structure morphism is the test's own, so the
Σ-components agree by construction rather than by hypothesis.

So the fork's negative branch reduces to a statement with **no** scheme-theoretic side
condition: distinctness in `divFamZar C π n T` plus equality of `chartValue`. -/
theorem not_isChartLocusFibre_of_divFamZar {T : Over (Spec (.of k))}
    (s₁ s₂ : divFamZar C π n T) (hne : s₁ ≠ s₂)
    (hval : chartValue C π n m Z T s₁ = chartValue C π n m Z T s₂) :
    ¬ IsChartLocusFibre C π n rep m Z hdeg := by
  set x₁ : T.left ⟶ D.left := (rep.homEquiv.symm s₁).left with hx₁
  set x₂ : T.left ⟶ D.left := (rep.homEquiv.symm s₂).left with hx₂
  -- both points have the test's own structure morphism, so the Σ-components agree
  have hs₁ : x₁ ≫ D.hom = T.hom := Over.w _
  have hs₂ : x₂ ≫ D.hom = T.hom := Over.w _
  have hstruct : x₁ ≫ D.hom = x₂ ≫ D.hom := hs₁.trans hs₂.symm
  -- `Over.homMk xᵢ` recovers the slice morphism `rep.homEquiv.symm sᵢ` was, hence `sᵢ`
  have hrec₁ : rep.homEquiv (Over.homMk x₁ hs₁) = s₁ := by
    refine (congrArg rep.homEquiv (Over.OverMorphism.ext ?_)).trans
      (rep.homEquiv.apply_symm_apply s₁)
    rfl
  have hrec₂ : rep.homEquiv (Over.homMk x₂ (hstruct.symm.trans hs₁)) = s₂ := by
    refine (congrArg rep.homEquiv (Over.OverMorphism.ext ?_)).trans
      (rep.homEquiv.apply_symm_apply s₂)
    rfl
  refine not_isChartLocusFibre_of_points rep m Z hdeg x₁ x₂ ?_ hstruct ?_
  · -- distinct families give distinct points, `rep.homEquiv.symm` being injective
    intro h
    exact hne (hrec₁.symm.trans ((congrArg rep.homEquiv
      (Over.OverMorphism.ext h)).trans hrec₂))
  · -- the two chart values are `hval` restricted along the identity-on-`T.left` slice
    -- morphism `e`, so naturality of `chartValue` transports it
    set e : Over.mk (x₁ ≫ D.hom) ⟶ T :=
      Over.homMk (𝟙 T.left) ((Category.id_comp T.hom).trans hs₁.symm) with he
    have hfac₁ : (Over.homMk x₁ rfl : Over.mk (x₁ ≫ D.hom) ⟶ D)
        = e ≫ rep.homEquiv.symm s₁ :=
      Over.OverMorphism.ext (Category.id_comp x₁).symm
    have hfac₂ : (Over.homMk x₂ hstruct.symm : Over.mk (x₁ ≫ D.hom) ⟶ D)
        = e ≫ rep.homEquiv.symm s₂ :=
      Over.OverMorphism.ext (Category.id_comp x₂).symm
    have hpull : ∀ s : divFamZar C π n T,
        rep.homEquiv (e ≫ rep.homEquiv.symm s) = divFamZar.map C π n e s := by
      intro s
      rw [rep.homEquiv_comp, rep.homEquiv.apply_symm_apply]
      rfl
    have hstep : ∀ (s : divFamZar C π n T) (y : Over.mk (x₁ ≫ D.hom) ⟶ D),
        y = e ≫ rep.homEquiv.symm s →
        chartValue C π n m Z (Over.mk (x₁ ≫ D.hom)) (rep.homEquiv y)
          = picEtMap C e (chartValue C π n m Z T s) := by
      intro s y hy
      subst hy
      exact (congrArg (chartValue C π n m Z (Over.mk (x₁ ≫ D.hom))) (hpull s)).trans
        (picEtMap_chartValue C π n m Z e s).symm
    exact (hstep s₁ _ hfac₁).trans
      ((congrArg (picEtMap C e) hval).trans (hstep s₂ _ hfac₂).symm)

end

end AlgebraicGeometry
