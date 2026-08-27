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

end StacksPart01
