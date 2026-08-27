/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.LinearAlgebra.TensorProduct.Quotient
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

/-
The pure-tensor formula characterizes the evaluation map.  This is useful when
an evaluation map is constructed by a different universal-property interface.
-/
theorem tensorProductEval_eq_of_tmul
    (R S M : Type*)
    [CommSemiring R] [CommSemiring S] [Algebra R S]
    [AddCommMonoid M] [Module R M] [Module S M]
    [IsScalarTower R S M]
    (f : S ⊗[R] M →ₗ[S] M)
    (h : ∀ s m, f (s ⊗ₜ[R] m) = s • m) :
    f = tensorProductEval R S M := by
  apply LinearMap.ext
  intro z
  induction z using TensorProduct.induction_on with
  | zero => simp
  | tmul s m => exact h s m
  | add x y hx hy => simp [hx, hy]

/-!
## Tensoring with a ring quotient

The quotient/residue fibre that occurs in Milne I.5.11 is canonically the
quotient of the module by the corresponding ideal action.  This is a small
MilneLib-facing alias for Mathlib's universal-property construction, together
with the formulas needed to use it on pure tensors and quotient maps.
-/

/-- The canonical equivalence
`(R ⧸ I) ⊗[R] M ≃ₗ[R] M ⧸ (I • ⊤)`.

This re-exports Mathlib's `TensorProduct.quotTensorEquivQuotSMul` under the
MilneLib namespace so residue-fibre arguments can use a project-local API.
-/
noncomputable def quotTensorEquivQuotSMul
    {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (I : Ideal R) :
    ((R ⧸ I) ⊗[R] M) ≃ₗ[R] M ⧸ (I • (⊤ : Submodule R M)) :=
  TensorProduct.quotTensorEquivQuotSMul M I

@[simp]
theorem quotTensorEquivQuotSMul_mk_tmul
    {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (I : Ideal R) (r : R) (x : M) :
    quotTensorEquivQuotSMul (M := M) I (Ideal.Quotient.mk I r ⊗ₜ[R] x) =
      Submodule.Quotient.mk (r • x) := by
  exact TensorProduct.quotTensorEquivQuotSMul_mk_tmul (M := M) I r x

theorem quotTensorEquivQuotSMul_comp_mkQ_rTensor
    {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (I : Ideal R) :
    quotTensorEquivQuotSMul (M := M) I ∘ₗ I.mkQ.rTensor M =
      (I • (⊤ : Submodule R M)).mkQ ∘ₗ TensorProduct.lid R M := by
  exact TensorProduct.quotTensorEquivQuotSMul_comp_mkQ_rTensor (M := M) I

end MilneLib
