/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.PicEtPushoutCarrierOverlap
import AlgebraicJacobian.Picard.PicEtTensorStageOverlap
import AlgebraicJacobian.Picard.RelPicFaithfullyFlatInjective
import AlgebraicJacobian.Picard.RelPicTensorStageFiniteStage

/-!
# Canonical tensor-stage descent helpers

The declarations in this module isolate the dependent tensor comparisons used by the
canonical finite-stage descent constructor.  Keeping them in a separate module lets each
comparison elaborate independently of the final wrapper.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

set_option synthInstance.maxHeartbeats 100000 in
set_option maxHeartbeats 800000 in
set_option maxSynthPendingDepth 16 in
/-- The canonical map from a selected normalized carrier stage to the actual ambient
base-changed cover carrier.  The intermediate tensor algebra is pinned inside the
definition and does not occur in the public type. -/
noncomputable def tensorStageDataCarrierMap
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : DatG0.FinSubext F K) :
    let R := M.1 ⊗[F] B
    let TK := K ⊗[F] B
    let iota : R →ₐ[F] TK :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra R TK := iota.toRingHom.toAlgebra
    ∀ (E₀ : Algebra.EtaleCover R) (S : DatG0.FiniteStageData M.1 K),
      S.stage ⊗[M.1] E₀.Carrier →ₐ[M.1] (E₀.baseChange TK).Carrier := by
  dsimp only
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
    iota.toRingHom.toAlgebra
  intro E₀ S
  letI : Algebra M.1 (K ⊗[M.1] E₀.Carrier) :=
    Algebra.TensorProduct.instAlgebra
  exact
    ((DatG0.etaleCoverTensorStageCarrierEquiv M E₀).symm.toAlgHom.restrictScalars M.1).comp
      (S.tensorMap (A := E₀.Carrier))

set_option synthInstance.maxHeartbeats 100000 in
set_option maxHeartbeats 1600000 in
set_option maxSynthPendingDepth 16 in
/-- The canonical map from a selected normalized overlap stage to the actual ambient
self-overlap.  As for `tensorStageDataCarrierMap`, the intermediate algebra instance is
kept behind the definition. -/
noncomputable def tensorStageDataOverlapMap
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : DatG0.FinSubext F K) :
    let R := M.1 ⊗[F] B
    let TK := K ⊗[F] B
    let iota : R →ₐ[F] TK :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra R TK := iota.toRingHom.toAlgebra
    ∀ (E₀ : Algebra.EtaleCover R) (S : DatG0.FiniteStageData M.1 K),
      let f : R →ₐ[M.1] E₀.Carrier :=
        (Algebra.ofId R E₀.Carrier).restrictScalars M.1
      S.stage ⊗[M.1] Pic0FiniteStageTensorPushoutRing f f →ₐ[M.1]
        (E₀.baseChange TK).Carrier ⊗[TK] (E₀.baseChange TK).Carrier := by
  dsimp only
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
    iota.toRingHom.toAlgebra
  intro E₀ S
  let f : M.1 ⊗[F] B →ₐ[M.1] E₀.Carrier :=
    (Algebra.ofId (M.1 ⊗[F] B) E₀.Carrier).restrictScalars M.1
  let Q := Pic0FiniteStageTensorPushoutRing f f
  letI : Algebra M.1 (K ⊗[M.1] Q) := Algebra.TensorProduct.instAlgebra
  exact
    ((DatG0.etaleCoverTensorStageOverlapEquiv M E₀).toAlgHom.restrictScalars M.1).comp
      (S.tensorMap (A := Q))

