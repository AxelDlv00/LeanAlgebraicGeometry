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

The construction first glues scalar extensions of a family of rings. Tensor-pushout
comparison equivalences carry the descended face and cyclic equations to the literal
tensor products used by `Scheme.GlueData`. The Picard specialization then supplies the
equations reflected from the ambient field.
-/

set_option autoImplicit false

universe u

open CategoryTheory TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

private def scalarExtendedGluePresentation
    {R K J : Type u} [CommRing R] [CommRing K] [Algebra R K]
    (A : J → Type u) (B : J → J → Type u)
    [∀ i, CommRing (A i)] [∀ i j, CommRing (B i j)]
    [∀ i, Algebra R (A i)] [∀ i j, Algebra R (B i j)]
    (r : ∀ i j, A i →ₐ[R] B i j)
    (tau : ∀ i j, B j i →ₐ[R] B i j)
    (theta : ∀ i j l,
      K ⊗[R] Pic0FiniteStageTensorPushoutRing (r j l) (r j i) →ₐ[K]
        K ⊗[R] Pic0FiniteStageTensorPushoutRing (r i j) (r i l))
    (hdiag : ∀ i, IsIso (Spec.map (CommRingCat.ofHom
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K) (r i i)).toRingHom)))
    (hopen : ∀ i j, IsOpenImmersion (Spec.map (CommRingCat.ofHom
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K) (r i j)).toRingHom)))
    (htau : ∀ i,
      AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K) (tau i i) =
        AlgHom.id K (K ⊗[R] B i i))
    (hface : ∀ i j l,
      (theta i j l).comp
          (AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K)
            (finiteStageTensorPushoutFaceRight (r j l) (r j i))) =
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K)
          (finiteStageTensorPushoutFaceLeft (r i j) (r i l))).comp
            (AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K) (tau i j)))
    (hcycle : ∀ i j l,
      (theta i j l).comp ((theta j l i).comp (theta l i j)) =
        AlgHom.id K
          (K ⊗[R] Pic0FiniteStageTensorPushoutRing (r i j) (r i l))) :
    AlgebraicJacobian.AffineRingGluePresentation K := by
  let A' := fun i => K ⊗[R] A i
  let B' := fun i j => K ⊗[R] B i j
  let r' := fun i j => AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K) (r i j)
  let tau' := fun i j => AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K) (tau i j)
  letI (i j : J) : Algebra (A' i) (B' i j) := pic0FiniteStageAlgebraOfMap (r' i j)
  letI (i j : J) : IsScalarTower K (A' i) (B' i j) :=
    pic0FiniteStageTowerOfMap (r' i j)
  let e : ∀ i j l,
      (K ⊗[R] Pic0FiniteStageTensorPushoutRing (r i j) (r i l)) ≃ₐ[K]
        AlgebraicJacobian.AffineTripleTensor A' B' i j l :=
    fun i j l => finiteStageTensorPushoutScalarExtension (K := K) (r i j) (r i l)
  let theta' : ∀ i j l,
      AlgebraicJacobian.AffineTripleTensor A' B' j l i →ₐ[K]
        AlgebraicJacobian.AffineTripleTensor A' B' i j l :=
    fun i j l => (e i j l).toAlgHom.comp
      ((theta i j l).comp (e j l i).symm.toAlgHom)
  refine AlgebraicJacobian.affineRingGluePresentation A' B' tau' theta'
    hdiag hopen htau ?_ ?_
  · intro i j l
    have hr := finiteStageTensorPushoutScalarExtension_faceRight_map
      (K := K) (r j l) (r j i)
    have hl := finiteStageTensorPushoutScalarExtension_faceLeft_map
      (K := K) (r i j) (r i l)
    apply DFunLike.ext _ _
    intro x
    have hr' : e j l i
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K)
          (finiteStageTensorPushoutFaceRight (r j l) (r j i)) x) =
        AlgebraicJacobian.affineTensorIncludeRight (R := K) A' B' j l i x :=
      DFunLike.congr_fun hr x
    have hl' : e i j l
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := K)
          (finiteStageTensorPushoutFaceLeft (r i j) (r i l)) (tau' i j x)) =
        AlgebraicJacobian.affineTensorIncludeLeft (R := K) A' B' i j l (tau' i j x) :=
      DFunLike.congr_fun hl (tau' i j x)
    change e i j l (theta i j l ((e j l i).symm
        (AlgebraicJacobian.affineTensorIncludeRight (R := K) A' B' j l i x))) =
      AlgebraicJacobian.affineTensorIncludeLeft (R := K) A' B' i j l (tau' i j x)
    rw [← hr', AlgEquiv.symm_apply_apply]
    exact (congrArg (e i j l) (DFunLike.congr_fun (hface i j l) x)).trans hl'
  · intro i j l
    apply DFunLike.ext _ _
    intro x
    change e i j l (theta i j l ((e j l i).symm
      (e j l i (theta j l i ((e l i j).symm
        (e l i j (theta l i j ((e i j l).symm x)))))))) = x
    rw [AlgEquiv.symm_apply_apply, AlgEquiv.symm_apply_apply]
    exact (congrArg (e i j l)
      (DFunLike.congr_fun (hcycle i j l) ((e i j l).symm x))).trans
        ((e i j l).apply_symm_apply x)

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

set_option maxHeartbeats 800000 in
-- Comparing the reflected face package with the literal tensor family exceeds 200k.
/-- Assemble the descended chart rings, overlap rings, and compatible triple transitions
into the finite-stage affine glue presentation. -/
noncomputable def pic0FiniteStageAffineRingGluePresentation
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGlueContext C F) :
    AlgebraicJacobian.AffineRingGluePresentation P.N.1 := by
  rcases P with ⟨D, T⟩
  let A := Pic0FiniteStageChartModelRing C D.L D.n D.m D.relation D.M
  let B := Pic0FiniteStageOverlapModelRing C D.L D.n D.m D.relation D.M
  letI (U : Pic0FiniteStageChartIndex C) : Algebra D.M.1 (A U) :=
    faceChartModelRingAlgebra C D.L D.n D.m D.relation D.M U
  letI (U V : Pic0FiniteStageChartIndex C) : Algebra D.M.1 (B U V) :=
    faceOverlapModelRingAlgebra C D.L D.n D.m D.relation D.M U V
  let r := pic0FiniteStageRestrictionLeftModel C D.L D.n D.m D.relation D.M D.mapM
  let tau := fun U V => D.mapM (Sum.inr (U, V))
  refine scalarExtendedGluePresentation (K := T.N.1) A B r tau
    (fun U V W => T.thetaN (U, (V, W))) ?_ ?_ ?_ ?_ ?_
  · intro U
    exact isIso_pic0FiniteStageRestrictionBaseChange_diagonal
      C D.L D.n D.m D.relation D.e D.M D.mapM D.comparison T.N U
  · intro U V
    exact isOpenImmersion_pic0FiniteStageRestrictionBaseChange
      C D.L D.n D.m D.relation D.M D.mapM D.openImmersion T.N U V
  · intro U
    exact pic0FiniteStageTransitionBaseChange_self
      C D.L D.n D.m D.relation D.e D.M D.mapM D.comparison T.N U
  · intro U V W
    exact (pic0FiniteStageTripleTransitionFacePackage
      C D.L D.n D.m D.relation D.M D.mapM D.e D.comparison
        T.N U V W T.thetaN T.comparison).face
  · intro U V W
    exact pic0FiniteStageTripleTransitionModel_cocycle
      C D.L D.n D.m D.relation D.M D.mapM
      (pic0FiniteStageTripleModelComparisonFamily
        C D.L D.n D.m D.relation D.e D.M D.mapM D.comparison)
      T.N T.thetaN T.comparison U V W

end

end AlgebraicGeometry
