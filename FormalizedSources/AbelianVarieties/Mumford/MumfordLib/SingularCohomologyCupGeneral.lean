/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomologyDegrees
import MumfordLib.SingularCohomologyCup
import MumfordLib.SingularCupLeibniz
import Mathlib.LinearAlgebra.BilinearMap

/-!
# The integral singular cup product in positive degrees

The Alexander--Whitney product of cocycles is a cocycle in every bidegree.
The signed Leibniz identity gives explicit primitives whenever either factor
is a coboundary. Consequently the bilinear cocycle cup descends to the homology
of the integral singular cochain complex in all positive degrees.

This supplies the positive-degree cup-product operation for Mumford,
*Abelian Varieties*, Chapter I, Section 1, p. 3. The exterior-algebra comparison
is a separate assertion.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory

namespace Mumford.Analytic

variable {X : TopCat} {p q n : ℕ}

/-- The Alexander--Whitney cup of two integral cocycles. -/
def singularCocycleCup (φ : singularCocycles X p) (ψ : singularCocycles X q)
    (h : p + q = n) : singularCocycles X n :=
  ⟨singularCochainCup φ.1 ψ.1 h,
    singularCochainCup_cocycle ⟨φ.1, φ.2⟩ ⟨ψ.1, ψ.2⟩ h⟩

@[simp]
theorem singularCocycleCup_coe (φ : singularCocycles X p) (ψ : singularCocycles X q)
    (h : p + q = n) :
    (singularCocycleCup φ ψ h).1 = singularCochainCup φ.1 ψ.1 h := rfl

/-- The cocycle cup product is bilinear over the integers. -/
def singularCocycleCupBilinear (X : TopCat) (p q n : ℕ) (h : p + q = n) :
    singularCocycles X p →ₗ[ℤ] singularCocycles X q →ₗ[ℤ] singularCocycles X n where
  toFun φ :=
    { toFun := fun ψ => singularCocycleCup φ ψ h
      map_add' ψ χ := by
        apply Subtype.ext
        exact (singularCochainCupBilinear X p q n h φ.1).map_add ψ.1 χ.1
      map_smul' c ψ := by
        apply Subtype.ext
        exact (singularCochainCupBilinear X p q n h φ.1).map_smul c ψ.1 }
  map_add' φ ψ := by
    apply LinearMap.ext
    intro χ
    apply Subtype.ext
    exact congrArg (fun f => f χ.1)
      ((singularCochainCupBilinear X p q n h).map_add φ.1 ψ.1)
  map_smul' c φ := by
    apply LinearMap.ext
    intro ψ
    apply Subtype.ext
    exact congrArg (fun f => f ψ.1)
      ((singularCochainCupBilinear X p q n h).map_smul c φ.1)

@[simp]
theorem singularCocycleCupBilinear_apply (φ : singularCocycles X p)
    (ψ : singularCocycles X q) (h : p + q = n) :
    singularCocycleCupBilinear X p q n h φ ψ = singularCocycleCup φ ψ h := rfl

/-- The positive-degree cohomology class of a cup of cocycles. -/
def singularCocycleCupClass (X : TopCat) (p q : ℕ) :
    singularCocycles X (p + 1) →ₗ[ℤ] singularCocycles X (q + 1) →ₗ[ℤ]
      IntegralSingularCohomology X (p + q + 2) :=
  (singularCocycleCupBilinear X (p + 1) (q + 1) (p + q + 2) (by omega)).compr₂ₛₗ
    (singularPositiveCohomologyClass X (p + q + 1))

@[simp]
theorem singularCocycleCupClass_apply (φ : singularCocycles X (p + 1))
    (ψ : singularCocycles X (q + 1)) :
    singularCocycleCupClass X p q φ ψ =
      singularPositiveCohomologyClass X (p + q + 1)
        (singularCocycleCup φ ψ (by omega)) := rfl

@[simp]
theorem singularCocycleCupClass_coboundary_left (φ : IntegralSingularCochain X p)
    (ψ : singularCocycles X (q + 1)) :
    singularCocycleCupClass X p q (singularCoboundaryToCocycles X p φ) ψ = 0 := by
  apply (singularPositiveCohomologyClass_eq_zero_iff X (p + q + 1) _).mpr
  refine ⟨singularCochainCup φ ψ.1 (by omega), ?_⟩
  apply Subtype.ext
  exact singularCochainCup_coboundary_left φ ⟨ψ.1, ψ.2⟩ (by omega)

@[simp]
theorem singularCocycleCupClass_coboundary_right (φ : singularCocycles X (p + 1))
    (ψ : IntegralSingularCochain X q) :
    singularCocycleCupClass X p q φ (singularCoboundaryToCocycles X q ψ) = 0 := by
  apply (singularPositiveCohomologyClass_eq_zero_iff X (p + q + 1) _).mpr
  refine ⟨(-1 : ℤ) ^ (p + 1) • singularCochainCup φ.1 ψ (by omega), ?_⟩
  apply Subtype.ext
  exact singularCochainCup_coboundary_right ⟨φ.1, φ.2⟩ ψ (by omega)

