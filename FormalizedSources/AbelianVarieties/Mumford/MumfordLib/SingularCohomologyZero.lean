/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomologyDegrees

/-!
# Integral singular cohomology in degree zero and uniform descent

There are no coboundaries in degree zero, so the zeroth cohomology of the
integral singular cochain complex is its module of zero-cocycles. Together with
the positive-degree quotient comparison, this gives a class map and its linear
universal property in every degree. These are used to include degree zero in
the integral cup product of Mumford, Chapter I, Section 1, p. 3.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory

namespace Mumford.Analytic

private def singularZeroCochainShortComplex (X : TopCat) :
    ShortComplex (ModuleCat ℤ) :=
  ShortComplex.moduleCatMk (0 : IntegralSingularCochain X 0 →ₗ[ℤ]
    IntegralSingularCochain X 0) (singularCochainDifferential X 0) (by simp)

private def singularZeroCochainShortComplexIso (X : TopCat) :
    (integralSingularCochainComplex X).sc' 0 0 1 ≅
      singularZeroCochainShortComplex X := by
  refine ShortComplex.isoMk (Iso.refl _) (Iso.refl _) (Iso.refl _) ?_ ?_
  · change 𝟙 _ ≫ 0 = (integralSingularCochainComplex X).d 0 0 ≫ 𝟙 _
    simp
  · change 𝟙 _ ≫ ModuleCat.ofHom (singularCochainDifferential X 0) =
      (integralSingularCochainComplex X).d 0 1 ≫ 𝟙 _
    simp [integralSingularCochainComplex, CochainComplex.of.d]

