---
author: sync
content_type: definition
created: '2026-07-28T13:42:18'
decl: AlgebraicGeometry.overDualNumber
docstring: '**The dual-number test object** `Spec k[ε]` as an object of `Over (Spec
  k)`.

  Its pointed `X`-valued points at a section `e` of a `k`-scheme `X` form the

  Zariski tangent space `T_e X` (Mumford, "Abelian varieties", §II.4).'
file: AlgebraicJacobian/Tangent/DualNumberTestObject.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.overDualNumber
type: lean
updated: '2026-08-01T09:44:18'
---
noncomputable def overDualNumber (k : Type u) [Field k] :
    Over (Spec (CommRingCat.of k)) :=
  Over.mk (Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k))))