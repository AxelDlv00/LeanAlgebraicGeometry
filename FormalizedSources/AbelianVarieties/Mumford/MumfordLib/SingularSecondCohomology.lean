/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomology

/-!
# Degree-two integral singular cohomology

The degree-one quotient construction is useful on its own, but the cup of two
one-cocycles naturally lands in degree two.  This file exposes the same
kernel-modulo-image interface in that degree, so the cup cocycle producer can
be consumed by later Kunneth and exterior-algebra arguments.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory

namespace Mumford.Analytic

variable {X : TopCat}

/-- Integral singular two-cocycles. -/
def singularTwoCocycles (X : TopCat) :
    Submodule ℤ (IntegralSingularCochain X 2) :=
  LinearMap.ker (singularCochainDifferential X 2)

/-- Degree-two coboundaries, regarded as two-cocycles. -/
def singularCoboundaryToTwoCocycles (X : TopCat) :
    IntegralSingularCochain X 1 →ₗ[ℤ] singularTwoCocycles X :=
  (singularCochainDifferential X 1).codRestrict _
    (fun φ => singularCochainCoboundary_squared φ)

/-- The concrete quotient computes degree-two singular cohomology. -/
def singularSecondCohomologyIso (X : TopCat) :
    IntegralSingularCohomology X 2 ≅ ModuleCat.of ℤ
      (singularTwoCocycles X ⧸ LinearMap.range (singularCoboundaryToTwoCocycles X)) := by
  exact (ShortComplex.homologyFunctor (ModuleCat ℤ)).mapIso
    ((integralSingularCochainComplex X).isoSc' 1 2 3
      ((ComplexShape.up ℕ).prev_eq' rfl) ((ComplexShape.up ℕ).next_eq' rfl)) ≪≫
    ((integralSingularCochainComplex X).sc' 1 2 3).moduleCatHomologyIso

/-- The class represented by an integral singular two-cocycle. -/
def singularSecondCohomologyClass (X : TopCat) :
    singularTwoCocycles X →ₗ[ℤ] IntegralSingularCohomology X 2 :=
  (singularSecondCohomologyIso X).inv.hom.comp
    (LinearMap.range (singularCoboundaryToTwoCocycles X)).mkQ

@[simp]
theorem singularSecondCohomologyIso_hom_class
    (X : TopCat) (φ : singularTwoCocycles X) :
    (singularSecondCohomologyIso X).hom (singularSecondCohomologyClass X φ) =
      (LinearMap.range (singularCoboundaryToTwoCocycles X)).mkQ φ := by
  simp only [singularSecondCohomologyClass, LinearMap.comp_apply]
  exact ConcreteCategory.congr_hom (singularSecondCohomologyIso X).inv_hom_id _

/-- Every degree-two class has a cocycle representative. -/
theorem singularSecondCohomologyClass_surjective (X : TopCat) :
    Function.Surjective (singularSecondCohomologyClass X) := by
  intro c
  obtain ⟨φ, hφ⟩ :=
    (LinearMap.range (singularCoboundaryToTwoCocycles X)).mkQ_surjective
      ((singularSecondCohomologyIso X).hom c)
  refine ⟨φ, ?_⟩
  change (singularSecondCohomologyIso X).inv.hom
    ((LinearMap.range (singularCoboundaryToTwoCocycles X)).mkQ φ) = c
  rw [hφ]
  exact ConcreteCategory.congr_hom (singularSecondCohomologyIso X).hom_inv_id c

/-- A two-cocycle represents zero precisely when it is a coboundary. -/
theorem singularSecondCohomologyClass_eq_zero_iff (X : TopCat)
    (φ : singularTwoCocycles X) :
    singularSecondCohomologyClass X φ = 0 ↔
      ∃ ψ : IntegralSingularCochain X 1,
        singularCoboundaryToTwoCocycles X ψ = φ := by
  constructor
  · intro h
    have h' := congrArg (singularSecondCohomologyIso X).hom h
    rw [singularSecondCohomologyIso_hom_class, map_zero] at h'
    exact (Submodule.Quotient.mk_eq_zero _).mp h'
  · rintro ⟨ψ, rfl⟩
    change (singularSecondCohomologyIso X).inv.hom
      ((LinearMap.range (singularCoboundaryToTwoCocycles X)).mkQ
        (singularCoboundaryToTwoCocycles X ψ)) = 0
    have h : (LinearMap.range (singularCoboundaryToTwoCocycles X)).mkQ
        (singularCoboundaryToTwoCocycles X ψ) = 0 :=
      (Submodule.Quotient.mk_eq_zero _).mpr ⟨ψ, rfl⟩
    rw [h, map_zero]

end Mumford.Analytic
