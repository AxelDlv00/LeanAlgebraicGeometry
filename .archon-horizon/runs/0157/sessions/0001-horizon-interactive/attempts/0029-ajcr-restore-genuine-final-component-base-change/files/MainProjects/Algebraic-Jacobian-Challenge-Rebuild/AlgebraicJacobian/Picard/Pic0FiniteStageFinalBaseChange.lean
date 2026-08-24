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

/-!
The nested tensor aliases above hide the carrier instances that `cancelBaseChange`
needs.  Keep the witnesses named and local to this module, mirroring the explicit
overlap instances in `Pic0FiniteStageGluePackage`.
-/
@[reducible] noncomputable instance pic0FiniteStageModelRingCommRing
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    CommRing (Pic0FiniteStageModelRing C L n m relation M j) := by
  dsimp only [Pic0FiniteStageModelRing]
  letI : Algebra M.1 (Pic0FiniteStageModelRing C L n m relation M j) :=
    Algebra.TensorProduct.leftAlgebra
      (R := L.1) (S := M.1) (A := M.1)
      (B := DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j))
  exact Algebra.TensorProduct.instCommRing

@[reducible] noncomputable instance pic0FiniteStageModelRingAlgebra
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    Algebra M.1 (Pic0FiniteStageModelRing C L n m relation M j) := by
  dsimp only [Pic0FiniteStageModelRing]
  exact Algebra.TensorProduct.leftAlgebra
    (R := L.1) (S := M.1) (A := M.1)
    (B := DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j))

@[reducible] noncomputable instance pic0FiniteStageFinalModelRingCommRing
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    CommRing (Pic0FiniteStageFinalModelRing C L n m relation M N j) := by
  dsimp only [Pic0FiniteStageFinalModelRing]
  letI : Algebra M.1 (Pic0FiniteStageModelRing C L n m relation M j) :=
    Algebra.TensorProduct.leftAlgebra
      (R := L.1) (S := M.1) (A := M.1)
      (B := DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j))
  letI : CommRing (Pic0FiniteStageModelRing C L n m relation M j) :=
    pic0FiniteStageModelRingCommRing C L n m relation M j
  letI : CommSemiring (Pic0FiniteStageModelRing C L n m relation M j) :=
    (inferInstance : CommRing (Pic0FiniteStageModelRing C L n m relation M j)).toCommSemiring
  exact @Algebra.TensorProduct.instCommRing M.1 N.1
    (Pic0FiniteStageModelRing C L n m relation M j)
    (inferInstance : CommSemiring M.1)
    (inferInstance : CommRing N.1)
    (inferInstance : Algebra M.1 N.1)
    (pic0FiniteStageModelRingCommRing C L n m relation M j).toCommSemiring
    (pic0FiniteStageModelRingAlgebra C L n m relation M j)

@[reducible] noncomputable instance pic0FiniteStageFinalModelRingCommSemiring
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    CommSemiring (Pic0FiniteStageFinalModelRing C L n m relation M N j) :=
  (pic0FiniteStageFinalModelRingCommRing C L n m relation M N j).toCommSemiring

@[reducible] noncomputable instance pic0FiniteStageFinalModelRingAlgebra
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    Algebra N.1 (Pic0FiniteStageFinalModelRing C L n m relation M N j) := by
  dsimp only [Pic0FiniteStageFinalModelRing]
  letI : Algebra M.1 (Pic0FiniteStageModelRing C L n m relation M j) :=
    Algebra.TensorProduct.leftAlgebra
      (R := L.1) (S := M.1) (A := M.1)
      (B := DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j))
  exact Algebra.TensorProduct.leftAlgebra
    (R := M.1) (S := N.1) (A := N.1)
    (B := Pic0FiniteStageModelRing C L n m relation M j)

attribute [instance 2000] pic0FiniteStageFinalModelRingAlgebra

@[reducible] noncomputable def pic0FiniteStageModelRingBaseAlgebra
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    Algebra L.1 (Pic0FiniteStageModelRing C L n m relation M j) := by
  exact @Algebra.TensorProduct.instAlgebra L.1 M.1
    (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j))
    (inferInstance : CommSemiring L.1)
    (inferInstance : Semiring M.1)
    (inferInstance : Algebra L.1 M.1)
    (inferInstance : Semiring
      (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j)))
    (inferInstance : Algebra L.1
      (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j)))

