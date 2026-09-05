/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Descent.AffineRingGlueData
import AlgebraicJacobian.Picard.Pic0FiniteStageGluePackageCore
import AlgebraicJacobian.Picard.Pic0FiniteStageScalarExtendedAtlas
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleTransitionEquations
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleTransitionFaceReflection

/-!
# Assembly of the finite-stage Picard glue presentation

The finite-stage transition model determines the chart and overlap rings. After one
further finite scalar extension, compatible cyclic triple transitions determine the
remaining gluing maps. This module exposes only the resulting affine presentation; the
conjugation and tensor-face calculations are implementation details of its construction.
-/

set_option autoImplicit false

universe u

open CategoryTheory TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

private noncomputable def conjugateAlgHom
    {R A B A' B' : Type u}
    [CommSemiring R] [Semiring A] [Semiring B] [Semiring A'] [Semiring B']
    [Algebra R A] [Algebra R B] [Algebra R A'] [Algebra R B']
    (eA : A ≃ₐ[R] A') (eB : B ≃ₐ[R] B') (f : A →ₐ[R] B) : A' →ₐ[R] B' :=
  eB.toAlgHom.comp (f.comp eA.symm.toAlgHom)

private noncomputable def algHomIdTarget
    {R A B : Type u} [CommSemiring R] [Semiring A] [Semiring B]
    [Algebra R A] [Algebra R B] (_e : A ≃ₐ[R] B) : B →ₐ[R] B :=
  AlgHom.id R B

private theorem conjugateAlgHom_threeCycle
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

private theorem conjugateAlgHom_face
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

private noncomputable abbrev assemblyChartRing
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U : Pic0FiniteStageChartIndex C) :=
  Pic0FiniteStageChartBaseChangeRing
    C P.L P.n P.m P.relation P.M P.N U

private noncomputable abbrev assemblyOverlapRing
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U V : Pic0FiniteStageChartIndex C) :=
  Pic0FiniteStageOverlapBaseChangeRing
    C P.L P.n P.m P.relation P.M P.N U V

private noncomputable def assemblyRestriction
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U V : Pic0FiniteStageChartIndex C) :=
  pic0FiniteStageRestrictionBaseChange
    C P.L P.n P.m P.relation P.M P.mapM P.N U V

private noncomputable def assemblyTransition
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U V : Pic0FiniteStageChartIndex C) :=
  pic0FiniteStageTransitionBaseChange
    C P.L P.n P.m P.relation P.M P.mapM P.N U V

private noncomputable def assemblyTensorEquiv
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U V W : Pic0FiniteStageChartIndex C) :=
  finiteStageTensorPushoutScalarExtension_named (K := P.N.1)
    (pic0FiniteStageRestrictionLeftModel
      C P.L P.n P.m P.relation P.M P.mapM U V)
    (pic0FiniteStageRestrictionLeftModel
      C P.L P.n P.m P.relation P.M P.mapM U W)

private noncomputable def assemblyTensorFaceRight
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U V W : Pic0FiniteStageChartIndex C) :=
  @finiteStageTensorPushoutFaceRight
    P.N.1 (assemblyChartRing C P U)
    (assemblyOverlapRing C P U V) (assemblyOverlapRing C P U W)
    (IntermediateField.toField P.N.1).toCommRing
    (pic0FiniteStageChartBaseChangeCommRing
      C P.L P.n P.m P.relation P.M P.N U)
    (pic0FiniteStageOverlapBaseChangeCommRing
      C P.L P.n P.m P.relation P.M P.N U V)
    (pic0FiniteStageOverlapBaseChangeCommRing
      C P.L P.n P.m P.relation P.M P.N U W)
    (pic0FiniteStageChartBaseChangeAlgebra
      C P.L P.n P.m P.relation P.M P.N U)
    (pic0FiniteStageOverlapBaseChangeAlgebra
      C P.L P.n P.m P.relation P.M P.N U V)
    (pic0FiniteStageOverlapBaseChangeAlgebra
      C P.L P.n P.m P.relation P.M P.N U W)
    (assemblyRestriction C P U V) (assemblyRestriction C P U W)

