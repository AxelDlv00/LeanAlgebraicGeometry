/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageGlueDataAssembly
import AlgebraicJacobian.Picard.Pic0FiniteStageTransitionModels
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleTransitionModels
import AlgebraicJacobian.Descent.GluedMapData

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

-- Rebuild a model map against the canonical `CommRing` semiring instances before
-- passing it to `CommRingCat.ofHom`; the `AlgHom` producer carries a tensor-product
-- semiring instance that is propositionally equal but not definitionally identical.
noncomputable def pic0FiniteStageModelMapToRingHom
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C → Nat)
    (relation : ∀ j, Fin (m j) → MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (mapM : forall q : Pic0FiniteStageMapIndex C,
      Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapSource C q) →ₐ[M.1]
        Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapTarget C q))
    (q : Pic0FiniteStageMapIndex C) :
    CommRingCat.of
        (Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapSource C q)) ⟶
      CommRingCat.of
        (Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapTarget C q)) := by
  letI : Semiring
      (Pic0FiniteStageModelRing C L n m relation M
        (Pic0FiniteStageMapSource C q)) :=
    (inferInstance : CommRing
      (Pic0FiniteStageModelRing C L n m relation M
        (Pic0FiniteStageMapSource C q))).toSemiring
  letI : Semiring
      (Pic0FiniteStageModelRing C L n m relation M
        (Pic0FiniteStageMapTarget C q)) :=
    (inferInstance : CommRing
      (Pic0FiniteStageModelRing C L n m relation M
        (Pic0FiniteStageMapTarget C q))).toSemiring
  exact CommRingCat.ofHom (mapM q).toRingHom

set_option synthInstance.maxHeartbeats 400000 in
-- Name the dependent triple-map carrier once to avoid repeated tower synthesis.
set_option maxHeartbeats 12800000 in
abbrev Pic0FiniteStageTripleTransitionModelAlgHom
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C → Nat)
    (relation : ∀ j, Fin (m j) → MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (mapM : ∀ q : Pic0FiniteStageMapIndex C,
      Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapSource C q) →ₐ[M.1]
        Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapTarget C q))
    (N : DatG0.FinSubext M.1 k)
    (p : Pic0FiniteStageTripleTransitionIndex C) : Type u :=
  N.1 ⊗[M.1] Pic0FiniteStageTripleTransitionModelSource
      C L n m relation M mapM p →ₐ[N.1]
    N.1 ⊗[M.1] Pic0FiniteStageTripleTransitionModelTarget
      C L n m relation M mapM p