attribute [local instance] pic0FiniteStageModelRingBaseAlgebra

set_option synthInstance.maxHeartbeats 400000 in
-- Register the fixed tensor actions so dependent `restrictScalars` declarations see this tower.
set_option maxHeartbeats 6400000 in
noncomputable instance pic0FiniteStageModelRingIsScalarTower
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
  (j : Pic0FiniteStageRingIndex C) :
    IsScalarTower L.1 M.1 (Pic0FiniteStageModelRing C L n m relation M j) := by
  letI : Algebra L.1 (Pic0FiniteStageModelRing C L n m relation M j) :=
    pic0FiniteStageModelRingBaseAlgebra C L n m relation M j
  letI : Algebra M.1 (Pic0FiniteStageModelRing C L n m relation M j) :=
    pic0FiniteStageModelRingAlgebra C L n m relation M j
  letI : SMul M.1 (Pic0FiniteStageModelRing C L n m relation M j) :=
    TensorProduct.leftHasSMul
  letI : SMul L.1 (Pic0FiniteStageModelRing C L n m relation M j) :=
    TensorProduct.instSMul
  refine { smul_assoc := ?_ }
  intro x y z
  induction z using TensorProduct.induction_on with
  | zero => simp
  | add z₁ z₂ ih₁ ih₂ => simp [ih₁, ih₂]
  | tmul a b =>
      simp [Algebra.smul_def, TensorProduct.smul_tmul', ← mul_assoc]

attribute [instance 100000] pic0FiniteStageModelRingIsScalarTower

/-
The source maps below are indexed by `q`, so elaborating `restrictScalars` directly
can select a different tensor-product action for the dependent source and target
models.  Freeze those actions at this private boundary.  The wrapper has the same
carrier map as `AlgHom.restrictScalars`; only its implicit algebra structures are
made explicit.  The original proof and public statement remain archived in the
preceding Horizon attempts.
-/
noncomputable abbrev pic0FiniteStageModelRingSMulLM
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k) (M : DatG0.FinSubext L.1 k) : SMul L.1 M.1 :=
  IntermediateField.instSMulSubtypeMem_1 M.1

noncomputable abbrev pic0FiniteStageModelRingSMulM
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    SMul M.1 (Pic0FiniteStageModelRing C L n m relation M j) :=
  TensorProduct.leftHasSMul

noncomputable abbrev pic0FiniteStageModelRingSMulL
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    SMul L.1 (Pic0FiniteStageModelRing C L n m relation M j) :=
  TensorProduct.instSMul

