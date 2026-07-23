---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.linearEndo_apply_comm
docstring: '**Commutativity of `S`-linear endomorphisms of the regular module of a
  commutative ring,

  applied at `1`.**  Re-ported local copy of the (private, hence inaccessible) `DualInverse`

  helper of the same name, dropped during the v4.31 recovery.  Used by

  `presheafDualUnitIso_naturality` below.'
file: AlgebraicJacobian/Picard/TensorObjInverse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.linearEndo_apply_comm
type: lean
updated: '2026-07-24T03:02:12'
---
private lemma linearEndo_apply_comm {S : Type u} [CommRing S] (a b : S →ₗ[S] S) :
    a (b 1) = b (a 1) := by
  have key : ∀ (g : S →ₗ[S] S) (x : S), g x = x * g 1 := fun g x => by
    rw [← smul_eq_mul, ← LinearMap.map_smul, smul_eq_mul, mul_one]
  rw [key a (b 1), key b (a 1), mul_comm]