private theorem relPicAlgMap_algEquiv_injective_tensorStage
    {k A B : Type u} [Field k]
    [CommRing A] [CommRing B] [Algebra k A] [Algebra k B]
    (C : Over (Spec (.of k))) (e : A ≃ₐ[k] B) :
    Function.Injective (relPicAlgMap C e.toAlgHom) := by
  intro x y hxy
  have h := congrArg (relPicAlgMap C e.symm.toAlgHom) hxy
  rw [← relPicAlgMap_comp, ← relPicAlgMap_comp,
    show e.symm.toAlgHom.comp e.toAlgHom = AlgHom.id k A from
      AlgHom.ext fun a => e.symm_apply_apply a,
    relPicAlgMap_id, relPicAlgMap_id] at h
  exact h

private theorem relPicAlgMap_symm_comp_eq_of_eq
    {k A B D : Type u} [Field k]
    [CommRing A] [CommRing B] [CommRing D]
    [Algebra k A] [Algebra k B] [Algebra k D]
    (C : Over (Spec (.of k)))
    (f : A →ₐ[k] B) (e : D ≃ₐ[k] B)
    (x : relPic C (overSpec k A)) (y : relPic C (overSpec k D))
    (h : relPicAlgMap C f x = relPicAlgMap C e.toAlgHom y) :
    relPicAlgMap C (e.symm.toAlgHom.comp f) x = y := by
  calc
    relPicAlgMap C (e.symm.toAlgHom.comp f) x =
        relPicAlgMap C e.symm.toAlgHom (relPicAlgMap C f x) :=
      relPicAlgMap_comp C f e.symm.toAlgHom x
    _ = relPicAlgMap C e.symm.toAlgHom
        (relPicAlgMap C e.toAlgHom y) := congrArg _ h
    _ = relPicAlgMap C (e.symm.toAlgHom.comp e.toAlgHom) y :=
      (relPicAlgMap_comp C e.toAlgHom e.symm.toAlgHom y).symm
    _ = relPicAlgMap C (AlgHom.id k D) y := by
      rw [show e.symm.toAlgHom.comp e.toAlgHom = AlgHom.id k D from
        AlgHom.ext fun d => e.symm_apply_apply d]
    _ = y := relPicAlgMap_id C y

set_option synthInstance.maxHeartbeats 100000 in
set_option maxHeartbeats 2400000 in
set_option maxSynthPendingDepth 16 in
/-- The finite-stage carrier map transports the selected stage class to the ambient class.

This is isolated from the final descent construction because the two tensor-product
`Algebra` instances on `K ⊗[M.1] E₀.Carrier` are definitionally close but not transparent
to rewriting. -/
theorem tensorStageData_map_eq
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : DatG0.FinSubext F K)
    {C : Over (Spec (.of M.1))} (pi : C.left ⟶ P1 M.1) [IsAffineHom pi]
    [IsProper C.hom] [GeometricallyIrreducible C.hom]
    [GeometricallyReduced C.hom] :
    let R := M.1 ⊗[F] B
    let TK := K ⊗[F] B
    let iota : R →ₐ[F] TK :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra R TK := iota.toRingHom.toAlgebra
    ∀ (E₀ : Algebra.EtaleCover R)
      (ξK : descentClasses C (E₀.baseChange TK))
      (D : RelPicTensorStageData pi
        (relPicAlgMap C
          ((DatG0.etaleCoverTensorStageCarrierEquiv M E₀).toAlgHom.restrictScalars M.1)
          ξK)),
      relPicAlgMap C (tensorStageDataCarrierMap M E₀ D.stage) D.qStage =
        (ξK : relPic C (overSpec M.1 (E₀.baseChange TK).Carrier)) := by
  dsimp only
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
    iota.toRingHom.toAlgebra
  intro E₀ ξK D
  let cA : (E₀.baseChange (K ⊗[F] B)).Carrier ≃ₐ[K]
      K ⊗[M.1] E₀.Carrier :=
    DatG0.etaleCoverTensorStageCarrierEquiv M E₀
  let cAM := cA.restrictScalars M.1
  let eAM := cAM.symm
  change relPicAlgMap C
      (eAM.toAlgHom.comp (D.stage.tensorMap (A := E₀.Carrier))) D.qStage = ξK
  exact relPicAlgMap_symm_comp_eq_of_eq C
    (D.stage.tensorMap (A := E₀.Carrier)) cAM D.qStage ξK D.map_eq

