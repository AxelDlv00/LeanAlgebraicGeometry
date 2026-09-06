/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import Mathlib.AlgebraicTopology.SingularHomology.Basic
import Mathlib.Algebra.Homology.Opposite
import Mathlib.Algebra.Category.ModuleCat.Basic
import Mathlib.Algebra.Category.ModuleCat.Limits
import Mathlib.Algebra.Category.ModuleCat.Products
import Mathlib.Algebra.Category.ModuleCat.Colimits

/-!
# Integral singular cochains

The singular chain complex with integral coefficients is available in Mathlib
as a functor to `ChainComplex (ModuleCat ℤ)`.  This file records its concrete
simplex boundary identities; dual cochains can evaluate these identities on
singular simplices in the subsequent loop-evaluation construction.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Limits Opposite
open AlgebraicTopology
open scoped Simplicial

namespace Mumford.Analytic

/-- Singular chains with integral coefficients on a topological space. -/
abbrev IntegralSingularChainComplex (X : TopCat) :
    ChainComplex (ModuleCat ℤ) ℕ :=
  ((singularChainComplexFunctor (ModuleCat ℤ)).obj (ModuleCat.of ℤ ℤ)).obj X

section Boundary

variable {X : TopCat} {n : ℕ}

/-- The canonical generator of integral singular `n`-chains associated to a
singular simplex. -/
noncomputable def singularSimplexChain
    (σ : (TopCat.toSSet.obj X).obj (Opposite.op ⦋n⦌)) :
    ModuleCat.of ℤ ℤ ⟶ (IntegralSingularChainComplex X).X n :=
  SSet.ιChainComplex
    (C := ModuleCat ℤ) (X := TopCat.toSSet.obj X)
      (R := ModuleCat.of ℤ ℤ) σ

@[reassoc]
theorem singularSimplexChain_boundary
    (σ : (TopCat.toSSet.obj X).obj (Opposite.op ⦋n + 1⦌)) :
    singularSimplexChain σ ≫ (IntegralSingularChainComplex X).d (n + 1) n =
      ∑ i : Fin (n + 2), (-1 : ℤ) ^ i.val •
        singularSimplexChain (X := X) ((TopCat.toSSet.obj X).δ i σ) := by
  exact SSet.ιChainComplex_d
    (C := ModuleCat ℤ) (X := TopCat.toSSet.obj X)
      (R := ModuleCat.of ℤ ℤ) σ

@[reassoc (attr := simp)]
theorem singularSimplexChain_boundary_zero
    (σ : (TopCat.toSSet.obj X).obj (Opposite.op ⦋1⦌)) :
    singularSimplexChain σ ≫ (IntegralSingularChainComplex X).d 1 0 =
      singularSimplexChain ((TopCat.toSSet.obj X).δ 0 σ) -
        singularSimplexChain ((TopCat.toSSet.obj X).δ 1 σ) := by
  have h := singularSimplexChain_boundary (X := X) (n := 0) σ
  simpa [Fin.sum_univ_two, sub_eq_add_neg] using h

@[reassoc (attr := simp)]
theorem singularSimplexChain_boundary_one
    (σ : (TopCat.toSSet.obj X).obj (Opposite.op ⦋2⦌)) :
    singularSimplexChain σ ≫ (IntegralSingularChainComplex X).d 2 1 =
      singularSimplexChain ((TopCat.toSSet.obj X).δ 0 σ) -
        singularSimplexChain ((TopCat.toSSet.obj X).δ 1 σ) +
          singularSimplexChain ((TopCat.toSSet.obj X).δ 2 σ) := by
  have h := singularSimplexChain_boundary (X := X) (n := 1) σ
  simpa [Fin.sum_univ_three, sub_eq_add_neg, add_assoc] using h

end Boundary

section Cochains

variable {X : TopCat} {n : ℕ}

/-- Integral singular `n`-cochains, represented as ModuleCat morphisms into the
 integers.  This is the concrete dual interface for a future degree-one
 loop-evaluation construction. -/
abbrev IntegralSingularCochain (X : TopCat) (n : ℕ) : Type _ :=
  (IntegralSingularChainComplex X).X n ⟶ ModuleCat.of ℤ ℤ

/-- The singular coboundary is precomposition with the chain differential. -/
def singularCochainCoboundary
    (φ : IntegralSingularCochain X n) :
    IntegralSingularCochain X (n + 1) :=
  (IntegralSingularChainComplex X).d (n + 1) n ≫ φ

@[simp]
theorem singularCochainCoboundary_eq_zero_iff (φ : IntegralSingularCochain X n) :
    singularCochainCoboundary (X := X) (n := n) φ = 0 ↔
      (IntegralSingularChainComplex X).d (n + 1) n ≫ φ = 0 := by
  rfl

/-- Coboundaries compose to zero, by the defining relation of the singular
chain complex. -/
theorem singularCochainCoboundary_squared
    (φ : IntegralSingularCochain X n) :
    singularCochainCoboundary
        (X := X) (n := n + 1)
        (singularCochainCoboundary (X := X) (n := n) φ) = 0 := by
  simp [singularCochainCoboundary]

/-- A cocycle is a cochain annihilating the next chain boundary. -/
def IntegralSingularCocycle (X : TopCat) (n : ℕ) : Type _ :=
  { φ : IntegralSingularCochain X n //
      singularCochainCoboundary (X := X) (n := n) φ = 0 }

@[simp]
theorem IntegralSingularCocycle.coe_coboundary
    (φ : IntegralSingularCocycle X n) :
    singularCochainCoboundary (X := X) (n := n) φ.1 = 0 :=
  φ.property

/-- A cocycle annihilates every simplex boundary morphism. -/
theorem IntegralSingularCocycle.annihilates_simplex_boundary
    (φ : IntegralSingularCocycle X n)
    (σ : (TopCat.toSSet.obj X).obj (Opposite.op ⦋n + 1⦌)) :
    singularSimplexChain σ ≫
        (IntegralSingularChainComplex X).d (n + 1) n ≫ φ.1 = 0 := by
  change singularSimplexChain σ ≫
      singularCochainCoboundary (X := X) (n := n) φ.val = 0
  rw [φ.property]
  simp

/- The degree-two boundary formula is the concrete cocycle relation used when
   comparing evaluations on concatenated paths. -/
theorem IntegralSingularCocycle.annihilates_two_simplex_boundary
    (φ : IntegralSingularCocycle X 1)
    (σ : (TopCat.toSSet.obj X).obj (Opposite.op ⦋2⦌)) :
    singularSimplexChain ((TopCat.toSSet.obj X).δ 0 σ) ≫ φ.1 -
        singularSimplexChain ((TopCat.toSSet.obj X).δ 1 σ) ≫ φ.1 +
        singularSimplexChain ((TopCat.toSSet.obj X).δ 2 σ) ≫ φ.1 = 0 := by
  have h := φ.annihilates_simplex_boundary σ
  rw [← Category.assoc] at h
  rw [singularSimplexChain_boundary_one] at h
  simpa [Category.assoc, sub_eq_add_neg] using h

end Cochains

end Mumford.Analytic