private theorem singularCocycleCupClass_comp_coboundary
    (φ : singularCocycles X (p + 1)) :
    (singularCocycleCupClass X p q φ).comp (singularCoboundaryToCocycles X q) = 0 := by
  apply LinearMap.ext
  intro ψ
  exact singularCocycleCupClass_coboundary_right φ ψ

private def singularCohomologyCupRight (X : TopCat) (p q : ℕ) :
    singularCocycles X (p + 1) →ₗ[ℤ] IntegralSingularCohomology X (q + 1) →ₗ[ℤ]
      IntegralSingularCohomology X (p + q + 2) where
  toFun φ := singularPositiveCohomologyDesc X q (singularCocycleCupClass X p q φ)
    (singularCocycleCupClass_comp_coboundary φ)
  map_add' φ ψ := by
    apply LinearMap.ext
    intro c
    obtain ⟨χ, rfl⟩ := singularPositiveCohomologyClass_surjective X q c
    simp only [LinearMap.add_apply, singularPositiveCohomologyDesc_class, map_add]
  map_smul' c φ := by
    apply LinearMap.ext
    intro d
    obtain ⟨ψ, rfl⟩ := singularPositiveCohomologyClass_surjective X q d
    change singularPositiveCohomologyDesc X q _ _ (singularPositiveCohomologyClass X q ψ) =
      c • singularPositiveCohomologyDesc X q _
        (singularCocycleCupClass_comp_coboundary φ) (singularPositiveCohomologyClass X q ψ)
    rw [singularPositiveCohomologyDesc_class, singularPositiveCohomologyDesc_class]
    exact congrArg (fun f => f ψ) ((singularCocycleCupClass X p q).map_smul c φ)

private theorem singularCohomologyCupRight_comp_coboundary (X : TopCat) (p q : ℕ) :
    (singularCohomologyCupRight X p q).comp (singularCoboundaryToCocycles X p) = 0 := by
  apply LinearMap.ext
  intro φ
  apply LinearMap.ext
  intro c
  obtain ⟨ψ, rfl⟩ := singularPositiveCohomologyClass_surjective X q c
  change singularPositiveCohomologyDesc X q _
    (singularCocycleCupClass_comp_coboundary _) (singularPositiveCohomologyClass X q ψ) = 0
  rw [singularPositiveCohomologyDesc_class]
  exact singularCocycleCupClass_coboundary_left φ ψ

/-- The bilinear integral singular cup product in any two positive degrees. -/
def singularPositiveCohomologyCup (X : TopCat) (p q : ℕ) :
    IntegralSingularCohomology X (p + 1) →ₗ[ℤ] IntegralSingularCohomology X (q + 1) →ₗ[ℤ]
      IntegralSingularCohomology X (p + q + 2) :=
  singularPositiveCohomologyDesc X p (singularCohomologyCupRight X p q)
    (singularCohomologyCupRight_comp_coboundary X p q)

/-- The descended product is represented by the Alexander--Whitney cup cochain. -/
@[simp]
theorem singularPositiveCohomologyCup_class (φ : singularCocycles X (p + 1))
    (ψ : singularCocycles X (q + 1)) :
    singularPositiveCohomologyCup X p q
        (singularPositiveCohomologyClass X p φ) (singularPositiveCohomologyClass X q ψ) =
      singularPositiveCohomologyClass X (p + q + 1)
        (singularCocycleCup φ ψ (by omega)) := by
  simp only [singularPositiveCohomologyCup, singularPositiveCohomologyDesc_class]
  change singularPositiveCohomologyDesc X q _
    (singularCocycleCupClass_comp_coboundary φ) (singularPositiveCohomologyClass X q ψ) = _
  rw [singularPositiveCohomologyDesc_class, singularCocycleCupClass_apply]

@[simp]
theorem singularCocycleCup_one_one (φ ψ : singularOneCocycles X) :
    singularCocycleCup φ ψ rfl = singularCocycleCupOne φ ψ := by
  apply Subtype.ext
  exact singularCochainCup_one_one φ.1 ψ.1

/-- The positive-degree construction extends the established degree-one cup. -/
@[simp]
theorem singularPositiveCohomologyCup_zero_zero (X : TopCat) :
    singularPositiveCohomologyCup X 0 0 = singularCohomologyCupOne X := by
  apply LinearMap.ext
  intro c
  apply LinearMap.ext
  intro d
  obtain ⟨φ, rfl⟩ := singularFirstCohomologyClass_surjective X c
  obtain ⟨ψ, rfl⟩ := singularFirstCohomologyClass_surjective X d
  rw [singularCohomologyCupOne_class]
  have h : singularPositiveCohomologyCup X 0 0
      (singularPositiveCohomologyClass X 0 φ) (singularPositiveCohomologyClass X 0 ψ) =
      singularPositiveCohomologyClass X 1 (singularCocycleCup φ ψ rfl) :=
    singularPositiveCohomologyCup_class φ ψ
  rw [singularPositiveCohomologyClass_zero, singularPositiveCohomologyClass_one,
    singularCocycleCup_one_one] at h
  exact h

end Mumford.Analytic
