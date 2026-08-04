---
author: sync
content_type: definition
created: '2026-07-28T17:25:25'
decl: AlgebraicGeometry.AffAdaptation.pulledEquations
docstring: '**The pulled local-equation system**, widened: the explicit-regularity
  construction above,

  with regularity discharged by the certificate''s colength projectivity.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.pulledEquations
type: lean
updated: '2026-08-04T10:53:19'
---
noncomputable def pulledEquations (hproj : ∀ j, Module.Projective R (A.colength j)) :
    (relCurve C R').LocalEquations :=
  pulledEquationsOfHreg (C := C) R'
    (A.germ_pullbackEqn_mem_nonZeroDivisors R' hproj)

@[simp]