---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.thetaGluedSubmodule
docstring: '**The Θ-twisted glued colength module `W(d)^{Θᵃ}`** (worksheet §2.3 step
  2): the

  submodule of the product of chart-local colengths cut by the Θ-twisted matching
  on the

  overlap colengths, spelled as a kernel so the `FlatCokernel` base-change shapes
  apply.'
file: AlgebraicJacobian/Picard/DivisorFamilyTheta.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivisorAdaptation.thetaGluedSubmodule
type: lean
updated: '2026-07-30T15:27:59'
---
noncomputable def thetaGluedSubmodule : Submodule R A.chartProd :=
  LinearMap.ker (A.deltaLeft - A.thetaDeltaRight a)