---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.classDegFun_picClass
docstring: The degree function evaluates a divisor's own class to its degree.
file: AlgebraicJacobian/RiemannRoch/Degree.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.classDegFun_picClass
type: lean
updated: '2026-07-16T21:33:28'
---
private theorem classDegFun_picClass (D : X.CurveDivisor) :
    classDegFun K (CurveDivisor.picClass K D) = CurveDivisor.deg K D :=
  deg_eq_deg_of_picClass_eq K
    (picClass_classDegFun_choose K (CurveDivisor.picClass K D))