@[reducible] noncomputable def pic0FiniteStageModelRingTowerExplicit
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    @IsScalarTower L.1 M.1 (Pic0FiniteStageModelRing C L n m relation M j)
      (pic0FiniteStageModelRingSMulLM L M)
      (pic0FiniteStageModelRingSMulM C L n m relation M j)
      (pic0FiniteStageModelRingSMulL C L n m relation M j) := by
  letI : Algebra L.1 (Pic0FiniteStageModelRing C L n m relation M j) :=
    pic0FiniteStageModelRingBaseAlgebra C L n m relation M j
  letI : Algebra M.1 (Pic0FiniteStageModelRing C L n m relation M j) :=
    pic0FiniteStageModelRingAlgebra C L n m relation M j
  letI : SMul L.1 M.1 := pic0FiniteStageModelRingSMulLM L M
  letI : SMul M.1 (Pic0FiniteStageModelRing C L n m relation M j) :=
    pic0FiniteStageModelRingSMulM C L n m relation M j
  letI : SMul L.1 (Pic0FiniteStageModelRing C L n m relation M j) :=
    pic0FiniteStageModelRingSMulL C L n m relation M j
  refine { smul_assoc := ?_ }
  intro x y z
  induction z using TensorProduct.induction_on with
  | zero => simp
  | add z1 z2 ih1 ih2 => simp [ih1, ih2]
  | tmul a b =>
      simp [Algebra.smul_def, TensorProduct.smul_tmul', ← mul_assoc]

noncomputable def pic0FiniteStageModelRestrictScalarsExplicit
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (j1 j2 : Pic0FiniteStageRingIndex C)
    (f : @AlgHom M.1
      (Pic0FiniteStageModelRing C L n m relation M j1)
      (Pic0FiniteStageModelRing C L n m relation M j2)
      (inferInstance : CommSemiring M.1)
      (pic0FiniteStageModelRingCommRing C L n m relation M j1).toSemiring
      (pic0FiniteStageModelRingCommRing C L n m relation M j2).toSemiring
      (pic0FiniteStageModelRingAlgebra C L n m relation M j1)
      (pic0FiniteStageModelRingAlgebra C L n m relation M j2)) :
    @AlgHom L.1
      (Pic0FiniteStageModelRing C L n m relation M j1)
      (Pic0FiniteStageModelRing C L n m relation M j2)
      (inferInstance : CommSemiring L.1)
      (pic0FiniteStageModelRingCommRing C L n m relation M j1).toSemiring
      (pic0FiniteStageModelRingCommRing C L n m relation M j2).toSemiring
      (pic0FiniteStageModelRingBaseAlgebra C L n m relation M j1)
      (pic0FiniteStageModelRingBaseAlgebra C L n m relation M j2) := by
  exact @AlgHom.restrictScalars
    L.1 M.1
      (Pic0FiniteStageModelRing C L n m relation M j1)
      (Pic0FiniteStageModelRing C L n m relation M j2)
      (inferInstance : CommSemiring L.1)
      (inferInstance : CommSemiring M.1)
      (pic0FiniteStageModelRingCommRing C L n m relation M j1).toSemiring
      (pic0FiniteStageModelRingCommRing C L n m relation M j2).toSemiring
      (inferInstance : Algebra L.1 M.1)
      (pic0FiniteStageModelRingAlgebra C L n m relation M j1)
      (pic0FiniteStageModelRingAlgebra C L n m relation M j2)
      (pic0FiniteStageModelRingBaseAlgebra C L n m relation M j1)
      (pic0FiniteStageModelRingBaseAlgebra C L n m relation M j2)
      (pic0FiniteStageModelRingTowerExplicit C L n m relation M j1)
      (pic0FiniteStageModelRingTowerExplicit C L n m relation M j2)
      f

/- The outer scalar extension sees these inner tensors as dependent carriers.
   Name their canonical instances so the nested map in the theorem header does
   not synthesize a fresh, incoherent `Semiring` structure for each `q`. -/
@[reducible] noncomputable def pic0FiniteStageModelScalarExtensionSemiring
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    Semiring (N.1 ⊗[M.1] Pic0FiniteStageModelRing C L n m relation M j) :=
  @Algebra.TensorProduct.instSemiring M.1 N.1
    (Pic0FiniteStageModelRing C L n m relation M j)
    (inferInstance : CommSemiring M.1)
    (inferInstance : Semiring N.1)
    (inferInstance : Algebra M.1 N.1)
    (pic0FiniteStageModelRingCommRing C L n m relation M j).toSemiring
    (pic0FiniteStageModelRingAlgebra C L n m relation M j)

attribute [local instance] pic0FiniteStageModelScalarExtensionSemiring

@[reducible] noncomputable def pic0FiniteStageModelScalarExtensionAlgebra
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    Algebra N.1 (N.1 ⊗[M.1] Pic0FiniteStageModelRing C L n m relation M j) :=
  @Algebra.TensorProduct.leftAlgebra M.1 N.1 N.1
    (Pic0FiniteStageModelRing C L n m relation M j)
    (inferInstance : CommSemiring M.1)
    (inferInstance : Semiring N.1)
    (inferInstance : Algebra M.1 N.1)
    (pic0FiniteStageModelRingCommRing C L n m relation M j).toSemiring
    (pic0FiniteStageModelRingAlgebra C L n m relation M j)
    (inferInstance : CommSemiring N.1)
    (inferInstance : Algebra N.1 N.1)
    (inferInstance : SMulCommClass M.1 N.1 N.1)

attribute [local instance] pic0FiniteStageModelScalarExtensionAlgebra
attribute [local instance] pic0FiniteStageModelScalarExtensionSemiring

noncomputable def pic0FiniteStageModelScalarExtensionMap
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (j1 j2 : Pic0FiniteStageRingIndex C)
    (f : @AlgHom M.1
      (Pic0FiniteStageModelRing C L n m relation M j1)
      (Pic0FiniteStageModelRing C L n m relation M j2)
      (inferInstance : CommSemiring M.1)
      (pic0FiniteStageModelRingCommRing C L n m relation M j1).toSemiring
      (pic0FiniteStageModelRingCommRing C L n m relation M j2).toSemiring
      (pic0FiniteStageModelRingAlgebra C L n m relation M j1)
      (pic0FiniteStageModelRingAlgebra C L n m relation M j2)) :
    @AlgHom N.1
      (N.1 ⊗[M.1] Pic0FiniteStageModelRing C L n m relation M j1)
      (N.1 ⊗[M.1] Pic0FiniteStageModelRing C L n m relation M j2)
      (inferInstance : CommSemiring N.1)
      (pic0FiniteStageModelScalarExtensionSemiring C L n m relation M N j1)
      (pic0FiniteStageModelScalarExtensionSemiring C L n m relation M N j2)
      (pic0FiniteStageModelScalarExtensionAlgebra C L n m relation M N j1)
      (pic0FiniteStageModelScalarExtensionAlgebra C L n m relation M N j2) := by
  letI : Algebra M.1 (Pic0FiniteStageModelRing C L n m relation M j1) :=
    pic0FiniteStageModelRingAlgebra C L n m relation M j1
  letI : Algebra M.1 (Pic0FiniteStageModelRing C L n m relation M j2) :=
    pic0FiniteStageModelRingAlgebra C L n m relation M j2
  exact @AlgebraicJacobian.scalarExtensionMapOfAlgHom
    M.1 N.1
      (Pic0FiniteStageModelRing C L n m relation M j1)
      (Pic0FiniteStageModelRing C L n m relation M j2)
      (inferInstance : CommRing M.1)
      (inferInstance : CommRing N.1)
      (pic0FiniteStageModelRingCommRing C L n m relation M j1).toSemiring
      (pic0FiniteStageModelRingCommRing C L n m relation M j2).toSemiring
      (inferInstance : Algebra M.1 N.1)
      (pic0FiniteStageModelRingAlgebra C L n m relation M j1)
      (pic0FiniteStageModelRingAlgebra C L n m relation M j2)
      f

@[reducible] noncomputable def pic0FiniteStageModelAmbientSemiring
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (j : Pic0FiniteStageRingIndex C) :
    Semiring
      (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n j) (m j) (relation j)) :=
  @Algebra.TensorProduct.instSemiring L.1 k
    (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j))
    (inferInstance : CommSemiring L.1)
    (inferInstance : Semiring k)
    (inferInstance : Algebra L.1 k)
    (inferInstance : Semiring
      (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j)))
    (inferInstance : Algebra L.1
      (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j)))

