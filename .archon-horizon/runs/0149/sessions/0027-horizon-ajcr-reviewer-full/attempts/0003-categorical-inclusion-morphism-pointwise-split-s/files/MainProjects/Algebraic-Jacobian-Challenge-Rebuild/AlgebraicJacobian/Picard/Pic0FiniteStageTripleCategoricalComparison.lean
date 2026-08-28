/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleModelComparison
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleOverlapRings

/-!
# Categorical comparison for finite-stage Picard triple-overlap models

The component comparisons identify the scalar extensions of the descended chart and
pair-overlap rings with their exact section rings.  Bundling those rings in
`CommRingCat` lets us transport the exact triple-overlap pushout without asking Lean to
reduce the incompatible hierarchy witnesses hidden in a monolithic tensor equivalence.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

set_option synthInstance.maxHeartbeats 400000 in
-- Each corner contains a scalar extension of a dependent finite-presentation model.
set_option maxHeartbeats 3200000 in
/-- The exact triple-overlap pushout transported back through the three component
comparisons. -/
theorem pic0FiniteStageTripleComparisonSquare
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (e : forall j,
      k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
        Pic0FiniteStageRing C j)
    (M : DatG0.FinSubext L.1 k)
    (mapM : forall q : Pic0FiniteStageMapIndex C,
      Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapSource C q) →ₐ[M.1]
        Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapTarget C q))
    (hmapM : forall q,
      (Algebra.TensorProduct.map M.1.val
          (AlgHom.id L.1
            (DatG0.FiniteRelationAlgebra L.1
              (n (Pic0FiniteStageMapTarget C q))
              (m (Pic0FiniteStageMapTarget C q))
              (relation (Pic0FiniteStageMapTarget C q))))).comp
          ((mapM q).restrictScalars L.1) =
        ((pic0FiniteStageTransportedMap C L n m relation e q).restrictScalars
          L.1).comp
          (Algebra.TensorProduct.map M.1.val
            (AlgHom.id L.1
              (DatG0.FiniteRelationAlgebra L.1
                (n (Pic0FiniteStageMapSource C q))
                (m (Pic0FiniteStageMapSource C q))
                (relation (Pic0FiniteStageMapSource C q))))))
    (U V W : Pic0FiniteStageChartIndex C) :
    let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
    let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
    let eUV := pic0FiniteStageModelBaseChangeEquiv
      C L n m relation e M (Sum.inr (U, V))
    let eUW := pic0FiniteStageModelBaseChangeEquiv
      C L n m relation e M (Sum.inr (U, W))
    IsPushout
      (CommRingCat.ofHom kfUV.toRingHom)
      (CommRingCat.ofHom kfUW.toRingHom)
      (eUV.toRingEquiv.toCommRingCatIso.hom ≫
        CommRingCat.ofHom
          (pic0FiniteStageOverlapToTripleLeft C U V W).toRingHom)
      (eUW.toRingEquiv.toCommRingCatIso.hom ≫
        CommRingCat.ofHom
          (pic0FiniteStageOverlapToTripleRight C U V W).toRingHom) := by
  dsimp only
  let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
  let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
  let eU := pic0FiniteStageModelBaseChangeEquiv
    C L n m relation e M (Sum.inl U)
  let eUV := pic0FiniteStageModelBaseChangeEquiv
    C L n m relation e M (Sum.inr (U, V))
  let eUW := pic0FiniteStageModelBaseChangeEquiv
    C L n m relation e M (Sum.inr (U, W))
  apply (isPushout_pic0FiniteStageTripleRing C U V W).of_iso'
    eU.toRingEquiv.toCommRingCatIso
    eUV.toRingEquiv.toCommRingCatIso
    eUW.toRingEquiv.toCommRingCatIso
    (Iso.refl (CommRingCat.of (Pic0FiniteStageTripleRing C U V W)))
  · have hUV := pic0FiniteStageModelBaseChangeEquiv_restrictionLeft
      C L n m relation e M mapM hmapM U V
    change CommRingCat.ofHom
        (((pic0FiniteStageRestrictionLeft C U V).comp eU.toAlgHom).toRingHom) =
      CommRingCat.ofHom ((eUV.toAlgHom.comp kfUV).toRingHom)
    exact congrArg (fun q => CommRingCat.ofHom q.toRingHom) hUV.symm
  · have hUW := pic0FiniteStageModelBaseChangeEquiv_restrictionLeft
      C L n m relation e M mapM hmapM U W
    change CommRingCat.ofHom
        (((pic0FiniteStageRestrictionLeft C U W).comp eU.toAlgHom).toRingHom) =
      CommRingCat.ofHom ((eUW.toAlgHom.comp kfUW).toRingHom)
    exact congrArg (fun q => CommRingCat.ofHom q.toRingHom) hUW.symm
  · rfl
  · rfl

