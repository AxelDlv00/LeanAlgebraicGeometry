/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.FieldTheory.IntermediateField.Basic
import Mathlib.RingTheory.TensorProduct.Maps

/-!
# Enlarging the coefficient field of a tensor algebra map

An algebra map between tensor products over an intermediate field extends to
any larger intermediate field. The extension preserves a comparison square
with a fixed map over the ambient field. In particular, previously descended
transition maps can be retained when a finite stage is enlarged to a Galois one.
-/

set_option autoImplicit false

universe u

open scoped TensorProduct

namespace AlgebraicGeometry.DatG0

noncomputable section

variable {F K A B : Type u} [Field F] [Field K] [Algebra F K]
  [CommRing A] [Algebra F A] [CommRing B] [Algebra F B]
  {L M : IntermediateField F K}

/-- Extend a tensor algebra map along an inclusion of intermediate fields,
retaining tensor products over the original ground field. -/
def tensorAlgHomOfLE (h : L ≤ M)
    (f : L ⊗[F] A →ₐ[L] L ⊗[F] B) : M ⊗[F] A →ₐ[M] M ⊗[F] B :=
  AlgHom.liftEquiv F M A (M ⊗[F] B)
    ((Algebra.TensorProduct.map (IntermediateField.inclusion h) (AlgHom.id F B)).comp
      ((f.restrictScalars F).comp Algebra.TensorProduct.includeRight))

@[simp]
theorem tensorAlgHomOfLE_tmul (h : L ≤ M)
    (f : L ⊗[F] A →ₐ[L] L ⊗[F] B) (m : M) (a : A) :
    tensorAlgHomOfLE h f (m ⊗ₜ[F] a) = m •
      (Algebra.TensorProduct.map (IntermediateField.inclusion h) (AlgHom.id F B))
        (f (1 ⊗ₜ[F] a)) := rfl

/-- Enlarging the coefficient field preserves the comparison with a fixed
ambient algebra map. No algebraicity or finiteness hypothesis is needed. -/
theorem tensorAlgHomOfLE_comparison (h : L ≤ M)
    (f : L ⊗[F] A →ₐ[L] L ⊗[F] B)
    (fK : K ⊗[F] A →ₐ[K] K ⊗[F] B)
    (hf : (Algebra.TensorProduct.map L.val (AlgHom.id F B)).comp
        (f.restrictScalars F) =
      (fK.restrictScalars F).comp
        (Algebra.TensorProduct.map L.val (AlgHom.id F A))) :
    (Algebra.TensorProduct.map M.val (AlgHom.id F B)).comp
        ((tensorAlgHomOfLE h f).restrictScalars F) =
      (fK.restrictScalars F).comp
        (Algebra.TensorProduct.map M.val (AlgHom.id F A)) := by
  let g : A →ₐ[F] M ⊗[F] B :=
    (Algebra.TensorProduct.map (IntermediateField.inclusion h) (AlgHom.id F B)).comp
      ((f.restrictScalars F).comp Algebra.TensorProduct.includeRight)
  have hmap : (Algebra.TensorProduct.map M.val (AlgHom.id F B)).comp
      (Algebra.TensorProduct.map (IntermediateField.inclusion h) (AlgHom.id F B)) =
        Algebra.TensorProduct.map L.val (AlgHom.id F B) := by
    ext x <;> rfl
  ext x
  · change (Algebra.TensorProduct.map M.val (AlgHom.id F B))
        ((AlgHom.liftEquiv F M A (M ⊗[F] B) g)
          (Algebra.TensorProduct.includeLeft (R := F) (S := M) (A := M) (B := A) x)) =
      fK ((Algebra.TensorProduct.map M.val (AlgHom.id F A))
        (Algebra.TensorProduct.includeLeft (R := F) (S := M) (A := M) (B := A) x))
    simp only [Algebra.TensorProduct.includeLeft_apply, AlgHom.liftEquiv_tmul,
      Algebra.TensorProduct.map_tmul, map_one]
    have hunit : (Algebra.TensorProduct.map M.val (AlgHom.id F B)) (g 1) = 1 := by
      rw [map_one, map_one]
    simpa [Algebra.smul_def, hunit] using (fK.commutes (x : K)).symm
  · change (Algebra.TensorProduct.map M.val (AlgHom.id F B))
        ((AlgHom.liftEquiv F M A (M ⊗[F] B) g)
          (Algebra.TensorProduct.includeRight (R := F) (A := M) (B := A) x)) =
      fK ((Algebra.TensorProduct.map M.val (AlgHom.id F A))
        (Algebra.TensorProduct.includeRight (R := F) (A := M) (B := A) x))
    simp only [Algebra.TensorProduct.includeRight_apply, AlgHom.liftEquiv_tmul,
      Algebra.TensorProduct.map_tmul, AlgHom.id_apply, map_one, one_smul, g,
      AlgHom.comp_apply]
    rw [← AlgHom.comp_apply, hmap]
    exact DFunLike.congr_fun hf
      (Algebra.TensorProduct.includeRight (R := F) (A := L) (B := A) x)

end

end AlgebraicGeometry.DatG0
