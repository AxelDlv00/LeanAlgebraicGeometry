---
author: sync
content_type: class
created: '2026-07-24T17:02:56'
decl: AlgebraicGeometry.Scheme.IsAffineHModuleVanishing
docstring: 'Vanishing of higher cohomology on affine opens: for every affine open
  `U` of `C.left.toTopCat`

  and every degree `i > 0`, the cohomology `Scheme.HModule'' k F i U` is the zero
  `k`-module. Since

  `HModule''` returns a `Type u` rather than a `ModuleCat` object, the vanishing is
  phrased as

  `Subsingleton`. This is carried as a hypothesis: Serre vanishing on affines is not
  available for

  `ModuleCat k`-valued sheaf cohomology.'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.IsAffineHModuleVanishing
type: lean
updated: '2026-07-27T01:33:11'
---
class IsAffineHModuleVanishing
    (k : Type u) [Field k] (C : Over (Spec (CommRingCat.of k)))
    (F : Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k)) :
    Prop where
  subsingleton_HModule' : ∀ {U : TopologicalSpace.Opens C.left.toTopCat},
    AlgebraicGeometry.IsAffineOpen U → ∀ i, 0 < i →
      Subsingleton (Scheme.HModule' k F i U)