set_option synthInstance.maxHeartbeats 400000 in
-- Name the comparison proposition once so the package field elaborates at a stable boundary.
set_option maxHeartbeats 12800000 in
abbrev Pic0FiniteStageTripleTransitionModelComparison
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C → Nat)
    (relation : ∀ j, Fin (m j) → MvPolynomial (Fin (n j)) L.1)
    (e : ∀ j,
      k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
        Pic0FiniteStageRing C j)
    (M : DatG0.FinSubext L.1 k)
    (mapM : ∀ q : Pic0FiniteStageMapIndex C,
      Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapSource C q) →ₐ[M.1]
        Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapTarget C q))
    (hmapM : ∀ q,
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
    (thetaN : ∀ p : Pic0FiniteStageTripleTransitionIndex C,
      Pic0FiniteStageTripleTransitionModelAlgHom
        C L n m relation M mapM N p)
    (p : Pic0FiniteStageTripleTransitionIndex C) : Prop :=
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
      (Spec.map
        (pic0FiniteStageModelMapToRingHom C L n m relation M mapM (Sum.inl i)))
  N : DatG0.FinSubext M.1 k
  thetaN : forall p : Pic0FiniteStageTripleTransitionIndex C,
    Pic0FiniteStageTripleTransitionModelAlgHom
      C L n m relation M mapM N p
  hthetaN : forall p : Pic0FiniteStageTripleTransitionIndex C,
    Pic0FiniteStageTripleTransitionModelComparison
      C L n m relation e M mapM hmapM N thetaN p

namespace Pic0FiniteStageGluePackage

set_option synthInstance.maxHeartbeats 400000 in
set_option maxHeartbeats 3200000 in
-- The raw overlap tensor needs the model's canonical left algebra before its ring
-- instance can be reconstructed.  Naming that instance keeps downstream `ofHom`
-- statements independent of whichever tensor-product semiring was used to build a map.
@[reducible]
noncomputable instance pic0FiniteStageOverlapBaseChangeRingCommRing
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (U V : Pic0FiniteStageChartIndex C) :
    CommRing (Pic0FiniteStageOverlapBaseChangeRing C L n m relation M N U V) := by
  letI : Algebra M.1 (Pic0FiniteStageOverlapModelRing C L n m relation M U V) :=
    Algebra.TensorProduct.leftAlgebra
      (R := L.1) (S := M.1) (A := M.1)
      (B := DatG0.FiniteRelationAlgebra L.1
        (n (Sum.inr (U, V))) (m (Sum.inr (U, V)))
        (relation (Sum.inr (U, V))))
  letI : CommRing (Pic0FiniteStageOverlapModelRing C L n m relation M U V) := inferInstance
  letI : CommSemiring (Pic0FiniteStageOverlapModelRing C L n m relation M U V) :=
    (inferInstance : CommRing (Pic0FiniteStageOverlapModelRing C L n m relation M U V)).toCommSemiring
  dsimp only [Pic0FiniteStageOverlapBaseChangeRing]
  exact Algebra.TensorProduct.instCommRing

set_option synthInstance.maxHeartbeats 400000 in
set_option maxHeartbeats 3200000 in
-- The scalar map into the overlap uses the same canonical tensor carrier as its ring.
@[reducible]
noncomputable instance pic0FiniteStageOverlapBaseChangeRingAlgebra
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (U V : Pic0FiniteStageChartIndex C) :
    Algebra N.1 (Pic0FiniteStageOverlapBaseChangeRing C L n m relation M N U V) := by
  letI : Algebra M.1 (Pic0FiniteStageOverlapModelRing C L n m relation M U V) :=
    Algebra.TensorProduct.leftAlgebra
      (R := L.1) (S := M.1) (A := M.1)
      (B := DatG0.FiniteRelationAlgebra L.1
        (n (Sum.inr (U, V))) (m (Sum.inr (U, V)))
        (relation (Sum.inr (U, V))))
  dsimp only [Pic0FiniteStageOverlapBaseChangeRing]
  exact Algebra.TensorProduct.leftAlgebra
    (R := M.1) (S := N.1) (A := N.1)
    (B := Pic0FiniteStageOverlapModelRing C L n m relation M U V)

-- Package projections occur behind local aliases in `gluedMap`.  This specialized
-- wrapper gives instance search a single package parameter to unify there, while the
-- generic carrier instance above remains available to the lower-level atlas modules.
@[reducible]
noncomputable instance (priority := 100)
    pic0FiniteStageGluePackageOverlapBaseChangeRingCommRing
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    CommRing
      (Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V) :=
  pic0FiniteStageOverlapBaseChangeRingCommRing
    C P.L P.n P.m P.relation P.M P.N U V

@[reducible]
noncomputable instance (priority := 100)
    pic0FiniteStageGluePackageOverlapBaseChangeRingAlgebra
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    Algebra P.N.1
      (Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V) :=
  pic0FiniteStageOverlapBaseChangeRingAlgebra
    C P.L P.n P.m P.relation P.M P.N U V

-- Expose the chart base-change carrier before package projections and downstream
-- restriction maps elaborate their dependent `AlgHom` parameters.
@[reducible]
noncomputable instance pic0FiniteStageChartBaseChangeRingCommRing
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C → Nat)
    (relation : forall j, Fin (m j) → MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (U : Pic0FiniteStageChartIndex C) :
    CommRing (Pic0FiniteStageChartBaseChangeRing C L n m relation M N U) := by
  letI : Algebra M.1
      (Pic0FiniteStageChartModelRing C L n m relation M U) :=
    Algebra.TensorProduct.leftAlgebra
      (R := L.1) (S := M.1) (A := M.1)
      (B := DatG0.FiniteRelationAlgebra L.1
        (n (Sum.inl U)) (m (Sum.inl U)) (relation (Sum.inl U)))
  letI : CommRing
      (Pic0FiniteStageChartModelRing C L n m relation M U) := inferInstance
  letI : CommSemiring
      (Pic0FiniteStageChartModelRing C L n m relation M U) :=
    (inferInstance : CommRing
      (Pic0FiniteStageChartModelRing C L n m relation M U)).toCommSemiring
  dsimp only [Pic0FiniteStageChartBaseChangeRing]
  exact Algebra.TensorProduct.instCommRing

@[reducible]
noncomputable instance pic0FiniteStageChartBaseChangeRingAlgebra
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C → Nat)
    (relation : forall j, Fin (m j) → MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (U : Pic0FiniteStageChartIndex C) :
    Algebra N.1 (Pic0FiniteStageChartBaseChangeRing C L n m relation M N U) := by
  letI : Algebra M.1
      (Pic0FiniteStageChartModelRing C L n m relation M U) :=
    Algebra.TensorProduct.leftAlgebra
      (R := L.1) (S := M.1) (A := M.1)
      (B := DatG0.FiniteRelationAlgebra L.1
        (n (Sum.inl U)) (m (Sum.inl U)) (relation (Sum.inl U)))
  dsimp only [Pic0FiniteStageChartBaseChangeRing]
  exact Algebra.TensorProduct.leftAlgebra
    (R := M.1) (S := N.1) (A := N.1)
    (B := Pic0FiniteStageChartModelRing C L n m relation M U)

set_option maxHeartbeats 25600000 in
-- The package projections retain the dependent tensor-product instances of the constructor.
/-- The scheme glue datum computed from an inhabited finite-stage package. -/
noncomputable def glueData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) : Scheme.GlueData := by
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  refine pic0FiniteStageAffineRingGlueData
    C P.L P.n P.m P.relation P.M P.mapM P.N
      P.e P.hmapM ?_ P.thetaN P.hthetaN
  intro i
  letI : Semiring
      (Pic0FiniteStageModelRing C P.L P.n P.m P.relation P.M
        (Pic0FiniteStageMapSource C (Sum.inl i))) :=
    (inferInstance : CommRing
      (Pic0FiniteStageModelRing C P.L P.n P.m P.relation P.M
        (Pic0FiniteStageMapSource C (Sum.inl i)))).toSemiring
  letI : Semiring
      (Pic0FiniteStageModelRing C P.L P.n P.m P.relation P.M
        (Pic0FiniteStageMapTarget C (Sum.inl i))) :=
    (inferInstance : CommRing
      (Pic0FiniteStageModelRing C P.L P.n P.m P.relation P.M
        (Pic0FiniteStageMapTarget C (Sum.inl i)))).toSemiring
  simpa only [pic0FiniteStageModelMapToRingHom] using P.hOpen i