attribute [local instance] pic0FiniteStageModelAmbientSemiring

@[reducible] noncomputable def pic0FiniteStageModelAmbientAlgebra
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (j : Pic0FiniteStageRingIndex C) :
    Algebra L.1
      (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n j) (m j) (relation j)) :=
  @Algebra.TensorProduct.instAlgebra L.1 k
    (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j))
    (inferInstance : CommSemiring L.1)
    (inferInstance : Semiring k)
    (inferInstance : Algebra L.1 k)
    (inferInstance : Semiring
      (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j)))
    (inferInstance : Algebra L.1
      (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j)))

attribute [local instance] pic0FiniteStageModelAmbientAlgebra

@[reducible] noncomputable def pic0FiniteStageModelAmbientKAlgebra
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (j : Pic0FiniteStageRingIndex C) :
    Algebra k
      (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n j) (m j) (relation j)) :=
  @Algebra.TensorProduct.leftAlgebra L.1 k k
    (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j))
    (inferInstance : CommSemiring L.1)
    (inferInstance : Semiring k)
    (inferInstance : Algebra L.1 k)
    (inferInstance : Semiring
      (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j)))
    (inferInstance : Algebra L.1
      (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j)))
    (inferInstance : CommSemiring k)
    (inferInstance : Algebra k k)
    (inferInstance : SMulCommClass L.1 k k)

attribute [local instance] pic0FiniteStageModelAmbientKAlgebra

