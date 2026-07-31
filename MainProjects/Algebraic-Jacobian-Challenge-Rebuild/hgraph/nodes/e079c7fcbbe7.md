---
author: sync
content_type: theorem
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.projective_pulledColength
docstring: '(c1) transport, projectivity: the pulled colengths are projective over
  `R''`.'
file: AlgebraicJacobian/Picard/DivisorFamilyPullbackCert.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivisorAdaptation.projective_pulledColength
type: lean
updated: '2026-07-31T20:14:51'
---
theorem projective_pulledColength (hproj : ∀ j, Module.Projective R (A.colength j))
    (j : A.index) :
    Module.Projective R' (A.pulledColength R' j) := by
  haveI := hproj j
  exact Module.Projective.of_equiv (A.colengthBaseChange R' j).toLinearEquiv

/-! ## The overlap colength transport -/