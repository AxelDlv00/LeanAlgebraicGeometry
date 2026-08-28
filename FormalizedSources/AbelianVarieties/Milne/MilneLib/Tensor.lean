/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.LinearAlgebra.TensorProduct.Quotient
import Mathlib.LinearAlgebra.TensorProduct.Tower
import Mathlib.Algebra.Category.ModuleCat.Stalk
import Mathlib.AlgebraicGeometry.Modules.Sheaf
import Mathlib.RingTheory.LocalRing.ResidueField.Basic

/-!
# Tensor evaluation

The canonical evaluation map from a scalar extension tensor product sends a
pure tensor `s ⊗ m` to the scalar action `s • m`.
-/

open scoped TensorProduct
open AlgebraicGeometry

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

/-- The quotient--tensor equivalence for the residue field of a local ring.

This is the local form used to compare a residue fibre with reduction modulo
the maximal ideal. -/
noncomputable def residueFieldTensorEquivQuotSMul
    {R M : Type*} [CommRing R] [IsLocalRing R]
    [AddCommGroup M] [Module R M] :
    IsLocalRing.ResidueField R ⊗[R] M ≃ₗ[R]
      M ⧸ (IsLocalRing.maximalIdeal R • (⊤ : Submodule R M)) :=
  quotTensorEquivQuotSMul (M := M) (IsLocalRing.maximalIdeal R)

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

/-!
## Residue fibres of scheme modules

The stalk of a scheme module is naturally a module over the local structure
ring.  This wrapper exposes the preceding quotient--tensor equivalence with
the scheme notation, so residue-fibre arguments can stay at the sheaf level.
-/

/-- The canonical module structure on the stalk of a scheme module over the
corresponding structure-sheaf stalk. -/
noncomputable abbrev schemeModuleStalkModule
    {X : Scheme.{u}} (F : X.Modules) (x : X) :
    Module (X.presheaf.stalk x)
      (↑(TopCat.Presheaf.stalk F.val.presheaf x) : Type u) :=
  PresheafOfModules.instModuleCarrierStalkCommRingCatCarrierAbPresheafOpensCarrier
    F.val x

/-- The residue fibre of a scheme module is the stalk modulo the maximal-ideal
action.  The source is written as tensoring the stalk with its residue field,
which is the form used by base-change arguments. -/
noncomputable def schemeModuleStalkResidueTensorEquiv
    {X : Scheme.{u}} (F : X.Modules) (x : X) :
    letI : Module (X.presheaf.stalk x)
        (↑(TopCat.Presheaf.stalk F.val.presheaf x) : Type u) :=
      schemeModuleStalkModule F x
    IsLocalRing.ResidueField (X.presheaf.stalk x) ⊗[X.presheaf.stalk x]
        (↑(TopCat.Presheaf.stalk F.val.presheaf x) : Type u) ≃ₗ[
          X.presheaf.stalk x]
      (↑(TopCat.Presheaf.stalk F.val.presheaf x) : Type u) ⧸
        (IsLocalRing.maximalIdeal (X.presheaf.stalk x) •
          (⊤ : Submodule (X.presheaf.stalk x)
            (↑(TopCat.Presheaf.stalk F.val.presheaf x) : Type u))) := by
  letI : Module (X.presheaf.stalk x)
      (↑(TopCat.Presheaf.stalk F.val.presheaf x) : Type u) :=
    schemeModuleStalkModule F x
  exact residueFieldTensorEquivQuotSMul

/-! The quotient model is functorial for maps preserving the ideal action. -/

/-- The tensor--quotient equivalence commutes with a linear map that carries
the `I`-action submodule into the target `I`-action submodule. -/
theorem quotTensorEquivQuotSMul_naturality
    {R M N : Type*} [CommRing R] [AddCommGroup M] [AddCommGroup N]
    [Module R M] [Module R N] (I : Ideal R) (f : M →ₗ[R] N)
    (hI : I • (⊤ : Submodule R M) ≤
      (I • (⊤ : Submodule R N)).comap f) :
    (quotTensorEquivQuotSMul (M := N) I).toLinearMap ∘ₗ
        (f.lTensor (R ⧸ I)) =
      ((I • (⊤ : Submodule R M)).mapQ (I • (⊤ : Submodule R N)) f hI) ∘ₗ
        (quotTensorEquivQuotSMul (M := M) I).toLinearMap := by
  apply LinearMap.ext
  intro z
  induction z using TensorProduct.induction_on with
  | zero => simp
  | tmul r m =>
      obtain ⟨a, rfl⟩ := Ideal.Quotient.mk_surjective r
      simp [LinearMap.comp_apply]
  | add x y hx hy =>
      simpa only [map_add, LinearMap.comp_apply] using
        congrArg₂ (fun a b => a + b) hx hy

end MilneLib