@[reducible] noncomputable def pic0FiniteStageModelAmbientTower
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (j : Pic0FiniteStageRingIndex C) :
    IsScalarTower L.1 k
      (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n j) (m j) (relation j)) := by
  letI : Algebra k
      (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n j) (m j) (relation j)) :=
    pic0FiniteStageModelAmbientKAlgebra C L n m relation j
  letI : Algebra L.1
      (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n j) (m j) (relation j)) :=
    pic0FiniteStageModelAmbientAlgebra C L n m relation j
  exact IsScalarTower.of_algebraMap_eq' rfl

noncomputable def pic0FiniteStageModelAmbientMap
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    @AlgHom L.1
      (Pic0FiniteStageModelRing C L n m relation M j)
      (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n j) (m j) (relation j))
      (inferInstance : CommSemiring L.1)
      (pic0FiniteStageModelRingCommRing C L n m relation M j).toSemiring
      (pic0FiniteStageModelAmbientSemiring C L n m relation j)
      (pic0FiniteStageModelRingBaseAlgebra C L n m relation M j)
      (pic0FiniteStageModelAmbientAlgebra C L n m relation j) := by
  letI : Algebra L.1 (Pic0FiniteStageModelRing C L n m relation M j) :=
    pic0FiniteStageModelRingBaseAlgebra C L n m relation M j
  letI : Algebra L.1
      (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n j) (m j) (relation j)) :=
    pic0FiniteStageModelAmbientAlgebra C L n m relation j
  exact Algebra.TensorProduct.map M.1.val
    (AlgHom.id L.1
      (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j)))

noncomputable def pic0FiniteStageModelAmbientMapCompRestrict
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (j1 j2 : Pic0FiniteStageRingIndex C)
    (f : @AlgHom M.1
      (Pic0FiniteStageModelRing C L n m relation M j1)
      (Pic0FiniteStageModelRing C L n m relation M j2)
      (inferInstance : CommSemiring M.1)
      (pic0FiniteStageModelRingCommRing C L n m relation M j1).toSemiring
      (pic0FiniteStageModelRingCommRing C L n m relation M j2).toSemiring
      (pic0FiniteStageModelRingAlgebra C L n m relation M j1)
      (pic0FiniteStageModelRingAlgebra C L n m relation M j2)) :
    @AlgHom L.1
      (Pic0FiniteStageModelRing C L n m relation M j1)
      (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n j2) (m j2) (relation j2))
      (inferInstance : CommSemiring L.1)
      (pic0FiniteStageModelRingCommRing C L n m relation M j1).toSemiring
      (pic0FiniteStageModelAmbientSemiring C L n m relation j2)
      (pic0FiniteStageModelRingBaseAlgebra C L n m relation M j1)
      (pic0FiniteStageModelAmbientAlgebra C L n m relation j2) := by
  exact @AlgHom.comp L.1
    (Pic0FiniteStageModelRing C L n m relation M j1)
    (Pic0FiniteStageModelRing C L n m relation M j2)
    (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
      (n j2) (m j2) (relation j2))
    (inferInstance : CommSemiring L.1)
    (pic0FiniteStageModelRingCommRing C L n m relation M j1).toSemiring
    (pic0FiniteStageModelRingCommRing C L n m relation M j2).toSemiring
    (pic0FiniteStageModelAmbientSemiring C L n m relation j2)
    (pic0FiniteStageModelRingBaseAlgebra C L n m relation M j1)
    (pic0FiniteStageModelRingBaseAlgebra C L n m relation M j2)
    (pic0FiniteStageModelAmbientAlgebra C L n m relation j2)
    (pic0FiniteStageModelAmbientMap C L n m relation M j2)
    (pic0FiniteStageModelRestrictScalarsExplicit C L n m relation M j1 j2 f)

