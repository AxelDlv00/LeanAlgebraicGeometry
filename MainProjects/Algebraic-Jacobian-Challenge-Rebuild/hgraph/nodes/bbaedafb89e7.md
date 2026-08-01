---
author: sync
content_type: theorem
created: '2026-07-31T21:34:23'
decl: AlgebraicGeometry.AffAdaptation.IsCertified.finite_gluedSubalgebra
docstring: 'The equalizer algebra and the certified glued module have the same finite
  `R`-module

  carrier.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaFinite.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.IsCertified.finite_gluedSubalgebra
type: lean
updated: '2026-08-01T09:44:13'
---
theorem IsCertified.finite_gluedSubalgebra (hc : A.IsCertified g) :
    Module.Finite R ↥(gluedSubalgebra A) := by
  letI := AlgebraicGeometry.AffAdaptation.IsCertified.finite_glued hc
  exact Module.Finite.equiv A.gluedSubalgebraEquiv.symm