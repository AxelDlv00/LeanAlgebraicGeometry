/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.Algebra.Module.FinitePresentation
import Mathlib.RingTheory.Artinian.Module

/-!
# StacksPart01Lib.CommutativeAlgebra

Small, source-faithful consequences of the commutative-algebra preliminaries.
-/

namespace StacksPart01

open Polynomial

/- The Cayley--Hamilton identity for matrices (Stacks, Tag 00DX). -/
theorem charpoly {R n : Type*} [CommRing R] [Fintype n] [DecidableEq n]
    (A : Matrix n n R) : aeval A A.charpoly = 0 := by
  exact Matrix.aeval_self_charpoly A

/- Finite modules over a Noetherian ring have finite presentations, finite
submodules, and the Noetherian module property (Stacks, Tag 00IK). -/
theorem noetherian_basic {R M : Type*} [Ring R] [AddCommGroup M] [Module R M]
    [IsNoetherianRing R] [Module.Finite R M] :
    Module.FinitePresentation R M ∧
      (∀ N : Submodule R M, Module.Finite R N) ∧
      IsNoetherian R M := by
  refine ⟨Module.finitePresentation_of_finite R M, ?_, inferInstance⟩
  intro N
  exact Module.Finite.of_fg (Submodule.FG.of_le Module.Finite.fg_top le_top)

/- An Artinian ring has finitely many maximal ideals (Stacks, Tag 00J7). -/
theorem artinian_finite_maximal_ideals {R : Type*} [CommSemiring R]
    [IsArtinianRing R] : {I : Ideal R | I.IsMaximal}.Finite := by
  exact IsArtinianRing.setOf_isMaximal_finite R

end StacksPart01