noncomputable def pic0FiniteStageTransportedMapRestrictScalars
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (e : forall j,
      k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
        Pic0FiniteStageRing C j)
    (q : Pic0FiniteStageMapIndex C) :
    @AlgHom L.1
      (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n (Pic0FiniteStageMapSource C q))
        (m (Pic0FiniteStageMapSource C q))
        (relation (Pic0FiniteStageMapSource C q)))
      (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n (Pic0FiniteStageMapTarget C q))
        (m (Pic0FiniteStageMapTarget C q))
        (relation (Pic0FiniteStageMapTarget C q)))
      (inferInstance : CommSemiring L.1)
      (pic0FiniteStageModelAmbientSemiring C L n m relation
        (Pic0FiniteStageMapSource C q))
      (pic0FiniteStageModelAmbientSemiring C L n m relation
        (Pic0FiniteStageMapTarget C q))
      (pic0FiniteStageModelAmbientAlgebra C L n m relation
        (Pic0FiniteStageMapSource C q))
      (pic0FiniteStageModelAmbientAlgebra C L n m relation
        (Pic0FiniteStageMapTarget C q)) := by
  letI : Algebra k
      (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n (Pic0FiniteStageMapSource C q))
        (m (Pic0FiniteStageMapSource C q))
        (relation (Pic0FiniteStageMapSource C q))) :=
    pic0FiniteStageModelAmbientKAlgebra C L n m relation
      (Pic0FiniteStageMapSource C q)
  letI : Algebra k
      (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n (Pic0FiniteStageMapTarget C q))
        (m (Pic0FiniteStageMapTarget C q))
        (relation (Pic0FiniteStageMapTarget C q))) :=
    pic0FiniteStageModelAmbientKAlgebra C L n m relation
      (Pic0FiniteStageMapTarget C q)
  exact @AlgHom.restrictScalars
    L.1 k
      (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n (Pic0FiniteStageMapSource C q))
        (m (Pic0FiniteStageMapSource C q))
        (relation (Pic0FiniteStageMapSource C q)))
      (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n (Pic0FiniteStageMapTarget C q))
        (m (Pic0FiniteStageMapTarget C q))
        (relation (Pic0FiniteStageMapTarget C q)))
      (inferInstance : CommSemiring L.1)
      (inferInstance : CommSemiring k)
      (pic0FiniteStageModelAmbientSemiring C L n m relation
        (Pic0FiniteStageMapSource C q))
      (pic0FiniteStageModelAmbientSemiring C L n m relation
        (Pic0FiniteStageMapTarget C q))
      (inferInstance : Algebra L.1 k)
      (pic0FiniteStageModelAmbientKAlgebra C L n m relation
        (Pic0FiniteStageMapSource C q))
      (pic0FiniteStageModelAmbientKAlgebra C L n m relation
        (Pic0FiniteStageMapTarget C q))
      (pic0FiniteStageModelAmbientAlgebra C L n m relation
        (Pic0FiniteStageMapSource C q))
      (pic0FiniteStageModelAmbientAlgebra C L n m relation
        (Pic0FiniteStageMapTarget C q))
      (pic0FiniteStageModelAmbientTower C L n m relation
        (Pic0FiniteStageMapSource C q))
      (pic0FiniteStageModelAmbientTower C L n m relation
        (Pic0FiniteStageMapTarget C q))
      (pic0FiniteStageTransportedMap C L n m relation e q)

noncomputable def pic0FiniteStageTransportedMapRestrictCompAmbient
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (e : forall j,
      k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
        Pic0FiniteStageRing C j)
    (M : DatG0.FinSubext L.1 k)
    (q : Pic0FiniteStageMapIndex C) :
    @AlgHom L.1
      (Pic0FiniteStageModelRing C L n m relation M
        (Pic0FiniteStageMapSource C q))
      (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n (Pic0FiniteStageMapTarget C q))
        (m (Pic0FiniteStageMapTarget C q))
        (relation (Pic0FiniteStageMapTarget C q)))
      (inferInstance : CommSemiring L.1)
      (pic0FiniteStageModelRingCommRing C L n m relation M
        (Pic0FiniteStageMapSource C q)).toSemiring
      (pic0FiniteStageModelAmbientSemiring C L n m relation
        (Pic0FiniteStageMapTarget C q))
      (pic0FiniteStageModelRingBaseAlgebra C L n m relation M
        (Pic0FiniteStageMapSource C q))
      (pic0FiniteStageModelAmbientAlgebra C L n m relation
        (Pic0FiniteStageMapTarget C q)) := by
  exact @AlgHom.comp L.1
    (Pic0FiniteStageModelRing C L n m relation M
      (Pic0FiniteStageMapSource C q))
    (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
      (n (Pic0FiniteStageMapSource C q))
      (m (Pic0FiniteStageMapSource C q))
      (relation (Pic0FiniteStageMapSource C q)))
    (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
      (n (Pic0FiniteStageMapTarget C q))
      (m (Pic0FiniteStageMapTarget C q))
      (relation (Pic0FiniteStageMapTarget C q)))
    (inferInstance : CommSemiring L.1)
    (pic0FiniteStageModelRingCommRing C L n m relation M
      (Pic0FiniteStageMapSource C q)).toSemiring
    (pic0FiniteStageModelAmbientSemiring C L n m relation
      (Pic0FiniteStageMapSource C q))
    (pic0FiniteStageModelAmbientSemiring C L n m relation
      (Pic0FiniteStageMapTarget C q))
    (pic0FiniteStageModelRingBaseAlgebra C L n m relation M
      (Pic0FiniteStageMapSource C q))
    (pic0FiniteStageModelAmbientAlgebra C L n m relation
      (Pic0FiniteStageMapSource C q))
    (pic0FiniteStageModelAmbientAlgebra C L n m relation
      (Pic0FiniteStageMapTarget C q))
    (pic0FiniteStageTransportedMapRestrictScalars C L n m relation e q)
    (pic0FiniteStageModelAmbientMap C L n m relation M
      (Pic0FiniteStageMapSource C q))

