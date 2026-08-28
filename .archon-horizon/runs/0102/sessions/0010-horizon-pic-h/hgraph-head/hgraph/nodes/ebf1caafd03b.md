---
author: sync
content_type: definition
created: '2026-07-28T17:25:25'
decl: AlgebraicGeometry.AffAdaptation.pulledEquations
docstring: '**The pulled local-equation system**, widened: `d` pulls back along the
  relative-curve

  comparison, with regularity discharged by the certificate''s colength projectivity.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.pulledEquations
type: lean
updated: '2026-08-01T09:44:13'
---
noncomputable def pulledEquations (hproj : ∀ j, Module.Projective R (A.colength j)) :
    (relCurve C R').LocalEquations :=
  d.pullback (relCurveMap C R R') (A.germ_pullbackEqn_mem_nonZeroDivisors R' hproj)

@[simp]