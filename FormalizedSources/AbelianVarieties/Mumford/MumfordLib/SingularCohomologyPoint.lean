/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomologyDegrees
import MumfordLib.SingularCupProductGeneral

/-!
# Positive-degree singular cohomology of a point

On a subsingleton space, every positive-degree integral singular cocycle is a
coboundary. Evaluating on degenerate simplices supplies an explicit primitive.
This computes the actual singular cohomology groups, including the empty space.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Opposite
open scoped Simplicial

namespace Mumford.Analytic

variable {X : TopCat} {n : ℕ}

private theorem singularSimplex_subsingleton [Subsingleton X] (n : ℕ) :
    Subsingleton ((TopCat.toSSet.obj X).obj (op ⦋n⦌)) :=
  (X.toSSetObjEquiv (op ⦋n⦌)).injective.subsingleton

/-- Every positive-degree cocycle on a subsingleton space has a primitive. -/
theorem singularCocycle_exists_primitive_of_subsingleton [Subsingleton X]
    (φ : singularCocycles X (n + 1)) :
    ∃ ψ : IntegralSingularCochain X n,
      singularCoboundaryToCocycles X n ψ = φ := by
  letI := singularSimplex_subsingleton (X := X) (n + 1)
  let ψ : IntegralSingularCochain X n := singularCochainOfSimplexFunction
    (fun σ => (singularSimplexChain ((TopCat.toSSet.obj X).σ 0 σ) ≫ φ.1).hom 1)
  refine ⟨ψ, Subtype.ext ?_⟩
  change singularCochainCoboundary ψ = φ.1
  apply integralSingularCochain_ext
  intro τ
  have hφ : singularCochainCoboundary φ.1 = 0 := φ.2
  have h := singularCochainCoboundary_eval φ.1 ((TopCat.toSSet.obj X).σ 0 τ)
  rw [hφ] at h
  simp only [Limits.comp_zero, ModuleCat.hom_zero, LinearMap.zero_apply] at h
  have hfaces (i : Fin (n + 3)) :
      (TopCat.toSSet.obj X).δ i ((TopCat.toSSet.obj X).σ 0 τ) = τ :=
    Subsingleton.elim _ _
  simp only [hfaces] at h
  rw [Fin.sum_univ_succ] at h
  simp only [Fin.val_zero, pow_zero, one_mul, Fin.val_succ, pow_succ,
    mul_neg_one, neg_mul, Finset.sum_neg_distrib] at h
  rw [singularCochainCoboundary_eval]
  have hprimitive (i : Fin (n + 2)) :
      (singularSimplexChain ((TopCat.toSSet.obj X).δ i τ) ≫ ψ).hom 1 =
        (singularSimplexChain τ ≫ φ.1).hom 1 := by
    dsimp only [ψ]
    rw [singularCochainOfSimplexFunction_eval]
    rw [Subsingleton.elim ((TopCat.toSSet.obj X).σ 0 ((TopCat.toSSet.obj X).δ i τ)) τ]
  simp only [hprimitive]
  linarith

/-- Positive-degree integral singular cohomology vanishes on a subsingleton space. -/
theorem integralSingularCohomology_eq_zero_of_subsingleton [Subsingleton X]
    (c : IntegralSingularCohomology X (n + 1)) : c = 0 := by
  obtain ⟨φ, rfl⟩ := singularPositiveCohomologyClass_surjective X n c
  exact (singularPositiveCohomologyClass_eq_zero_iff X n φ).mpr
    (singularCocycle_exists_primitive_of_subsingleton φ)

/-- Every positive-degree integral singular cohomology group of a subsingleton
space is a subsingleton. -/
theorem integralSingularCohomology_subsingleton [Subsingleton X] (n : ℕ) :
    Subsingleton (IntegralSingularCohomology X (n + 1)) := by
  refine ⟨fun c d => ?_⟩
  rw [integralSingularCohomology_eq_zero_of_subsingleton c,
    integralSingularCohomology_eq_zero_of_subsingleton d]

end Mumford.Analytic
