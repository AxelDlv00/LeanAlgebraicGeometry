---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.relFiberCoordOnePow
docstring: The relative chart-1 coordinate power `t₁ᵃ` on the pinned chart `V₁ᴿ`.
file: AlgebraicJacobian/Picard/DivisorFamilyThetaSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relFiberCoordOnePow
type: lean
updated: '2026-07-29T15:31:45'
---
noncomputable def relFiberCoordOnePow :
    Γ(relCurve C R, (relCover C R (fiberTwoCover π)).V₁) :=
  ((fst C (overSpec k R)).left.appLE (fiberChart₁ π)
    ((relCover C R (fiberTwoCover π)).V₁) le_rfl).hom (fiberCoord₁ π ^ a)