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

end Mumford.Analytic
