---
author: sync
content_type: definition
created: '2026-07-22T10:32:32'
decl: AlgebraicGeometry.thetaFieldPencilFstUnit
docstring: 'The rational reading of the canonical section `(t₀ᵃ,1)`, bundled as a

  function-field unit.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowPencilTheta.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.thetaFieldPencilFstUnit
type: lean
updated: '2026-07-29T15:31:40'
---
noncomputable def thetaFieldPencilFstUnit : (relCurve C K).functionFieldˣ :=
  Units.mk0 (thetaFieldRead C K π a (relThetaSectionFst C K π a))
    (thetaFieldRead_relThetaSectionFst_ne_zero C K π a)