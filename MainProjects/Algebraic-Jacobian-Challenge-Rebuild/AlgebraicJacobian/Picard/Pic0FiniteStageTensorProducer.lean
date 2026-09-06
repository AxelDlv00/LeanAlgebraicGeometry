/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.PicEtAffTensorStageFiniteStage
import AlgebraicJacobian.Picard.Pic0FaithfullyFlatDegreeZero

/-!
# Finite tensor stages for degree-zero Picard classes

The finite-stage theorem for `PicEtAff` also applies to a degree-zero class.  The
class obtained at the finite stage is shown to remain degree zero by faithful-flat
reflection, yielding the finite-stage producer needed by the Picard descent route.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {F K B : Type u} [Field F] [Field K] [Algebra F K]
  [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]

variable (C : Over (Spec (.of F)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

/-- Every degree-zero affine Picard class over `K ⊗[F] B` is already defined over
one finite tensor stage.  The returned stage class is degree zero on its own test
ring, and its restriction is the original class. -/
theorem exists_pic0Subgroup_tensorStage
    (x : pic0Subgroup C (overSpec F (K ⊗[F] B))) :
    ∃ (S : DatG0.FiniteStageData F K)
      (xS : pic0Subgroup C (overSpec F (S.stage ⊗[F] B))),
      pic0Map C (Over.overSpecMap (S.tensorMap (A := B))) xS = x := by
  obtain ⟨D⟩ := exists_picEtAff_tensorStage_data C
    (picEtAffineEquiv C (K ⊗[F] B) (x : picEt C (overSpec F (K ⊗[F] B))))
  let S := D.stage
  let φ : S.stage ⊗[F] B →ₐ[F] K ⊗[F] B := S.tensorMap (A := B)
  let lamS : picEt C (overSpec F (S.stage ⊗[F] B)) :=
    (picEtAffineEquiv C (S.stage ⊗[F] B)).symm D.xStage
  have hmap : picEtMap C (Over.overSpecMap φ) lamS =
      (x : picEt C (overSpec F (K ⊗[F] B))) := by
    apply (picEtAffineEquiv C (K ⊗[F] B)).injective
    rw [picEtAffineEquiv_naturality, MulEquiv.apply_symm_apply]
    exact D.map_eq
  letI : Algebra (S.stage ⊗[F] B) (K ⊗[F] B) := S.tensorAlgebra (A := B)
  have hff : φ.toRingHom.FaithfullyFlat := by
    haveI : Module.FaithfullyFlat (S.stage ⊗[F] B) (K ⊗[F] B) :=
      DatG0.tensorStageMap_faithfullyFlat (B := B) S.toFinSubext
    have halg : algebraMap (S.stage ⊗[F] B) (K ⊗[F] B) = φ.toRingHom := rfl
    rw [← halg]
    exact RingHom.faithfullyFlat_algebraMap_iff.mpr inferInstance
  have hzero : lamS ∈ pic0Subgroup C (overSpec F (S.stage ⊗[F] B)) := by
    apply mem_pic0Subgroup_of_faithfullyFlat (C := C) φ hff lamS
    rw [hmap]
    exact x.property
  refine ⟨S, ⟨lamS, hzero⟩, ?_⟩
  apply Subtype.ext
  change picEtMap C (Over.overSpecMap φ) lamS =
    (x : picEt C (overSpec F (K ⊗[F] B)))
  exact hmap

/-- A finite family of degree-zero classes descends simultaneously after enlarging any
prescribed finite stage.  The enlargement retains coefficients already used for chart
rings and restriction maps.  Compatibility between different family members is a separate
obligation. -/
theorem exists_pic0Subgroup_tensorStage_finite
    {ι : Type*} [Finite ι]
    (A : ι → Type u) [∀ i, CommRing (A i)] [∀ i, Algebra F (A i)]
    (S₀ : DatG0.FiniteStageData F K)
    (x : ∀ i, pic0Subgroup C (overSpec F (K ⊗[F] A i))) :
    ∃ (S : DatG0.FiniteStageData F K), S₀.stage ≤ S.stage ∧
      ∃ xS : ∀ i, pic0Subgroup C (overSpec F (S.stage ⊗[F] A i)),
        ∀ i, pic0Map C (Over.overSpecMap (S.tensorMap (A := A i))) (xS i) = x i := by
  classical
  choose M xM hxM using fun i => exists_pic0Subgroup_tensorStage C (x i)
  obtain ⟨N, hN⟩ := Finite.exists_le fun i => (M i).toFinSubext
  obtain ⟨S, hNS, hS₀S⟩ := DatG0.directed_finSubext N S₀.toFinSubext
  have hMS (i : ι) : (M i).stage ≤ (DatG0.FiniteStageData.ofFinSubext S).stage :=
    (hN i).trans hNS
  let j (i : ι) : (M i).stage ⊗[F] A i →ₐ[F]
      (DatG0.FiniteStageData.ofFinSubext S).stage ⊗[F] A i :=
    Algebra.TensorProduct.map (IntermediateField.inclusion (hMS i)) (AlgHom.id F (A i))
  refine ⟨DatG0.FiniteStageData.ofFinSubext S, hS₀S,
    fun i => pic0Map C (Over.overSpecMap (j i)) (xM i), ?_⟩
  intro i
  apply Subtype.ext
  change picEtMap C (Over.overSpecMap
      ((DatG0.FiniteStageData.ofFinSubext S).tensorMap (A := A i)))
      (picEtMap C (Over.overSpecMap (j i)) (xM i).val) = (x i).val
  rw [← picEtMap_comp, ← Over.overSpecMap_comp]
  have hcomp : ((DatG0.FiniteStageData.ofFinSubext S).tensorMap (A := A i)).comp
      (j i) = (M i).tensorMap := by
    ext z <;> rfl
  rw [hcomp]
  exact congrArg Subtype.val (hxM i)

end

end AlgebraicGeometry
