/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 as described in the LICENSE file.
-/

import Mathlib.LinearAlgebra.TensorProduct.Pi

/-!
# Base change of a finite component sum

This is the small algebraic tensor identity used by the universal multiplication
span.  Keeping it independent of the large window types prevents elaboration of
the geometric source from obscuring the actual finite-product calculation.
-/

set_option autoImplicit false
set_option quotPrecheck false

universe u

open scoped TensorProduct

namespace AlgebraicGeometry

variable {R K M N : Type u} [CommRing R] [CommRing K] [Algebra R K]
variable [AddCommMonoid M] [Module R M]
variable [AddCommMonoid N] [Module R N]
variable {ι : Type u} [Fintype ι] [DecidableEq ι]

/-- The sum of component maps on a finite product. -/
noncomputable def finiteComponentSum (f : ι → M →ₗ[R] N) :
    (ι → M) →ₗ[R] N :=
  ∑ t : ι, (f t).comp (LinearMap.proj t)

/-- Base change commutes with a finite component sum, after tensoring the
product source into its component fibres with `TensorProduct.piRightHom`. -/
theorem baseChange_finiteComponentSum (f : ι → M →ₗ[R] N) :
    LinearMap.baseChange K (finiteComponentSum f) =
      (∑ t : ι,
        (LinearMap.baseChange K (f t)).comp
          ((LinearMap.proj t) :
            (ι → (K ⊗[R] M)) →ₗ[K] (K ⊗[R] M))) ∘ₗ
        TensorProduct.piRightHom R K K (fun _ : ι => M) := by
  apply LinearMap.ext
  intro x
  induction x using TensorProduct.induction_on with
  | zero => simp
  | add x y hx hy => simp [hx, hy, Finset.sum_add_distrib]
  | tmul a v =>
      simp [finiteComponentSum, LinearMap.comp_apply, LinearMap.sum_apply,
        LinearMap.baseChange_tmul]
      rw [TensorProduct.tmul_sum]

end AlgebraicGeometry
