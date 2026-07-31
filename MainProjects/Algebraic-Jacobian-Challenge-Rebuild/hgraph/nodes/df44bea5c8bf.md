---
author: sync
content_type: definition
created: '2026-07-30T23:41:24'
decl: AlgebraicGeometry.AffAdaptation.intrinsicWindowCarve
docstring: The high-window sections evaluated in the intrinsic, chart-free theta restriction.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaKernelGlobal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.intrinsicWindowCarve
type: lean
updated: '2026-07-31T20:15:24'
---
noncomputable def intrinsicWindowCarve (A : AffAdaptation D d) (a : ℕ)
    (hH1 : Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1) :
    R ⊗[k] ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤) →ₗ[R]
      A.IntrinsicThetaGlued (π := π) a :=
  (A.intrinsicThetaEvalRel (π := π) a).comp
    (relThetaWindowEquiv C R π a hH1).toLinearMap