set_option synthInstance.maxHeartbeats 400000 in
-- The tensor-product object and all three dependent component models are bundled.
set_option maxHeartbeats 3200000 in
/-- The canonical categorical isomorphism from the scalar-extended model pushout to the
exact triple-overlap ring. -/
noncomputable def pic0FiniteStageTripleComparisonIso
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (e : forall j,
      k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
        Pic0FiniteStageRing C j)
    (M : DatG0.FinSubext L.1 k)
    (mapM : forall q : Pic0FiniteStageMapIndex C,
      Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapSource C q) →ₐ[M.1]
        Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapTarget C q))
    (hmapM : forall q,
      (Algebra.TensorProduct.map M.1.val
          (AlgHom.id L.1
            (DatG0.FiniteRelationAlgebra L.1
              (n (Pic0FiniteStageMapTarget C q))
              (m (Pic0FiniteStageMapTarget C q))
              (relation (Pic0FiniteStageMapTarget C q))))).comp
          ((mapM q).restrictScalars L.1) =
        ((pic0FiniteStageTransportedMap C L n m relation e q).restrictScalars
          L.1).comp
          (Algebra.TensorProduct.map M.1.val
            (AlgHom.id L.1
              (DatG0.FiniteRelationAlgebra L.1
                (n (Pic0FiniteStageMapSource C q))
                (m (Pic0FiniteStageMapSource C q))
                (relation (Pic0FiniteStageMapSource C q))))))
    (U V W : Pic0FiniteStageChartIndex C) :
    let A1 := k ⊗[M.1] Pic0FiniteStageChartModelRing C L n m relation M U
    let B1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U V
    let D1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U W
    let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
    let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
    letI : Algebra A1 B1 := kfUV.toRingHom.toAlgebra
    letI : Algebra A1 D1 := kfUW.toRingHom.toAlgebra
    CommRingCat.of (B1 ⊗[A1] D1) ≅
      CommRingCat.of (Pic0FiniteStageTripleRing C U V W) := by
  dsimp only
  let A1 := k ⊗[M.1] Pic0FiniteStageChartModelRing C L n m relation M U
  let B1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U V
  let D1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U W
  let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
  let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
  letI : Algebra A1 B1 := kfUV.toRingHom.toAlgebra
  letI : Algebra A1 D1 := kfUW.toRingHom.toAlgebra
  exact (CommRingCat.isPushout_tensorProduct A1 B1 D1).isoIsPushout
    (CommRingCat.of B1) (CommRingCat.of D1)
    (pic0FiniteStageTripleComparisonSquare
      C L n m relation e M mapM hmapM U V W)

section ComparisonFaces

set_option synthInstance.maxHeartbeats 400000
set_option maxHeartbeats 3200000

