/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Descent.AffineRingGlueData
import AlgebraicJacobian.Picard.Pic0FiniteStageScalarExtendedAtlas
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleTransitionEquations
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleTransitionFaceReflection

/-!
# A finite-stage glue datum for the Picard atlas

The descended cyclic transitions act on scalar extensions of the named triple-overlap
models.  The affine gluing constructor instead uses the literal tensor products of the
scalar-extended overlap rings.  The canonical scalar-extension pushout equivalences
identify these carriers.  Conjugating by those equivalences supplies the transition maps
expected by `AlgebraicJacobian.affineRingGlueData`.
-/

set_option autoImplicit false

universe u

open CategoryTheory TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

/-- Conjugating a three-cycle of algebra maps by three algebra equivalences preserves
the cycle identity. -/
theorem conjugateAlgHom_threeCycle
    {R A B D A' B' D' : Type u}
    [CommSemiring R]
    [CommSemiring A] [CommSemiring B] [CommSemiring D]
    [CommSemiring A'] [CommSemiring B'] [CommSemiring D']
    [Algebra R A] [Algebra R B] [Algebra R D]
    [Algebra R A'] [Algebra R B'] [Algebra R D']
    (eA : A ≃ₐ[R] A') (eB : B ≃ₐ[R] B') (eD : D ≃ₐ[R] D')
    (fA : B →ₐ[R] A) (fB : D →ₐ[R] B) (fD : A →ₐ[R] D)
    (hcycle : fA.comp (fB.comp fD) = AlgHom.id R A) :
    (eA.toAlgHom.comp (fA.comp eB.symm.toAlgHom)).comp
        ((eB.toAlgHom.comp (fB.comp eD.symm.toAlgHom)).comp
          (eD.toAlgHom.comp (fD.comp eA.symm.toAlgHom))) =
      AlgHom.id R A' := by
  apply DFunLike.ext _ _
  intro x
  change eA
      (fA (eB.symm (eB (fB (eD.symm (eD (fD (eA.symm x)))))))) = x
  rw [eB.symm_apply_apply, eD.symm_apply_apply]
  have hx := DFunLike.congr_fun hcycle (eA.symm x)
  calc
    _ = eA (eA.symm x) := congrArg eA hx
    _ = x := eA.apply_symm_apply x

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

section

set_option linter.style.setOption false
set_option synthInstance.maxHeartbeats 400000
set_option maxHeartbeats 3200000

variable {F : Type u} [Field F] [Algebra F k]
variable (L : DatG0.FinSubext F k)
variable (n m : Pic0FiniteStageRingIndex C -> Nat)
variable (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
variable (M : DatG0.FinSubext L.1 k)
variable (mapM : forall q : Pic0FiniteStageMapIndex C,
  Pic0FiniteStageModelRing C L n m relation M
      (Pic0FiniteStageMapSource C q) →ₐ[M.1]
    Pic0FiniteStageModelRing C L n m relation M
      (Pic0FiniteStageMapTarget C q))
variable (N : DatG0.FinSubext M.1 k)

/-! ## Pinned gluing context

The face and presentation declarations below use the same five dependent choices.  Keeping
those choices as one value prevents each theorem header from re-elaborating the tensor-product
algebras (and, more importantly, prevents two consumers from silently selecting different
instances for the same carrier).  The record is data rather than a typeclass: callers choose it
once and project its maps and comparison equations. -/

set_option synthInstance.maxHeartbeats 400000 in
set_option maxHeartbeats 6400000 in
/-- All finite-stage data used by the affine gluing face and cocycle equations. -/
structure Pic0FiniteStageGlueContext where
  e : forall j,
    k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
      Pic0FiniteStageRing C j
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

/-- The literal triple tensor ring made from the scalar-extended chart and overlap rings. -/
noncomputable abbrev Pic0FiniteStageTripleBaseChangeRing
    (U V W : Pic0FiniteStageChartIndex C) : Type u :=
  Pic0FiniteStageTensorPushoutRing
    (pic0FiniteStageRestrictionBaseChange C L n m relation M mapM N U V)
    (pic0FiniteStageRestrictionBaseChange C L n m relation M mapM N U W)

/-- Scalar extension of a descended triple model is canonically the literal tensor
pushout of the scalar-extended restriction legs. -/
noncomputable def pic0FiniteStageTripleBaseChangeEquiv
    (U V W : Pic0FiniteStageChartIndex C) :
    N.1 ⊗[M.1] Pic0FiniteStageTripleModelRing
        C L n m relation M mapM U V W ≃ₐ[N.1]
      Pic0FiniteStageTripleBaseChangeRing
        C L n m relation M mapM N U V W :=
  finiteStageTensorPushoutScalarExtension_named (K := N.1)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)

/-- A descended cyclic triple transition, conjugated onto the literal tensor-pushout
rings used by affine gluing. -/
noncomputable def pic0FiniteStageAffineTripleTransition
    (thetaN : forall p : Pic0FiniteStageTripleTransitionIndex C,
      N.1 ⊗[M.1] Pic0FiniteStageTripleTransitionModelSource
          C L n m relation M mapM p →ₐ[N.1]
        N.1 ⊗[M.1] Pic0FiniteStageTripleTransitionModelTarget
          C L n m relation M mapM p)
    (U V W : Pic0FiniteStageChartIndex C) :
    Pic0FiniteStageTripleBaseChangeRing
        C L n m relation M mapM N V W U →ₐ[N.1]
      Pic0FiniteStageTripleBaseChangeRing
        C L n m relation M mapM N U V W :=
  (pic0FiniteStageTripleBaseChangeEquiv
      C L n m relation M mapM N U V W).toAlgHom.comp
    ((thetaN (U, (V, W))).comp
      (pic0FiniteStageTripleBaseChangeEquiv
        C L n m relation M mapM N V W U).symm.toAlgHom)

set_option maxHeartbeats 6400000 in
-- Three dependent comparison equivalences normalize in the pointwise cancellation.
/-- Conjugating the descended cyclic transitions onto the literal tensor-pushout rings
preserves their three-cycle identity. -/
theorem pic0FiniteStageAffineTripleTransition_cocycle
    (e : forall j,
      k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
        Pic0FiniteStageRing C j)
    [Algebra.IsAlgebraic M.1 k]
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
    (thetaN : forall p : Pic0FiniteStageTripleTransitionIndex C,
      N.1 ⊗[M.1] Pic0FiniteStageTripleTransitionModelSource
          C L n m relation M mapM p →ₐ[N.1]
        N.1 ⊗[M.1] Pic0FiniteStageTripleTransitionModelTarget
          C L n m relation M mapM p)
    (hthetaN : forall p : Pic0FiniteStageTripleTransitionIndex C,
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
              C L n m relation M mapM p))))
    (U V W : Pic0FiniteStageChartIndex C) :
    (pic0FiniteStageAffineTripleTransition
        C L n m relation M mapM N thetaN U V W).comp
        ((pic0FiniteStageAffineTripleTransition
          C L n m relation M mapM N thetaN V W U).comp
          (pic0FiniteStageAffineTripleTransition
            C L n m relation M mapM N thetaN W U V)) =
      AlgHom.id N.1
        (Pic0FiniteStageTripleBaseChangeRing
          C L n m relation M mapM N U V W) := by
  -- Elaborate the dependent comparison family once.  Reconstructing it in both
  -- the compatibility square and the cocycle call makes instance search revisit
  -- the same nested tensor towers and was the observed timeout hotspot.
  let Q := pic0FiniteStageTripleModelComparisonFamily
    C L n m relation e M mapM hmapM
  have hthetaN' : forall p : Pic0FiniteStageTripleTransitionIndex C,
      (Algebra.TensorProduct.map N.1.val
          (AlgHom.id M.1
            (Pic0FiniteStageTripleTransitionModelTarget
              C L n m relation M mapM p))).comp
          ((thetaN p).restrictScalars M.1) =
        ((pic0FiniteStageTransportedTripleTransition C L n m relation M mapM
          Q p).restrictScalars M.1).comp
          (Algebra.TensorProduct.map N.1.val
            (AlgHom.id M.1
              (Pic0FiniteStageTripleTransitionModelSource
                C L n m relation M mapM p))) := by
    intro p
    simpa only [pic0FiniteStageTransportedTripleTransitionOfModels] using hthetaN p
  have hcycle := pic0FiniteStageTripleTransitionModel_cocycle
    C L n m relation M mapM
      Q
      N thetaN hthetaN' U V W
  exact conjugateAlgHom_threeCycle
    (pic0FiniteStageTripleBaseChangeEquiv
      C L n m relation M mapM N U V W)
    (pic0FiniteStageTripleBaseChangeEquiv
      C L n m relation M mapM N V W U)
    (pic0FiniteStageTripleBaseChangeEquiv
      C L n m relation M mapM N W U V)
    (thetaN (U, (V, W))) (thetaN (V, (W, U))) (thetaN (W, (U, V))) hcycle

end

end

end AlgebraicGeometry
