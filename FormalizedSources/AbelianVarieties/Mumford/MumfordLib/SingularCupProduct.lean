/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCochainExtension

/-!
# The degree-zero singular cup product

The Alexander--Whitney cup product in bidegree `(0, 0)` is pointwise
multiplication on vertices.  This file records that concrete operation on
integral singular cochains and its elementary ring laws.  Higher-degree cup
products use the same simplex-generator interface.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Opposite AlgebraicTopology
open scoped Simplicial

namespace Mumford.Analytic

variable {X : TopCat}

/-- The integral singular cup product of two degree-zero cochains. -/
def singularCochainCupZero (φ ψ : IntegralSingularCochain X 0) :
    IntegralSingularCochain X 0 :=
  singularCochainOfSimplexFunction (fun σ =>
    (singularSimplexChain σ ≫ φ).hom 1 *
      (singularSimplexChain σ ≫ ψ).hom 1)

@[simp]
theorem singularCochainCupZero_eval
    (φ ψ : IntegralSingularCochain X 0)
    (σ : (TopCat.toSSet.obj X).obj (op ⦋0⦌)) :
    (singularSimplexChain σ ≫ singularCochainCupZero φ ψ).hom 1 =
      (singularSimplexChain σ ≫ φ).hom 1 *
        (singularSimplexChain σ ≫ ψ).hom 1 := by
  simp [singularCochainCupZero]

@[simp]
theorem singularCochainCupZero_pointEval
    (φ ψ : IntegralSingularCochain X 0) (x : X) :
    singularCochainPointEval (singularCochainCupZero φ ψ) x =
      singularCochainPointEval φ x * singularCochainPointEval ψ x := by
  simp [singularCochainPointEval, singularCochainCupZero]

theorem singularCochainCupZero_comm
    (φ ψ : IntegralSingularCochain X 0) :
    singularCochainCupZero φ ψ = singularCochainCupZero ψ φ := by
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCupZero, mul_comm]

theorem singularCochainCupZero_assoc
    (φ ψ χ : IntegralSingularCochain X 0) :
    singularCochainCupZero (singularCochainCupZero φ ψ) χ =
      singularCochainCupZero φ (singularCochainCupZero ψ χ) := by
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCupZero, mul_assoc]

theorem singularCochainCupZero_zero
    (φ : IntegralSingularCochain X 0) :
    singularCochainCupZero φ 0 = 0 := by
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCupZero]

/-- The constant-one degree-zero cochain used as the cup-product unit. -/
def singularCochainOne (X : TopCat) : IntegralSingularCochain X 0 :=
  singularCochainOfSimplexFunction (fun _ => 1)

@[simp]
theorem singularCochainOne_eval
    (σ : (TopCat.toSSet.obj X).obj (op ⦋0⦌)) :
    (singularSimplexChain σ ≫ singularCochainOne X).hom 1 = 1 := by
  simp [singularCochainOne]

@[simp]
theorem singularCochainCupZero_one_left
    (φ : IntegralSingularCochain X 0) :
    singularCochainCupZero (singularCochainOne X) φ = φ := by
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCupZero, singularCochainOne]

@[simp]
theorem singularCochainCupZero_one_right
    (φ : IntegralSingularCochain X 0) :
    singularCochainCupZero φ (singularCochainOne X) = φ := by
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCupZero, singularCochainOne]

/-- The Alexander--Whitney cup product in bidegree `(1, 1)`.  The first
factor is evaluated on the edge `(0, 1)` and the second on `(1, 2)`. -/
def singularCochainCupOne (φ ψ : IntegralSingularCochain X 1) :
    IntegralSingularCochain X 2 :=
  singularCochainOfSimplexFunction (fun σ =>
    (singularSimplexChain ((TopCat.toSSet.obj X).δ 2 σ) ≫ φ).hom 1 *
      (singularSimplexChain ((TopCat.toSSet.obj X).δ 0 σ) ≫ ψ).hom 1)

