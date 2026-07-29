---
author: sync
content_type: definition
created: '2026-07-17T16:57:12'
decl: AlgebraicGeometry.twistCollapseDom
docstring: 'The product of the two chart collapses, as a `k`-linear map of the domains
  of the two

  Čech differentials.'
file: AlgebraicJacobian/Cohomology/RelThetaTransportCore.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.twistCollapseDom
type: lean
updated: '2026-07-29T15:26:30'
---
noncomputable def twistCollapseDom :
    (↥(twistSubmodule k (fiberChart₀ π) (fiberChart₁ π) (thetaUnit π ^ n)
          (fiberChart₀ π)) ×
        ↥(twistSubmodule k (fiberChart₀ π) (fiberChart₁ π) (thetaUnit π ^ n)
          (fiberChart₁ π))) →ₗ[k]
      (↥(twistSubmodule k (relCover C k (fiberTwoCover π)).V₀
            (relCover C k (fiberTwoCover π)).V₁ (relThetaCocycle C k π n)
            (relCover C k (fiberTwoCover π)).V₀) ×
        ↥(twistSubmodule k (relCover C k (fiberTwoCover π)).V₀
            (relCover C k (fiberTwoCover π)).V₁ (relThetaCocycle C k π n)
            (relCover C k (fiberTwoCover π)).V₁)) :=
  (twistCollapse₀ C π n).toLinearMap.prodMap (twistCollapse₁ C π n).toLinearMap