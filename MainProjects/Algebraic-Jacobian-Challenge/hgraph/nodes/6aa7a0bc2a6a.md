---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.leftRes_toCover
docstring: 'The restriction of a global section to a cover is a compatible family:
  it lands in the

  `eqLocus` of the two restriction legs. Project-local: the equalizer-membership feeding
  the

  global-sections `eqLocus` presentation.'
file: AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.leftRes_toCover
type: lean
updated: '2026-07-16T21:14:26'
---
theorem leftRes_toCover {X : Scheme.{u}} (M : X.Modules) {ι : Type u} (U : ι → X.Opens)
    (s : gammaModA M (⊤ : X.Opens)) :
    leftRes M U (toCover M U s) = rightRes M U (toCover M U s) := by
  funext p
  simp only [leftRes, rightRes, toCover, LinearMap.pi_apply, LinearMap.comp_apply,
    LinearMap.proj_apply, gammaResA_comp]