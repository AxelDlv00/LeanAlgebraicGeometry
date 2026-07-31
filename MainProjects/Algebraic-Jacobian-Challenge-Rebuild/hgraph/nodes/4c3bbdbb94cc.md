---
author: sync
content_type: definition
created: '2026-07-30T21:44:01'
decl: AlgebraicGeometry.AffAdaptation.thetaIntrinsicDeltaLeftGlued
docstring: The left arrow of the intrinsic theta descent fork in `A_D`-modules.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaCech.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.thetaIntrinsicDeltaLeftGlued
type: lean
updated: '2026-07-31T20:14:43'
---
noncomputable def thetaIntrinsicDeltaLeftGlued (A : AffAdaptation D d) (a : ℕ) :
    A.ThetaPieceProd (π := π) a →ₗ[↥(gluedSubalgebra A)]
      A.ThetaOverlapProd (π := π) a :=
  LinearMap.pi (fun p : D.index × D.index =>
    A.thetaToOverlapLeftGlued (π := π) a p.1 p.2 ∘ₗ LinearMap.proj p.1)