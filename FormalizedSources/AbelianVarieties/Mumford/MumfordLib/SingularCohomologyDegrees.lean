/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularSecondCohomology

/-!
# Positive-degree integral singular cohomology

The concrete kernel modulo image description of singular cohomology extends
uniformly to every positive degree. The class and descent maps below use the
homology of the existing integral singular cochain complex.

This supplies the cohomological quotient interface for the integral cup product
in Mumford, *Abelian Varieties*, Chapter I, Section 1, p. 3.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory

namespace Mumford.Analytic

/-- Integral singular cocycles of degree `n`. -/
def singularCocycles (X : TopCat) (n : ℕ) :
    Submodule ℤ (IntegralSingularCochain X n) :=
  LinearMap.ker (singularCochainDifferential X n)

/-- The coboundary of a degree-`n` cochain, regarded as a cocycle. -/
def singularCoboundaryToCocycles (X : TopCat) (n : ℕ) :
    IntegralSingularCochain X n →ₗ[ℤ] singularCocycles X (n + 1) :=
  (singularCochainDifferential X n).codRestrict _
    (fun φ => singularCochainCoboundary_squared φ)

private def singularPositiveCochainShortComplex (X : TopCat) (n : ℕ) :
    ShortComplex (ModuleCat ℤ) :=
  ShortComplex.moduleCatMk (singularCochainDifferential X n)
    (singularCochainDifferential X (n + 1)) (by
      apply LinearMap.ext
      intro φ
      exact singularCochainCoboundary_squared φ)

private def singularPositiveCochainShortComplexIso (X : TopCat) (n : ℕ) :
    (integralSingularCochainComplex X).sc' n (n + 1) (n + 2) ≅
      singularPositiveCochainShortComplex X n := by
  refine ShortComplex.isoMk (Iso.refl _) (Iso.refl _) (Iso.refl _) ?_ ?_
  · change 𝟙 _ ≫ ModuleCat.ofHom (singularCochainDifferential X n) =
      (integralSingularCochainComplex X).d n (n + 1) ≫ 𝟙 _
    simp only [Category.id_comp, Category.comp_id, integralSingularCochainComplex,
      CochainComplex.of_d]
  · change 𝟙 _ ≫ ModuleCat.ofHom (singularCochainDifferential X (n + 1)) =
      (integralSingularCochainComplex X).d (n + 1) ((n + 1) + 1) ≫ 𝟙 _
    simp only [Category.id_comp, Category.comp_id, integralSingularCochainComplex,
      CochainComplex.of_d]

/-- The cocycle quotient computes singular cohomology in degree `n + 1`. -/
def singularPositiveCohomologyIso (X : TopCat) (n : ℕ) :
    IntegralSingularCohomology X (n + 1) ≅ ModuleCat.of ℤ
      (singularCocycles X (n + 1) ⧸
        LinearMap.range (singularCoboundaryToCocycles X n)) :=
  (ShortComplex.homologyFunctor (ModuleCat ℤ)).mapIso
    ((integralSingularCochainComplex X).isoSc' n (n + 1) (n + 2)
      ((ComplexShape.up ℕ).prev_eq' rfl) ((ComplexShape.up ℕ).next_eq' rfl) ≪≫
      singularPositiveCochainShortComplexIso X n) ≪≫
    (singularPositiveCochainShortComplex X n).moduleCatHomologyIso

/-- The singular cohomology class of a positive-degree cocycle. -/
def singularPositiveCohomologyClass (X : TopCat) (n : ℕ) :
    singularCocycles X (n + 1) →ₗ[ℤ] IntegralSingularCohomology X (n + 1) :=
  (singularPositiveCohomologyIso X n).inv.hom.comp
    (LinearMap.range (singularCoboundaryToCocycles X n)).mkQ

@[simp]
theorem singularPositiveCohomologyIso_hom_class (X : TopCat) (n : ℕ)
    (φ : singularCocycles X (n + 1)) :
    (singularPositiveCohomologyIso X n).hom (singularPositiveCohomologyClass X n φ) =
      (LinearMap.range (singularCoboundaryToCocycles X n)).mkQ φ := by
  simp only [singularPositiveCohomologyClass, LinearMap.comp_apply]
  exact ConcreteCategory.congr_hom (singularPositiveCohomologyIso X n).inv_hom_id _

/-- Every positive-degree cohomology class has a cocycle representative. -/
theorem singularPositiveCohomologyClass_surjective (X : TopCat) (n : ℕ) :
    Function.Surjective (singularPositiveCohomologyClass X n) := by
  intro c
  obtain ⟨φ, hφ⟩ :=
    (LinearMap.range (singularCoboundaryToCocycles X n)).mkQ_surjective
      ((singularPositiveCohomologyIso X n).hom c)
  refine ⟨φ, ?_⟩
  change (singularPositiveCohomologyIso X n).inv.hom
    ((LinearMap.range (singularCoboundaryToCocycles X n)).mkQ φ) = c
  rw [hφ]
  exact ConcreteCategory.congr_hom (singularPositiveCohomologyIso X n).hom_inv_id c

/-- A positive-degree cocycle represents zero precisely when it is a coboundary. -/
theorem singularPositiveCohomologyClass_eq_zero_iff (X : TopCat) (n : ℕ)
    (φ : singularCocycles X (n + 1)) :
    singularPositiveCohomologyClass X n φ = 0 ↔
      ∃ ψ : IntegralSingularCochain X n,
        singularCoboundaryToCocycles X n ψ = φ := by
  constructor
  · intro h
    have h' := congrArg (singularPositiveCohomologyIso X n).hom h
    rw [singularPositiveCohomologyIso_hom_class, map_zero] at h'
    exact (Submodule.Quotient.mk_eq_zero _).mp h'
  · rintro ⟨ψ, rfl⟩
    change (singularPositiveCohomologyIso X n).inv.hom
      ((LinearMap.range (singularCoboundaryToCocycles X n)).mkQ
        (singularCoboundaryToCocycles X n ψ)) = 0
    have h : (LinearMap.range (singularCoboundaryToCocycles X n)).mkQ
        (singularCoboundaryToCocycles X n ψ) = 0 :=
      (Submodule.Quotient.mk_eq_zero _).mpr ⟨ψ, rfl⟩
    rw [h, map_zero]