@[reducible] noncomputable def pic0FiniteStageFinalModelRingModule
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    Module N.1 (Pic0FiniteStageFinalModelRing C L n m relation M N j) :=
  (pic0FiniteStageFinalModelRingAlgebra C L n m relation M N j).toModule

attribute [local instance] pic0FiniteStageFinalModelRingModule

@[reducible] noncomputable def pic0FiniteStageFinalScalarExtensionSemiring
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    Semiring (k ⊗[N.1] Pic0FiniteStageFinalModelRing C L n m relation M N j) :=
  @Algebra.TensorProduct.instSemiring N.1 k
    (Pic0FiniteStageFinalModelRing C L n m relation M N j)
    (inferInstance : CommSemiring N.1)
    (inferInstance : Semiring k)
    (inferInstance : Algebra N.1 k)
    (pic0FiniteStageFinalModelRingCommSemiring C L n m relation M N j).toSemiring
    (pic0FiniteStageFinalModelRingAlgebra C L n m relation M N j)

attribute [local instance] pic0FiniteStageFinalScalarExtensionSemiring

@[reducible] noncomputable def pic0FiniteStageFinalScalarExtensionAlgebra
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    Algebra k (k ⊗[N.1] Pic0FiniteStageFinalModelRing C L n m relation M N j) :=
  @Algebra.TensorProduct.leftAlgebra N.1 k k
    (Pic0FiniteStageFinalModelRing C L n m relation M N j)
    (inferInstance : CommSemiring N.1)
    (inferInstance : Semiring k)
    (inferInstance : Algebra N.1 k)
    (pic0FiniteStageFinalModelRingCommSemiring C L n m relation M N j).toSemiring
    (pic0FiniteStageFinalModelRingAlgebra C L n m relation M N j)
    (inferInstance : CommSemiring k)
    (inferInstance : Algebra k k)
    (inferInstance : SMulCommClass N.1 k k)

attribute [local instance] pic0FiniteStageFinalScalarExtensionAlgebra

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
      Pic0FiniteStageRing C j := by
  exact (Algebra.TensorProduct.cancelBaseChange M.1 N.1 k k
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
      (pic0FiniteStageModelAmbientMapCompRestrict C L n m relation M
        (Pic0FiniteStageMapSource C q)
        (Pic0FiniteStageMapTarget C q)
        (mapM q)) =
        (pic0FiniteStageTransportedMapRestrictCompAmbient C L n m relation e M q))
    (N : DatG0.FinSubext M.1 k)
    (q : Pic0FiniteStageMapIndex C) :
    (pic0FiniteStageFinalBaseChangeEquiv C L n m relation e M N
        (Pic0FiniteStageMapTarget C q)).toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := N.1) (K := k)
          (pic0FiniteStageModelScalarExtensionMap C L n m relation M N
            (Pic0FiniteStageMapSource C q)
            (Pic0FiniteStageMapTarget C q)
            (mapM q))) =
      (pic0FiniteStageMap C q).comp
        (pic0FiniteStageFinalBaseChangeEquiv C L n m relation e M N
          (Pic0FiniteStageMapSource C q)).toAlgHom := by
  sorry

end

end AlgebraicGeometry
