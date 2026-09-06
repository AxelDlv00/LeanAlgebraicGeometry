/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomologyZero
import MumfordLib.SingularCocycleCupLaws

/-!
# The integral singular cup product in every degree

The Alexander--Whitney product descends from cocycles to the cohomology of the
integral singular cochain complex in every bidegree, including degree zero.
The boundary calculations use the signed Leibniz identity. The resulting cup
extends the existing positive-degree cup and has the same cocycle formula.

This supplies the cup operation for Mumford, Chapter I, Section 1, p. 3;
the exterior-algebra comparison requires further results.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory

namespace Mumford.Analytic

variable {X : TopCat} {p q n : ℕ}

/-- The cohomology class of a cup of cocycles, in any bidegree. -/
def singularCocycleCupClassAll (X : TopCat) (p q n : ℕ) (h : p + q = n) :
    singularCocycles X p →ₗ[ℤ] singularCocycles X q →ₗ[ℤ]
      IntegralSingularCohomology X n :=
  (singularCocycleCupBilinear X p q n h).compr₂ₛₗ (singularCohomologyClass X n)

@[simp]
theorem singularCocycleCupClassAll_apply (φ : singularCocycles X p)
    (ψ : singularCocycles X q) (h : p + q = n) :
    singularCocycleCupClassAll X p q n h φ ψ =
      singularCohomologyClass X n (singularCocycleCup φ ψ h) := rfl

@[simp]
theorem singularCocycleCupClassAll_coboundary_left (φ : IntegralSingularCochain X p)
    (ψ : singularCocycles X q) (h : (p + 1) + q = n) :
    singularCocycleCupClassAll X (p + 1) q n h
      (singularCoboundaryToCocycles X p φ) ψ = 0 := by
  cases n with
  | zero => omega
  | succ n =>
    apply (singularCohomologyClass_eq_zero_iff X (n + 1) _).mpr
    refine ⟨singularCochainCup φ ψ.1 (by omega), ?_⟩
    apply Subtype.ext
    exact singularCochainCup_coboundary_left φ ⟨ψ.1, ψ.2⟩ (by omega)

@[simp]
theorem singularCocycleCupClassAll_coboundary_right (φ : singularCocycles X p)
    (ψ : IntegralSingularCochain X q) (h : p + (q + 1) = n) :
    singularCocycleCupClassAll X p (q + 1) n h
      φ (singularCoboundaryToCocycles X q ψ) = 0 := by
  cases n with
  | zero => omega
  | succ n =>
    apply (singularCohomologyClass_eq_zero_iff X (n + 1) _).mpr
    refine ⟨(-1 : ℤ) ^ p • singularCochainCup φ.1 ψ (by omega), ?_⟩
    apply Subtype.ext
    exact singularCochainCup_coboundary_right ⟨φ.1, φ.2⟩ ψ (by omega)

private theorem singularCocycleCupClassAll_boundary_right (h : p + q = n)
    (φ : singularCocycles X p) :
    singularCoboundaries X q ≤ LinearMap.ker (singularCocycleCupClassAll X p q n h φ) := by
  cases q with
  | zero => exact bot_le
  | succ q =>
    rintro ψ ⟨θ, rfl⟩
    exact singularCocycleCupClassAll_coboundary_right φ θ h

private theorem singularCocycleCupClassAll_boundary_left (h : p + q = n)
    (φ : singularCocycles X p) (hφ : φ ∈ singularCoboundaries X p)
    (ψ : singularCocycles X q) : singularCocycleCupClassAll X p q n h φ ψ = 0 := by
  cases p with
  | zero =>
    have hzero : φ = 0 := hφ
    rw [hzero, map_zero]
    rfl
  | succ p =>
    obtain ⟨θ, rfl⟩ := hφ
    exact singularCocycleCupClassAll_coboundary_left θ ψ h

