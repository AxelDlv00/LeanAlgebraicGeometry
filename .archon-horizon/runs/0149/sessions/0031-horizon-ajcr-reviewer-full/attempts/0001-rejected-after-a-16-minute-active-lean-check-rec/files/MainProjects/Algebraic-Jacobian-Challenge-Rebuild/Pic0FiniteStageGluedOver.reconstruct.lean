import AlgebraicJacobian.Picard.Pic0FiniteStageGluePackage

set_option autoImplicit false

universe u

open CategoryTheory TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

namespace Pic0FiniteStageGluePackage

set_option linter.style.setOption false
set_option synthInstance.maxHeartbeats 400000 in
set_option maxHeartbeats 12800000 in
noncomputable def reconstructedGluedMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    P.glueData.glued ⟶ Spec (.of P.N.1) := by
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  let A : Pic0FiniteStageChartIndex C -> Type u := fun U =>
    Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U
  let B : Pic0FiniteStageChartIndex C -> Pic0FiniteStageChartIndex C -> Type u :=
    fun U V =>
      Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V
  let r : ∀ U V, A U →ₐ[P.N.1] B U V := fun U V =>
    pic0FiniteStageRestrictionBaseChange
      C P.L P.n P.m P.relation P.M P.mapM P.N U V
  letI : ∀ U V, Algebra (A U) (B U V) := fun U V =>
    pic0FiniteStageAlgebraOfMap (r U V)
  letI : ∀ U V, IsScalarTower P.N.1 (A U) (B U V) := fun U V =>
    pic0FiniteStageTowerOfMap (r U V)
  let tau : ∀ U V, B V U →ₐ[P.N.1] B U V := fun U V =>
    pic0FiniteStageTransitionBaseChange
      C P.L P.n P.m P.relation P.M P.mapM P.N U V
  let theta : ∀ U V W,
      AlgebraicJacobian.AffineTripleTensor A B V W U →ₐ[P.N.1]
        AlgebraicJacobian.AffineTripleTensor A B U V W := fun U V W =>
    pic0FiniteStageAffineTripleTransition
      C P.L P.n P.m P.relation P.M P.mapM P.N P.thetaN U V W
  let fId : ∀ U, IsIso (AlgebraicJacobian.affineRestriction A B U U) := fun U =>
    isIso_pic0FiniteStageRestrictionBaseChange_diagonal
      C P.L P.n P.m P.relation P.e P.M P.mapM P.hmapM P.N U
  let fOpen : ∀ U V, IsOpenImmersion
      (AlgebraicJacobian.affineRestriction A B U V) := fun U V =>
    isOpenImmersion_pic0FiniteStageRestrictionBaseChange
      C P.L P.n P.m P.relation P.M P.mapM P.hOpen P.N U V
  let tauId : ∀ U, tau U U = AlgHom.id P.N.1 (B U U) := fun U =>
    pic0FiniteStageTransitionBaseChange_self
      C P.L P.n P.m P.relation P.e P.M P.mapM P.hmapM P.N U
  let thetaFac : ∀ U V W,
      (theta U V W).comp
          (AlgebraicJacobian.affineTensorIncludeRight A B V W U) =
        (AlgebraicJacobian.affineTensorIncludeLeft A B U V W).comp
          (tau U V) := by
    intro U V W
    change
      (pic0FiniteStageAffineTripleTransition
        C P.L P.n P.m P.relation P.M P.mapM P.N P.thetaN U V W).comp
          (finiteStageTensorPushoutFaceRight (r V W) (r V U)) =
        (finiteStageTensorPushoutFaceLeft (r U V) (r U W)).comp
          (pic0FiniteStageTransitionBaseChange
            C P.L P.n P.m P.relation P.M P.mapM P.N U V)
    exact pic0FiniteStageAffineTripleTransition_fac
      C P.L P.n P.m P.relation P.M P.mapM P.N P.e P.hmapM
        P.thetaN P.hthetaN U V W
  let thetaCocycle : ∀ U V W,
      (theta U V W).comp ((theta V W U).comp (theta W U V)) =
        AlgHom.id P.N.1
          (AlgebraicJacobian.AffineTripleTensor A B U V W) := by
    intro U V W
    change
      (pic0FiniteStageAffineTripleTransition
        C P.L P.n P.m P.relation P.M P.mapM P.N P.thetaN U V W).comp
          ((pic0FiniteStageAffineTripleTransition
            C P.L P.n P.m P.relation P.M P.mapM P.N P.thetaN V W U).comp
            (pic0FiniteStageAffineTripleTransition
              C P.L P.n P.m P.relation P.M P.mapM P.N P.thetaN W U V)) =
        AlgHom.id P.N.1
          (Pic0FiniteStageTripleBaseChangeRing
            C P.L P.n P.m P.relation P.M P.mapM P.N U V W)
    exact pic0FiniteStageAffineTripleTransition_cocycle
      C P.L P.n P.m P.relation P.M P.mapM P.N P.e P.hmapM
        P.thetaN P.hthetaN U V W
  change
    (AlgebraicJacobian.affineRingGlueData
      A B tau theta fId fOpen tauId thetaFac thetaCocycle).glued ⟶
        Spec (.of P.N.1)
  exact AlgebraicJacobian.affineRingGluedMap
    A B tau theta fId fOpen tauId thetaFac thetaCocycle

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