set_option linter.style.setOption false
set_option synthInstance.maxHeartbeats 3200000 in
-- Construct the glued structure map in the same instance scope as the glue datum.  Keeping
-- this producer here means downstream files project one map package instead of rebuilding
-- the chart algebras and the multicoequalizer compatibility proof.
set_option maxHeartbeats 12800000 in
noncomputable def canonicalGluedMapData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    AlgebraicJacobian.GluedMapData P.glueData (Spec (.of P.N.1)) := by
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  let A : Pic0FiniteStageChartIndex C -> Type u := fun U =>
    Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U
  let B : Pic0FiniteStageChartIndex C -> Pic0FiniteStageChartIndex C -> Type u :=
    fun U V =>
      Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V
  letI : ∀ U, Algebra P.M.1
      (Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U) := fun U =>
    by
      dsimp only [Pic0FiniteStageChartModelRing, Pic0FiniteStageModelRing]
      exact Algebra.TensorProduct.leftAlgebra
        (R := P.L.1) (S := P.M.1) (A := P.M.1)
        (B := DatG0.FiniteRelationAlgebra P.L.1
          (P.n (Sum.inl U)) (P.m (Sum.inl U))
          (P.relation (Sum.inl U)))
  letI : ∀ U, CommRing
      (Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U) :=
    fun U => by
      letI : CommRing
          (Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U) := inferInstance
      letI : CommSemiring
          (Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U) :=
        (inferInstance : CommRing
          (Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U)).toCommSemiring
      dsimp only [Pic0FiniteStageChartBaseChangeRing]
      exact Algebra.TensorProduct.instCommRing
  letI : ∀ U, Algebra P.N.1
      (Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U) :=
    fun U => by
      letI : Algebra P.M.1
          (Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U) :=
        Algebra.TensorProduct.leftAlgebra
          (R := P.L.1) (S := P.M.1) (A := P.M.1)
          (B := DatG0.FiniteRelationAlgebra P.L.1
            (P.n (Sum.inl U)) (P.m (Sum.inl U))
            (P.relation (Sum.inl U)))
      letI : CommRing
          (Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U) := inferInstance
      letI : CommSemiring
          (Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U) :=
        (inferInstance : CommRing
          (Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U)).toCommSemiring
      dsimp only [Pic0FiniteStageChartBaseChangeRing]
      exact Algebra.TensorProduct.leftAlgebra
        (R := P.M.1) (S := P.N.1) (A := P.N.1)
        (B := Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U)
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
  refine AlgebraicJacobian.GluedMapData.ofChartMaps ?_ ?_
  · intro U
    change Pic0FiniteStageChartIndex C at U
    exact Spec.map (CommRingCat.ofHom (algebraMap P.N.1 (A U)))
  · intro U V
    change Pic0FiniteStageChartIndex C at U V
    change
      Spec.map (CommRingCat.ofHom (algebraMap (A U) (B U V))) ≫
          Spec.map (CommRingCat.ofHom (algebraMap P.N.1 (A U))) =
        (Spec.map (CommRingCat.ofHom (tau U V).toRingHom) ≫
          Spec.map (CommRingCat.ofHom (algebraMap (A V) (B V U)))) ≫
            Spec.map (CommRingCat.ofHom (algebraMap P.N.1 (A V)))
    rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
    rw [Category.assoc, ← Spec.map_comp, ← CommRingCat.ofHom_comp]
    rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
    congr 1
    ext x
    simp only [CommRingCat.ofHom_comp, CommRingCat.hom_comp,
      ConcreteCategory.hom_ofHom, RingHom.coe_comp, Function.comp_apply,
      AlgHom.toRingHom_eq_coe, Category.assoc, RingHom.coe_coe]
    rw [← IsScalarTower.algebraMap_apply P.N.1 (A U) (B U V)]
    rw [← IsScalarTower.algebraMap_apply P.N.1 (A V) (B V U)]
    exact (tau U V).commutes x |>.symm