set_option synthInstance.maxHeartbeats 100000 in
set_option maxHeartbeats 1600000 in
set_option maxSynthPendingDepth 16 in
/-- Restriction along the canonical finite-stage overlap map is injective. -/
theorem tensorStageData_overlapMap_injective
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : DatG0.FinSubext F K) (C : Over (Spec (.of M.1)))
    [IsProper C.hom] [GeometricallyIrreducible C.hom]
    [GeometricallyReduced C.hom] :
    let R := M.1 ⊗[F] B
    let TK := K ⊗[F] B
    let iota : R →ₐ[F] TK :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra R TK := iota.toRingHom.toAlgebra
    ∀ (E₀ : Algebra.EtaleCover R) (S : DatG0.FiniteStageData M.1 K),
      Function.Injective
        (relPicAlgMap C (tensorStageDataOverlapMap (B := B) M E₀ S)) := by
  dsimp only
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
    iota.toRingHom.toAlgebra
  intro E₀ S
  let f : M.1 ⊗[F] B →ₐ[M.1] E₀.Carrier :=
    (Algebra.ofId (M.1 ⊗[F] B) E₀.Carrier).restrictScalars M.1
  let Q := Pic0FiniteStageTensorPushoutRing f f
  letI algebraMKQ : Algebra M.1 (K ⊗[M.1] Q) :=
    Algebra.TensorProduct.instAlgebra
  let nQ : S.stage ⊗[M.1] Q →ₐ[M.1] K ⊗[M.1] Q :=
    S.tensorMap (A := Q)
  let eQk : K ⊗[M.1] Q ≃ₐ[M.1]
      (E₀.baseChange (K ⊗[F] B)).Carrier ⊗[K ⊗[F] B]
        (E₀.baseChange (K ⊗[F] B)).Carrier :=
    (DatG0.etaleCoverTensorStageOverlapEquiv M E₀).restrictScalars M.1
  letI : Algebra (S.stage ⊗[M.1] Q) (K ⊗[M.1] Q) :=
    S.tensorAlgebra (A := Q)
  letI : IsScalarTower M.1 (S.stage ⊗[M.1] Q) (K ⊗[M.1] Q) :=
    S.tensorTower (A := Q)
  letI : Module.FaithfullyFlat (S.stage ⊗[M.1] Q) (K ⊗[M.1] Q) :=
    DatG0.tensorStageMap_faithfullyFlat (B := Q) S.toFinSubext
  have hnQ : Function.Injective (relPicAlgMap C nQ) :=
    relPicAlgMap_faithfullyFlat_injective C
  have heQ : Function.Injective (relPicAlgMap C eQk.toAlgHom) :=
    relPicAlgMap_algEquiv_injective_tensorStage C eQk
  change Function.Injective (relPicAlgMap C (eQk.toAlgHom.comp nQ))
  intro x y hxy
  apply hnQ
  apply heQ
  simpa only [relPicAlgMap_comp] using hxy

