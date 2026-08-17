/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Descent.TensorProductFieldTowerMap
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleOverlapRings

/-!
# Comparing finite-stage Picard triple-overlap models

The finite-stage atlas theorem supplies presentations over `L`, models over a further
finite subextension `M`, and comparison maps after scalar extension.  This file first
cancels the tower `L -> M -> k`, producing a componentwise equivalence from the scalar
extension of every model ring to its exact section ring.  The supplied map squares become
literal naturality squares for these component equivalences.

The second step transports tensor pushouts along the component equivalences.  Applying it
to the two restriction legs identifies the scalar extension of the descended triple model
with the section ring of the exact triple intersection, including both face formulas.
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

/-! ## Component comparisons -/

set_option synthInstance.maxHeartbeats 200000 in
-- The component contains two dependent quotient-algebra instances.
/-- Cancel the intermediate finite subextension in a finite-presentation model and then
apply its chosen exact-ring comparison. -/
def pic0FiniteStageModelBaseChangeEquiv
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (e : forall j,
      k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
        Pic0FiniteStageRing C j)
    (M : DatG0.FinSubext L.1 k)
    (j : Pic0FiniteStageRingIndex C) :=
  (Algebra.TensorProduct.cancelBaseChange L.1 M.1 k k
    (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j))).trans (e j)

set_option synthInstance.maxHeartbeats 200000 in
-- The source and target quotient algebras depend on the finite ring tag.
set_option maxHeartbeats 1600000 in
-- Cancellation naturality and conjugation elaborate through both dependent models.
/-- The component comparisons intertwine each scalar-extended finite-stage map with the
corresponding exact restriction or transition map. -/
theorem pic0FiniteStageModelBaseChangeEquiv_naturality
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
    (q : Pic0FiniteStageMapIndex C) :
    (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
        (Pic0FiniteStageMapTarget C q)).toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := k) (mapM q)) =
      (pic0FiniteStageMap C q).comp
        (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
          (Pic0FiniteStageMapSource C q)).toAlgHom := by
  have hval : M.1.val = IsScalarTower.toAlgHom L.1 M.1 k := by
    ext x
    rfl
  have hcancel := AlgebraicJacobian.cancelBaseChange_naturality
    (F := L.1) (L := M.1) (K := k)
    (phiL := mapM q)
    (phiK := pic0FiniteStageTransportedMap C L n m relation e q)
    (by
      rw [← hval]
      exact hmapM q)
  apply DFunLike.ext _ _
  intro x
  have hx := DFunLike.congr_fun hcancel x
  change
    (Algebra.TensorProduct.cancelBaseChange L.1 M.1 k k
      (DatG0.FiniteRelationAlgebra L.1
        (n (Pic0FiniteStageMapTarget C q))
        (m (Pic0FiniteStageMapTarget C q))
        (relation (Pic0FiniteStageMapTarget C q))))
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := k) (mapM q) x) =
      pic0FiniteStageTransportedMap C L n m relation e q
        ((Algebra.TensorProduct.cancelBaseChange L.1 M.1 k k
          (DatG0.FiniteRelationAlgebra L.1
            (n (Pic0FiniteStageMapSource C q))
            (m (Pic0FiniteStageMapSource C q))
            (relation (Pic0FiniteStageMapSource C q)))) x) at hx
  change
    e (Pic0FiniteStageMapTarget C q)
      ((Algebra.TensorProduct.cancelBaseChange L.1 M.1 k k
        (DatG0.FiniteRelationAlgebra L.1
          (n (Pic0FiniteStageMapTarget C q))
          (m (Pic0FiniteStageMapTarget C q))
          (relation (Pic0FiniteStageMapTarget C q))))
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := k) (mapM q) x)) =
      pic0FiniteStageMap C q
        (e (Pic0FiniteStageMapSource C q)
          ((Algebra.TensorProduct.cancelBaseChange L.1 M.1 k k
            (DatG0.FiniteRelationAlgebra L.1
              (n (Pic0FiniteStageMapSource C q))
              (m (Pic0FiniteStageMapSource C q))
              (relation (Pic0FiniteStageMapSource C q)))) x))
  rw [hx]
  exact (e (Pic0FiniteStageMapTarget C q)).apply_symm_apply
    (pic0FiniteStageMap C q
      (e (Pic0FiniteStageMapSource C q)
        ((Algebra.TensorProduct.cancelBaseChange L.1 M.1 k k
          (DatG0.FiniteRelationAlgebra L.1
            (n (Pic0FiniteStageMapSource C q))
            (m (Pic0FiniteStageMapSource C q))
            (relation (Pic0FiniteStageMapSource C q)))) x)))

