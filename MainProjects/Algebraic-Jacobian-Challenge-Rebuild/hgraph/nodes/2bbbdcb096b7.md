---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.thetaInvSpan
docstring: '`W(d)^{Θ⁻ᵃ}` (the inverse-twisted glued module) as an `A_D`-submodule.'
file: AlgebraicJacobian/Picard/DivisorFamilyThetaRank.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.thetaInvSpan
type: lean
updated: '2026-08-01T09:44:14'
---
noncomputable def thetaInvSpan : Submodule ↥A.gluedSubalgebra A.chartProd :=
  A.unitGluedOver (A.thetaOvlUnit a)⁻¹