set_option synthInstance.maxHeartbeats 100000 in
set_option maxHeartbeats 1600000 in
set_option maxSynthPendingDepth 16 in
/-- The canonical finite-stage overlap map intertwines the normalized and actual left
faces. -/
theorem tensorStageData_faceLeft
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : DatG0.FinSubext F K) :
    let R := M.1 ⊗[F] B
    let TK := K ⊗[F] B
    let iota : R →ₐ[F] TK :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra R TK := iota.toRingHom.toAlgebra
    ∀ (E₀ : Algebra.EtaleCover R) (S : DatG0.FiniteStageData M.1 K),
      let f : R →ₐ[M.1] E₀.Carrier :=
        (Algebra.ofId R E₀.Carrier).restrictScalars M.1
      let q₁ := finiteStageTensorPushoutFaceLeft f f
      (tensorStageDataOverlapMap (B := B) M E₀ S).comp
          ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := M.1) (K := S.stage) q₁).restrictScalars M.1) =
        (doubleInl (E₀.baseChange TK)).comp
          (tensorStageDataCarrierMap (B := B) M E₀ S) := by
  dsimp only
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
    iota.toRingHom.toAlgebra
  intro E₀ S
  let f : M.1 ⊗[F] B →ₐ[M.1] E₀.Carrier :=
    (Algebra.ofId (M.1 ⊗[F] B) E₀.Carrier).restrictScalars M.1
  let Q := Pic0FiniteStageTensorPushoutRing f f
  let q₁ : E₀.Carrier →ₐ[M.1] Q := finiteStageTensorPushoutFaceLeft f f
  letI algebraMKA : Algebra M.1 (K ⊗[M.1] E₀.Carrier) :=
    Algebra.TensorProduct.instAlgebra
  letI algebraMKQ : Algebra M.1 (K ⊗[M.1] Q) :=
    Algebra.TensorProduct.instAlgebra
  let nA := S.tensorMap (A := E₀.Carrier)
  let nQ := S.tensorMap (A := Q)
  let eAk : K ⊗[M.1] E₀.Carrier →ₐ[M.1]
      (E₀.baseChange (K ⊗[F] B)).Carrier :=
    (DatG0.etaleCoverTensorStageCarrierEquiv M E₀).symm.toAlgHom.restrictScalars M.1
  let eQk : K ⊗[M.1] Q →ₐ[M.1]
      (E₀.baseChange (K ⊗[F] B)).Carrier ⊗[K ⊗[F] B]
        (E₀.baseChange (K ⊗[F] B)).Carrier :=
    (DatG0.etaleCoverTensorStageOverlapEquiv M E₀).toAlgHom.restrictScalars M.1
  let q₁S := (AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := S.stage) q₁).restrictScalars M.1
  let q₁K := (AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := K) q₁).restrictScalars M.1
  have hn₁ : nQ.comp q₁S = q₁K.comp nA := by
    exact AlgebraicJacobian.scalarExtensionMapOfAlgHom_tower q₁
  have he₁ : eQk.comp q₁K = (doubleInl (E₀.baseChange (K ⊗[F] B))).comp eAk := by
    apply AlgHom.ext
    intro x
    exact DFunLike.congr_fun
      (DatG0.etaleCoverTensorStageOverlapEquiv_faceLeft
        (F := F) (K := K) (B := B) M E₀) x
  change (eQk.comp nQ).comp q₁S =
    (doubleInl (E₀.baseChange (K ⊗[F] B))).comp (eAk.comp nA)
  have h₁' := congrArg (fun h => h.comp nA) he₁
  calc
    (eQk.comp nQ).comp q₁S = eQk.comp (nQ.comp q₁S) := by
      apply AlgHom.ext
      intro x
      rfl
    _ = eQk.comp (q₁K.comp nA) :=
      congrArg (fun h => eQk.comp h) hn₁
    _ = (eQk.comp q₁K).comp nA := by
      apply AlgHom.ext
      intro x
      rfl
    _ = ((doubleInl (E₀.baseChange (K ⊗[F] B))).comp eAk).comp nA := h₁'
    _ = (doubleInl (E₀.baseChange (K ⊗[F] B))).comp (eAk.comp nA) := by
      apply AlgHom.ext
      intro x
      rfl

