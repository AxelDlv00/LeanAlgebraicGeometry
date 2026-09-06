/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCupCoboundary
import Mathlib.RingTheory.Binomial

/-!
# Vanishing of degree-one integral cup squares

For an integral one-cocycle, the negative binomial coefficient of each edge
value gives an explicit primitive for its self-cup product. The binomial
identity works on all integers, so no torsion-freeness hypothesis on the
cohomology of the space is required.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Opposite AlgebraicTopology
open scoped Simplicial

namespace Mumford.Analytic

variable {X : TopCat}

private theorem choose_add_two (a b : ℤ) :
    Ring.choose (a + b) 2 = Ring.choose a 2 + a * b + Ring.choose b 2 := by
  rw [Ring.add_choose_eq 2 (Commute.all a b)]
  have h : Finset.antidiagonal 2 = {(0, 2), (1, 1), (2, 0)} := by decide
  rw [h]
  simp [add_comm]

/-- The one-cochain whose value on an edge with value `n` is `-choose n 2`.
Its coboundary is the self-cup product when the input is a cocycle. -/
def singularCochainSelfCupPrimitive (φ : IntegralSingularCochain X 1) :
    IntegralSingularCochain X 1 :=
  singularCochainOfSimplexFunction (fun σ =>
    -Ring.choose ((singularSimplexChain σ ≫ φ).hom 1) 2)

@[simp]
theorem singularCochainSelfCupPrimitive_eval (φ : IntegralSingularCochain X 1)
    (σ : (TopCat.toSSet.obj X).obj (op ⦋1⦌)) :
    (singularSimplexChain σ ≫ singularCochainSelfCupPrimitive φ).hom 1 =
      -Ring.choose ((singularSimplexChain σ ≫ φ).hom 1) 2 := by
  simp [singularCochainSelfCupPrimitive]

/-- Every integral singular one-cocycle has an explicit primitive for its
self-cup product. -/
theorem singularCochainSelfCupPrimitive_coboundary (φ : singularOneCocycles X) :
    singularCochainCoboundary (singularCochainSelfCupPrimitive φ.1) =
      singularCochainCupOne φ.1 φ.1 := by
  apply integralSingularCochain_ext
  intro σ
  have hφ :
      (singularSimplexChain ((TopCat.toSSet.obj X).δ 1 σ) ≫ φ.1).hom 1 =
        (singularSimplexChain ((TopCat.toSSet.obj X).δ 2 σ) ≫ φ.1).hom 1 +
          (singularSimplexChain ((TopCat.toSSet.obj X).δ 0 σ) ≫ φ.1).hom 1 := by
    have h := IntegralSingularCocycle.annihilates_two_simplex_boundary
      (X := X) ⟨φ.1, φ.2⟩ σ
    have h' := congrArg
      (fun f : ModuleCat.of ℤ ℤ ⟶ ModuleCat.of ℤ ℤ => f.hom 1) h
    simp only [ModuleCat.hom_add, LinearMap.add_apply, ModuleCat.hom_sub,
      LinearMap.sub_apply, ModuleCat.hom_zero, LinearMap.zero_apply] at h'
    linear_combination -h'
  rw [singularCochainCoboundary_one_eval, singularCochainCupOne_eval,
    singularCochainSelfCupPrimitive_eval, singularCochainSelfCupPrimitive_eval,
    singularCochainSelfCupPrimitive_eval, hφ, choose_add_two]
  ring

theorem singularCochainCupOne_self_coboundary (φ : singularOneCocycles X) :
    ∃ η : IntegralSingularCochain X 1,
      singularCochainCoboundary η = singularCochainCupOne φ.1 φ.1 :=
  ⟨singularCochainSelfCupPrimitive φ.1, singularCochainSelfCupPrimitive_coboundary φ⟩

end Mumford.Analytic
