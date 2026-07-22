---
author: sync
content_type: instance
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.locallyOfFiniteType_structureMorphism
docstring: '`LocallyOfFiniteType` of the structure morphism, derived from smoothness
  of relative

  dimension one (needed to invoke `Scheme.ordZ_support_finite`).'
file: AlgebraicJacobian/RiemannRoch/DevissageExact.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.locallyOfFiniteType_structureMorphism
type: lean
updated: '2026-07-16T21:33:29'
---
instance locallyOfFiniteType_structureMorphism :
    LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K)) :=
  haveI : Smooth (X ↘ Spec (CommRingCat.of K)) :=
    SmoothOfRelativeDimension.smooth 1 (X ↘ Spec (CommRingCat.of K))
  inferInstance

/-! ## Part 1: the dévissage projection is a local epimorphism -/