private noncomputable def assemblyTensorFaceLeft
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U V W : Pic0FiniteStageChartIndex C) :=
  @finiteStageTensorPushoutFaceLeft
    P.N.1 (assemblyChartRing C P U)
    (assemblyOverlapRing C P U V) (assemblyOverlapRing C P U W)
    (IntermediateField.toField P.N.1).toCommRing
    (pic0FiniteStageChartBaseChangeCommRing
      C P.L P.n P.m P.relation P.M P.N U)
    (pic0FiniteStageOverlapBaseChangeCommRing
      C P.L P.n P.m P.relation P.M P.N U V)
    (pic0FiniteStageOverlapBaseChangeCommRing
      C P.L P.n P.m P.relation P.M P.N U W)
    (pic0FiniteStageChartBaseChangeAlgebra
      C P.L P.n P.m P.relation P.M P.N U)
    (pic0FiniteStageOverlapBaseChangeAlgebra
      C P.L P.n P.m P.relation P.M P.N U V)
    (pic0FiniteStageOverlapBaseChangeAlgebra
      C P.L P.n P.m P.relation P.M P.N U W)
    (assemblyRestriction C P U V) (assemblyRestriction C P U W)

set_option synthInstance.maxHeartbeats 400000 in
set_option maxHeartbeats 1600000 in
-- The equivalences pin the instances, but Lean must normalize both tensor-pushout carriers.
private noncomputable def assemblyTripleTransition
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U V W : Pic0FiniteStageChartIndex C) :=
  conjugateAlgHom
    (assemblyTensorEquiv C P V W U) (assemblyTensorEquiv C P U V W)
    (P.thetaN (U, (V, W)))

set_option synthInstance.maxHeartbeats 400000 in
set_option maxHeartbeats 12800000 in
-- The face proof compares the named scalar-extension and literal pushout presentations.
private theorem assemblyTripleTransition_face
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U V W : Pic0FiniteStageChartIndex C) :
    (assemblyTripleTransition C P U V W).comp
        (assemblyTensorFaceRight C P V W U) =
      (assemblyTensorFaceLeft C P U V W).comp
        (assemblyTransition C P U V) := by
  let D := P
  let N := P.N
  let thetaN := P.thetaN
  let comparison := P.comparison
  let Q := pic0FiniteStageTripleTransitionFacePackage
    C D.L D.n D.m D.relation D.M D.mapM D.e D.modelComparison
      N U V W thetaN fun p => by
        simpa only [Pic0FiniteStageTripleTransitionFamilyComparison,
          pic0FiniteStageTransportedTripleTransitionOfModels] using comparison p
  have hright :
      (assemblyTensorEquiv C P V W U).toAlgHom.comp Q.rightN =
        assemblyTensorFaceRight C P V W U := by
    change
      (finiteStageTensorPushoutScalarExtension_named (K := N.1)
        (pic0FiniteStageRestrictionLeftModel
          C D.L D.n D.m D.relation D.M D.mapM V W)
        (pic0FiniteStageRestrictionLeftModel
          C D.L D.n D.m D.relation D.M D.mapM V U)).toAlgHom.comp
          (AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := D.M.1) (K := N.1)
              (pic0FiniteStageTripleModelFaceRight
                C D.L D.n D.m D.relation D.M D.mapM V W U)) = _
    exact finiteStageTensorPushoutScalarExtension_faceRight_map
      (K := N.1)
      (pic0FiniteStageRestrictionLeftModel
        C D.L D.n D.m D.relation D.M D.mapM V W)
      (pic0FiniteStageRestrictionLeftModel
        C D.L D.n D.m D.relation D.M D.mapM V U)
  have htau : Q.tauN = assemblyTransition C P U V := by
    rfl
  have hleft :
      (assemblyTensorEquiv C P U V W).toAlgHom.comp Q.leftN =
        assemblyTensorFaceLeft C P U V W := by
    change
      (finiteStageTensorPushoutScalarExtension_named (K := N.1)
        (pic0FiniteStageRestrictionLeftModel
          C D.L D.n D.m D.relation D.M D.mapM U V)
        (pic0FiniteStageRestrictionLeftModel
          C D.L D.n D.m D.relation D.M D.mapM U W)).toAlgHom.comp
          (AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := D.M.1) (K := N.1)
              (pic0FiniteStageTripleModelFaceLeft
                C D.L D.n D.m D.relation D.M D.mapM U V W)) = _
    exact finiteStageTensorPushoutScalarExtension_faceLeft_map
      (K := N.1)
      (pic0FiniteStageRestrictionLeftModel
        C D.L D.n D.m D.relation D.M D.mapM U V)
      (pic0FiniteStageRestrictionLeftModel
        C D.L D.n D.m D.relation D.M D.mapM U W)
  exact conjugateAlgHom_face
    (assemblyTensorEquiv C P V W U) (assemblyTensorEquiv C P U V W)
    Q.rightN Q.thetaN Q.tauN Q.leftN
    (assemblyTensorFaceRight C P V W U)
    (assemblyTransition C P U V)
    (assemblyTensorFaceLeft C P U V W)
    hright htau hleft Q.face