private def singularCohomologyCupAllRight (X : TopCat) (p q n : ℕ) (h : p + q = n) :
    singularCocycles X p →ₗ[ℤ] IntegralSingularCohomology X q →ₗ[ℤ]
      IntegralSingularCohomology X n where
  toFun φ := singularCohomologyDesc X q (singularCocycleCupClassAll X p q n h φ)
    (singularCocycleCupClassAll_boundary_right h φ)
  map_add' φ ψ := by
    apply singularCohomology_hom_ext X q
    intro χ
    simp only [LinearMap.add_apply, singularCohomologyDesc_class, map_add]
  map_smul' c φ := by
    apply singularCohomology_hom_ext X q
    intro ψ
    change singularCohomologyDesc X q _ _ (singularCohomologyClass X q ψ) =
      c • singularCohomologyDesc X q _
        (singularCocycleCupClassAll_boundary_right h φ) (singularCohomologyClass X q ψ)
    rw [singularCohomologyDesc_class, singularCohomologyDesc_class]
    exact congrArg (fun f => f ψ) ((singularCocycleCupClassAll X p q n h).map_smul c φ)

private theorem singularCohomologyCupAllRight_boundary (X : TopCat) (p q n : ℕ)
    (h : p + q = n) :
    singularCoboundaries X p ≤ LinearMap.ker (singularCohomologyCupAllRight X p q n h) := by
  intro φ hφ
  apply singularCohomology_hom_ext X q
  intro ψ
  change singularCohomologyDesc X q _
    (singularCocycleCupClassAll_boundary_right h φ) (singularCohomologyClass X q ψ) = 0
  rw [singularCohomologyDesc_class]
  exact singularCocycleCupClassAll_boundary_left h φ hφ ψ

/-- The bilinear integral singular cup product in any two degrees. -/
def singularCohomologyCup (X : TopCat) (p q n : ℕ) (h : p + q = n) :
    IntegralSingularCohomology X p →ₗ[ℤ] IntegralSingularCohomology X q →ₗ[ℤ]
      IntegralSingularCohomology X n :=
  singularCohomologyDesc X p (singularCohomologyCupAllRight X p q n h)
    (singularCohomologyCupAllRight_boundary X p q n h)

/-- The descended cup is represented by the Alexander--Whitney cup of cocycles. -/
@[simp]
theorem singularCohomologyCup_class (φ : singularCocycles X p)
    (ψ : singularCocycles X q) (h : p + q = n) :
    singularCohomologyCup X p q n h
        (singularCohomologyClass X p φ) (singularCohomologyClass X q ψ) =
      singularCohomologyClass X n (singularCocycleCup φ ψ h) := by
  simp only [singularCohomologyCup, singularCohomologyDesc_class]
  change singularCohomologyDesc X q _
    (singularCocycleCupClassAll_boundary_right h φ) (singularCohomologyClass X q ψ) = _
  rw [singularCohomologyDesc_class, singularCocycleCupClassAll_apply]

/-- The all-degree cup agrees with the established positive-degree cup. -/
@[simp]
theorem singularCohomologyCup_succ_succ (X : TopCat) (p q : ℕ) :
    singularCohomologyCup X (p + 1) (q + 1) (p + q + 2) (by omega) =
      singularPositiveCohomologyCup X p q := by
  apply singularCohomology_hom_ext X (p + 1)
  intro φ
  apply singularCohomology_hom_ext X (q + 1)
  intro ψ
  rw [singularCohomologyCup_class]
  exact (singularPositiveCohomologyCup_class φ ψ).symm

/-- The all-degree cup recovers the degree-one cup used for alternating products. -/
@[simp]
theorem singularCohomologyCup_one_one (X : TopCat) :
    singularCohomologyCup X 1 1 2 rfl = singularCohomologyCupOne X := by
  exact (singularCohomologyCup_succ_succ X 0 0).trans
    (singularPositiveCohomologyCup_zero_zero X)

end Mumford.Analytic
