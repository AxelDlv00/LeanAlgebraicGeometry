---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.P1.overlapRingEquiv_awayToOverlapLeft
file: AlgebraicJacobian/Curve/P1Charts.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.overlapRingEquiv_awayToOverlapLeft
type: lean
updated: '2026-08-01T09:44:10'
---
theorem overlapRingEquiv_awayToOverlapLeft (z : Away 𝒜 (X 0)) :
    overlapRingEquiv k (awayToOverlapLeft k z) =
      Polynomial.toLaurent (awayAlgEquiv k fin_zero_ne_one z) := by
  rw [← LaurentPolynomial.algebraMap_eq_toLaurent]
  exact IsLocalization.ringEquivOfRingEquiv_eq _ _