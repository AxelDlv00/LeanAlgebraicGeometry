/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.PicRepColimitResidual
import Mathlib.FieldTheory.IntermediateField.Adjoin.Algebra
import Mathlib.RingTheory.Smooth.NoetherianDescent
import Mathlib.RingTheory.TensorProduct.DirectLimitFG

/-!
# Tensor products over algebraic extensions at finite subextensions

Elements and equalities in a tensor product with an algebraic field extension are already
defined at finite intermediate extensions.  These are finite-field wrappers around the
finitely generated subalgebra results in `Mathlib.RingTheory.TensorProduct.DirectLimitFG`.
-/

set_option autoImplicit false

universe u

open TensorProduct

namespace AlgebraicGeometry.DatG0

/-- Every element of `K ⊗[F] B` comes from `L ⊗[F] B` for some finite subextension
`L/F` of an algebraic extension `K/F`. -/
theorem exists_finSubext_tensorProduct_preimage
    {F K B : Type u} [Field F] [Field K] [Algebra F K] [Algebra.IsAlgebraic F K]
    [CommRing B] [Algebra F B] (x : K ⊗[F] B) :
    ∃ L : FinSubext F K, ∃ xL : L.1 ⊗[F] B,
      LinearMap.rTensor B L.1.val.toLinearMap xL = x := by
  obtain ⟨A, hA, xA, hxA⟩ := TensorProduct.Algebra.exists_of_fg x
  letI : Algebra.IsAlgebraic F A :=
    Algebra.IsAlgebraic.of_injective A.val Subtype.val_injective
  let L0 : IntermediateField F K := Algebra.IsAlgebraic.toIntermediateField A
  letI : Algebra.FiniteType F L0 := by
    change Algebra.FiniteType F A
    exact (Subalgebra.fg_iff_finiteType A).mp hA
  letI : Module.Finite F L0 := Algebra.finite_of_essFiniteType_of_isAlgebraic
  let L : FinSubext F K := ⟨L0, inferInstance⟩
  exact ⟨L, xA, hxA⟩

/-- If two tensors over a finite subextension become equal over `K`, they are already equal
after passage to some larger finite subextension. -/
theorem exists_finSubext_tensorProduct_eq
    {F K B : Type u} [Field F] [Field K] [Algebra F K] [Algebra.IsAlgebraic F K]
    [CommRing B] [Algebra F B] (L : FinSubext F K) (x y : L.1 ⊗[F] B)
    (hxy : LinearMap.rTensor B L.1.val.toLinearMap x =
      LinearMap.rTensor B L.1.val.toLinearMap y) :
    ∃ M : FinSubext F K, ∃ hLM : L.1 ≤ M.1,
      LinearMap.rTensor B (IntermediateField.inclusion hLM).toLinearMap x =
        LinearMap.rTensor B (IntermediateField.inclusion hLM).toLinearMap y := by
  have hLfg : L.1.toSubalgebra.FG := by
    rw [Subalgebra.fg_iff_finiteType]
    change Algebra.FiniteType F L.1
    infer_instance
  obtain ⟨A, hLA, hA, hxyA⟩ :=
    TensorProduct.Algebra.eq_of_fg_of_subtype_eq hLfg hxy
  letI : Algebra.IsAlgebraic F A :=
    Algebra.IsAlgebraic.of_injective A.val Subtype.val_injective
  let M0 : IntermediateField F K := Algebra.IsAlgebraic.toIntermediateField A
  letI : Algebra.FiniteType F M0 := by
    change Algebra.FiniteType F A
    exact (Subalgebra.fg_iff_finiteType A).mp hA
  letI : Module.Finite F M0 := Algebra.finite_of_essFiniteType_of_isAlgebraic
  let M : FinSubext F K := ⟨M0, inferInstance⟩
  have hLM : L.1 ≤ M.1 := hLA
  exact ⟨M, hLM, hxyA⟩

end AlgebraicGeometry.DatG0
