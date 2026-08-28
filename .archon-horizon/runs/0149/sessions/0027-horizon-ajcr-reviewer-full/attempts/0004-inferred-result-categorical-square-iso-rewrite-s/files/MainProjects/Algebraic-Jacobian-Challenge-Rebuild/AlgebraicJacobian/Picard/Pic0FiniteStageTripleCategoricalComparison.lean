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
comparisons.  Its categorical type is inferred from the bundled maps, retaining their
chosen ring structures. -/
noncomputable def pic0FiniteStageTripleComparisonSquare
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
    (U V W : Pic0FiniteStageChartIndex C) :=
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
  (isPushout_pic0FiniteStageTripleRing C U V W).of_iso'
    eU.toRingEquiv.toCommRingCatIso
    eUV.toRingEquiv.toCommRingCatIso
    eUW.toRingEquiv.toCommRingCatIso
    (Iso.refl (CommRingCat.of (Pic0FiniteStageTripleRing C U V W)))
    (by
      have hUV := pic0FiniteStageModelBaseChangeEquiv_restrictionLeft
        C L n m relation e M mapM hmapM U V
      change CommRingCat.ofHom
          (((pic0FiniteStageRestrictionLeft C U V).comp eU.toAlgHom).toRingHom) =
        CommRingCat.ofHom ((eUV.toAlgHom.comp kfUV).toRingHom)
      exact congrArg (fun q => CommRingCat.ofHom q.toRingHom) hUV.symm)
    (by
      have hUW := pic0FiniteStageModelBaseChangeEquiv_restrictionLeft
        C L n m relation e M mapM hmapM U W
      change CommRingCat.ofHom
          (((pic0FiniteStageRestrictionLeft C U W).comp eU.toAlgHom).toRingHom) =
        CommRingCat.ofHom ((eUW.toAlgHom.comp kfUW).toRingHom)
      exact congrArg (fun q => CommRingCat.ofHom q.toRingHom) hUW.symm)
    (by rfl)
    (by rfl)

set_option synthInstance.maxHeartbeats 400000 in
-- The tensor-product object and all three dependent component models are bundled.
set_option maxHeartbeats 3200000 in
/-- The canonical categorical isomorphism from the scalar-extended model pushout to the
exact triple-overlap ring.  Its result type is inherited from the two pushout witnesses,
so no hierarchy witness is reconstructed at the declaration boundary. -/
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
    (U V W : Pic0FiniteStageChartIndex C) :=
  let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
  let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
  letI := kfUV.toRingHom.toAlgebra
  letI := kfUW.toRingHom.toAlgebra
  (CommRingCat.isPushout_tensorProduct
      (k ⊗[M.1] Pic0FiniteStageChartModelRing C L n m relation M U)
      (k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U V)
      (k ⊗[M.1] Pic0FiniteStageOverlapModelRing C L n m relation M U W)).isoIsPushout
    _ _
    (pic0FiniteStageTripleComparisonSquare
      C L n m relation e M mapM hmapM U V W)

end

end AlgebraicGeometry
