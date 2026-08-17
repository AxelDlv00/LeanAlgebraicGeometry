/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageGlueDataAssembly
import AlgebraicJacobian.Picard.Pic0FiniteStageTransitionModels
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleTransitionModels

/-!
# An inhabited finite-stage Picard glue package

The simultaneous pair- and triple-transition descent theorems supply every input of
`pic0FiniteStageAffineRingGlueData`.  This file records those dependent inputs in one
package and immediately exposes the resulting scheme glue datum.
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

set_option synthInstance.maxHeartbeats 400000 in
-- The fields retain three nested finite-subextension scalar towers.
set_option maxHeartbeats 12800000 in
/-- All finite-stage models and comparison equations needed to assemble the descended
Picard atlas.  The fields are outputs of the simultaneous finite-subextension producers,
not additional geometric hypotheses. -/
structure Pic0FiniteStageGluePackage
    (F : Type u) [Field F] [Algebra F k] [Algebra.IsAlgebraic F k] where
  L : DatG0.FinSubext F k
  n : Pic0FiniteStageRingIndex C -> Nat
  m : Pic0FiniteStageRingIndex C -> Nat
  relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1
  e : forall j,
    k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
      Pic0FiniteStageRing C j
  M : DatG0.FinSubext L.1 k
  mapM : forall q : Pic0FiniteStageMapIndex C,
    Pic0FiniteStageModelRing C L n m relation M
        (Pic0FiniteStageMapSource C q) →ₐ[M.1]
      Pic0FiniteStageModelRing C L n m relation M
        (Pic0FiniteStageMapTarget C q)
  hmapM : forall q,
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
              (relation (Pic0FiniteStageMapSource C q)))))
  hOpen : forall i : Pic0FiniteStageRestrictionIndex C,
    IsOpenImmersion
      (Spec.map (CommRingCat.ofHom (mapM (Sum.inl i)).toRingHom))
  N : DatG0.FinSubext M.1 k
  thetaN : forall p : Pic0FiniteStageTripleTransitionIndex C,
    N.1 ⊗[M.1] Pic0FiniteStageTripleTransitionModelSource
        C L n m relation M mapM p →ₐ[N.1]
      N.1 ⊗[M.1] Pic0FiniteStageTripleTransitionModelTarget
        C L n m relation M mapM p
  hthetaN : forall p : Pic0FiniteStageTripleTransitionIndex C,
    (Algebra.TensorProduct.map N.1.val
        (AlgHom.id M.1
          (Pic0FiniteStageTripleTransitionModelTarget
            C L n m relation M mapM p))).comp
        ((thetaN p).restrictScalars M.1) =
      ((pic0FiniteStageTransportedTripleTransitionOfModels
        C L n m relation e M mapM hmapM p.1 p.2.1 p.2.2).restrictScalars
          M.1).comp
        (Algebra.TensorProduct.map N.1.val
          (AlgHom.id M.1
            (Pic0FiniteStageTripleTransitionModelSource
              C L n m relation M mapM p)))

namespace Pic0FiniteStageGluePackage

set_option maxHeartbeats 25600000 in
-- The package projections retain the dependent tensor-product instances of the constructor.
/-- The scheme glue datum computed from an inhabited finite-stage package. -/
noncomputable def glueData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) : Scheme.GlueData := by
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  exact pic0FiniteStageAffineRingGlueData
    C P.L P.n P.m P.relation P.M P.mapM P.N
      P.e P.hmapM P.hOpen P.thetaN P.hthetaN

end Pic0FiniteStageGluePackage

set_option synthInstance.maxHeartbeats 400000 in
-- Selecting both finite families exposes many dependent quotient-algebra instances.
set_option maxHeartbeats 12800000 in
/-- The simultaneous finite-stage descent producers inhabit the glue package. -/
theorem exists_pic0FiniteStageGluePackage
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k] :
    Nonempty (Pic0FiniteStageGluePackage C F) := by
  classical
  obtain ⟨L, n, m, relation, e, M, mapM, hmapM, hOpen, _⟩ :=
    exists_finSubext_pic0FiniteStageTransition_models (C := C) (F := F)
  letI : Algebra.IsAlgebraic L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic M.1 k := by infer_instance
  let Q := pic0FiniteStageTripleModelComparisonFamily
    C L n m relation e M mapM hmapM
  obtain ⟨N, hN⟩ :=
    exists_finSubext_pic0FiniteStageTripleTransition_models_of_comparisons
      C L n m relation M mapM Q
  choose thetaN hthetaN using hN
  exact ⟨{
    L := L
    n := n
    m := m
    relation := relation
    e := e
    M := M
    mapM := mapM
    hmapM := hmapM
    hOpen := hOpen
    N := N
    thetaN := thetaN
    hthetaN := by
      intro p
      simpa only [Q, pic0FiniteStageTransportedTripleTransitionOfModels] using
        hthetaN p
  }⟩

end

end AlgebraicGeometry
