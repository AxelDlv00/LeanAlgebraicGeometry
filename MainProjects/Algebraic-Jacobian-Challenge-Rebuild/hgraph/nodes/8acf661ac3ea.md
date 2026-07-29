---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.classDeg_picClass
docstring: '**(E-i) Normalization** (the definitional anchor): the degree of the class
  `𝒪(D)` of a

  Weil divisor `D` is `deg D`, for *every* `D`.'
file: AlgebraicJacobian/RiemannRoch/Degree.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.classDeg_picClass
type: lean
updated: '2026-07-29T15:31:49'
---
theorem classDeg_picClass (D : X.CurveDivisor) :
    classDeg K (CurveDivisor.picClass K D) = CurveDivisor.deg K D :=
  classDegFun_picClass K D