---
author: sync
content_type: instance
created: '2026-07-27T17:35:58'
decl: AlgebraicGeometry.Adelic.instIsDomainAwayP1
docstring: '**The chart ring of `ℙ¹` over a domain is a domain**, being a polynomial
  ring.'
file: AlgebraicJacobian/Picard/RigidPushforwardP1ChartRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.instIsDomainAwayP1
type: lean
updated: '2026-07-27T17:35:58'
---
instance instIsDomainAwayP1 [IsDomain R] (i : ULift.{u} (Fin 2)) :
    IsDomain (Away (homogeneousSubmodule (ULift.{u} (Fin 2)) R) (X i)) := by
  obtain ⟨j, hij⟩ := exists_ne_index i
  exact Function.Injective.isDomain (p1AwayAlgEquiv R hij).toRingEquiv.toRingHom
    (p1AwayAlgEquiv R hij).injective

end ChartRing

/-! ## The integral model `R = ULift ℤ`

The base of the integral model of `ℙ¹` used throughout `AlgebraicJacobian` (the grading
`𝒫[n] = homogeneousSubmodule n (ULift ℤ)` of `Picard/ProjectiveSpace.lean`).  Here the general
chart coordinate is *definitionally* the coordinate fraction `Adelic.p1CoordAway` of
`RiemannRoch/Adelic/P1ChartData.lean`. -/

section IntegralModel