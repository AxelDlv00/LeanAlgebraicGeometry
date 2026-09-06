/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCupCoboundary

/-!
# Alexander--Whitney products in arbitrary degrees

The integral singular cup product evaluates its two factors on the front and
back subintervals of a simplex. The shared vertex has index equal to the degree
of the first factor. The explicit degree equality avoids transport in formulas
involving coboundaries.

This is cochain infrastructure for Mumford, Chapter I, Section 1, p. 3.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Opposite AlgebraicTopology
open scoped Simplicial

namespace Mumford.Analytic

variable {X : TopCat} {p q n : ℕ}

/-- The Alexander--Whitney product, evaluated on the front `p`-face and the
back `q`-face of an `n`-simplex, where `p + q = n`. -/
def singularCochainCup (φ : IntegralSingularCochain X p)
    (ψ : IntegralSingularCochain X q) (h : p + q = n) :
    IntegralSingularCochain X n :=
  singularCochainOfSimplexFunction (fun σ =>
    (singularSimplexChain ((TopCat.toSSet.obj X).map
      (SimplexCategory.subinterval 0 p (by omega)).op σ) ≫ φ).hom 1 *
    (singularSimplexChain ((TopCat.toSSet.obj X).map
      (SimplexCategory.subinterval p q (by omega)).op σ) ≫ ψ).hom 1)

@[simp]
theorem singularCochainCup_eval (φ : IntegralSingularCochain X p)
    (ψ : IntegralSingularCochain X q) (h : p + q = n)
    (σ : (TopCat.toSSet.obj X).obj (op ⦋n⦌)) :
    (singularSimplexChain σ ≫ singularCochainCup φ ψ h).hom 1 =
      (singularSimplexChain ((TopCat.toSSet.obj X).map
        (SimplexCategory.subinterval 0 p (by omega)).op σ) ≫ φ).hom 1 *
      (singularSimplexChain ((TopCat.toSSet.obj X).map
        (SimplexCategory.subinterval p q (by omega)).op σ) ≫ ψ).hom 1 := by
  simp [singularCochainCup]

/-- The cup product is bilinear in arbitrary degrees. -/
def singularCochainCupBilinear (X : TopCat) (p q n : ℕ) (h : p + q = n) :
    IntegralSingularCochain X p →ₗ[ℤ] IntegralSingularCochain X q →ₗ[ℤ]
      IntegralSingularCochain X n where
  toFun φ :=
    { toFun := fun ψ => singularCochainCup φ ψ h
      map_add' ψ χ := by
        apply integralSingularCochain_ext
        intro σ
        simp [singularCochainCup, mul_add]
      map_smul' c ψ := by
        apply integralSingularCochain_ext
        intro σ
        simp [singularCochainCup, mul_left_comm] }
  map_add' φ ψ := by
    ext χ : 1
    apply integralSingularCochain_ext
    intro σ
    simp [singularCochainCup, add_mul]
  map_smul' c φ := by
    ext ψ : 1
    apply integralSingularCochain_ext
    intro σ
    simp [singularCochainCup, mul_assoc]

@[simp]
theorem singularCochainCupBilinear_apply (φ : IntegralSingularCochain X p)
    (ψ : IntegralSingularCochain X q) (h : p + q = n) :
    singularCochainCupBilinear X p q n h φ ψ = singularCochainCup φ ψ h := rfl

@[simp]
theorem singularCochainCup_zero_left (ψ : IntegralSingularCochain X q)
    (h : p + q = n) : singularCochainCup (0 : IntegralSingularCochain X p) ψ h = 0 := by
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCup]

@[simp]
theorem singularCochainCup_zero_right (φ : IntegralSingularCochain X p)
    (h : p + q = n) : singularCochainCup φ (0 : IntegralSingularCochain X q) h = 0 := by
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCup]

/-- The arbitrary-degree construction agrees with the previously defined
degree-one cup product. -/
@[simp]
theorem singularCochainCup_one_one (φ ψ : IntegralSingularCochain X 1) :
    singularCochainCup φ ψ rfl = singularCochainCupOne φ ψ := by
  have hf : SimplexCategory.subinterval 0 1 (by decide : 0 + 1 ≤ 2) =
      SimplexCategory.δ (2 : Fin 3) := by decide
  have hb : SimplexCategory.subinterval 1 1 (by decide : 1 + 1 ≤ 2) =
      SimplexCategory.δ (0 : Fin 3) := by decide
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCup, singularCochainCupOne, hf, hb, SimplicialObject.δ]

/-- Evaluating the singular coboundary on a simplex gives its alternating
sum of face evaluations in every degree. -/
theorem singularCochainCoboundary_eval (φ : IntegralSingularCochain X n)
    (σ : (TopCat.toSSet.obj X).obj (op ⦋n + 1⦌)) :
    (singularSimplexChain σ ≫ singularCochainCoboundary φ).hom 1 =
      ∑ i : Fin (n + 2), (-1 : ℤ) ^ i.val *
        (singularSimplexChain ((TopCat.toSSet.obj X).δ i σ) ≫ φ).hom 1 := by
  have h := congrArg
    (fun f : ModuleCat.of ℤ ℤ ⟶ (IntegralSingularChainComplex X).X n =>
      (f ≫ φ).hom 1) (singularSimplexChain_boundary σ)
  simpa [singularCochainCoboundary, Category.assoc] using h

end Mumford.Analytic