set_option synthInstance.maxHeartbeats 100000 in
set_option maxHeartbeats 1600000 in
set_option maxSynthPendingDepth 16 in
/-- The canonical finite-stage overlap map intertwines the normalized and actual right
faces. -/
theorem tensorStageData_faceRight
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : DatG0.FinSubext F K) :
    let R := M.1 ⊗[F] B
    let TK := K ⊗[F] B
    let iota : R →ₐ[F] TK :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra R TK := iota.toRingHom.toAlgebra
    ∀ (E₀ : Algebra.EtaleCover R) (S : DatG0.FiniteStageData M.1 K),
      let f : R →ₐ[M.1] E₀.Carrier :=
        (Algebra.ofId R E₀.Carrier).restrictScalars M.1
      let q₂ := finiteStageTensorPushoutFaceRight f f
      (tensorStageDataOverlapMap (B := B) M E₀ S).comp
          ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := M.1) (K := S.stage) q₂).restrictScalars M.1) =
        (doubleInr (E₀.baseChange TK)).comp
          (tensorStageDataCarrierMap (B := B) M E₀ S) := by
  dsimp only
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
    iota.toRingHom.toAlgebra
  intro E₀ S
  let f : M.1 ⊗[F] B →ₐ[M.1] E₀.Carrier :=
    (Algebra.ofId (M.1 ⊗[F] B) E₀.Carrier).restrictScalars M.1
  let Q := Pic0FiniteStageTensorPushoutRing f f
  let q₂ : E₀.Carrier →ₐ[M.1] Q := finiteStageTensorPushoutFaceRight f f
  letI algebraMKA : Algebra M.1 (K ⊗[M.1] E₀.Carrier) :=
    Algebra.TensorProduct.instAlgebra
  letI algebraMKQ : Algebra M.1 (K ⊗[M.1] Q) :=
    Algebra.TensorProduct.instAlgebra
  let nA := S.tensorMap (A := E₀.Carrier)
  let nQ := S.tensorMap (A := Q)
  let eAk : K ⊗[M.1] E₀.Carrier →ₐ[M.1]
      (E₀.baseChange (K ⊗[F] B)).Carrier :=
    (DatG0.etaleCoverTensorStageCarrierEquiv M E₀).symm.toAlgHom.restrictScalars M.1
  let eQk : K ⊗[M.1] Q →ₐ[M.1]
      (E₀.baseChange (K ⊗[F] B)).Carrier ⊗[K ⊗[F] B]
        (E₀.baseChange (K ⊗[F] B)).Carrier :=
    (DatG0.etaleCoverTensorStageOverlapEquiv M E₀).toAlgHom.restrictScalars M.1
  let q₂S := (AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := S.stage) q₂).restrictScalars M.1
  let q₂K := (AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := K) q₂).restrictScalars M.1
  have hn₂ : nQ.comp q₂S = q₂K.comp nA := by
    exact AlgebraicJacobian.scalarExtensionMapOfAlgHom_tower q₂
  have he₂ : eQk.comp q₂K = (doubleInr (E₀.baseChange (K ⊗[F] B))).comp eAk := by
    apply AlgHom.ext
    intro x
    exact DFunLike.congr_fun
      (DatG0.etaleCoverTensorStageOverlapEquiv_faceRight
        (F := F) (K := K) (B := B) M E₀) x
  change (eQk.comp nQ).comp q₂S =
    (doubleInr (E₀.baseChange (K ⊗[F] B))).comp (eAk.comp nA)
  have h₂' := congrArg (fun h => h.comp nA) he₂
  calc
    (eQk.comp nQ).comp q₂S = eQk.comp (nQ.comp q₂S) := by
      apply AlgHom.ext
      intro x
      rfl
    _ = eQk.comp (q₂K.comp nA) :=
      congrArg (fun h => eQk.comp h) hn₂
    _ = (eQk.comp q₂K).comp nA := by
      apply AlgHom.ext
      intro x
      rfl
    _ = ((doubleInr (E₀.baseChange (K ⊗[F] B))).comp eAk).comp nA := h₂'
    _ = (doubleInr (E₀.baseChange (K ⊗[F] B))).comp (eAk.comp nA) := by
      apply AlgHom.ext
      intro x
      rfl

end

end AlgebraicGeometry
