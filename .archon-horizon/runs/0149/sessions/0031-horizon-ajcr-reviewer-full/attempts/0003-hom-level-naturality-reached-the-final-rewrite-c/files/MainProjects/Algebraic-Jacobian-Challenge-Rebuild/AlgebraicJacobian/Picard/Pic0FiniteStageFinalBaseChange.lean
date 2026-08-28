/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageGluedOver
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleModelComparison

/-!
# Base change of the final finite-stage Picard atlas

The glue package extends the finite-presentation models from `M` to a final finite
subextension `N`.  Extending once more to the separably closed field cancels the tower
`M -> N -> k`.  The resulting component equivalences recover the exact Picard atlas
rings and intertwine every restriction and transition map.
-/

set_option autoImplicit false

universe u

open CategoryTheory TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

/-- A finite-presentation model ring after extension to the final finite subextension. -/
noncomputable abbrev Pic0FiniteStageFinalModelRing
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (j : Pic0FiniteStageRingIndex C) : Type u :=
  N.1 ⊗[M.1] Pic0FiniteStageModelRing C L n m relation M j

set_option synthInstance.maxHeartbeats 400000 in
-- The comparison cancels two nested finite-subextension scalar towers.
set_option maxHeartbeats 6400000 in
/-- Scalar extension of a final finite-stage model ring recovers its exact atlas ring. -/
noncomputable def pic0FiniteStageFinalBaseChangeEquiv
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (e : forall j,
      k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
        Pic0FiniteStageRing C j)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    k ⊗[N.1] Pic0FiniteStageFinalModelRing C L n m relation M N j ≃ₐ[k]
      Pic0FiniteStageRing C j :=
  (Algebra.TensorProduct.cancelBaseChange M.1 N.1 k k
    (Pic0FiniteStageModelRing C L n m relation M j)).trans
      (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M j)

set_option synthInstance.maxHeartbeats 400000 in
-- Naturality elaborates the cancellation and model-comparison squares together.
set_option maxHeartbeats 12800000 in
/-- The final component comparisons intertwine every scalar-extended finite-stage map
with its exact restriction or transition map. -/
theorem pic0FiniteStageFinalBaseChangeEquiv_naturality
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (e : forall j,
      k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
        Pic0FiniteStageRing C j)
    (M : DatG0.FinSubext L.1 k)
    [Algebra.IsAlgebraic M.1 k]
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
    (N : DatG0.FinSubext M.1 k)
    (q : Pic0FiniteStageMapIndex C) :
    (pic0FiniteStageFinalBaseChangeEquiv C L n m relation e M N
        (Pic0FiniteStageMapTarget C q)).toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := N.1) (K := k)
          (AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := M.1) (K := N.1) (mapM q))) =
      (pic0FiniteStageMap C q).comp
        (pic0FiniteStageFinalBaseChangeEquiv C L n m relation e M N
          (Pic0FiniteStageMapSource C q)).toAlgHom := by
  have hval : N.1.val = IsScalarTower.toAlgHom M.1 N.1 k := by
    ext x
    rfl
  have htower :=
    scalarExtensionMapOfAlgHom_tower_finSubext (K := k) N (mapM q)
  rw [hval] at htower
  have hcancel := AlgebraicJacobian.cancelBaseChange_naturality
    (F := M.1) (L := N.1) (K := k)
    (phiL := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := N.1) (mapM q))
    (phiK := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k) (mapM q))
    htower
  have hmodel := pic0FiniteStageModelBaseChangeEquiv_naturality
    C L n m relation e M mapM hmapM q
  change
    ((pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
        (Pic0FiniteStageMapTarget C q)).toAlgHom.comp
      (Algebra.TensorProduct.cancelBaseChange M.1 N.1 k k
        (Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapTarget C q))).toAlgHom).comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := N.1) (K := k)
          (AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := M.1) (K := N.1) (mapM q))) =
      (pic0FiniteStageMap C q).comp
        ((pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
          (Pic0FiniteStageMapSource C q)).toAlgHom.comp
          (Algebra.TensorProduct.cancelBaseChange M.1 N.1 k k
            (Pic0FiniteStageModelRing C L n m relation M
              (Pic0FiniteStageMapSource C q))).toAlgHom)
  rw [AlgHom.comp_assoc, hcancel, ← AlgHom.comp_assoc, hmodel,
    AlgHom.comp_assoc]

end

end AlgebraicGeometry