@[simp]
theorem singularCochainCupOne_eval
    (φ ψ : IntegralSingularCochain X 1)
    (σ : (TopCat.toSSet.obj X).obj (op ⦋2⦌)) :
    (singularSimplexChain σ ≫ singularCochainCupOne φ ψ).hom 1 =
      (singularSimplexChain ((TopCat.toSSet.obj X).δ 2 σ) ≫ φ).hom 1 *
        (singularSimplexChain ((TopCat.toSSet.obj X).δ 0 σ) ≫ ψ).hom 1 := by
  simp [singularCochainCupOne]

theorem singularCochainCupOne_add_left
    (φ₁ φ₂ ψ : IntegralSingularCochain X 1) :
    singularCochainCupOne (φ₁ + φ₂) ψ =
      singularCochainCupOne φ₁ ψ + singularCochainCupOne φ₂ ψ := by
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCupOne, add_mul]

theorem singularCochainCupOne_add_right
    (φ ψ₁ ψ₂ : IntegralSingularCochain X 1) :
    singularCochainCupOne φ (ψ₁ + ψ₂) =
      singularCochainCupOne φ ψ₁ + singularCochainCupOne φ ψ₂ := by
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCupOne, mul_add]

theorem singularCochainCupOne_zero_left
    (ψ : IntegralSingularCochain X 1) :
    singularCochainCupOne 0 ψ = 0 := by
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCupOne]

theorem singularCochainCupOne_zero_right
    (φ : IntegralSingularCochain X 1) :
    singularCochainCupOne φ 0 = 0 := by
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCupOne]

/- The coboundary of a degree-two cup cochain is evaluated by the
   alternating sum of its four triangular faces.  This is the concrete
   degree-three interface used by the subsequent cocycle calculation. -/
theorem singularCochainCupOne_coboundary_eval
    (φ ψ : IntegralSingularCochain X 1)
    (σ : (TopCat.toSSet.obj X).obj (op ⦋3⦌)) :
    (singularSimplexChain σ ≫
        singularCochainCoboundary (singularCochainCupOne φ ψ)).hom 1 =
      (singularSimplexChain ((TopCat.toSSet.obj X).δ 0 σ) ≫
          singularCochainCupOne φ ψ).hom 1 -
        (singularSimplexChain ((TopCat.toSSet.obj X).δ 1 σ) ≫
          singularCochainCupOne φ ψ).hom 1 +
        (singularSimplexChain ((TopCat.toSSet.obj X).δ 2 σ) ≫
          singularCochainCupOne φ ψ).hom 1 -
      (singularSimplexChain ((TopCat.toSSet.obj X).δ 3 σ) ≫
          singularCochainCupOne φ ψ).hom 1 := by
  have h := singularSimplexChain_boundary (X := X) (n := 2) σ
  have h' := congrArg
    (fun f : ModuleCat.of ℤ ℤ ⟶ (IntegralSingularChainComplex X).X 2 =>
      (f ≫ singularCochainCupOne φ ψ).hom 1) h
  simpa [singularCochainCoboundary, Category.assoc, Fin.sum_univ_four,
    sub_eq_add_neg, singularCochainCupOne_eval] using h'

