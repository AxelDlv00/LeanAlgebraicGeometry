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

private noncomputable def scalarExtendedAffineRingGluePresentation
    {R K J : Type u} [CommRing R] [CommRing K] [Algebra R K]
    (A : J → Type u) (B : J → J → Type u)
    [∀ i, CommRing (A i)] [∀ i j, CommRing (B i j)]
    [∀ i, Algebra R (A i)] [∀ i j, Algebra R (B i j)]
    (r : ∀ i j, A i →ₐ[R] B i j)
    (tau : ∀ i j, B j i →ₐ[R] B i j)
    (theta : ∀ i j k,
      (K ⊗[R] Pic0FiniteStageTensorPushoutRing (r j k) (r j i)) →ₐ[K]
        K ⊗[R] Pic0FiniteStageTensorPushoutRing (r i j) (r i k))
    (fId : ∀ i, IsIso (Spec.map (CommRingCat.ofHom
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K) (r i i)).toRingHom)))
    (fOpen : ∀ i j, IsOpenImmersion (Spec.map (CommRingCat.ofHom
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K) (r i j)).toRingHom)))
    (tauId : ∀ i, AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K) (tau i i) =
      AlgHom.id K (K ⊗[R] B i i))
    (thetaFac : ∀ i j k, (theta i j k).comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K)
          (finiteStageTensorPushoutFaceRight (r j k) (r j i))) =
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K)
        (finiteStageTensorPushoutFaceLeft (r i j) (r i k))).comp
          (AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K) (tau i j)))
    (thetaCocycle : ∀ i j k,
      (theta i j k).comp ((theta j k i).comp (theta k i j)) =
        AlgHom.id K (K ⊗[R] Pic0FiniteStageTensorPushoutRing (r i j) (r i k))) :
    AlgebraicJacobian.AffineRingGluePresentation K := by
  let AK := fun i => K ⊗[R] A i
  let BK := fun i j => K ⊗[R] B i j
  let rK := fun i j => AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K) (r i j)
  let tauK := fun i j => AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K) (tau i j)
  letI (i j : J) : Algebra (AK i) (BK i j) := pic0FiniteStageAlgebraOfMap (rK i j)
  letI (i j : J) : IsScalarTower K (AK i) (BK i j) := pic0FiniteStageTowerOfMap (rK i j)
  let e := fun i j k => finiteStageTensorPushoutScalarExtension_named (K := K) (r i j) (r i k)
  let thetaK := fun i j k => conjugateAlgHom (e j k i) (e i j k) (theta i j k)
  refine AlgebraicJacobian.affineRingGluePresentation AK BK tauK thetaK fId fOpen tauId ?_ ?_
  · intro i j k
    exact conjugateAlgHom_face (e j k i) (e i j k)
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K)
        (finiteStageTensorPushoutFaceRight (r j k) (r j i)))
      (theta i j k) (tauK i j)
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K)
        (finiteStageTensorPushoutFaceLeft (r i j) (r i k)))
      (AlgebraicJacobian.affineTensorIncludeRight AK BK j k i) (tauK i j)
      (AlgebraicJacobian.affineTensorIncludeLeft AK BK i j k)
      (finiteStageTensorPushoutScalarExtension_faceRight_map (K := K) (r j k) (r j i))
      rfl
      (finiteStageTensorPushoutScalarExtension_faceLeft_map (K := K) (r i j) (r i k))
      (thetaFac i j k)
  · intro i j k
    exact conjugateAlgHom_threeCycle (e i j k) (e j k i) (e k i j)
      (theta i j k) (theta j k i) (theta k i j) (thetaCocycle i j k)

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

/-- Assemble the canonical finite-stage charts and transitions into one affine gluing
presentation. The triple-transition comparison is indexed by the comparison family
canonically determined by the package's transition model. -/
noncomputable def pic0FiniteStageAffineRingGluePresentation
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    @AlgebraicJacobian.AffineRingGluePresentation P.N.1
      (IntermediateField.toField P.N.1).toCommRing := by
  refine scalarExtendedAffineRingGluePresentation
    (R := P.M.1) (K := P.N.1)
    (Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M)
    (Pic0FiniteStageOverlapModelRing C P.L P.n P.m P.relation P.M)
    (pic0FiniteStageRestrictionLeftModel C P.L P.n P.m P.relation P.M P.mapM)
    (fun U V => P.mapM (Sum.inr (U, V)))
    (fun U V W => P.thetaN (U, (V, W))) ?_ ?_ ?_ ?_ ?_
  · intro U
    exact isIso_pic0FiniteStageRestrictionBaseChange_diagonal
      C P.L P.n P.m P.relation P.e P.M P.mapM P.comparison P.N U
  · intro U V
    exact isOpenImmersion_pic0FiniteStageRestrictionBaseChange
      C P.L P.n P.m P.relation P.M P.mapM P.openImmersion P.N U V
  · intro U
    exact pic0FiniteStageTransitionBaseChange_self
      C P.L P.n P.m P.relation P.e P.M P.mapM P.comparison P.N U
  · intro U V W
    exact (pic0FiniteStageTripleTransitionFacePackage
      C P.L P.n P.m P.relation P.M P.mapM P.e P.comparison
      P.N U V W P.thetaN (fun p => by
        simpa only [Pic0FiniteStageTripleTransitionFamilyComparison,
          pic0FiniteStageTransportedTripleTransitionOfModels] using P.tripleComparison p)).face
  · intro U V W
    exact pic0FiniteStageTripleTransitionModel_cocycle
      C P.L P.n P.m P.relation P.M P.mapM
      (pic0FiniteStageTripleModelComparisonFamily
        C P.L P.n P.m P.relation P.e P.M P.mapM P.comparison)
      P.N P.thetaN P.tripleComparison U V W

end

end AlgebraicGeometry
