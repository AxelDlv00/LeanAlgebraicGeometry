/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageRestrictionNaturality
import AlgebraicJacobian.Picard.Pic0FiniteStageRightRestrictionAlgHom

/-!
# Naturality of the right finite-stage Picard restriction

The scalar-extended right restriction descends to the exact right restriction
under the final chart and overlap comparisons.  Applying the affine base-change
comparison gives the corresponding scheme-level naturality square.
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

/-- The exact right restriction with its indexed source and target rings. -/
noncomputable def exactRightRestrictionAlgHom
    (U V : Pic0FiniteStageChartIndex C) :
    Pic0FiniteStageRing C (Sum.inl V) →ₐ[k]
      Pic0FiniteStageRing C (Sum.inr (U, V)) :=
  pic0FiniteStageMap C (Sum.inl (Sum.inr (U, V)))

set_option synthInstance.maxHeartbeats 3200000 in
-- Rewriting the dependent finite-stage maps unfolds the two scalar-extension towers.
set_option maxHeartbeats 12800000 in
/-- The final chart and overlap ring comparisons identify the scalar-extended
right restriction with the exact right restriction. -/
theorem rightRestrictionFinalBaseChangeEquiv_naturality
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (overlapFinalBaseChangeEquiv C P U V).toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := P.N.1) (K := k) (rightRestrictionBaseChangeAlgHom C P U V)) =
      (exactRightRestrictionAlgHom C U V).comp
        (chartFinalBaseChangeEquiv C P V).toAlgHom := by
  rw [rightRestrictionBaseChangeAlgHom_eq_direct C P U V]
  exact pic0FiniteStageFinalBaseChangeEquiv_naturality
    C P.L P.n P.m P.relation P.e P.M P.mapM P.hmapM P.N
      (Sum.inl (Sum.inr (U, V)))

set_option synthInstance.maxHeartbeats 3200000 in
-- The explicit pullback type fixes the package's dependent chart and overlap rings.
set_option maxHeartbeats 12800000 in
/-- Pullback of the scalar-extended right restriction from the forward overlap
to the right chart. -/
noncomputable def rightRestrictionBaseChangeMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    pullback
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageOverlapBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N U V))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ⟶
      pullback
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageChartBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N V))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) :=
  affineBaseChangeMap P.N.1 k
    (Pic0FiniteStageChartBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N V)
    (Pic0FiniteStageOverlapBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U V)
    (rightRestrictionBaseChangeAlgHom C P U V)

set_option synthInstance.maxHeartbeats 3200000 in
-- Specializing the generic affine square unfolds both final ring comparisons.
set_option maxHeartbeats 12800000 in
/-- Under the final chart and overlap comparisons, the pulled-back right
restriction is the exact right restriction of the separably closed atlas. -/
theorem rightRestrictionBaseChangeMap_naturality
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    rightRestrictionBaseChangeMap C P U V ≫
        (chartRingBaseChangeIso C P V).hom =
      (overlapRingBaseChangeIso C P U V).hom ≫
        Spec.map (CommRingCat.ofHom
          (exactRightRestrictionAlgHom C U V).toRingHom) := by
  exact affineBaseChangeIso_trans_naturality
    P.N.1 k
    (Pic0FiniteStageChartBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N V)
    (Pic0FiniteStageOverlapBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U V)
    (Pic0FiniteStageRing C (Sum.inl V))
    (Pic0FiniteStageRing C (Sum.inr (U, V)))
    (rightRestrictionBaseChangeAlgHom C P U V)
    (chartFinalBaseChangeEquiv C P V)
    (overlapFinalBaseChangeEquiv C P U V)
    (exactRightRestrictionAlgHom C U V)
    (rightRestrictionFinalBaseChangeEquiv_naturality C P U V)

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
