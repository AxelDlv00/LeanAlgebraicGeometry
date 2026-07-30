---
author: sync
content_type: definition
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.BasicOpenCoverData.overlapMap
docstring: '**The overlap comparison map**: sections on a double overlap of pieces
  compare to

  sections on the double overlap of the base-changed pieces, through `appLE` of the

  relative-curve comparison.'
file: AlgebraicJacobian/Cohomology/GluedSheafDatumBaseChange.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.BasicOpenCoverData.overlapMap
type: lean
updated: '2026-07-30T15:28:05'
---
noncomputable def overlapMap (i j : D.index) :
    Γ(relCurve C B, D.pieces i ⊓ D.pieces j) →+*
      Γ(relCurve C B', (D.baseChange B').pieces i ⊓ (D.baseChange B').pieces j) :=
  ((relCurveMap C B B').appLE (D.pieces i ⊓ D.pieces j)
    ((D.baseChange B').pieces i ⊓ (D.baseChange B').pieces j)
    (D.baseChange_inf_le_preimage B' i j)).hom

end BasicOpenCoverData

namespace BasicOpenCocycleDatum

variable (D : BasicOpenCocycleDatum C B π)