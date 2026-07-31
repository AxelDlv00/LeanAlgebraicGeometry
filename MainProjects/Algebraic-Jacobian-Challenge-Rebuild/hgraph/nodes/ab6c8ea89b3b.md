---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.picClassHom
docstring: 'The anchored `CurveDivisor.picClass` packaged as an additive-to-multiplicative

  homomorphism.'
file: AlgebraicJacobian/Picard/DivisorClassCompat.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.picClassHom
type: lean
updated: '2026-07-31T20:15:23'
---
noncomputable def picClassHom : X.CurveDivisor →+ Additive X.CechPic where
  toFun D := Additive.ofMul (CurveDivisor.picClass K D)
  map_zero' := by rw [CurveDivisor.picClass_zero]; rfl
  map_add' D D' := by rw [CurveDivisor.picClass_add]; rfl