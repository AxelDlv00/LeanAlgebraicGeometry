/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageRestrictionNaturality

/-!
# Naturality of the right finite-stage Picard restriction

The finite-stage model family contains the right restriction as its own indexed
map.  We first lift final base-change naturality to schemes for an arbitrary
family index, then specialize it to the right-restriction index.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

namespace Pic0FiniteStageGluePackage

set_option synthInstance.maxHeartbeats 3200000 in
-- Keeping the family index abstract preserves the canonical dependent instances.
set_option maxHeartbeats 12800000 in
/-- Scalar extension of an arbitrary map in the final finite-stage family. -/
noncomputable def indexedBaseChangeAlgHom
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (q : Pic0FiniteStageMapIndex C) :
    Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
        (Pic0FiniteStageMapSource C q) →ₐ[P.N.1]
      Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
        (Pic0FiniteStageMapTarget C q) :=
  AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := P.M.1) (K := P.N.1) (P.mapM q)

set_option synthInstance.maxHeartbeats 3200000 in
-- The abstract ring tag retains the model family's canonical instances.
set_option maxHeartbeats 12800000 in
/-- Scheme comparison between the base change of a final model ring and its
exact separably closed atlas ring. -/
noncomputable def indexedRingBaseChangeIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (j : Pic0FiniteStageRingIndex C) :
    pullback
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageFinalModelRing
              C P.L P.n P.m P.relation P.M P.N j))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≅
      Spec (.of (Pic0FiniteStageRing C j)) :=
  affineBaseChangeIso P.N.1 k
      (Pic0FiniteStageFinalModelRing
        C P.L P.n P.m P.relation P.M P.N j) ≪≫
    Scheme.Spec.mapIso
      (pic0FiniteStageFinalBaseChangeEquiv
        C P.L P.n P.m P.relation P.e P.M P.N j).symm.toRingEquiv.toCommRingCatIso.op

set_option synthInstance.maxHeartbeats 3200000 in
-- The abstract map index fixes both dependent model-ring instances at once.
set_option maxHeartbeats 12800000 in
/-- Pullback of an arbitrary directly descended finite-stage map. -/
noncomputable def indexedBaseChangeMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (q : Pic0FiniteStageMapIndex C) :
    pullback
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
              (Pic0FiniteStageMapTarget C q)))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ⟶
      pullback
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
              (Pic0FiniteStageMapSource C q)))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) :=
  affineBaseChangeMap P.N.1 k
    (Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
      (Pic0FiniteStageMapSource C q))
    (Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
      (Pic0FiniteStageMapTarget C q))
    (indexedBaseChangeAlgHom C P q)

set_option synthInstance.maxHeartbeats 3200000 in
-- This is the scheme-level form of the final ring naturality square.
set_option maxHeartbeats 12800000 in
/-- Every directly descended finite-stage map becomes its exact atlas map after
base change to the separably closed field. -/
theorem indexedBaseChangeMap_naturality
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (q : Pic0FiniteStageMapIndex C) :
    indexedBaseChangeMap C P q ≫
        (indexedRingBaseChangeIso C P
          (Pic0FiniteStageMapSource C q)).hom =
      (indexedRingBaseChangeIso C P
          (Pic0FiniteStageMapTarget C q)).hom ≫
        Spec.map (CommRingCat.ofHom (pic0FiniteStageMap C q).toRingHom) := by
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  apply affineBaseChangeIso_trans_naturality
    P.N.1 k
    (Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
      (Pic0FiniteStageMapSource C q))
    (Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
      (Pic0FiniteStageMapTarget C q))
    (Pic0FiniteStageRing C (Pic0FiniteStageMapSource C q))
    (Pic0FiniteStageRing C (Pic0FiniteStageMapTarget C q))
    (indexedBaseChangeAlgHom C P q)
    (pic0FiniteStageFinalBaseChangeEquiv C P.L P.n P.m P.relation P.e P.M P.N
      (Pic0FiniteStageMapSource C q))
    (pic0FiniteStageFinalBaseChangeEquiv C P.L P.n P.m P.relation P.e P.M P.N
      (Pic0FiniteStageMapTarget C q))
    (pic0FiniteStageMap C q)
  exact pic0FiniteStageFinalBaseChangeEquiv_naturality
    C P.L P.n P.m P.relation P.e P.M P.mapM P.hmapM P.N q

/-- Pullback of the directly descended right restriction. -/
noncomputable def rightRestrictionBaseChangeMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U V : Pic0FiniteStageChartIndex C) :=
  indexedBaseChangeMap C P (Sum.inl (Sum.inr (U, V)))

/-- The scheme naturality square for the directly descended right restriction. -/
theorem rightRestrictionBaseChangeMap_naturality
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U V : Pic0FiniteStageChartIndex C) :
    rightRestrictionBaseChangeMap C P U V ≫
        (indexedRingBaseChangeIso C P
          (Pic0FiniteStageMapSource C (Sum.inl (Sum.inr (U, V))))).hom =
      (indexedRingBaseChangeIso C P
        (Pic0FiniteStageMapTarget C (Sum.inl (Sum.inr (U, V))))).hom ≫
        Spec.map (CommRingCat.ofHom
          (pic0FiniteStageMap C (Sum.inl (Sum.inr (U, V)))).toRingHom) := by
  simpa only [rightRestrictionBaseChangeMap] using
    indexedBaseChangeMap_naturality C P (Sum.inl (Sum.inr (U, V)))

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