/-! ## Transporting tensor pushouts -/

/-- Tensor-product pushouts are invariant under compatible equivalences of their base
and two factors.  The result is an equivalence over the common ground ring. -/
noncomputable def tensorPushoutAlgEquivCongr
    {R A1 A2 B1 B2 D1 D2 : Type u}
    [CommRing R] [CommRing A1] [CommRing A2]
    [CommRing B1] [CommRing B2] [CommRing D1] [CommRing D2]
    [Algebra R A1] [Algebra R A2]
    [Algebra R B1] [Algebra R B2] [Algebra R D1] [Algebra R D2]
    (f1 : A1 →ₐ[R] B1) (g1 : A1 →ₐ[R] D1)
    (f2 : A2 →ₐ[R] B2) (g2 : A2 →ₐ[R] D2)
    (eA : A1 ≃ₐ[R] A2) (eB : B1 ≃ₐ[R] B2) (eD : D1 ≃ₐ[R] D2)
    (hf : eB.toAlgHom.comp f1 = f2.comp eA.toAlgHom)
    (hg : eD.toAlgHom.comp g1 = g2.comp eA.toAlgHom) :
    letI : Algebra A1 B1 := f1.toRingHom.toAlgebra
    letI : Algebra A1 D1 := g1.toRingHom.toAlgebra
    letI : Algebra A2 B2 := f2.toRingHom.toAlgebra
    letI : Algebra A2 D2 := g2.toRingHom.toAlgebra
    letI : IsScalarTower R A1 B1 :=
      IsScalarTower.of_algebraMap_eq (fun x => (f1.commutes x).symm)
    letI : IsScalarTower R A2 B2 :=
      IsScalarTower.of_algebraMap_eq (fun x => (f2.commutes x).symm)
    B1 ⊗[A1] D1 ≃ₐ[R] B2 ⊗[A2] D2 := by
  letI : Algebra A1 B1 := f1.toRingHom.toAlgebra
  letI : Algebra A1 D1 := g1.toRingHom.toAlgebra
  letI : Algebra A2 B2 := f2.toRingHom.toAlgebra
  letI : Algebra A2 D2 := g2.toRingHom.toAlgebra
  letI : IsScalarTower R A1 B1 :=
    IsScalarTower.of_algebraMap_eq (fun x => (f1.commutes x).symm)
  letI : IsScalarTower R A2 B2 :=
    IsScalarTower.of_algebraMap_eq (fun x => (f2.commutes x).symm)
  let P1 := B1 ⊗[A1] D1
  let P2 := B2 ⊗[A2] D2
  let jB : B1 →+* P2 :=
    Algebra.TensorProduct.includeLeftRingHom.comp eB.toRingEquiv.toRingHom
  let jD : D1 →+* P2 :=
    Algebra.TensorProduct.includeRight.toRingHom.comp eD.toRingEquiv.toRingHom
  have ht : IsPushout
      (CommRingCat.ofHom f1.toRingHom) (CommRingCat.ofHom g1.toRingHom)
      (CommRingCat.ofHom jB) (CommRingCat.ofHom jD) := by
    apply (CommRingCat.isPushout_tensorProduct A2 B2 D2).of_iso'
      eA.toRingEquiv.toCommRingCatIso eB.toRingEquiv.toCommRingCatIso
      eD.toRingEquiv.toCommRingCatIso (Iso.refl (CommRingCat.of P2))
    · ext x
      exact DFunLike.congr_fun hf.symm x
    · ext x
      exact DFunLike.congr_fun hg.symm x
    · rfl
    · rfl
  have hs : IsPushout
      (CommRingCat.ofHom f1.toRingHom) (CommRingCat.ofHom g1.toRingHom)
      (CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
        (R := A1) (A := B1) (B := D1)))
      (CommRingCat.ofHom (Algebra.TensorProduct.includeRight
        (R := A1) (A := B1) (B := D1)).toRingHom) :=
    CommRingCat.isPushout_tensorProduct A1 B1 D1
  let ie : CommRingCat.of P1 ≅ CommRingCat.of P2 :=
    hs.isoIsPushout (CommRingCat.of B1) (CommRingCat.of D1) ht
  have left_formula (b : B1) :
      ie.hom.hom (b ⊗ₜ[A1] (1 : D1)) = eB b ⊗ₜ[A2] (1 : D2) := by
    have hleft := hs.inl_isoIsPushout_hom
      (CommRingCat.of B1) (CommRingCat.of D1) ht
    have hx := congrArg
      (fun q : CommRingCat.of B1 ⟶ CommRingCat.of P2 => q.hom b) hleft
    change ie.hom.hom (b ⊗ₜ[A1] (1 : D1)) = jB b at hx
    exact hx
  let re : P1 ≃+* P2 := ie.commRingCatIsoToRingEquiv
  refine AlgEquiv.ofRingEquiv (f := re) fun x => ?_
  change ie.hom.hom (((algebraMap R B1) x) ⊗ₜ[A1] (1 : D1)) =
    ((algebraMap R B2) x) ⊗ₜ[A2] (1 : D2)
  rw [left_formula, eB.commutes]

