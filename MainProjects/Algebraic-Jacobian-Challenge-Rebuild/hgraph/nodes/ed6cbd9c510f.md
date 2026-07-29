---
author: sync
content_type: definition
created: '2026-07-29T09:42:53'
decl: AlgebraicGeometry.AffAdaptation.thetaInvSpan
docstring: The widened inverse-twisted glued module as an `A_D`-submodule.
file: AlgebraicJacobian/Picard/DivisorFamilyAffTheta.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.thetaInvSpan
type: lean
updated: '2026-07-29T15:26:38'
---
noncomputable def thetaInvSpan : Submodule ↥(gluedSubalgebra A) A.chartProd :=
  unitGluedOver A (thetaOvlUnit τ a)⁻¹