set_option synthInstance.maxHeartbeats 400000 in
set_option maxHeartbeats 12800000 in
-- The cyclic composite normalizes three conjugated tensor-pushout transitions.
private theorem assemblyTripleTransition_cocycle
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U V W : Pic0FiniteStageChartIndex C) :
    (assemblyTripleTransition C P U V W).comp
        ((assemblyTripleTransition C P V W U).comp
          (assemblyTripleTransition C P W U V)) =
      algHomIdTarget (assemblyTensorEquiv C P U V W) := by
  let D := P
  let N := P.N
  let Q := pic0FiniteStageTripleModelComparisonFamily
    C D.L D.n D.m D.relation D.e D.M D.mapM D.modelComparison
  have hcycle := pic0FiniteStageTripleTransitionModel_cocycle
    C D.L D.n D.m D.relation D.M D.mapM Q N
      P.thetaN P.comparison U V W
  exact conjugateAlgHom_threeCycle
    (assemblyTensorEquiv C P U V W)
    (assemblyTensorEquiv C P V W U)
    (assemblyTensorEquiv C P W U V)
    (P.thetaN (U, (V, W))) (P.thetaN (V, (W, U)))
    (P.thetaN (W, (U, V))) hcycle

set_option synthInstance.maxHeartbeats 1600000 in
set_option maxHeartbeats 12800000 in
-- The constructor aligns five proof-independent fields with the pinned ring presentation.
/-- Assemble the canonical finite-stage charts and transitions into one affine gluing
presentation. The triple-transition comparison is indexed by the comparison family
canonically determined by the package's transition model. -/
noncomputable def pic0FiniteStageAffineRingGluePresentation
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    @AlgebraicJacobian.AffineRingGluePresentation P.N.1
      (IntermediateField.toField P.N.1).toCommRing := by
  let D := P
  let N := P.N
  letI : CommRing N.1 := (IntermediateField.toField N.1).toCommRing
  letI : Algebra.IsAlgebraic D.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic D.M.1 k := by infer_instance
  let A := assemblyChartRing C P
  let B := assemblyOverlapRing C P
  letI (U : Pic0FiniteStageChartIndex C) : CommRing (A U) :=
    pic0FiniteStageChartBaseChangeCommRing
      C D.L D.n D.m D.relation D.M N U
  letI (U V : Pic0FiniteStageChartIndex C) : CommRing (B U V) :=
    pic0FiniteStageOverlapBaseChangeCommRing
      C D.L D.n D.m D.relation D.M N U V
  letI (U : Pic0FiniteStageChartIndex C) : Algebra N.1 (A U) :=
    pic0FiniteStageChartBaseChangeAlgebra
      C D.L D.n D.m D.relation D.M N U
  letI (U V : Pic0FiniteStageChartIndex C) : Algebra N.1 (B U V) :=
    pic0FiniteStageOverlapBaseChangeAlgebra
      C D.L D.n D.m D.relation D.M N U V
  let r := assemblyRestriction C P
  letI (U V : Pic0FiniteStageChartIndex C) : Algebra (A U) (B U V) :=
    pic0FiniteStageAlgebraOfMap (r U V)
  letI (U V : Pic0FiniteStageChartIndex C) : IsScalarTower N.1 (A U) (B U V) := by
    letI : Algebra (A U) (B U V) := pic0FiniteStageAlgebraOfMap (r U V)
    exact pic0FiniteStageTowerOfMap (r U V)
  let tau := assemblyTransition C P
  let theta := assemblyTripleTransition C P
  refine AlgebraicJacobian.affineRingGluePresentation
    (R := N.1) A B tau theta ?_ ?_ ?_ ?_ ?_
  · intro U
    exact isIso_pic0FiniteStageRestrictionBaseChange_diagonal
      C D.L D.n D.m D.relation D.e D.M D.mapM D.modelComparison N U
  · intro U V
    exact isOpenImmersion_pic0FiniteStageRestrictionBaseChange
      C D.L D.n D.m D.relation D.M D.mapM D.openImmersion N U V
  · intro U
    exact pic0FiniteStageTransitionBaseChange_self
      C D.L D.n D.m D.relation D.e D.M D.mapM D.modelComparison N U
  · intro U V W
    exact assemblyTripleTransition_face C P U V W
  · intro U V W
    exact assemblyTripleTransition_cocycle C P U V W

end

end AlgebraicGeometry