/-- The pushout-congruence equivalence carries both tensor inclusions to the transported
factor inclusions. -/
theorem tensorPushoutAlgEquivCongr_faces
    {R A1 A2 B1 B2 D1 D2 : Type u}
    [CommRing R] [CommRing A1] [CommRing A2]
    [CommRing B1] [CommRing B2] [CommRing D1] [CommRing D2]
    [Algebra R A1] [Algebra R A2]
    [Algebra R B1] [Algebra R B2] [Algebra R D1] [Algebra R D2]
    (f1 : A1 →ₐ[R] B1) (g1 : A1 →ₐ[R] D1)
    (f2 : A2 →ₐ[R] B2) (g2 : A2 →ₐ[R] D2)
    (eA : A1 ≃ₐ[R] A2) (eB : B1 ≃ₐ[R] B2) (eD : D1 ≃ₐ[R] D2)
    (hf : eB.toAlgHom.comp f1 = f2.comp eA.toAlgHom)
    (hg : eD.toAlgHom.comp g1 = g2.comp eA.toAlgHom) :
    letI : Algebra A1 B1 := f1.toRingHom.toAlgebra
    letI : Algebra A1 D1 := g1.toRingHom.toAlgebra
    letI : Algebra A2 B2 := f2.toRingHom.toAlgebra
    letI : Algebra A2 D2 := g2.toRingHom.toAlgebra
    letI : IsScalarTower R A1 B1 :=
      IsScalarTower.of_algebraMap_eq (fun x => (f1.commutes x).symm)
    letI : IsScalarTower R A2 B2 :=
      IsScalarTower.of_algebraMap_eq (fun x => (f2.commutes x).symm)
    (forall b : B1,
      tensorPushoutAlgEquivCongr f1 g1 f2 g2 eA eB eD hf hg
          (b ⊗ₜ[A1] (1 : D1)) =
        eB b ⊗ₜ[A2] (1 : D2)) ∧
    (forall d : D1,
      tensorPushoutAlgEquivCongr f1 g1 f2 g2 eA eB eD hf hg
          ((1 : B1) ⊗ₜ[A1] d) =
        (1 : B2) ⊗ₜ[A2] eD d) := by
  letI : Algebra A1 B1 := f1.toRingHom.toAlgebra
  letI : Algebra A1 D1 := g1.toRingHom.toAlgebra
  letI : Algebra A2 B2 := f2.toRingHom.toAlgebra
  letI : Algebra A2 D2 := g2.toRingHom.toAlgebra
  letI : IsScalarTower R A1 B1 :=
    IsScalarTower.of_algebraMap_eq (fun x => (f1.commutes x).symm)
  letI : IsScalarTower R A2 B2 :=
    IsScalarTower.of_algebraMap_eq (fun x => (f2.commutes x).symm)
  let P1 := B1 ⊗[A1] D1
  let P2 := B2 ⊗[A2] D2
  let jB : B1 →+* P2 :=
    Algebra.TensorProduct.includeLeftRingHom.comp eB.toRingEquiv.toRingHom
  let jD : D1 →+* P2 :=
    Algebra.TensorProduct.includeRight.toRingHom.comp eD.toRingEquiv.toRingHom
  have ht : IsPushout
      (CommRingCat.ofHom f1.toRingHom) (CommRingCat.ofHom g1.toRingHom)
      (CommRingCat.ofHom jB) (CommRingCat.ofHom jD) := by
    apply (CommRingCat.isPushout_tensorProduct A2 B2 D2).of_iso'
      eA.toRingEquiv.toCommRingCatIso eB.toRingEquiv.toCommRingCatIso
      eD.toRingEquiv.toCommRingCatIso (Iso.refl (CommRingCat.of P2))
    · ext x
      exact DFunLike.congr_fun hf.symm x
    · ext x
      exact DFunLike.congr_fun hg.symm x
    · rfl
    · rfl
  have hs : IsPushout
      (CommRingCat.ofHom f1.toRingHom) (CommRingCat.ofHom g1.toRingHom)
      (CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
        (R := A1) (A := B1) (B := D1)))
      (CommRingCat.ofHom (Algebra.TensorProduct.includeRight
        (R := A1) (A := B1) (B := D1)).toRingHom) :=
    CommRingCat.isPushout_tensorProduct A1 B1 D1
  let ie : CommRingCat.of P1 ≅ CommRingCat.of P2 :=
    hs.isoIsPushout (CommRingCat.of B1) (CommRingCat.of D1) ht
  constructor
  · intro b
    change ie.hom.hom (b ⊗ₜ[A1] (1 : D1)) = eB b ⊗ₜ[A2] (1 : D2)
    have hleft := hs.inl_isoIsPushout_hom
      (CommRingCat.of B1) (CommRingCat.of D1) ht
    have hx := congrArg
      (fun q : CommRingCat.of B1 ⟶ CommRingCat.of P2 => q.hom b) hleft
    change ie.hom.hom (b ⊗ₜ[A1] (1 : D1)) = jB b at hx
    exact hx
  · intro d
    change ie.hom.hom ((1 : B1) ⊗ₜ[A1] d) = (1 : B2) ⊗ₜ[A2] eD d
    have hright := hs.inr_isoIsPushout_hom
      (CommRingCat.of B1) (CommRingCat.of D1) ht
    have hx := congrArg
      (fun q : CommRingCat.of D1 ⟶ CommRingCat.of P2 => q.hom d) hright
    change ie.hom.hom ((1 : B1) ⊗ₜ[A1] d) = jD d at hx
    exact hx