end Pic0FiniteStageGluePackage

set_option synthInstance.maxHeartbeats 400000 in
-- Selecting both finite families exposes many dependent quotient-algebra instances.
set_option maxHeartbeats 12800000 in
/-- The simultaneous finite-stage descent producers inhabit the glue package. -/
theorem exists_pic0FiniteStageGluePackage
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k] :
    Nonempty (Pic0FiniteStageGluePackage C F) := by
  classical
  obtain ⟨L, n, m, relation, e, M, mapM, hmapM, hOpenOld, _⟩ :=
    exists_finSubext_pic0FiniteStageTransition_models (C := C) (F := F)
  letI : Algebra.IsAlgebraic L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic M.1 k := by infer_instance
  let Q := pic0FiniteStageTripleModelComparisonFamily
    C L n m relation e M mapM hmapM
  obtain ⟨N, hN⟩ :=
    exists_finSubext_pic0FiniteStageTripleTransition_models_of_comparisons
      C L n m relation M mapM Q
  choose thetaN hthetaN using hN
  have hOpen' :
      ∀ i : Pic0FiniteStageRestrictionIndex C,
        IsOpenImmersion
          (Spec.map
            (pic0FiniteStageModelMapToRingHom C L n m relation M mapM (Sum.inl i))) := by
    intro i
    simpa only [pic0FiniteStageModelMapToRingHom] using hOpenOld i
  have hthetaN' :
      ∀ p : Pic0FiniteStageTripleTransitionIndex C,
        Pic0FiniteStageTripleTransitionModelComparison
          C L n m relation e M mapM hmapM N thetaN p := by
    intro p
    simpa only [Pic0FiniteStageTripleTransitionModelComparison, Q,
      pic0FiniteStageTransportedTripleTransitionOfModels] using
      hthetaN p
  exact ⟨{
    L := L
    n := n
    m := m
    relation := relation
    e := e
    M := M
    mapM := mapM
    hmapM := hmapM
    hOpen := hOpen'
    N := N
    thetaN := thetaN
    hthetaN := hthetaN'
  }⟩

end

end AlgebraicGeometry
