/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCupProduct
import MumfordLib.SingularCohomology

/-!
# Coboundaries in the degree-one cup product

The Alexander--Whitney products in bidegrees `(0, 1)` and `(1, 0)` give
explicit primitives when either factor of a `(1, 1)` cup product is a
coboundary and the other is a cocycle. These identities allow the cup product
to descend from cocycles to cohomology classes.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Opposite AlgebraicTopology
open scoped Simplicial

namespace Mumford.Analytic

variable {X : TopCat}

/-- The Alexander--Whitney product of a zero-cochain and a one-cochain. -/
def singularCochainCupZeroOne (φ : IntegralSingularCochain X 0)
    (ψ : IntegralSingularCochain X 1) : IntegralSingularCochain X 1 :=
  singularCochainOfSimplexFunction (fun σ =>
    (singularSimplexChain ((TopCat.toSSet.obj X).δ 1 σ) ≫ φ).hom 1 *
      (singularSimplexChain σ ≫ ψ).hom 1)

/-- The Alexander--Whitney product of a one-cochain and a zero-cochain. -/
def singularCochainCupOneZero (φ : IntegralSingularCochain X 1)
    (ψ : IntegralSingularCochain X 0) : IntegralSingularCochain X 1 :=
  singularCochainOfSimplexFunction (fun σ =>
    (singularSimplexChain σ ≫ φ).hom 1 *
      (singularSimplexChain ((TopCat.toSSet.obj X).δ 0 σ) ≫ ψ).hom 1)

@[simp]
theorem singularCochainCupZeroOne_eval (φ : IntegralSingularCochain X 0)
    (ψ : IntegralSingularCochain X 1)
    (σ : (TopCat.toSSet.obj X).obj (op ⦋1⦌)) :
    (singularSimplexChain σ ≫ singularCochainCupZeroOne φ ψ).hom 1 =
      (singularSimplexChain ((TopCat.toSSet.obj X).δ 1 σ) ≫ φ).hom 1 *
        (singularSimplexChain σ ≫ ψ).hom 1 := by
  simp [singularCochainCupZeroOne]

@[simp]
theorem singularCochainCupOneZero_eval (φ : IntegralSingularCochain X 1)
    (ψ : IntegralSingularCochain X 0)
    (σ : (TopCat.toSSet.obj X).obj (op ⦋1⦌)) :
    (singularSimplexChain σ ≫ singularCochainCupOneZero φ ψ).hom 1 =
      (singularSimplexChain σ ≫ φ).hom 1 *
        (singularSimplexChain ((TopCat.toSSet.obj X).δ 0 σ) ≫ ψ).hom 1 := by
  simp [singularCochainCupOneZero]

theorem singularCochainCoboundary_zero_eval (φ : IntegralSingularCochain X 0)
    (σ : (TopCat.toSSet.obj X).obj (op ⦋1⦌)) :
    (singularSimplexChain σ ≫ singularCochainCoboundary φ).hom 1 =
      (singularSimplexChain ((TopCat.toSSet.obj X).δ 0 σ) ≫ φ).hom 1 -
        (singularSimplexChain ((TopCat.toSSet.obj X).δ 1 σ) ≫ φ).hom 1 := by
  simp [singularCochainCoboundary, ← Category.assoc]

theorem singularCochainCoboundary_one_eval (φ : IntegralSingularCochain X 1)
    (σ : (TopCat.toSSet.obj X).obj (op ⦋2⦌)) :
    (singularSimplexChain σ ≫ singularCochainCoboundary φ).hom 1 =
      (singularSimplexChain ((TopCat.toSSet.obj X).δ 0 σ) ≫ φ).hom 1 -
        (singularSimplexChain ((TopCat.toSSet.obj X).δ 1 σ) ≫ φ).hom 1 +
          (singularSimplexChain ((TopCat.toSSet.obj X).δ 2 σ) ≫ φ).hom 1 := by
  simp [singularCochainCoboundary, ← Category.assoc]

