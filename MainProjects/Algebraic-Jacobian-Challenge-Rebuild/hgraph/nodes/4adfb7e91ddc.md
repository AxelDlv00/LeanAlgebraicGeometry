---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.classDeg_divisorClass
docstring: '**Compatibility with `divisorClass`**: the deg-D1 divisor class map has
  the same degree,

  `classDeg (divisorClass K D) = deg D`, via the collapse `divisorClass_eq_picClass`.'
file: AlgebraicJacobian/RiemannRoch/Degree.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.classDeg_divisorClass
type: lean
updated: '2026-07-29T15:26:19'
---
theorem classDeg_divisorClass (D : X.CurveDivisor) :
    classDeg K (divisorClass K D) = CurveDivisor.deg K D := by
  rw [divisorClass_eq_picClass, classDeg_picClass]

end AlgebraicGeometry

/-! ## The curve layer -/

namespace AlgebraicGeometry

open Scheme

section Curve

variable {k : Type u} [Field k]