@[simp]
theorem singularPositiveCohomologyClass_coboundary (X : TopCat) (n : ℕ)
    (φ : IntegralSingularCochain X n) :
    singularPositiveCohomologyClass X n (singularCoboundaryToCocycles X n φ) = 0 :=
  (singularPositiveCohomologyClass_eq_zero_iff X n _).mpr ⟨φ, rfl⟩

/-- Cocycles define the same class exactly when their difference is a coboundary. -/
theorem singularPositiveCohomologyClass_eq_iff (X : TopCat) (n : ℕ)
    (φ ψ : singularCocycles X (n + 1)) :
    singularPositiveCohomologyClass X n φ = singularPositiveCohomologyClass X n ψ ↔
      ∃ θ : IntegralSingularCochain X n,
        singularCoboundaryToCocycles X n θ = φ - ψ := by
  rw [← sub_eq_zero, ← map_sub, singularPositiveCohomologyClass_eq_zero_iff]

/-- A linear cocycle map descends when it annihilates coboundaries. -/
def singularPositiveCohomologyDesc (X : TopCat) (n : ℕ)
    {M : Type*} [AddCommGroup M] [Module ℤ M]
    (f : singularCocycles X (n + 1) →ₗ[ℤ] M)
    (hf : f.comp (singularCoboundaryToCocycles X n) = 0) :
    IntegralSingularCohomology X (n + 1) →ₗ[ℤ] M :=
  ((LinearMap.range (singularCoboundaryToCocycles X n)).liftQ f
    (LinearMap.range_le_ker_iff.mpr hf)).comp (singularPositiveCohomologyIso X n).hom.hom

@[simp]
theorem singularPositiveCohomologyDesc_class (X : TopCat) (n : ℕ)
    {M : Type*} [AddCommGroup M] [Module ℤ M]
    (f : singularCocycles X (n + 1) →ₗ[ℤ] M)
    (hf : f.comp (singularCoboundaryToCocycles X n) = 0)
    (φ : singularCocycles X (n + 1)) :
    singularPositiveCohomologyDesc X n f hf
      (singularPositiveCohomologyClass X n φ) = f φ := by
  change ((LinearMap.range (singularCoboundaryToCocycles X n)).liftQ f
    (LinearMap.range_le_ker_iff.mpr hf))
    ((singularPositiveCohomologyIso X n).hom
      (singularPositiveCohomologyClass X n φ)) = f φ
  rw [singularPositiveCohomologyIso_hom_class]
  rfl

/-- Linear maps out of positive-degree cohomology are determined on cocycle classes. -/
theorem singularPositiveCohomology_hom_ext (X : TopCat) (n : ℕ)
    {M : Type*} [AddCommGroup M] [Module ℤ M]
    {f g : IntegralSingularCohomology X (n + 1) →ₗ[ℤ] M}
    (h : ∀ φ : singularCocycles X (n + 1),
      f (singularPositiveCohomologyClass X n φ) =
        g (singularPositiveCohomologyClass X n φ)) : f = g := by
  ext c
  obtain ⟨φ, rfl⟩ := singularPositiveCohomologyClass_surjective X n c
  exact h φ

/-- The general quotient comparison recovers the degree-one comparison. -/
@[simp]
theorem singularPositiveCohomologyIso_zero (X : TopCat) :
    singularPositiveCohomologyIso X 0 = singularFirstCohomologyIso X := by
  have h : singularPositiveCochainShortComplexIso X 0 = Iso.refl _ := by
    ext <;> rfl
  simp only [singularPositiveCohomologyIso, h]
  rfl

/-- The general quotient comparison recovers the degree-two comparison. -/
@[simp]
theorem singularPositiveCohomologyIso_one (X : TopCat) :
    singularPositiveCohomologyIso X 1 = singularSecondCohomologyIso X := by
  have h : singularPositiveCochainShortComplexIso X 1 = Iso.refl _ := by
    ext <;> rfl
  simp only [singularPositiveCohomologyIso, h]
  rfl

@[simp]
theorem singularPositiveCohomologyClass_zero (X : TopCat) :
    singularPositiveCohomologyClass X 0 = singularFirstCohomologyClass X := by
  simp only [singularPositiveCohomologyClass, singularPositiveCohomologyIso_zero]
  rfl

@[simp]
theorem singularPositiveCohomologyClass_one (X : TopCat) :
    singularPositiveCohomologyClass X 1 = singularSecondCohomologyClass X := by
  simp only [singularPositiveCohomologyClass, singularPositiveCohomologyIso_one]
  rfl

@[simp]
theorem singularPositiveCohomologyDesc_zero (X : TopCat)
    {M : Type*} [AddCommGroup M] [Module ℤ M]
    (f : singularCocycles X 1 →ₗ[ℤ] M)
    (hf : f.comp (singularCoboundaryToCocycles X 0) = 0) :
    singularPositiveCohomologyDesc X 0 f hf = singularFirstCohomologyDesc X f hf := by
  simp only [singularPositiveCohomologyDesc, singularPositiveCohomologyIso_zero]
  rfl

end Mumford.Analytic