variable {F : Type u} [Field F] [Algebra F k]
variable (L : DatG0.FinSubext F k)
variable (n m : Pic0FiniteStageRingIndex C -> Nat)
variable (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
variable (e : forall j,
  k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
    Pic0FiniteStageRing C j)
variable (M : DatG0.FinSubext L.1 k)
variable (mapM : forall q : Pic0FiniteStageMapIndex C,
  Pic0FiniteStageModelRing C L n m relation M
      (Pic0FiniteStageMapSource C q) →ₐ[M.1]
    Pic0FiniteStageModelRing C L n m relation M
      (Pic0FiniteStageMapTarget C q))
variable (hmapM : forall q,
  (Algebra.TensorProduct.map M.1.val
      (AlgHom.id L.1
        (DatG0.FiniteRelationAlgebra L.1
          (n (Pic0FiniteStageMapTarget C q))
          (m (Pic0FiniteStageMapTarget C q))
          (relation (Pic0FiniteStageMapTarget C q))))).comp
      ((mapM q).restrictScalars L.1) =
    ((pic0FiniteStageTransportedMap C L n m relation e q).restrictScalars
      L.1).comp
      (Algebra.TensorProduct.map M.1.val
        (AlgHom.id L.1
          (DatG0.FiniteRelationAlgebra L.1
            (n (Pic0FiniteStageMapSource C q))
            (m (Pic0FiniteStageMapSource C q))
            (relation (Pic0FiniteStageMapSource C q))))))

/-- The left tensor inclusion followed by the categorical comparison is the transported
exact left face. -/
theorem pic0FiniteStageTripleComparisonIso_includeLeft_hom
    (U V W : Pic0FiniteStageChartIndex C) :
    let A1 := k ⊗[M.1] Pic0FiniteStageChartModelRing C L n m relation M U
    let B1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U V
    let D1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U W
    let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
    let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
    let eUV := pic0FiniteStageModelBaseChangeEquiv
      C L n m relation e M (Sum.inr (U, V))
    letI : Algebra A1 B1 := kfUV.toRingHom.toAlgebra
    letI : Algebra A1 D1 := kfUW.toRingHom.toAlgebra
    CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
        (R := A1) (A := B1) (B := D1)) ≫
        (pic0FiniteStageTripleComparisonIso
          C L n m relation e M mapM hmapM U V W).hom =
      eUV.toRingEquiv.toCommRingCatIso.hom ≫
        CommRingCat.ofHom
          (pic0FiniteStageOverlapToTripleLeft C U V W).toRingHom := by
  dsimp only
  let A1 := k ⊗[M.1] Pic0FiniteStageChartModelRing C L n m relation M U
  let B1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U V
  let D1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U W
  let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
  let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
  letI : Algebra A1 B1 := kfUV.toRingHom.toAlgebra
  letI : Algebra A1 D1 := kfUW.toRingHom.toAlgebra
  exact (CommRingCat.isPushout_tensorProduct A1 B1 D1).inl_isoIsPushout_hom
    (CommRingCat.of B1) (CommRingCat.of D1)
    (pic0FiniteStageTripleComparisonSquare
      C L n m relation e M mapM hmapM U V W)

set_option synthInstance.maxHeartbeats 400000 in
-- The source tensor product uses algebra structures selected by the two scalar maps.
set_option maxHeartbeats 3200000 in
/-- The categorical comparison carries the left tensor inclusion to exact restriction
from the first pair-overlap. -/
theorem pic0FiniteStageTripleComparisonIso_includeLeft
    (U V W : Pic0FiniteStageChartIndex C)
    (x : k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U V) :
    let A1 := k ⊗[M.1] Pic0FiniteStageChartModelRing C L n m relation M U
    let B1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U V
    let D1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U W
    let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
    let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
    letI : Algebra A1 B1 := kfUV.toRingHom.toAlgebra
    letI : Algebra A1 D1 := kfUW.toRingHom.toAlgebra
    (pic0FiniteStageTripleComparisonIso
        C L n m relation e M mapM hmapM U V W).hom.hom
        (x ⊗ₜ[A1] (1 : D1)) =
      pic0FiniteStageOverlapToTripleLeft C U V W
        (pic0FiniteStageModelBaseChangeEquiv
          C L n m relation e M (Sum.inr (U, V)) x) := by
  dsimp only
  let A1 := k ⊗[M.1] Pic0FiniteStageChartModelRing C L n m relation M U
  let B1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U V
  let D1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U W
  let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
  let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
  letI : Algebra A1 B1 := kfUV.toRingHom.toAlgebra
  letI : Algebra A1 D1 := kfUW.toRingHom.toAlgebra
  let eUV := pic0FiniteStageModelBaseChangeEquiv
    C L n m relation e M (Sum.inr (U, V))
  have hleft := pic0FiniteStageTripleComparisonIso_includeLeft_hom
    C L n m relation e M mapM hmapM U V W
  have hx := congrArg
    (fun q : CommRingCat.of B1 ⟶
        CommRingCat.of (Pic0FiniteStageTripleRing C U V W) => q.hom x) hleft
  change (pic0FiniteStageTripleComparisonIso
      C L n m relation e M mapM hmapM U V W).hom.hom
      (x ⊗ₜ[A1] (1 : D1)) =
    pic0FiniteStageOverlapToTripleLeft C U V W (eUV x) at hx
  exact hx