/-! ## The Picard triple-model comparison -/

set_option synthInstance.maxHeartbeats 200000 in
-- Specializing the dependent combined-map family requires both quotient models.
set_option maxHeartbeats 1600000 in
-- Definitional reduction identifies the combined-map tags with the restriction leg.
/-- Component naturality for a descended left restriction map. -/
theorem pic0FiniteStageModelBaseChangeEquiv_restrictionLeft
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
    (U V : Pic0FiniteStageChartIndex C) :
    (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
      (Sum.inr (U, V))).toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := k)
          (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)) =
      (pic0FiniteStageRestrictionLeft C U V).comp
        (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
          (Sum.inl U)).toAlgHom := by
  apply DFunLike.ext _ _
  intro x
  exact DFunLike.congr_fun
    (pic0FiniteStageModelBaseChangeEquiv_naturality
      C L n m relation e M mapM hmapM (Sum.inl (Sum.inl (U, V)))) x

set_option synthInstance.maxHeartbeats 400000 in
-- The comparison composes three tensor equivalences with dependent quotient factors.
set_option maxHeartbeats 6400000 in
-- The exact tensor equivalence is restricted through two explicitly chosen scalar towers.
/-- Scalar extension of the descended triple-overlap model is the section ring of the
literal exact triple intersection. -/
noncomputable def pic0FiniteStageTripleModelComparison
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
    (U V W : Pic0FiniteStageChartIndex C) := by
  have hUV := pic0FiniteStageModelBaseChangeEquiv_restrictionLeft
    C L n m relation e M mapM hmapM U V
  have hUW := pic0FiniteStageModelBaseChangeEquiv_restrictionLeft
    C L n m relation e M mapM hmapM U W
  letI := pic0FiniteStageOverlapLeftAlgebra C U V
  letI := pic0FiniteStageOverlapLeftAlgebra C U W
  letI := pic0FiniteStageTripleLeftAlgebra C U V W
  letI := pic0FiniteStageTowerOfMap (pic0FiniteStageRestrictionLeft C U V)
  letI := pic0FiniteStageTowerOfMap (pic0FiniteStageRestrictionLeft C U W)
  letI := pic0FiniteStageTowerOfMap
    ((pic0FiniteStageOverlapToTripleLeft C U V W).comp
      (pic0FiniteStageRestrictionLeft C U V))
  exact (pic0FiniteStageTripleModelBaseChange
    C L n m relation M mapM U V W).trans
      ((tensorPushoutAlgEquivCongr
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := k)
          (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V))
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := k)
          (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W))
        (pic0FiniteStageRestrictionLeft C U V)
        (pic0FiniteStageRestrictionLeft C U W)
        (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M (Sum.inl U))
        (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M (Sum.inr (U, V)))
        (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M (Sum.inr (U, W)))
        hUV hUW).trans
        ((pic0FiniteStageTripleTensorEquiv C U V W).restrictScalars k))

