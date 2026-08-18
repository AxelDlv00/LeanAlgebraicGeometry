---
author: sync
content_type: definition
created: '2026-08-18T08:27:19'
decl: AlgebraicGeometry.Pic0FiniteStageGluePackage.overlapFinalBaseChangeEquiv
docstring: 'Final scalar-extension comparison for an overlap, with an indexed

  exact-ring target.'
file: AlgebraicJacobian/Picard/Pic0FiniteStageRestrictionBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Pic0FiniteStageGluePackage.overlapFinalBaseChangeEquiv
type: lean
updated: '2026-08-18T20:51:05'
---
noncomputable def overlapFinalBaseChangeEquiv
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    k ⊗[P.N.1]
        Pic0FiniteStageOverlapBaseChangeRing
          C P.L P.n P.m P.relation P.M P.N U V ≃ₐ[k]
      Pic0FiniteStageRing C (Sum.inr (U, V)) :=
  pic0FiniteStageFinalBaseChangeEquiv
    C P.L P.n P.m P.relation P.e P.M P.N (Sum.inr (U, V))

set_option synthInstance.maxHeartbeats 3200000 in
-- Specializing the generic pullback map infers both scalar-extended model rings.
set_option maxHeartbeats 12800000 in