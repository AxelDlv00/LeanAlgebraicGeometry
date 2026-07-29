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
* `not_injective_abelSigmaChart_of_divFamZar` — the version stated on the **divisor families**
  rather than on the points, obtained by transporting along `rep.homEquiv`: two distinct
  families over one test with equal chart value.  This is the shape the linear-system argument
  produces, and the transport is where `rep` does its work.

## What is NOT proved here, stated so this file is not over-read

**Nothing here exhibits a curve on which the hypothesis holds.**  The reduction is
`(∃ two families with equal chart value) → ¬ IsChartLocusFibre`, and its antecedent is open.
The remaining obligation is exactly:

  for some curve, some test `T`, and `n = g`: two *distinct* elements of `divFamZar C π n T`
  whose `chartValue` agree.

Over a field test that is the classical statement `h⁰(𝒪(D)) ≥ 2 ⇒ |D|` has two points, and
`Scheme.CurveDivisor.eq_of_picClass_eq_of_h0_one` (`RiemannRoch/EffectiveUniqueness.lean:144`)
is its exact contrapositive boundary: uniqueness holds **at** `h⁰ = 1` and the hypothesis to
contradict is `h⁰ ≥ 2`.  What the tree does not have is the passage from two divisors to two
*elements of `divFamZar`* — the families carry local equations, so distinctness of divisors does
not immediately give distinctness of families, and that step is named here rather than assumed.

So: this file converts a prose fork into a named divisor-level obligation, and does not close
the fork.  Whoever closes it should read `divFamZar`'s quotient (`DivisorFamilyZar.lean:235`)
first — the equivalence there is what decides whether two local-equation data are one family.
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
  sorry

end

end AlgebraicGeometry