set_option synthInstance.maxHeartbeats 400000 in
-- The face type contains the dependent chart, overlap, and tensor-model rings.
set_option maxHeartbeats 1600000 in
-- The inclusion is restricted through the model scalar tower.
/-- The left factor inclusion into a descended triple-overlap tensor model. -/
noncomputable def pic0FiniteStageTripleModelFaceLeft
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (mapM : forall q : Pic0FiniteStageMapIndex C,
      Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapSource C q) →ₐ[M.1]
        Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapTarget C q))
    (U V W : Pic0FiniteStageChartIndex C) :
    Pic0FiniteStageOverlapModelRing C L n m relation M U V →ₐ[M.1]
      Pic0FiniteStageTripleModelRing C L n m relation M mapM U V W := by
  let fUV := pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V
  let fUW := pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W
  letI := pic0FiniteStageAlgebraOfMap fUV
  letI := pic0FiniteStageAlgebraOfMap fUW
  letI := pic0FiniteStageTowerOfMap fUV
  exact Algebra.TensorProduct.includeLeft
    (R := Pic0FiniteStageChartModelRing C L n m relation M U)
    (S := M.1)
    (A := Pic0FiniteStageOverlapModelRing C L n m relation M U V)
    (B := Pic0FiniteStageOverlapModelRing C L n m relation M U W)

set_option synthInstance.maxHeartbeats 400000 in
-- The face type contains the dependent chart, overlap, and tensor-model rings.
set_option maxHeartbeats 1600000 in
-- The inclusion is restricted through the model scalar tower.
/-- The right factor inclusion into a descended triple-overlap tensor model. -/
noncomputable def pic0FiniteStageTripleModelFaceRight
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (mapM : forall q : Pic0FiniteStageMapIndex C,
      Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapSource C q) →ₐ[M.1]
        Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapTarget C q))
    (U V W : Pic0FiniteStageChartIndex C) :
    Pic0FiniteStageOverlapModelRing C L n m relation M U W →ₐ[M.1]
      Pic0FiniteStageTripleModelRing C L n m relation M mapM U V W := by
  let fUV := pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V
  let fUW := pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W
  letI := pic0FiniteStageAlgebraOfMap fUV
  letI := pic0FiniteStageAlgebraOfMap fUW
  letI := pic0FiniteStageTowerOfMap fUV
  exact (Algebra.TensorProduct.includeRight
    (R := Pic0FiniteStageChartModelRing C L n m relation M U)
    (A := Pic0FiniteStageOverlapModelRing C L n m relation M U V)
    (B := Pic0FiniteStageOverlapModelRing C L n m relation M U W)).restrictScalars M.1

