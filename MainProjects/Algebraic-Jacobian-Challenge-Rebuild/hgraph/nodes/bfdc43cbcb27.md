---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.thetaSpan
docstring: '`W(d)^{Θᵃ}` as an `A_D`-submodule of the chart product.'
file: AlgebraicJacobian/Picard/DivisorFamilyThetaRank.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivisorAdaptation.thetaSpan
type: lean
updated: '2026-07-29T15:26:33'
---
noncomputable def thetaSpan : Submodule ↥A.gluedSubalgebra A.chartProd :=
  A.unitGluedOver (A.thetaOvlUnit a)