/-- Degree-zero singular cohomology is the module of zero-cocycles. -/
def singularZeroCohomologyIso (X : TopCat) :
    IntegralSingularCohomology X 0 ≅ ModuleCat.of ℤ (singularCocycles X 0) :=
  (integralSingularCochainComplex X).isoHomologyπ₀.symm ≪≫
    (ShortComplex.cyclesFunctor (ModuleCat ℤ)).mapIso
      ((integralSingularCochainComplex X).isoSc' 0 0 1 (by simp)
        ((ComplexShape.up ℕ).next_eq' rfl) ≪≫ singularZeroCochainShortComplexIso X) ≪≫
    (singularZeroCochainShortComplex X).moduleCatCyclesIso

/-- The coboundaries inside the cocycle module, including the zero boundary
module in degree zero. -/
def singularCoboundaries (X : TopCat) : (n : ℕ) → Submodule ℤ (singularCocycles X n)
  | 0 => ⊥
  | n + 1 => LinearMap.range (singularCoboundaryToCocycles X n)

@[simp]
theorem singularCoboundaries_zero (X : TopCat) : singularCoboundaries X 0 = ⊥ := rfl

@[simp]
theorem singularCoboundaries_succ (X : TopCat) (n : ℕ) :
    singularCoboundaries X (n + 1) =
      LinearMap.range (singularCoboundaryToCocycles X n) := rfl

/-- The singular cohomology class of a cocycle in any degree. -/
def singularCohomologyClass (X : TopCat) :
    (n : ℕ) → singularCocycles X n →ₗ[ℤ] IntegralSingularCohomology X n
  | 0 => (singularZeroCohomologyIso X).inv.hom
  | n + 1 => singularPositiveCohomologyClass X n

@[simp]
theorem singularCohomologyClass_zero (X : TopCat) :
    singularCohomologyClass X 0 = (singularZeroCohomologyIso X).inv.hom := rfl

@[simp]
theorem singularCohomologyClass_succ (X : TopCat) (n : ℕ) :
    singularCohomologyClass X (n + 1) = singularPositiveCohomologyClass X n := rfl

/-- Every integral singular cohomology class has a cocycle representative. -/
theorem singularCohomologyClass_surjective (X : TopCat) (n : ℕ) :
    Function.Surjective (singularCohomologyClass X n) := by
  cases n with
  | zero =>
    intro c
    exact ⟨(singularZeroCohomologyIso X).hom c,
      ConcreteCategory.congr_hom (singularZeroCohomologyIso X).hom_inv_id c⟩
  | succ n => exact singularPositiveCohomologyClass_surjective X n

/-- A cocycle represents zero exactly when it is a coboundary. -/
theorem singularCohomologyClass_eq_zero_iff (X : TopCat) (n : ℕ)
    (φ : singularCocycles X n) :
    singularCohomologyClass X n φ = 0 ↔ φ ∈ singularCoboundaries X n := by
  cases n with
  | zero =>
    change (singularZeroCohomologyIso X).inv φ = 0 ↔ φ ∈ (⊥ : Submodule ℤ _)
    rw [Submodule.mem_bot]
    constructor
    · intro h
      have h' := congrArg (singularZeroCohomologyIso X).hom h
      simpa using h'
    · rintro rfl
      exact map_zero _
  | succ n => exact singularPositiveCohomologyClass_eq_zero_iff X n φ

@[simp]
theorem singularCohomologyClass_coboundary (X : TopCat) (n : ℕ)
    (φ : IntegralSingularCochain X n) :
    singularCohomologyClass X (n + 1) (singularCoboundaryToCocycles X n φ) = 0 :=
  singularPositiveCohomologyClass_coboundary X n φ

/-- A linear map on cocycles descends if it vanishes on coboundaries. -/
def singularCohomologyDesc (X : TopCat) (n : ℕ)
    {M : Type*} [AddCommGroup M] [Module ℤ M]
    (f : singularCocycles X n →ₗ[ℤ] M)
    (hf : singularCoboundaries X n ≤ LinearMap.ker f) :
    IntegralSingularCohomology X n →ₗ[ℤ] M :=
  match n with
  | 0 => f.comp (singularZeroCohomologyIso X).hom.hom
  | n + 1 => singularPositiveCohomologyDesc X n f (LinearMap.range_le_ker_iff.mp hf)

@[simp]
theorem singularCohomologyDesc_class (X : TopCat) (n : ℕ)
    {M : Type*} [AddCommGroup M] [Module ℤ M]
    (f : singularCocycles X n →ₗ[ℤ] M)
    (hf : singularCoboundaries X n ≤ LinearMap.ker f) (φ : singularCocycles X n) :
    singularCohomologyDesc X n f hf (singularCohomologyClass X n φ) = f φ := by
  cases n with
  | zero =>
    change f ((singularZeroCohomologyIso X).hom ((singularZeroCohomologyIso X).inv φ)) = f φ
    exact congrArg f (ConcreteCategory.congr_hom (singularZeroCohomologyIso X).inv_hom_id φ)
  | succ n =>
    exact singularPositiveCohomologyDesc_class X n f (LinearMap.range_le_ker_iff.mp hf) φ

@[simp]
theorem singularCohomologyDesc_succ (X : TopCat) (n : ℕ)
    {M : Type*} [AddCommGroup M] [Module ℤ M]
    (f : singularCocycles X (n + 1) →ₗ[ℤ] M)
    (hf : singularCoboundaries X (n + 1) ≤ LinearMap.ker f) :
    singularCohomologyDesc X (n + 1) f hf =
      singularPositiveCohomologyDesc X n f (LinearMap.range_le_ker_iff.mp hf) := rfl

/-- Linear maps from singular cohomology are determined on cocycle classes. -/
theorem singularCohomology_hom_ext (X : TopCat) (n : ℕ)
    {M : Type*} [AddCommGroup M] [Module ℤ M]
    {f g : IntegralSingularCohomology X n →ₗ[ℤ] M}
    (h : ∀ φ : singularCocycles X n,
      f (singularCohomologyClass X n φ) = g (singularCohomologyClass X n φ)) : f = g := by
  apply LinearMap.ext
  intro c
  obtain ⟨φ, rfl⟩ := singularCohomologyClass_surjective X n c
  exact h φ

end Mumford.Analytic
