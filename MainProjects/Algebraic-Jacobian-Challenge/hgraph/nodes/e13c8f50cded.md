---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.overDualNumber
docstring: '**The dual-number object** `Spec k[ε]` as an object of `Over (Spec k)`,

  via the structure map `Spec` of `k → k[ε]`. Its pointed `X`-valued points at

  a section `e` of a `k`-scheme `X` form the Zariski tangent space `T_e X`

  (Mumford, "Abelian varieties", §II.4).'
file: AlgebraicJacobian/Picard/Pic0DualNumberCocycle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.overDualNumber
type: lean
updated: '2026-07-24T03:02:11'
---
noncomputable def overDualNumber (k : Type u) [Field k] :
    Over (Spec (CommRingCat.of k)) :=
  Over.mk (Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k))))