/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCochains
import Mathlib.Algebra.Homology.ShortComplex.ModuleCat

/-!
# Integral singular cohomology

The dual of the integral singular chain differential forms a cochain complex.
Its homology is integral singular cohomology. In degree one, the concrete
kernel modulo image description gives the cocycle class and descent maps.

Reference: Mumford, *Abelian Varieties*, Chapter I, Section 1, p. 3, the
degree-one step in the integral-cohomology assertion.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory

namespace Mumford.Analytic

/-- The singular coboundary as an integral linear map. -/
def singularCochainDifferential (X : TopCat) (n : ℕ) :
    IntegralSingularCochain X n →ₗ[ℤ] IntegralSingularCochain X (n + 1) where
  toFun := singularCochainCoboundary
  map_add' φ ψ := by simp [singularCochainCoboundary]
  map_smul' c φ := by simp [singularCochainCoboundary]

/-- The integral singular cochain complex, with terms `Hom(C_n(X), ℤ)`. -/
def integralSingularCochainComplex (X : TopCat) : CochainComplex (ModuleCat ℤ) ℕ :=
  CochainComplex.of (fun n => ModuleCat.of ℤ (IntegralSingularCochain X n))
    (fun n => ModuleCat.ofHom (singularCochainDifferential X n)) (by
      intro n
      apply ModuleCat.hom_ext
      apply LinearMap.ext
      intro φ
      exact singularCochainCoboundary_squared φ)

/-- Integral singular cohomology, defined by the homology of the dual complex. -/
abbrev IntegralSingularCohomology (X : TopCat) (n : ℕ) : ModuleCat ℤ :=
  (integralSingularCochainComplex X).homology n

/-- The submodule of integral singular one-cocycles. -/
def singularOneCocycles (X : TopCat) : Submodule ℤ (IntegralSingularCochain X 1) :=
  LinearMap.ker (singularCochainDifferential X 1)

/-- Coboundaries, regarded as one-cocycles. -/
def singularCoboundaryToOneCocycles (X : TopCat) :
    IntegralSingularCochain X 0 →ₗ[ℤ] singularOneCocycles X :=
  (singularCochainDifferential X 0).codRestrict _
    (fun φ => singularCochainCoboundary_squared φ)

/-- The concrete cocycle quotient computes the homology of the singular
cochain complex in degree one. -/
def singularFirstCohomologyIso (X : TopCat) :
    IntegralSingularCohomology X 1 ≅ ModuleCat.of ℤ
      (singularOneCocycles X ⧸ LinearMap.range (singularCoboundaryToOneCocycles X)) := by
  exact (ShortComplex.homologyFunctor (ModuleCat ℤ)).mapIso
    ((integralSingularCochainComplex X).isoSc' 0 1 2
      ((ComplexShape.up ℕ).prev_eq' rfl) ((ComplexShape.up ℕ).next_eq' rfl)) ≪≫
    ((integralSingularCochainComplex X).sc' 0 1 2).moduleCatHomologyIso

/-- The cohomology class of an integral singular one-cocycle. -/
def singularFirstCohomologyClass (X : TopCat) :
    singularOneCocycles X →ₗ[ℤ] IntegralSingularCohomology X 1 :=
  (singularFirstCohomologyIso X).inv.hom.comp
    (LinearMap.range (singularCoboundaryToOneCocycles X)).mkQ

@[simp]
theorem singularFirstCohomologyIso_hom_class (X : TopCat) (φ : singularOneCocycles X) :
    (singularFirstCohomologyIso X).hom (singularFirstCohomologyClass X φ) =
      (LinearMap.range (singularCoboundaryToOneCocycles X)).mkQ φ := by
  simp only [singularFirstCohomologyClass, LinearMap.comp_apply]
  exact ConcreteCategory.congr_hom (singularFirstCohomologyIso X).inv_hom_id _

/-- Every cohomology class has a cocycle representative. -/
theorem singularFirstCohomologyClass_surjective (X : TopCat) :
    Function.Surjective (singularFirstCohomologyClass X) := by
  intro c
  obtain ⟨φ, hφ⟩ :=
    (LinearMap.range (singularCoboundaryToOneCocycles X)).mkQ_surjective
      ((singularFirstCohomologyIso X).hom c)
  refine ⟨φ, ?_⟩
  change (singularFirstCohomologyIso X).inv.hom
    ((LinearMap.range (singularCoboundaryToOneCocycles X)).mkQ φ) = c
  rw [hφ]
  exact ConcreteCategory.congr_hom (singularFirstCohomologyIso X).hom_inv_id c

/-- A one-cocycle represents zero precisely when it is a coboundary. -/
theorem singularFirstCohomologyClass_eq_zero_iff (X : TopCat)
    (φ : singularOneCocycles X) :
    singularFirstCohomologyClass X φ = 0 ↔
      ∃ ψ : IntegralSingularCochain X 0, singularCoboundaryToOneCocycles X ψ = φ := by
  constructor
  · intro h
    have h' := congrArg (singularFirstCohomologyIso X).hom h
    rw [singularFirstCohomologyIso_hom_class, map_zero] at h'
    exact (Submodule.Quotient.mk_eq_zero _).mp h'
  · rintro ⟨ψ, rfl⟩
    change (singularFirstCohomologyIso X).inv.hom
      ((LinearMap.range (singularCoboundaryToOneCocycles X)).mkQ
        (singularCoboundaryToOneCocycles X ψ)) = 0
    have h : (LinearMap.range (singularCoboundaryToOneCocycles X)).mkQ
        (singularCoboundaryToOneCocycles X ψ) = 0 :=
      (Submodule.Quotient.mk_eq_zero _).mpr ⟨ψ, rfl⟩
    rw [h, map_zero]

/-- Linear evaluation on cocycles descends to singular cohomology when it
annihilates coboundaries. -/
def singularFirstCohomologyDesc (X : TopCat) {M : Type*} [AddCommGroup M] [Module ℤ M]
    (f : singularOneCocycles X →ₗ[ℤ] M)
    (hf : f.comp (singularCoboundaryToOneCocycles X) = 0) :
    IntegralSingularCohomology X 1 →ₗ[ℤ] M :=
  ((LinearMap.range (singularCoboundaryToOneCocycles X)).liftQ f
    (LinearMap.range_le_ker_iff.mpr hf)).comp (singularFirstCohomologyIso X).hom.hom

@[simp]
theorem singularFirstCohomologyDesc_class (X : TopCat) {M : Type*}
    [AddCommGroup M] [Module ℤ M] (f : singularOneCocycles X →ₗ[ℤ] M)
    (hf : f.comp (singularCoboundaryToOneCocycles X) = 0)
    (φ : singularOneCocycles X) :
    singularFirstCohomologyDesc X f hf (singularFirstCohomologyClass X φ) = f φ := by
  change ((LinearMap.range (singularCoboundaryToOneCocycles X)).liftQ f
    (LinearMap.range_le_ker_iff.mpr hf))
    ((singularFirstCohomologyIso X).hom (singularFirstCohomologyClass X φ)) = f φ
  rw [singularFirstCohomologyIso_hom_class]
  rfl

end Mumford.Analytic
