---
author: sync
content_type: lemma
created: '2026-07-30T21:44:01'
decl: AlgebraicGeometry.AffAdaptation.intrinsicThetaGluedOverLift_apply
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaCech.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.intrinsicThetaGluedOverLift_apply
type: lean
updated: '2026-07-31T20:14:49'
---
lemma intrinsicThetaGluedOverLift_apply (a : ℕ)
    (f : ∀ j : D.index, M →ₗ[↥(gluedSubalgebra A)]
      A.ThetaPieceQuotient (π := π) a j)
    (hf : ∀ i j : D.index,
      A.thetaToOverlapLeftGlued (π := π) a i j ∘ₗ f i =
        A.thetaToOverlapRightGlued (π := π) a i j ∘ₗ f j)
    (x : M) (j : D.index) :
    (A.intrinsicThetaGluedOverLift (π := π) a f hf x :
      A.ThetaPieceProd (π := π) a) j = f j x := by
  rfl

set_option synthInstance.maxHeartbeats 200000 in
-- Comparing the two dependent-product linear maps needs the lift's instance-search budget.