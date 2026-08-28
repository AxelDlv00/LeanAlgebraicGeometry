/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageGlueData

/-!
# The face equation for the finite-stage Picard glue datum

The descended transition first acts on scalar extensions of the named triple-overlap
models.  Conjugating by the canonical tensor-pushout scalar-extension equivalences puts
that transition on the literal tensor products used by affine gluing.  The two canonical
face squares then transport the reflected model-level face equation to those literal
tensor products.
-/

set_option autoImplicit false

universe u

open CategoryTheory TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

/-- A face equation survives conjugating its upper map, provided the two face maps and
the lower map are carried to the chosen target diagram. -/
theorem conjugateAlgHom_face_of_squares
    {R A B D E B' E' : Type u}
    [CommSemiring R]
    [CommSemiring A] [CommSemiring B] [CommSemiring D] [CommSemiring E]
    [CommSemiring B'] [CommSemiring E']
    [Algebra R A] [Algebra R B] [Algebra R D] [Algebra R E]
    [Algebra R B'] [Algebra R E']
    (eB : B ≃ₐ[R] B') (eE : E ≃ₐ[R] E')
    (right : A →ₐ[R] B) (theta : B →ₐ[R] E)
    (tau : A →ₐ[R] D) (left : D →ₐ[R] E)
    (right' : A →ₐ[R] B') (tau' : A →ₐ[R] D) (left' : D →ₐ[R] E')
    (hright : eB.toAlgHom.comp right = right')
    (htau : tau = tau')
    (hleft : eE.toAlgHom.comp left = left')
    (hface : theta.comp right = left.comp tau) :
    (eE.toAlgHom.comp (theta.comp eB.symm.toAlgHom)).comp right' =
      left'.comp tau' := by
  apply DFunLike.ext _ _
  intro x
  change eE (theta (eB.symm (right' x))) = left' (tau' x)
  calc
    _ = eE (theta (right x)) := congrArg (fun y => eE (theta y))
      ((congrArg eB.symm (DFunLike.congr_fun hright x).symm).trans
        (eB.symm_apply_apply (right x)))
    _ = eE (left (tau x)) := congrArg eE (DFunLike.congr_fun hface x)
    _ = left' (tau x) := DFunLike.congr_fun hleft (tau x)
    _ = left' (tau' x) := congrArg left' (DFunLike.congr_fun htau x)

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

set_option maxHeartbeats 6400000 in
-- The package projections keep all four dependent tensor-product carriers aligned.
/-- The descended affine triple transition intertwines the overlap transition with the
two literal tensor-pushout face maps used by affine gluing. -/
theorem pic0FiniteStageAffineTripleTransition_fac
    [Algebra.IsAlgebraic M.1 k]
    (D : Pic0FiniteStageGlueContext C L n m relation M mapM)
    (U V W : Pic0FiniteStageChartIndex C) :
    (pic0FiniteStageAffineTripleTransition
        C L n m relation M mapM D.N D.thetaN U V W).comp
        (finiteStageTensorPushoutFaceRight
          (pic0FiniteStageRestrictionBaseChange
            C L n m relation M mapM D.N V W)
          (pic0FiniteStageRestrictionBaseChange
            C L n m relation M mapM D.N V U)) =
      (finiteStageTensorPushoutFaceLeft
        (pic0FiniteStageRestrictionBaseChange
          C L n m relation M mapM D.N U V)
        (pic0FiniteStageRestrictionBaseChange
          C L n m relation M mapM D.N U W)).comp
        (pic0FiniteStageTransitionBaseChange
          C L n m relation M mapM D.N U V) := by
  let P := pic0FiniteStageTripleTransitionFacePackage
    C L n m relation M mapM D.e D.hmapM D.N U V W D.thetaN D.hthetaN
  have hright :
      (pic0FiniteStageTripleBaseChangeEquiv
        C L n m relation M mapM D.N V W U).toAlgHom.comp P.rightN =
        finiteStageTensorPushoutFaceRight
          (pic0FiniteStageRestrictionBaseChange
            C L n m relation M mapM D.N V W)
          (pic0FiniteStageRestrictionBaseChange
            C L n m relation M mapM D.N V U) := by
    change
      (finiteStageTensorPushoutScalarExtension_named (K := D.N.1)
        (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM V W)
        (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM V U)).toAlgHom.comp
          (AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := M.1) (K := D.N.1)
              (pic0FiniteStageTripleModelFaceRight
                C L n m relation M mapM V W U)) = _
    exact finiteStageTensorPushoutScalarExtension_faceRight_map
      (K := D.N.1)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM V W)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM V U)
  have htau :
      P.tauN = pic0FiniteStageTransitionBaseChange
        C L n m relation M mapM D.N U V := by
    rfl
  have hleft :
      (pic0FiniteStageTripleBaseChangeEquiv
        C L n m relation M mapM D.N U V W).toAlgHom.comp P.leftN =
        finiteStageTensorPushoutFaceLeft
          (pic0FiniteStageRestrictionBaseChange
            C L n m relation M mapM D.N U V)
          (pic0FiniteStageRestrictionBaseChange
            C L n m relation M mapM D.N U W) := by
    change
      (finiteStageTensorPushoutScalarExtension_named (K := D.N.1)
        (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
        (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)).toAlgHom.comp
          (AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := M.1) (K := D.N.1)
              (pic0FiniteStageTripleModelFaceLeft
                C L n m relation M mapM U V W)) = _
    exact finiteStageTensorPushoutScalarExtension_faceLeft_map
      (K := D.N.1)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
  have hface : P.thetaN.comp P.rightN = P.leftN.comp P.tauN := P.face
  exact conjugateAlgHom_face_of_squares
    (pic0FiniteStageTripleBaseChangeEquiv
      C L n m relation M mapM D.N V W U)
    (pic0FiniteStageTripleBaseChangeEquiv
      C L n m relation M mapM D.N U V W)
    P.rightN P.thetaN P.tauN P.leftN
    (finiteStageTensorPushoutFaceRight
      (pic0FiniteStageRestrictionBaseChange C L n m relation M mapM D.N V W)
      (pic0FiniteStageRestrictionBaseChange C L n m relation M mapM D.N V U))
    (pic0FiniteStageTransitionBaseChange C L n m relation M mapM D.N U V)
    (finiteStageTensorPushoutFaceLeft
      (pic0FiniteStageRestrictionBaseChange C L n m relation M mapM D.N U V)
      (pic0FiniteStageRestrictionBaseChange C L n m relation M mapM D.N U W))
    hright htau hleft hface

end

end

end AlgebraicGeometry