set_option synthInstance.maxHeartbeats 400000 in
-- The face square contains all component and triple-model quotient instances.
set_option maxHeartbeats 3200000 in
-- The comparison composite is reduced through its three pure-tensor formulas.
/-- On the left face, the triple-model comparison is restriction from the first exact
overlap into the exact triple intersection. -/
theorem pic0FiniteStageTripleModelComparison_faceLeft
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
    (U V W : Pic0FiniteStageChartIndex C)
    (c : k) (b : Pic0FiniteStageOverlapModelRing C L n m relation M U V) :
    pic0FiniteStageTripleModelComparison C L n m relation e M mapM hmapM U V W
        (c ⊗ₜ[M.1] (b ⊗ₜ[
          Pic0FiniteStageChartModelRing C L n m relation M U] 1)) =
      pic0FiniteStageOverlapToTripleLeft C U V W
        (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
          (Sum.inr (U, V)) (c ⊗ₜ[M.1] b)) := by
  let fUV := pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V
  let fUW := pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W
  let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k) fUV
  let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k) fUW
  letI := pic0FiniteStageAlgebraOfMap fUV
  letI := pic0FiniteStageAlgebraOfMap fUW
  letI := pic0FiniteStageTowerOfMap fUV
  letI := pic0FiniteStageTowerOfMap fUW
  letI := pic0FiniteStageAlgebraOfMap kfUV
  letI := pic0FiniteStageAlgebraOfMap kfUW
  letI := pic0FiniteStageTowerOfMap kfUV
  letI := pic0FiniteStageOverlapLeftAlgebra C U V
  letI := pic0FiniteStageOverlapLeftAlgebra C U W
  letI := pic0FiniteStageTripleLeftAlgebra C U V W
  letI := pic0FiniteStageTowerOfMap (pic0FiniteStageRestrictionLeft C U V)
  letI := pic0FiniteStageTowerOfMap (pic0FiniteStageRestrictionLeft C U W)
  letI := pic0FiniteStageTowerOfMap
    ((pic0FiniteStageOverlapToTripleLeft C U V W).comp
      (pic0FiniteStageRestrictionLeft C U V))
  calc
    _ = (pic0FiniteStageTripleTensorEquiv C U V W).restrictScalars k
        (pic0FiniteStageTripleTensorComparison
          C L n m relation e M mapM hmapM U V W
          (pic0FiniteStageTripleModelBaseChange
            C L n m relation M mapM U V W
            (c ⊗ₜ[M.1] (b ⊗ₜ[
              Pic0FiniteStageChartModelRing C L n m relation M U] 1)))) := rfl
    _ = (pic0FiniteStageTripleTensorEquiv C U V W).restrictScalars k
        (pic0FiniteStageTripleTensorComparison
          C L n m relation e M mapM hmapM U V W
          ((c ⊗ₜ[M.1] b) ⊗ₜ 1)) := by
            rw [AlgebraicJacobian.tensorProductPushoutBaseChange_tmul]
    _ = (pic0FiniteStageTripleTensorEquiv C U V W).restrictScalars k
        ((pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
            (Sum.inr (U, V)) (c ⊗ₜ[M.1] b)) ⊗ₜ[
          Pic0FiniteStageChartRing C U] 1) := by
            rw [(tensorPushoutAlgEquivCongr_faces
              kfUV kfUW
              (pic0FiniteStageRestrictionLeft C U V)
              (pic0FiniteStageRestrictionLeft C U W)
              (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
                (Sum.inl U))
              (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
                (Sum.inr (U, V)))
              (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
                (Sum.inr (U, W)))
              (pic0FiniteStageModelBaseChangeEquiv_restrictionLeft
                C L n m relation e M mapM hmapM U V)
              (pic0FiniteStageModelBaseChangeEquiv_restrictionLeft
                C L n m relation e M mapM hmapM U W)).1 (c ⊗ₜ[M.1] b)]
    _ = _ := pic0FiniteStageTripleTensorEquiv_tmul_one C U V W
      (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
        (Sum.inr (U, V)) (c ⊗ₜ[M.1] b))