theorem singularCochainCupOne_cocycle
    (φ ψ : IntegralSingularCocycle X 1) :
    singularCochainCoboundary
        (singularCochainCupOne φ.1 ψ.1) = 0 := by
  apply integralSingularCochain_ext
  intro σ
  rw [singularCochainCupOne_coboundary_eval]
  simp [singularCochainCupOne]
  have h20 :
      (TopCat.toSSet.obj X).δ 2 ((TopCat.toSSet.obj X).δ 0 σ) =
        (TopCat.toSSet.obj X).δ 0 ((TopCat.toSSet.obj X).δ 3 σ) := by
    simpa using congrArg (fun f => f σ)
      ((CategoryTheory.SimplicialObject.δ_comp_δ (TopCat.toSSet.obj X)
        (i := (0 : Fin 3)) (j := (2 : Fin 3)) (by decide)).symm)
  have h21 :
      (TopCat.toSSet.obj X).δ 2 ((TopCat.toSSet.obj X).δ 1 σ) =
        (TopCat.toSSet.obj X).δ 1 ((TopCat.toSSet.obj X).δ 3 σ) := by
    simpa using congrArg (fun f => f σ)
      ((CategoryTheory.SimplicialObject.δ_comp_δ (TopCat.toSSet.obj X)
        (i := (1 : Fin 3)) (j := (2 : Fin 3)) (by decide)).symm)
  have h22 :
      (TopCat.toSSet.obj X).δ 2 ((TopCat.toSSet.obj X).δ 2 σ) =
        (TopCat.toSSet.obj X).δ 2 ((TopCat.toSSet.obj X).δ 3 σ) := by
    simpa using congrArg (fun f => f σ)
      ((CategoryTheory.SimplicialObject.δ_comp_δ (TopCat.toSSet.obj X)
        (i := (2 : Fin 3)) (j := (2 : Fin 3)) (by decide)).symm)
  have h01 :
      (TopCat.toSSet.obj X).δ 0 ((TopCat.toSSet.obj X).δ 1 σ) =
        (TopCat.toSSet.obj X).δ 0 ((TopCat.toSSet.obj X).δ 0 σ) := by
    simpa using congrArg (fun f => f σ)
      (CategoryTheory.SimplicialObject.δ_comp_δ (TopCat.toSSet.obj X)
        (i := (0 : Fin 3)) (j := (0 : Fin 3)) (by decide))
  have h02 :
      (TopCat.toSSet.obj X).δ 0 ((TopCat.toSSet.obj X).δ 2 σ) =
        (TopCat.toSSet.obj X).δ 1 ((TopCat.toSSet.obj X).δ 0 σ) := by
    simpa using congrArg (fun f => f σ)
      (CategoryTheory.SimplicialObject.δ_comp_δ (TopCat.toSSet.obj X)
        (i := (0 : Fin 3)) (j := (1 : Fin 3)) (by decide))
  have h03 :
      (TopCat.toSSet.obj X).δ 0 ((TopCat.toSSet.obj X).δ 3 σ) =
        (TopCat.toSSet.obj X).δ 2 ((TopCat.toSSet.obj X).δ 0 σ) := by
    simpa using congrArg (fun f => f σ)
      (CategoryTheory.SimplicialObject.δ_comp_δ (TopCat.toSSet.obj X)
        (i := (0 : Fin 3)) (j := (2 : Fin 3)) (by decide))
  rw [h20, h21, h22, h01, h02]
  have hφ := φ.annihilates_two_simplex_boundary
    ((TopCat.toSSet.obj X).δ 3 σ)
  have hψ := ψ.annihilates_two_simplex_boundary
    ((TopCat.toSSet.obj X).δ 0 σ)
  have hφ' := congrArg
    (fun f : ModuleCat.of ℤ ℤ ⟶ ModuleCat.of ℤ ℤ => f.hom 1) hφ
  have hψ' := congrArg
    (fun f : ModuleCat.of ℤ ℤ ⟶ ModuleCat.of ℤ ℤ => f.hom 1) hψ
  simp at hφ' hψ'
  have h03ψ := congrArg
    (fun τ => (ModuleCat.Hom.hom ψ.1)
      ((ModuleCat.Hom.hom (singularSimplexChain τ)) 1)) h03
  rw [h03ψ]
  ring_nf at hφ' hψ' ⊢
  linear_combination
    hφ' * (ModuleCat.Hom.hom ψ.1)
      ((ModuleCat.Hom.hom
        (singularSimplexChain
          ((TopCat.toSSet.obj X).δ 0 ((TopCat.toSSet.obj X).δ 0 σ)))) 1) -
    hψ' * (ModuleCat.Hom.hom φ.1)
      ((ModuleCat.Hom.hom
        (singularSimplexChain
          ((TopCat.toSSet.obj X).δ 2 ((TopCat.toSSet.obj X).δ 3 σ)))) 1)

end Mumford.Analytic
