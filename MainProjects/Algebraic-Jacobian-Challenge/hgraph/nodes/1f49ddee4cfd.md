---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.BaseSections.val
docstring: 'Reinterpret an element of `BaseSections C M U` as a raw section of the

  abelian presheaf of `M` (the identity function; the definitional bridge

  between the `k`-module synonym and the `Γ(C, U)`-module of sections).'
file: AlgebraicJacobian/RiemannRoch/CohomologyKit.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.BaseSections.val
type: lean
updated: '2026-07-16T21:14:28'
---
def BaseSections.val {C : Over (Spec (CommRingCat.of k))} {M : C.left.Modules}
    {U : C.left.Opens} (m : BaseSections C M U) : Γ(M, U) := m