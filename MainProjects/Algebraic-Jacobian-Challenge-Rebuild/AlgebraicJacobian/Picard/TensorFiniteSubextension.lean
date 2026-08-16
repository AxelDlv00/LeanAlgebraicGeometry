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

/-- A finite family of elements of `K ⊗[F] B` comes from one common finite
subextension of `K/F`. -/
theorem exists_finSubext_tensorProduct_preimage_finite
    {F K B : Type u} [Field F] [Field K] [Algebra F K] [Algebra.IsAlgebraic F K]
    [CommRing B] [Algebra F B] {iota : Type*} [Finite iota]
    (x : iota → K ⊗[F] B) :
    ∃ L : FinSubext F K, ∃ xL : iota → L.1 ⊗[F] B,
      ∀ i, LinearMap.rTensor B L.1.val.toLinearMap (xL i) = x i := by
  classical
  letI := Fintype.ofFinite iota
  choose A hA xA hxA using fun i => TensorProduct.Algebra.exists_of_fg (x i)
  let A0 : Subalgebra F K := Finset.univ.sup A
  have hA0 : A0.FG := by
    dsimp only [A0]
    induction (Finset.univ : Finset iota) using Finset.induction_on with
    | empty => simpa using (Subalgebra.fg_bot : (⊥ : Subalgebra F K).FG)
    | @insert i s hi hs =>
        simpa [Finset.sup_insert] using (hA i).sup hs
  have hAA0 : ∀ i, A i ≤ A0 := fun i =>
    Finset.le_sup (s := Finset.univ) (f := A) (Finset.mem_univ i)
  let xA0 : iota → A0 ⊗[F] B := fun i =>
    LinearMap.rTensor B (Subalgebra.inclusion (hAA0 i)).toLinearMap (xA i)
  have hxA0 : ∀ i, LinearMap.rTensor B A0.val.toLinearMap (xA0 i) = x i := by
    intro i
    have hcomp :
        A0.val.toLinearMap.comp (Subalgebra.inclusion (hAA0 i)).toLinearMap =
          (A i).val.toLinearMap := by
      ext
      rfl
    dsimp only [xA0]
    rw [← LinearMap.rTensor_comp_apply, hcomp]
    exact hxA i
  letI : Algebra.IsAlgebraic F A0 :=
    Algebra.IsAlgebraic.of_injective A0.val Subtype.val_injective
  let L0 : IntermediateField F K := Algebra.IsAlgebraic.toIntermediateField A0
  letI : Algebra.FiniteType F L0 := by
    change Algebra.FiniteType F A0
    exact (Subalgebra.fg_iff_finiteType A0).mp hA0
  letI : Module.Finite F L0 := Algebra.finite_of_essFiniteType_of_isAlgebraic
  let L : FinSubext F K := ⟨L0, inferInstance⟩
  exact ⟨L, xA0, hxA0⟩

/-- A finite family of tensor equalities that holds over `K` already holds over one common
finite subextension containing the original stage. -/
theorem exists_finSubext_tensorProduct_eq_finite
    {F K B : Type u} [Field F] [Field K] [Algebra F K] [Algebra.IsAlgebraic F K]
    [CommRing B] [Algebra F B] {iota : Type*} [Finite iota]
    (L : FinSubext F K) (x y : iota → L.1 ⊗[F] B)
    (hxy : ∀ i, LinearMap.rTensor B L.1.val.toLinearMap (x i) =
      LinearMap.rTensor B L.1.val.toLinearMap (y i)) :
    ∃ M : FinSubext F K, ∃ hLM : L.1 ≤ M.1, ∀ i,
      LinearMap.rTensor B (IntermediateField.inclusion hLM).toLinearMap (x i) =
        LinearMap.rTensor B (IntermediateField.inclusion hLM).toLinearMap (y i) := by
  classical
  letI := Fintype.ofFinite iota
  have hLfg : L.1.toSubalgebra.FG := by
    rw [Subalgebra.fg_iff_finiteType]
    change Algebra.FiniteType F L.1
    infer_instance
  choose A hLA hA hxyA using fun i =>
    TensorProduct.Algebra.eq_of_fg_of_subtype_eq hLfg (hxy i)
  let A0 : Subalgebra F K := L.1.toSubalgebra ⊔ Finset.univ.sup A
  have hA0 : A0.FG := by
    apply hLfg.sup
    induction (Finset.univ : Finset iota) using Finset.induction_on with
    | empty => simpa using (Subalgebra.fg_bot : (⊥ : Subalgebra F K).FG)
    | @insert i s hi hs =>
        simpa [Finset.sup_insert] using (hA i).sup hs
  have hLA0 : L.1.toSubalgebra ≤ A0 := le_sup_left
  have hAA0 : ∀ i, A i ≤ A0 := fun i =>
    (Finset.le_sup (s := Finset.univ) (f := A) (Finset.mem_univ i)).trans le_sup_right
  have hxyA0 : ∀ i,
      LinearMap.rTensor B (Subalgebra.inclusion hLA0).toLinearMap (x i) =
        LinearMap.rTensor B (Subalgebra.inclusion hLA0).toLinearMap (y i) := by
    intro i
    have hi := congrArg
      (LinearMap.rTensor B (Subalgebra.inclusion (hAA0 i)).toLinearMap) (hxyA i)
    have hcomp :
        (Subalgebra.inclusion (hAA0 i)).toLinearMap.comp
            (Subalgebra.inclusion (hLA i)).toLinearMap =
          (Subalgebra.inclusion hLA0).toLinearMap := by
      ext
      rfl
    simpa only [← LinearMap.rTensor_comp_apply, hcomp] using hi
  letI : Algebra.IsAlgebraic F A0 :=
    Algebra.IsAlgebraic.of_injective A0.val Subtype.val_injective
  let M0 : IntermediateField F K := Algebra.IsAlgebraic.toIntermediateField A0
  letI : Algebra.FiniteType F M0 := by
    change Algebra.FiniteType F A0
    exact (Subalgebra.fg_iff_finiteType A0).mp hA0
  letI : Module.Finite F M0 := Algebra.finite_of_essFiniteType_of_isAlgebraic
  let M : FinSubext F K := ⟨M0, inferInstance⟩
  have hLM : L.1 ≤ M.1 := hLA0
  exact ⟨M, hLM, hxyA0⟩

end AlgebraicGeometry.DatG0