/-- The mixed cup product is an explicit primitive when the left factor
of a degree-one cup product is a coboundary. -/
theorem singularCochainCupZeroOne_coboundary (φ : IntegralSingularCochain X 0)
    (ψ : singularOneCocycles X) :
    singularCochainCoboundary (singularCochainCupZeroOne φ ψ.1) =
      singularCochainCupOne (singularCochainCoboundary φ) ψ.1 := by
  apply integralSingularCochain_ext
  intro σ
  have h10 :
      (TopCat.toSSet.obj X).δ 1 ((TopCat.toSSet.obj X).δ 0 σ) =
        (TopCat.toSSet.obj X).δ 0 ((TopCat.toSSet.obj X).δ 2 σ) := by
    simpa using congrArg (fun f => f σ)
      ((CategoryTheory.SimplicialObject.δ_comp_δ (TopCat.toSSet.obj X)
        (i := (0 : Fin 2)) (j := (1 : Fin 2)) (by decide)).symm)
  have h11 :
      (TopCat.toSSet.obj X).δ 1 ((TopCat.toSSet.obj X).δ 1 σ) =
        (TopCat.toSSet.obj X).δ 1 ((TopCat.toSSet.obj X).δ 2 σ) := by
    simpa using congrArg (fun f => f σ)
      ((CategoryTheory.SimplicialObject.δ_comp_δ (TopCat.toSSet.obj X)
        (i := (1 : Fin 2)) (j := (1 : Fin 2)) (by decide)).symm)
  have hψ :
      (singularSimplexChain ((TopCat.toSSet.obj X).δ 0 σ) ≫ ψ.1).hom 1 -
        (singularSimplexChain ((TopCat.toSSet.obj X).δ 1 σ) ≫ ψ.1).hom 1 +
          (singularSimplexChain ((TopCat.toSSet.obj X).δ 2 σ) ≫ ψ.1).hom 1 = 0 := by
    have h := IntegralSingularCocycle.annihilates_two_simplex_boundary
      (X := X) ⟨ψ.1, ψ.2⟩ σ
    simpa using congrArg
      (fun f : ModuleCat.of ℤ ℤ ⟶ ModuleCat.of ℤ ℤ => f.hom 1) h
  rw [singularCochainCoboundary_one_eval, singularCochainCupOne_eval,
    singularCochainCoboundary_zero_eval]
  rw [singularCochainCupZeroOne_eval, singularCochainCupZeroOne_eval,
    singularCochainCupZeroOne_eval, h10, h11]
  linear_combination
    (singularSimplexChain
      ((TopCat.toSSet.obj X).δ 1 ((TopCat.toSSet.obj X).δ 2 σ)) ≫ φ).hom 1 * hψ

/-- The mixed cup product has the usual negative Leibniz sign when the
degree-one left factor is a cocycle. -/
theorem singularCochainCupOneZero_coboundary (φ : singularOneCocycles X)
    (ψ : IntegralSingularCochain X 0) :
    singularCochainCoboundary (singularCochainCupOneZero φ.1 ψ) =
      -singularCochainCupOne φ.1 (singularCochainCoboundary ψ) := by
  apply integralSingularCochain_ext
  intro σ
  have h00 :
      (TopCat.toSSet.obj X).δ 0 ((TopCat.toSSet.obj X).δ 1 σ) =
        (TopCat.toSSet.obj X).δ 0 ((TopCat.toSSet.obj X).δ 0 σ) := by
    simpa using congrArg (fun f => f σ)
      (CategoryTheory.SimplicialObject.δ_comp_δ (TopCat.toSSet.obj X)
        (i := (0 : Fin 2)) (j := (0 : Fin 2)) (by decide))
  have h10 :
      (TopCat.toSSet.obj X).δ 1 ((TopCat.toSSet.obj X).δ 0 σ) =
        (TopCat.toSSet.obj X).δ 0 ((TopCat.toSSet.obj X).δ 2 σ) := by
    simpa using congrArg (fun f => f σ)
      ((CategoryTheory.SimplicialObject.δ_comp_δ (TopCat.toSSet.obj X)
        (i := (0 : Fin 2)) (j := (1 : Fin 2)) (by decide)).symm)
  have hφ :
      (singularSimplexChain ((TopCat.toSSet.obj X).δ 0 σ) ≫ φ.1).hom 1 -
        (singularSimplexChain ((TopCat.toSSet.obj X).δ 1 σ) ≫ φ.1).hom 1 +
          (singularSimplexChain ((TopCat.toSSet.obj X).δ 2 σ) ≫ φ.1).hom 1 = 0 := by
    have h := IntegralSingularCocycle.annihilates_two_simplex_boundary
      (X := X) ⟨φ.1, φ.2⟩ σ
    simpa using congrArg
      (fun f : ModuleCat.of ℤ ℤ ⟶ ModuleCat.of ℤ ℤ => f.hom 1) h
  rw [singularCochainCoboundary_one_eval]
  rw [Preadditive.comp_neg, ModuleCat.hom_neg, LinearMap.neg_apply,
    singularCochainCupOne_eval, singularCochainCoboundary_zero_eval,
    singularCochainCupOneZero_eval, singularCochainCupOneZero_eval,
    singularCochainCupOneZero_eval, h00, h10]
  linear_combination
    (singularSimplexChain
      ((TopCat.toSSet.obj X).δ 0 ((TopCat.toSSet.obj X).δ 0 σ)) ≫ ψ).hom 1 * hφ

theorem singularCochainCupOne_coboundary_left (φ : IntegralSingularCochain X 0)
    (ψ : singularOneCocycles X) :
    ∃ η : IntegralSingularCochain X 1,
      singularCochainCoboundary η =
        singularCochainCupOne (singularCochainCoboundary φ) ψ.1 :=
  ⟨singularCochainCupZeroOne φ ψ.1, singularCochainCupZeroOne_coboundary φ ψ⟩

theorem singularCochainCupOne_coboundary_right (φ : singularOneCocycles X)
    (ψ : IntegralSingularCochain X 0) :
    ∃ η : IntegralSingularCochain X 1,
      singularCochainCoboundary η =
        singularCochainCupOne φ.1 (singularCochainCoboundary ψ) := by
  refine ⟨-singularCochainCupOneZero φ.1 ψ, ?_⟩
  change -(singularCochainCoboundary (singularCochainCupOneZero φ.1 ψ)) = _
  rw [singularCochainCupOneZero_coboundary, neg_neg]

end Mumford.Analytic
