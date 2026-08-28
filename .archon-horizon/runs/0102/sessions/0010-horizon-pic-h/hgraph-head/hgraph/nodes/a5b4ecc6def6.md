---
author: sync
content_type: theorem
created: '2026-08-01T10:43:32'
decl: AlgebraicGeometry.AffAdaptation.thetaPieceProdBaseChangeToOverlapEquiv_coaction
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaCoaction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.thetaPieceProdBaseChangeToOverlapEquiv_coaction
type: lean
updated: '2026-08-01T10:43:32'
---
theorem thetaPieceProdBaseChangeToOverlapEquiv_coaction {n : ℕ}
    (hc : A.IsCertified n) (s : A.ThetaPieceProd (π := π) a) :
    A.thetaPieceProdBaseChangeToOverlapEquiv (π := π) a hc
        (A.thetaDescentCoaction (π := π) a hc s) =
      A.thetaIntrinsicDeltaLeftCP (π := π) a s := by
  simp [thetaDescentCoaction]

@[simp]