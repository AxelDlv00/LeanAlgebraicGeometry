/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Curve.MapToP1
import AlgebraicJacobian.Picard.PicEtTensorStageCanonicalHelpers
import AlgebraicJacobian.Picard.PicEtAffDescentReflection

/-!
# Face compatibility at a finite tensor stage

Faithful flatness reflects the ambient descent equality to the normalized finite-stage
cover. The statement uses a stage and a class directly, independently of a Picard datum.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

set_option synthInstance.maxHeartbeats 100000 in
-- The canonical face maps use the polynomial-quotient carrier of an etale cover.
set_option maxHeartbeats 1600000 in
set_option maxSynthPendingDepth 16 in
/-- An ambient descent class reflects to equal normalized face restrictions at a finite
tensor stage as soon as its relative Picard class descends to that stage. -/
theorem tensorStageData_face_eq
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : DatG0.FinSubext F K) (C : Over (Spec (.of M.1)))
    [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom] :
    let R := M.1 ⊗[F] B
    let TK := K ⊗[F] B
    let iota : R →ₐ[F] TK := Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra R TK := iota.toRingHom.toAlgebra
    ∀ (E : Algebra.EtaleCover R) (S : DatG0.FiniteStageData M.1 K)
      (ξ : descentClasses C (E.baseChange TK))
      (q : relPic C (overSpec M.1 (S.stage ⊗[M.1] E.Carrier))),
      relPicAlgMap C (tensorStageDataCarrierMap (B := B) M E S) q = ξ →
      let f : R →ₐ[M.1] E.Carrier := (Algebra.ofId R E.Carrier).restrictScalars M.1
      relPicAlgMap C (Algebra.TensorProduct.map (AlgHom.id M.1 S.stage)
          (finiteStageTensorPushoutFaceLeft f f)) q =
        relPicAlgMap C (Algebra.TensorProduct.map (AlgHom.id M.1 S.stage)
          (finiteStageTensorPushoutFaceRight f f)) q := by
  dsimp only
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) := iota.toRingHom.toAlgebra
  intro E S ξ q hq
  let f : M.1 ⊗[F] B →ₐ[M.1] E.Carrier :=
    (Algebra.ofId (M.1 ⊗[F] B) E.Carrier).restrictScalars M.1
  let jA := tensorStageDataCarrierMap (B := B) M E S
  let jQ := tensorStageDataOverlapMap (B := B) M E S
  let q₁ := Algebra.TensorProduct.map (AlgHom.id M.1 S.stage)
    (finiteStageTensorPushoutFaceLeft f f)
  let q₂ := Algebra.TensorProduct.map (AlgHom.id M.1 S.stage)
    (finiteStageTensorPushoutFaceRight f f)
  have hjQ := tensorStageData_overlapMap_injective (B := B) M C E S
  have hleft := tensorStageData_faceLeft (B := B) M E S
  have hright := tensorStageData_faceRight (B := B) M E S
  have hξ := (mem_descentClasses_iff (C := C)).mp ξ.2
  have hmapLeft := congrArg (relPicAlgMap C (doubleInl (E.baseChange (K ⊗[F] B)))) hq
  have hmapRight := congrArg (relPicAlgMap C (doubleInr (E.baseChange (K ⊗[F] B)))) hq
  exact relPicAlgMap_pair_eq_of_injective C jA jQ q₁ q₂
    (doubleInl (E.baseChange (K ⊗[F] B))) (doubleInr (E.baseChange (K ⊗[F] B)))
    hjQ hleft hright (x := q) (hmapLeft.trans (hξ.trans hmapRight.symm))

set_option synthInstance.maxHeartbeats 100000 in
-- The finite-stage class lives on the polynomial-quotient carrier of an etale cover.
set_option maxHeartbeats 1600000 in
set_option maxSynthPendingDepth 16 in
/-- An ambient etale descent class has a normalized relative class at one finite tensor
stage, with both its ambient comparison and its face equality. -/
theorem exists_tensorStageData_class_faces
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : DatG0.FinSubext F K) (C : Over (Spec (.of M.1)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] :
    let R := M.1 ⊗[F] B
    let TK := K ⊗[F] B
    let iota : R →ₐ[F] TK := Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra R TK := iota.toRingHom.toAlgebra
    ∀ (E : Algebra.EtaleCover R) (ξ : descentClasses C (E.baseChange TK)),
      ∃ (S : DatG0.FiniteStageData M.1 K)
        (q : relPic C (overSpec M.1 (S.stage ⊗[M.1] E.Carrier))),
        relPicAlgMap C (tensorStageDataCarrierMap (B := B) M E S) q = ξ ∧
        let f : R →ₐ[M.1] E.Carrier := (Algebra.ofId R E.Carrier).restrictScalars M.1
        relPicAlgMap C (Algebra.TensorProduct.map (AlgHom.id M.1 S.stage)
            (finiteStageTensorPushoutFaceLeft f f)) q =
          relPicAlgMap C (Algebra.TensorProduct.map (AlgHom.id M.1 S.stage)
            (finiteStageTensorPushoutFaceRight f f)) q := by
  dsimp only
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) := iota.toRingHom.toAlgebra
  intro E ξ
  let hpi := exists_isFinite_toP1 (k := M.1) (C := C)
  let pi := Classical.choose hpi
  letI : IsFinite pi := (Classical.choose_spec hpi).1
  let cA := DatG0.etaleCoverTensorStageCarrierEquiv M E
  let qK := relPicAlgMap C (cA.toAlgHom.restrictScalars M.1) ξ
  let D := Classical.choice (exists_relPic_tensorStage_data
    (F := M.1) (K := K) (B := E.Carrier) (C := C) (pi := pi) qK)
  have hmap := tensorStageData_map_eq (B := B) M pi E ξ D
  exact ⟨D.stage, D.qStage, hmap,
    tensorStageData_face_eq (B := B) M C E D.stage ξ D.qStage hmap⟩

end

end AlgebraicGeometry
