/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCupCoboundary
import MumfordLib.SingularSecondCohomology
import Mathlib.LinearAlgebra.BilinearMap

/-!
# The integral singular cup product from degree one to degree two

The Alexander--Whitney product of one-cocycles is a two-cocycle. Its
cohomology class is bilinear and annihilates coboundaries in both variables,
so it descends to a bilinear map on integral singular cohomology.

This is a producer for the cup-product comparison in Mumford, Chapter I,
Section 1, p. 3; the all-degree exterior-algebra comparison is separate.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory

namespace Mumford.Analytic

variable {X : TopCat}

/-- The Alexander--Whitney cup of two one-cocycles, as a two-cocycle. -/
def singularCocycleCupOne (φ ψ : singularOneCocycles X) : singularTwoCocycles X :=
  ⟨singularCochainCupOne φ.1 ψ.1,
    singularCochainCupOne_cocycle ⟨φ.1, φ.2⟩ ⟨ψ.1, ψ.2⟩⟩

@[simp]
theorem singularCocycleCupOne_coe (φ ψ : singularOneCocycles X) :
    (singularCocycleCupOne φ ψ).1 = singularCochainCupOne φ.1 ψ.1 := rfl

/-- The cocycle cup product is bilinear over the integers. -/
def singularCocycleCupOneBilinear (X : TopCat) :
    singularOneCocycles X →ₗ[ℤ] singularOneCocycles X →ₗ[ℤ] singularTwoCocycles X where
  toFun φ :=
    { toFun := singularCocycleCupOne φ
      map_add' ψ χ := by
        apply Subtype.ext
        exact singularCochainCupOne_add_right φ.1 ψ.1 χ.1
      map_smul' c ψ := by
        apply Subtype.ext
        apply integralSingularCochain_ext
        intro σ
        simp [singularCochainCupOne, mul_left_comm] }
  map_add' φ ψ := by
    ext χ : 1
    apply Subtype.ext
    exact singularCochainCupOne_add_left φ.1 ψ.1 χ.1
  map_smul' c φ := by
    ext ψ : 1
    apply Subtype.ext
    apply integralSingularCochain_ext
    intro σ
    simp [singularCochainCupOne, mul_assoc]

@[simp]
theorem singularCocycleCupOneBilinear_apply (φ ψ : singularOneCocycles X) :
    singularCocycleCupOneBilinear X φ ψ = singularCocycleCupOne φ ψ := rfl

/-- The degree-two class of the cup of two one-cocycles. -/
def singularCocycleCupOneClass (X : TopCat) :
    singularOneCocycles X →ₗ[ℤ] singularOneCocycles X →ₗ[ℤ]
      IntegralSingularCohomology X 2 :=
  (singularCocycleCupOneBilinear X).compr₂ₛₗ (singularSecondCohomologyClass X)

@[simp]
theorem singularCocycleCupOneClass_apply (φ ψ : singularOneCocycles X) :
    singularCocycleCupOneClass X φ ψ =
      singularSecondCohomologyClass X (singularCocycleCupOne φ ψ) := rfl

@[simp]
theorem singularCocycleCupOneClass_coboundary_left
    (φ : IntegralSingularCochain X 0) (ψ : singularOneCocycles X) :
    singularCocycleCupOneClass X (singularCoboundaryToOneCocycles X φ) ψ = 0 := by
  apply (singularSecondCohomologyClass_eq_zero_iff X _).mpr
  obtain ⟨η, hη⟩ := singularCochainCupOne_coboundary_left φ ψ
  exact ⟨η, Subtype.ext hη⟩

@[simp]
theorem singularCocycleCupOneClass_coboundary_right
    (φ : singularOneCocycles X) (ψ : IntegralSingularCochain X 0) :
    singularCocycleCupOneClass X φ (singularCoboundaryToOneCocycles X ψ) = 0 := by
  apply (singularSecondCohomologyClass_eq_zero_iff X _).mpr
  obtain ⟨η, hη⟩ := singularCochainCupOne_coboundary_right φ ψ
  exact ⟨η, Subtype.ext hη⟩

private theorem singularCocycleCupOneClass_comp_coboundary
    (φ : singularOneCocycles X) :
    (singularCocycleCupOneClass X φ).comp (singularCoboundaryToOneCocycles X) = 0 := by
  ext ψ
  exact singularCocycleCupOneClass_coboundary_right φ ψ

private def singularCohomologyCupOneRight (X : TopCat) :
    singularOneCocycles X →ₗ[ℤ] IntegralSingularCohomology X 1 →ₗ[ℤ]
      IntegralSingularCohomology X 2 where
  toFun φ := singularFirstCohomologyDesc X (singularCocycleCupOneClass X φ)
    (singularCocycleCupOneClass_comp_coboundary φ)
  map_add' φ ψ := by
    ext c
    obtain ⟨χ, rfl⟩ := singularFirstCohomologyClass_surjective X c
    simp only [LinearMap.add_apply, singularFirstCohomologyDesc_class, map_add]
  map_smul' c φ := by
    ext d
    obtain ⟨ψ, rfl⟩ := singularFirstCohomologyClass_surjective X d
    change singularFirstCohomologyDesc X _ _ (singularFirstCohomologyClass X ψ) =
      c • singularFirstCohomologyDesc X _
        (singularCocycleCupOneClass_comp_coboundary φ) (singularFirstCohomologyClass X ψ)
    rw [singularFirstCohomologyDesc_class, singularFirstCohomologyDesc_class]
    exact congrArg (fun f => f ψ) ((singularCocycleCupOneClass X).map_smul c φ)

private theorem singularCohomologyCupOneRight_comp_coboundary (X : TopCat) :
    (singularCohomologyCupOneRight X).comp (singularCoboundaryToOneCocycles X) = 0 := by
  ext φ c
  obtain ⟨ψ, rfl⟩ := singularFirstCohomologyClass_surjective X c
  change singularFirstCohomologyDesc X _
    (singularCocycleCupOneClass_comp_coboundary _) (singularFirstCohomologyClass X ψ) = 0
  rw [singularFirstCohomologyDesc_class]
  exact singularCocycleCupOneClass_coboundary_left φ ψ

/-- The bilinear integral singular cup product `H¹(X, ℤ) × H¹(X, ℤ) → H²(X, ℤ)`. -/
def singularCohomologyCupOne (X : TopCat) :
    IntegralSingularCohomology X 1 →ₗ[ℤ] IntegralSingularCohomology X 1 →ₗ[ℤ]
      IntegralSingularCohomology X 2 :=
  singularFirstCohomologyDesc X (singularCohomologyCupOneRight X)
    (singularCohomologyCupOneRight_comp_coboundary X)

/-- The descended cup is represented by the Alexander--Whitney cup cochain. -/
@[simp]
theorem singularCohomologyCupOne_class (φ ψ : singularOneCocycles X) :
    singularCohomologyCupOne X
        (singularFirstCohomologyClass X φ) (singularFirstCohomologyClass X ψ) =
      singularSecondCohomologyClass X (singularCocycleCupOne φ ψ) := by
  simp only [singularCohomologyCupOne, singularFirstCohomologyDesc_class]
  change singularFirstCohomologyDesc X _
    (singularCocycleCupOneClass_comp_coboundary φ) (singularFirstCohomologyClass X ψ) = _
  rw [singularFirstCohomologyDesc_class, singularCocycleCupOneClass_apply]

end Mumford.Analytic
