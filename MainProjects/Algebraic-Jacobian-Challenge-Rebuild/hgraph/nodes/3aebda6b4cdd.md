---
author: sync
content_type: definition
created: '2026-07-24T17:02:46'
decl: AlgebraicGeometry.relFiberCoord₀
docstring: '**The relative chart-0 coordinate** `t₀ᴿ ∈ Γ(C_R, V₀ᴿ)`: the pullback
  of the

  pulled-back chart coordinate `t₀` along the first projection.'
file: AlgebraicJacobian/Cohomology/RigidEngine4Relative.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relFiberCoord₀
type: lean
updated: '2026-07-24T17:02:46'
---
noncomputable def relFiberCoord₀ [IsAffineHom π] :
    Γ(relCurve C R, (relCover C R (fiberTwoCover π)).V₀) :=
  relPullbackSection C R (fiberChart₀ π) (fiberCoord π)