/-- The right tensor inclusion followed by the categorical comparison is the transported
exact right face. -/
theorem pic0FiniteStageTripleComparisonIso_includeRight_hom
    (U V W : Pic0FiniteStageChartIndex C) :
    let A1 := k ⊗[M.1] Pic0FiniteStageChartModelRing C L n m relation M U
    let B1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U V
    let D1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U W
    let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
    let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
    let eUW := pic0FiniteStageModelBaseChangeEquiv
      C L n m relation e M (Sum.inr (U, W))
    letI : Algebra A1 B1 := kfUV.toRingHom.toAlgebra
    letI : Algebra A1 D1 := kfUW.toRingHom.toAlgebra
    CommRingCat.ofHom (Algebra.TensorProduct.includeRight
        (R := A1) (A := B1) (B := D1)).toRingHom ≫
        (pic0FiniteStageTripleComparisonIso
          C L n m relation e M mapM hmapM U V W).hom =
      eUW.toRingEquiv.toCommRingCatIso.hom ≫
        CommRingCat.ofHom
          (pic0FiniteStageOverlapToTripleRight C U V W).toRingHom := by
  dsimp only
  let A1 := k ⊗[M.1] Pic0FiniteStageChartModelRing C L n m relation M U
  let B1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U V
  let D1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U W
  let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
  let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
  letI : Algebra A1 B1 := kfUV.toRingHom.toAlgebra
  letI : Algebra A1 D1 := kfUW.toRingHom.toAlgebra
  exact (CommRingCat.isPushout_tensorProduct A1 B1 D1).inr_isoIsPushout_hom
    (CommRingCat.of B1) (CommRingCat.of D1)
    (pic0FiniteStageTripleComparisonSquare
      C L n m relation e M mapM hmapM U V W)

set_option synthInstance.maxHeartbeats 400000 in
-- The source tensor product uses algebra structures selected by the two scalar maps.
set_option maxHeartbeats 3200000 in
/-- The categorical comparison carries the right tensor inclusion to exact restriction
from the second pair-overlap. -/
theorem pic0FiniteStageTripleComparisonIso_includeRight
    (U V W : Pic0FiniteStageChartIndex C)
    (x : k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U W) :
    let A1 := k ⊗[M.1] Pic0FiniteStageChartModelRing C L n m relation M U
    let B1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U V
    let D1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U W
    let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
    let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
    letI : Algebra A1 B1 := kfUV.toRingHom.toAlgebra
    letI : Algebra A1 D1 := kfUW.toRingHom.toAlgebra
    (pic0FiniteStageTripleComparisonIso
        C L n m relation e M mapM hmapM U V W).hom.hom
        ((1 : B1) ⊗ₜ[A1] x) =
      pic0FiniteStageOverlapToTripleRight C U V W
        (pic0FiniteStageModelBaseChangeEquiv
          C L n m relation e M (Sum.inr (U, W)) x) := by
  dsimp only
  let A1 := k ⊗[M.1] Pic0FiniteStageChartModelRing C L n m relation M U
  let B1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U V
  let D1 := k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U W
  let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
  let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
  letI : Algebra A1 B1 := kfUV.toRingHom.toAlgebra
  letI : Algebra A1 D1 := kfUW.toRingHom.toAlgebra
  let eUW := pic0FiniteStageModelBaseChangeEquiv
    C L n m relation e M (Sum.inr (U, W))
  have hright := pic0FiniteStageTripleComparisonIso_includeRight_hom
    C L n m relation e M mapM hmapM U V W
  have hx := congrArg
    (fun q : CommRingCat.of D1 ⟶
        CommRingCat.of (Pic0FiniteStageTripleRing C U V W) => q.hom x) hright
  change (pic0FiniteStageTripleComparisonIso
      C L n m relation e M mapM hmapM U V W).hom.hom
      ((1 : B1) ⊗ₜ[A1] x) =
    pic0FiniteStageOverlapToTripleRight C U V W (eUW x) at hx
  exact hx

end ComparisonFaces

end

end AlgebraicGeometry
