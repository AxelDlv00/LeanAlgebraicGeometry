/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularPathEvaluation

/-!
# Extending integer functions to singular cochains

Singular chains are the coproduct of one copy of the integers for each
singular simplex. Thus a function on simplices extends uniquely to a
cochain. In degree zero this constructs a cochain from any function on points.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Limits Opposite AlgebraicTopology
open scoped Simplicial

namespace Mumford.Analytic

variable {X : TopCat} {n : ℕ}

/-- The cochain specified by its integer values on singular simplices. -/
def singularCochainOfSimplexFunction
    (f : (TopCat.toSSet.obj X).obj (op ⦋n⦌) → ℤ) :
    IntegralSingularCochain X n :=
  Sigma.desc (fun σ => f σ • 𝟙 (ModuleCat.of ℤ ℤ))

@[reassoc (attr := simp)]
theorem singularSimplexChain_cochainOfSimplexFunction
    (f : (TopCat.toSSet.obj X).obj (op ⦋n⦌) → ℤ)
    (σ : (TopCat.toSSet.obj X).obj (op ⦋n⦌)) :
    singularSimplexChain σ ≫ singularCochainOfSimplexFunction f =
      f σ • 𝟙 (ModuleCat.of ℤ ℤ) := by
  exact Sigma.ι_desc _ _

@[simp]
theorem singularCochainOfSimplexFunction_eval
    (f : (TopCat.toSSet.obj X).obj (op ⦋n⦌) → ℤ)
    (σ : (TopCat.toSSet.obj X).obj (op ⦋n⦌)) :
    (singularSimplexChain σ ≫ singularCochainOfSimplexFunction f).hom 1 = f σ := by
  simp

/-- Values on simplex generators determine a cochain. -/
@[ext]
theorem integralSingularCochain_ext {φ ψ : IntegralSingularCochain X n}
    (h : ∀ σ : (TopCat.toSSet.obj X).obj (op ⦋n⦌),
      (singularSimplexChain σ ≫ φ).hom 1 =
        (singularSimplexChain σ ≫ ψ).hom 1) : φ = ψ := by
  apply SSet.chainComplex_hom_ext
  intro σ
  apply ModuleCat.hom_ext
  exact LinearMap.ext_ring (h σ)

/-- A one-cochain is a cocycle exactly when its values satisfy the triangle
boundary identity. -/
theorem singularCochainOfSimplexFunction_coboundary_eq_zero_iff
    (f : (TopCat.toSSet.obj X).obj (op ⦋1⦌) → ℤ) :
    singularCochainCoboundary (singularCochainOfSimplexFunction f) = 0 ↔
      ∀ σ : (TopCat.toSSet.obj X).obj (op ⦋2⦌),
        f ((TopCat.toSSet.obj X).δ 0 σ) -
          f ((TopCat.toSSet.obj X).δ 1 σ) +
            f ((TopCat.toSSet.obj X).δ 2 σ) = 0 := by
  constructor
  · intro h σ
    have hc := (IntegralSingularCocycle.annihilates_two_simplex_boundary
      ⟨singularCochainOfSimplexFunction f, h⟩ σ)
    have he := congrArg (fun g : ModuleCat.of ℤ ℤ ⟶ ModuleCat.of ℤ ℤ => g.hom 1) hc
    simpa using he
  · intro h
    apply integralSingularCochain_ext
    intro σ
    simp [singularCochainCoboundary, ← Category.assoc,
      singularSimplexChain_boundary_one, h σ]

/-- The zero-cochain specified by an arbitrary integer-valued function on
the points of a space. Continuity of the function is not required. -/
def singularCochainOfPointFunction (f : X → ℤ) : IntegralSingularCochain X 0 :=
  singularCochainOfSimplexFunction
    (fun σ => f ((X.toSSetObjEquiv (op ⦋0⦌) σ) (stdSimplex.vertex 0)))

@[simp]
theorem singularCochainOfPointFunction_eval (f : X → ℤ) (x : X) :
    singularCochainPointEval (singularCochainOfPointFunction f) x = f x := by
  simp [singularCochainPointEval, singularCochainOfPointFunction,
    constantSingularSimplex, singularSimplexOfContinuousMap]

@[simp]
theorem singularCochainOfPointFunction_coboundary_pathEval
    (f : X → ℤ) {x y : X} (p : Path x y) :
    singularCochainPathEval
        (singularCochainCoboundary (singularCochainOfPointFunction f)) p = f y - f x := by
  simp [singularCochainPathEval_coboundary]

end Mumford.Analytic
