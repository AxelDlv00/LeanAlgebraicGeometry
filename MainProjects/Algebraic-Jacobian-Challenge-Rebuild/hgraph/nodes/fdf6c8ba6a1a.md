---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.BasicOpenCoverData.hInf
docstring: The chart-0 generators, restricted to the overlap of the pinned charts.
file: AlgebraicJacobian/Cohomology/GluedSheafDatum.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCoverData.hInf
type: lean
updated: '2026-07-31T20:15:17'
---
noncomputable def hInf (j : D.J₀) :
    Γ(relCurve C B,
      (relCover C B (fiberTwoCover π)).V₀ ⊓ (relCover C B (fiberTwoCover π)).V₁) :=
  (relCurve C B).resHom inf_le_left (D.h₀ j)