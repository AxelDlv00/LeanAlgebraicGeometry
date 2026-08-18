/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageAffineBaseChangeTrans
import AlgebraicJacobian.Picard.Pic0FiniteStageRestrictionBaseChange

/-!
# Naturality of finite-stage Picard restrictions after base change

The affine base-change comparison and the final finite-stage ring comparison
identify the pulled-back left restriction with the exact left restriction in
the separably closed Picard atlas.
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
-- Specialization unfolds the package's dependent finite-subextension towers.
set_option maxHeartbeats 12800000 in
/-- Under the final chart and overlap comparisons, the pulled-back left
restriction is the exact left restriction of the separably closed atlas. -/
theorem restrictionBaseChangeMap_naturality
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    restrictionBaseChangeMap C P U V ≫
        (chartRingBaseChangeIso C P U).hom =
      (overlapRingBaseChangeIso C P U V).hom ≫
        Spec.map (CommRingCat.ofHom
          (exactRestrictionAlgHom C U V).toRingHom) := by
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  apply affineBaseChangeIso_trans_naturality
    P.N.1 k
    (P.N.1 ⊗[P.M.1]
      Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U)
    (P.N.1 ⊗[P.M.1]
      Pic0FiniteStageOverlapModelRing C P.L P.n P.m P.relation P.M U V)
    (Pic0FiniteStageRing C (Sum.inl U))
    (Pic0FiniteStageRing C (Sum.inr (U, V)))
    (restrictionBaseChangeAlgHom C P U V)
    (chartFinalBaseChangeEquiv C P U)
    (overlapFinalBaseChangeEquiv C P U V)
    (exactRestrictionAlgHom C U V)
  exact pic0FiniteStageFinalBaseChangeEquiv_naturality
    C P.L P.n P.m P.relation P.e P.M P.mapM P.hmapM P.N
      (Sum.inl (Sum.inl (U, V)))

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
