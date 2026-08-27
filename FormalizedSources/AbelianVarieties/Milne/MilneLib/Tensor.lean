/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.LinearAlgebra.TensorProduct.Tower

/-!
# Tensor evaluation

The canonical evaluation map from a scalar extension tensor product sends a
pure tensor `s ⊗ m` to the scalar action `s • m`.
-/

open scoped TensorProduct

namespace MilneLib

noncomputable def tensorProductEval
    (R S M : Type*)
    [CommSemiring R] [CommSemiring S] [Algebra R S]
    [AddCommMonoid M] [Module R M] [Module S M]
    [IsScalarTower R S M] :
    S ⊗[R] M →ₗ[S] M :=
  TensorProduct.AlgebraTensorModule.lift
    (LinearMap.restrictScalarsₗ R S M M S ∘ₗ LinearMap.lsmul S M)

@[simp]
theorem tensorProductEval_tmul
    (R S M : Type*)
    [CommSemiring R] [CommSemiring S] [Algebra R S]
    [AddCommMonoid M] [Module R M] [Module S M]
    [IsScalarTower R S M]
    (s : S) (m : M) :
    tensorProductEval R S M (s ⊗ₜ[R] m) = s • m := by
  rfl

end MilneLib