set_option synthInstance.maxHeartbeats 400000 in
-- The face square contains all component and triple-model quotient instances.
set_option maxHeartbeats 3200000 in
-- The comparison composite is reduced through its three pure-tensor formulas.
/-- On the right face, the triple-model comparison is restriction from the second exact
overlap into the exact triple intersection. -/
theorem pic0FiniteStageTripleModelComparison_faceRight
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
    (U V W : Pic0FiniteStageChartIndex C)
    (b : Pic0FiniteStageOverlapModelRing C L n m relation M U W) :
    pic0FiniteStageTripleModelComparison C L n m relation e M mapM hmapM U V W
        ((1 : k) ⊗ₜ[M.1] ((1 :
          Pic0FiniteStageOverlapModelRing C L n m relation M U V) ⊗ₜ[
            Pic0FiniteStageChartModelRing C L n m relation M U] b)) =
      pic0FiniteStageOverlapToTripleRight C U V W
        (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
          (Sum.inr (U, W)) ((1 : k) ⊗ₜ[M.1] b)) := by
  let fUV := pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V
  let fUW := pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W
  let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k) fUV
  let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k) fUW
  letI := pic0FiniteStageAlgebraOfMap fUV
  letI := pic0FiniteStageAlgebraOfMap fUW
  letI := pic0FiniteStageTowerOfMap fUV
  letI := pic0FiniteStageTowerOfMap fUW
  letI := pic0FiniteStageAlgebraOfMap kfUV
  letI := pic0FiniteStageAlgebraOfMap kfUW
  letI := pic0FiniteStageTowerOfMap kfUV
  letI := pic0FiniteStageOverlapLeftAlgebra C U V
  letI := pic0FiniteStageOverlapLeftAlgebra C U W
  letI := pic0FiniteStageTripleLeftAlgebra C U V W
  letI := pic0FiniteStageTowerOfMap (pic0FiniteStageRestrictionLeft C U V)
  letI := pic0FiniteStageTowerOfMap (pic0FiniteStageRestrictionLeft C U W)
  letI := pic0FiniteStageTowerOfMap
    ((pic0FiniteStageOverlapToTripleLeft C U V W).comp
      (pic0FiniteStageRestrictionLeft C U V))
  calc
    _ = (pic0FiniteStageTripleTensorEquiv C U V W).restrictScalars k
        (pic0FiniteStageTripleTensorComparison
          C L n m relation e M mapM hmapM U V W
          (pic0FiniteStageTripleModelBaseChange
            C L n m relation M mapM U V W
            ((1 : k) ⊗ₜ[M.1] ((1 :
              Pic0FiniteStageOverlapModelRing C L n m relation M U V) ⊗ₜ[
                Pic0FiniteStageChartModelRing C L n m relation M U] b)))) := rfl
    _ = (pic0FiniteStageTripleTensorEquiv C U V W).restrictScalars k
        (pic0FiniteStageTripleTensorComparison
          C L n m relation e M mapM hmapM U V W
          ((1 : k ⊗[M.1]
            Pic0FiniteStageOverlapModelRing C L n m relation M U V) ⊗ₜ
              ((1 : k) ⊗ₜ[M.1] b))) := by
            rw [AlgebraicJacobian.tensorProductPushoutBaseChange_tmul]
            rfl
    _ = (pic0FiniteStageTripleTensorEquiv C U V W).restrictScalars k
        ((1 : Pic0FiniteStageOverlapRing C U V) ⊗ₜ[
          Pic0FiniteStageChartRing C U]
            pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
              (Sum.inr (U, W)) ((1 : k) ⊗ₜ[M.1] b)) := by
            rw [(tensorPushoutAlgEquivCongr_faces
              kfUV kfUW
              (pic0FiniteStageRestrictionLeft C U V)
              (pic0FiniteStageRestrictionLeft C U W)
              (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
                (Sum.inl U))
              (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
                (Sum.inr (U, V)))
              (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
                (Sum.inr (U, W)))
              (pic0FiniteStageModelBaseChangeEquiv_restrictionLeft
                C L n m relation e M mapM hmapM U V)
              (pic0FiniteStageModelBaseChangeEquiv_restrictionLeft
                C L n m relation e M mapM hmapM U W)).2 ((1 : k) ⊗ₜ[M.1] b)]
    _ = _ := pic0FiniteStageTripleTensorEquiv_one_tmul C U V W
      (pic0FiniteStageModelBaseChangeEquiv C L n m relation e M
        (Sum.inr (U, W)) ((1 : k) ⊗ₜ[M.1] b))

end

end AlgebraicGeometry
