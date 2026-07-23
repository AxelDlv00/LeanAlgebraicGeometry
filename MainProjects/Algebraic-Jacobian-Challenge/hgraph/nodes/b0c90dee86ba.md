---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.overDualNumberScale
docstring: '**The `ε ↦ aε` scaling of the dual-number object**, as an endomorphism

  of `Spec k[ε]` in `Over (Spec k)`. Precomposition with it is Mumford''s

  scalar multiplication by `a` on tangent vectors (functor-of-points Zariski

  tangent space); pushing through a group-valued functor it becomes the scalar

  action on the dual-number kernel (`relPicKernelSMul` below).'
file: AlgebraicJacobian/Picard/Pic0DualNumberCocycle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.overDualNumberScale
type: lean
updated: '2026-07-16T21:14:27'
---
noncomputable def overDualNumberScale (a : k) :
    overDualNumber k ⟶ overDualNumber k :=
  Over.homMk (Spec.map (CommRingCat.ofHom (DualNumber.scaleRingHom a)))
    (specMap_scaleRingHom_comp a)