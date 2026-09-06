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

end Boundary

end Mumford.Analytic
