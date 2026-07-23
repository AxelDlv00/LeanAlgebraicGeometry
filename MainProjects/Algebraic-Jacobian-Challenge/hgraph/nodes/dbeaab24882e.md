---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: DualNumber.scaleRingHom
docstring: '**The `ε ↦ aε` scaling of the dual numbers**: `TrivSqZeroExt.map` of

  scalar multiplication by `a` on the infinitesimal part, as a ring

  homomorphism `R[ε] →+* R[ε]`, `r + m ε ↦ r + (a m) ε`. Mumford''s `k`-module

  structure on the tangent space `T_e F` of a functor at a rational point

  scales tangent vectors by functoriality along it ("Abelian varieties",

  §II.4); the scheme-level upgrade is `AlgebraicGeometry.overDualNumberScale`

  below.'
file: AlgebraicJacobian/Picard/Pic0DualNumberCocycle.lean
generated: lean
lean_status: lean_ok
title: DualNumber.scaleRingHom
type: lean
updated: '2026-07-24T03:02:11'
---
def scaleRingHom (a : R) : R[ε] →+* R[ε] :=
  (TrivSqZeroExt.map (a • (LinearMap.id : R →ₗ[R] R))).toRingHom

@[simp]